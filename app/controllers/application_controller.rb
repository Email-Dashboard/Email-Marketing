class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def set_all_tags
    @all_tags = ActsAsTaggableOn::Tag.all.pluck(:name)
  end

  def ransack_results_with_limit
    if params[:limit_count].present?
      Kaminari.paginate_array(
        @q.result(distinct: true).first(params[:limit_count])
      ).page(params[:page])
    else
      @q.result(distinct: true).page(params[:page])
    end
  end
end
