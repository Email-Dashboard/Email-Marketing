class UsersController < ApplicationController
  before_action :authenticate_account!
  before_action :set_all_tags, only: [:new, :import]

  def index
    @q = current_account.users.includes(:user_attributes, :campaigns, :campaign_users, :tags)
                        .ransack(params[:q])
    @q.build_grouping unless @q.groupings.any?
    @q.sorts = 'created_at DESC' if @q.sorts.empty?

    @users = ransack_results_with_limit
    @associations = [:taggings_tag, :user_attributes, :campaign_users, :campaign_users_taggings_tag, :campaigns, :campaigns_taggings_tag]
    @total_user_count = @users.total_count

    respond_to do |format|
      format.html
      format.xlsx { render xlsx: 'download', filename: "Users-#{Time.now.strftime("%Y%m%d%H%M")}.xlsx", locals: { users: users_to_export } }
      format.csv { send_data  users_to_export.to_csv_file, filename: "Users-#{Time.now.strftime("%Y%m%d%H%M")}.csv" }
    end
  end

  def new; end

  def import; end

  def create
    if params[:file].present? && params[:tags].present?

      name = "#{(0...50).map { ('a'..'z').to_a[rand(26)] }.join}-#{params[:file].original_filename}"
      directory = 'public/upload'
      path = File.join(directory, name)
      File.open(path, 'wb') { |f| f.write(params[:file].read) }

      ImportUsersJob.perform_later(current_account.id, name, params[:tags])

      @result = 'Your user list importing in background. It will take awhile.'
    else
      @result = { imported_users: 0, import_errors: 'Tags and Csv file required.' }
    end
    redirect_to import_users_path, notice: @result
  end

  def create_single
    user = current_account.users.new(name: params[:name], email: params[:email])
    user.tag_list << params[:tags]
    if user.save
      @result = 'User was successfully created!'
    else
      @result = user.errors.full_messages.to_sentence
    end
    redirect_to new_user_path, notice: @result
  end

  def destroy
    @user = current_account.users.find params[:id]
    @user.user_attributes.destroy_all
    @user.destroy
    respond_to do |format|
      format.js
    end
  end
end
