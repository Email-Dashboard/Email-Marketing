class CampaignsController < ApplicationController
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
    # sa
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
                        q = current_account.users.ransack(params[:q])
                        q.result(distinct: true)
                      end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def campaign_params
    params.fetch(:campaign, {})
    params.require(:campaign).permit(:name, :tag_list)
  end
end
