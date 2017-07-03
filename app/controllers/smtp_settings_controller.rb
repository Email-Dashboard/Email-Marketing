class SmtpSettingsController < ApplicationController
  before_action :authenticate_account!
  before_action :set_smtp_setting, only: [:edit, :update, :destroy, :set_default]

  # GET /smtp_settings
  def index
    @smtp_settings = current_account.smtp_settings.all
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
        @smtp_setting.update(is_default: true) if current_account.smtp_settings.count == 1
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
    message = if @smtp_setting.is_default
                'You can destroy the default smtp settings. Set another one as default.'
              else
                @smtp_setting.destroy
                'Smtp setting was successfully destroyed.'
              end

    respond_to do |format|
      format.html { redirect_to smtp_settings_url, notice: message }
    end
  end

  def set_default
    current_account.smtp_settings.update_all(is_default: false)
    @smtp_setting.update(is_default: true)
    respond_to do |format|
      format.html { redirect_to smtp_settings_url, notice: 'Settings was successfully set as default.' }
    end
  end

  private
    def set_smtp_setting
      @smtp_setting = current_account.smtp_settings.find(params[:id])
    end

    def smtp_setting_params
      params.require(:smtp_setting).permit(:from_email, :reply_to, :provider, :address, :port, :domain, :username, :password)
    end
end
