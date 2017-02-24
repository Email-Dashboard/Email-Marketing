class CampaignsController < ApplicationController
  before_action :authenticate_account!
  before_action :set_campaign, only: [:show, :destroy, :send_emails]
  before_action :set_campaign_users, only: :create

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
    @campaign = current_account.campaigns.new(campaign_params)
    @campaign.users = @campaign_users
    respond_to do |format|
      if @campaign.save
        format.html { redirect_to @campaign, notice: 'Campaign was successfully created.' }
        format.json { render :show, status: :created, location: @campaign }
      else
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to campaigns_url, notice: 'Campaign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def send_emails
    @campaign.users.each do |_user|
      begin
        UserMailer.campaign_email(_user, params[:subject], params[:content]).deliver_now
        campaign_user = @campaign.campaign_users.find_by(user_id: _user.id)
        campaign_user.sent!
      rescue => e
        Rails.logger.info("MAILER EXCEPTION: #{e} - ID: #{_user.id}")
      end
    end
    redirect_to @campaign, notice: 'Emails was successfully sent!'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_campaign
    @campaign = current_account.campaigns.find(params[:id])
  end

  def set_campaign_users
    @campaign_users = if params[:q] == 'all'
                        current_account.users.all
                      else
                        query = Rack::Utils.parse_nested_query(params[:q]) # convert string params to hash
                        q = current_account.users.ransack(query)
                        q.result(distinct: true)
                      end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def campaign_params
    params.require(:campaign).permit(:name, :tag_list)
  end
end
