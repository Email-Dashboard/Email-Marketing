class UserAttributesController < ApplicationController
  helper_method :xeditable?
  before_action :set_user

  def index; end

  def create
    @attribute = @user.user_attributes.create(attribute_params)
  end

  def update
    @attribute = @user.user_attributes.find(params[:id])
    @attribute.update(attribute_params)
  end

  def destroy
    @attribute = @user.user_attributes.find(params[:id])
    @attribute.destroy
  end

  private
  def xeditable?(_a = nil)
    true
  end

  def set_user
    @user = current_account.users.find(params[:user_id])
  end

  def attribute_params
    params.require(:user_attribute).permit(:key, :value)
  end
end