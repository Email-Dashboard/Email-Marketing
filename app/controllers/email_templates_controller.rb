class EmailTemplatesController < ApplicationController
  before_action :authenticate_account!
  before_action :set_email_template, only: [:show, :edit, :update, :destroy]

  def index
    @email_templates = current_account.email_templates.all
  end

  def show; end

  def new
    @email_template = current_account.email_templates.new
  end

  def edit; end

  def create
    @email_template = current_account.email_templates.new(email_template_params)

    respond_to do |format|
      if @email_template.save
        format.html { redirect_to email_templates_path, notice: 'Email template was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /email_templates/1
  def update
    respond_to do |format|
      if @email_template.update(email_template_params)
        format.html { redirect_to email_templates_path, notice: 'Email template was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @email_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_templates/1
  def destroy
    @email_template.campaigns.update_all(email_template_id: nil)
    @email_template.destroy
    respond_to do |format|
      format.html { redirect_to email_templates_url, notice: 'Email template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_email_template
    @email_template = current_account.email_templates.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def email_template_params
    params.fetch(:email_template, {}).permit!
  end
end
