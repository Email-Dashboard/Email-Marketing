class SmtpSettingsController < ApplicationController
  before_action :authenticate_account!
  before_action :set_smtp_setting, only: [:edit, :update, :destroy, :set_default_for_campaigns, :set_default_for_reply]

  # GET /smtp_settings
  def index
    @smtp_settings = current_account.smtp_settings.order('created_at DESC')
  end

  # GET /smtp_settings/new
  def new
    @smtp_setting = current_account.smtp_settings.new
  end

  # GET /smtp_settings/1/edit
  def edit
  end

  # POST /smtp_settings
  def create
    @smtp_setting = current_account.smtp_settings.new(smtp_setting_params)

    respond_to do |format|
      if @smtp_setting.save
        @smtp_setting.update(is_default_for_campaigns: true, is_default_for_reply: true) if current_account.smtp_settings.count == 1
        format.html { redirect_to smtp_settings_path, notice: 'Smtp setting was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /smtp_settings/1
  def update
    respond_to do |format|
      if @smtp_setting.update(smtp_setting_params)
        format.html { redirect_to smtp_settings_path, notice: 'Smtp setting was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /smtp_settings/1
  def destroy
    @smtp_setting.destroy
    respond_to do |format|
      format.html { redirect_to smtp_settings_url, notice: 'Smtp setting was successfully destroyed.' }
    end
  end

  def set_default_for_campaigns
    current_account.smtp_settings.update_all(is_default_for_campaigns: false)
    @smtp_setting.update(is_default_for_campaigns: true)
    redirect_to smtp_settings_url
  end

  def set_default_for_reply
    current_account.smtp_settings.update_all(is_default_for_reply: false)
    @smtp_setting.update(is_default_for_reply: true)
    redirect_to smtp_settings_url
  end

  private
    def set_smtp_setting
      @smtp_setting = current_account.smtp_settings.find(params[:id])
    end

    def smtp_setting_params
      params.require(:smtp_setting).permit(:from_email, :reply_to, :provider, :address, :port, :domain, :username, :password, :is_default_for_campaigns, :is_default_for_reply)
    end
end
