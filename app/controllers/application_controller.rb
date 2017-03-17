class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def ransack_query_with_limit
    if params[:limit_count].present?
      @q.result(distinct: true).limit(params[:limit_count])
    else
      @q.result(distinct: true).page(params[:page])
    end
  end
end
