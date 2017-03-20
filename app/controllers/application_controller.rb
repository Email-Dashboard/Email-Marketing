class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def set_all_tags
    @all_tags = ActsAsTaggableOn::Tag.all.pluck(:name)
  end
end
