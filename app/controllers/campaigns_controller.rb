class CampaignsController < ApplicationController
  before_action      :authenticate_account!, except: :event_receiver
  before_action      :set_campaign, only: [:show, :destroy, :send_emails]
  skip_before_action :verify_authenticity_token, only: :event_receiver

  def index
    @campaigns = current_account.campaigns.all
  end

  def show
    @campaign_users = @campaign.campaign_users.page(params[:page])
  end

  def new
    unless params[:q]
      redirect_to users_path, notice: 'You can\'t create campaign without filter.'
    end
    @campaign = Campaign.new
  end

  def create
    # @campaign = current_account.campaigns.new(campaign_params)
    # @campaign.users = @campaign_users
    # @campaign.email_template_id = nil if campaign_params[:email_template_id] == 'new_template'

    CreateCampaignJob.perform_later(params[:q],
                                    campaign_params.to_hash,
                                    current_account.id)

    redirect_to campaigns_path, notice: 'Your campaign ll create in a few minutes.'

  end

  def destroy
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to campaigns_url, notice: 'Campaign was successfully destroyed.' }
    end
  end

  def send_emails
    # Redirect to settings path if account doesn't have settings.
    unless current_account.mail_setting.try(:all_present?)
      redirect_to settings_path, notice: 'Your settings information are required!'
      return
    end

    @campaign.users.each do |_user|
      begin
        campaign_user = @campaign.campaign_users.find_by(user_id: _user.id)
        if campaign_user.draft?
          UserMailer.campaign_email(campaign_user, params[:subject], params[:content]).deliver_now
          campaign_user.processed!
        end
      rescue => e
        Rails.logger.info("MAILER EXCEPTION: #{e} - ID: #{_user.id}")
      end
    end
    redirect_to @campaign, notice: 'Emails were successfully sent!'
  end

  # This method handling requests from Sendgrid Event Notification
  # It updates sent emails statuses
  # Info: https://sendgrid.com/docs/API_Reference/Webhooks/event.html
  def event_receiver
    data_parsed = JSON.parse(request.raw_post)

    data_parsed.each do |info|
      campaign_user = CampaignUser.find_by(id: info['campaign_user_id'])
      campaign_user.update(status: info['event']) if campaign_user
    end
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_campaign
    @campaign = current_account.campaigns.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def campaign_params
    params.require(:campaign).permit(:name, :tag_list, :email_template_id)
  end
end
