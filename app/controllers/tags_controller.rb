class TagsController < ApplicationController
  helper_method :xeditable?

  before_action :authenticate_account!
  before_action :set_tag, only: [:update, :destroy]

  def index
    @all_tags = ActsAsTaggableOn::Tag.order('taggings_count desc')
  end

  def new
    @tag = current_account.email_templates.new
  end

  # PATCH/PUT /email_templates/1
  def update
    respond_to do |format|
      if @tag.update(tags_params)
        format.json { head :no_content }
      else
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_templates/1
  def destroy
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to tags_path, notice: 'Tag was successfully destroyed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tags_params
    params.fetch(:tag, {}).permit!
  end

  def xeditable?(_a = nil)
    true
  end
end
