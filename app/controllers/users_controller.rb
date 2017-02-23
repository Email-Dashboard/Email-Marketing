class UsersController < ApplicationController
  before_action :authenticate_account!

  def index
    @users = current_account.users.page(params[:page])
  end

  def destroy
    @user = current_account.users.find params[:id]
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
