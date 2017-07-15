class TagsController < ApplicationController
  helper_method :xeditable?
  before_action :set_tag, only: [:update, :destroy]
  skip_before_action :authenticate_account!, only: :tag_search

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

  def add_tag_to_item
    @item = params[:item_type].constantize.find(params[:item_id])
    @item.tag_list.add(params[:name])
    @item.save
    render 'update_tags'
  end

  def remove_tag_from_item
    @item = params[:item_type].constantize.find(params[:item_id])
    @item.tag_list.remove(params[:name])
    @item.save
    render 'update_tags'
  end

  def tag_search
    @tags = ActsAsTaggableOn::Tag.where("name like ?", "%#{params[:term]}%")
    respond_to do |format|
      format.json { render json: { results: @tags.map{|t| { id: t.id, name: t.name }} } }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tags_params
    params.require(:tag).permit(:name)
  end

  def xeditable?(_a = nil)
    true
  end
end
