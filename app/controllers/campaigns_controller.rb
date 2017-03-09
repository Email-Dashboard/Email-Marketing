class CampaignsController < ApplicationController
  before_action      :authenticate_account!, except: :event_receiver
  before_action      :set_campaign, only: [:show, :destroy, :send_emails]
  before_action      :check_new_campaign_avaibility, only: :new
  skip_before_action :verify_authenticity_token, only: :event_receiver

  def index
    @campaigns = current_account.campaigns.all
  end

  def show
    @campaign_users = @campaign.campaign_users.page(params[:page])
  end

  # TODO @sadik move to job.
  def add_users
    campaign = current_account.campaigns.find(params[:campaign_id])
    filter = JSON.parse(params[:filter])
    current_account.users.ransack(filter).result(distinct: true).each do |user|
      begin
        campaign.campaign_users.create(user_id: user.id)
      rescue => ex
        Rails.logger.info ex
      end
    end
    redirect_to campaign
  end

  def new
    @campaign = Campaign.new
  end

  def create
    # Assign users campaign in a sidekiq worker
    # It can take awhile in large users count

    CreateCampaignJob.perform_now(params[:q],
                                    params[:limit_count],
                                    campaign_params.to_hash,
                                    current_account.id)

    redirect_to campaigns_path, notice: 'Your campaign is creating... It will take a few seconds, refresh the page to see changes.'

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

    # TODO move to job
    @campaign.users.each do |_user|
      begin
        campaign_user = @campaign.campaign_users.find_by(user_id: _user.id)
        if campaign_user.draft?
          UserMailer.campaign_email(campaign_user).deliver_now
          campaign_user.update(sent_at: Time.now, status: :processed)
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
  # Go to: https://app.sendgrid.com/settings/mail_settings
  # Event Notification -> <yourhost.com>/campaigns/event_receiver
  def event_receiver
    data_parsed = JSON.parse(request.raw_post)

    data_parsed.each do |info|
      campaign_user = CampaignUser.find_by(id: info['campaign_user_id'])
      campaign_user.update(status: info['event']) if campaign_user
    end
    head :no_content
  end

  private

  def check_new_campaign_avaibility
    # Check if any filter exist
    unless params[:q]
      redirect_to users_path, notice: 'You can\'t create campaign without filter.'
    end

    # redirect_to templates path if account not have any template
    unless current_account.email_templates.present?
      redirect_to new_email_template_path, notice: 'You don\'t have any email template to create campaign. Create one first!'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_campaign
    @campaign = current_account.campaigns.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def campaign_params
    params.require(:campaign).permit(:name, :tag_list, :email_template_id)
  end
end
