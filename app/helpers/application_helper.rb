# Helper methods to be used across the entire app
module ApplicationHelper
  def locale_link(locale)
    path = request.path
    path_with_locale = "#{path}?locale=#{locale}"
    link_to path_with_locale, class: "nav-link" do
      yield
    end
  end

  def sf_select(form, field, collection, html_class: '')
    klass = { class: 'form-select ' + html_class }
    form.input field, collection: collection, input_html: klass
  end
end

