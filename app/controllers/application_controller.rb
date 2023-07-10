# Controller Methods that spread around the whole app
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  helper_method :breadcrumbs

  def set_locale
    local_param = params[:locale] 
    local_cookie = cookies[:locale]

    local_cookie = local_param if local_param
    I18n.locale = local_cookie if local_cookie
  end

  def breadcrumbs
    @breadcrumbs ||= []
  end

  def add_breadcrumb(name, path: nil)
    breadcrumbs << Breadcrumb.new(name, path)
  end
end

