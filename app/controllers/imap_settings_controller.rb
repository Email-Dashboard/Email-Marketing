class ImapSettingsController < ApplicationController
  before_action :authenticate_account!
  before_action :set_imap_setting, only: [:edit, :update, :destroy]

  # GET /imap_settings
  def index
    @imap_settings = current_account.imap_settings.all
  end

  # GET /imap_settings/new
  def new
    unless current_account.smtp_settings.present?
      redirect_to smtp_settings_path, notice: 'Please define at least one smtp settings to read reply emails of it.'
      return
    end
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
        format.html { redirect_to imap_settings_path, notice: 'IMAP setting was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /imap_settings/1
  def update
    respond_to do |format|
      if @imap_setting.update(imap_setting_params)
        format.html { redirect_to imap_settings_path, notice: 'IMAP setting was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /imap_settings/1
  def destroy
    @imap_setting.destroy
    respond_to do |format|
      format.html { redirect_to imap_settings_url, notice: 'IMAP setting was successfully destroyed.' }
    end
  end

  private
  def set_imap_setting
    @imap_setting = current_account.imap_settings.find(params[:id])
  end

  def imap_setting_params
    params.require(:imap_setting).permit(:address, :port, :email, :password)
  end
end
