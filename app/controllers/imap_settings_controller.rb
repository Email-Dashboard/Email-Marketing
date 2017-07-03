class SmtpSettingsController < ApplicationController
  before_action :authenticate_account!
  before_action :set_imap_setting, only: [:edit, :update, :destroy, :set_default]

  # GET /imap_settings
  def index
    @imap_settings = current_account.imap_settings.all
  end

  # GET /imap_settings/new
  def new
    @imap_setting = current_account.imap_settings.new
  end

  # GET /imap_settings/1/edit
  def edit
  end

  # POST /imap_settings
  def create
    @imap_setting = current_account.imap_settings.new(imap_setting_params)

    respond_to do |format|
      if @imap_setting.save
        format.html { redirect_to imap_settings_path, notice: 'Smtp setting was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /imap_settings/1
  def update
    respond_to do |format|
      if @imap_setting.update(imap_setting_params)
        format.html { redirect_to imap_settings_path, notice: 'Smtp setting was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /imap_settings/1
  def destroy
    respond_to do |format|
      format.html { redirect_to imap_settings_url, notice: 'Smtp setting was successfully destroyed.' }
    end
  end

  private
  def set_imap_setting
    @imap_setting = current_account.imap_settings.find(params[:id])
  end

  def imap_setting_params
    params.require(:imap_setting).permit(:from_email, :reply_to, :provider, :address, :port, :domain, :username, :password)
  end
end
