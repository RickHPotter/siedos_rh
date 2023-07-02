module ApplicationHelper
  def locale_link(locale)
    path = request.path
    path_with_locale = "#{path}?locale=#{locale}"
    link_to path_with_locale, class: "nav-link" do
      yield
    end
  end
end

