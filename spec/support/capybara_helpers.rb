# Capybara Helpers for abstracting out some capybara methods
module CapybaraHelpers
  def click_link_or_button(text, wait: nil)
    if page.has_link?(text, exact: true)
      click_link(text, exact: true, wait: wait)
    elsif page.has_button?(text, exact: true)
      click_button(text, exact: true, wait: wait)
    elsif page.has_field?(text, type: 'submit', exact: true)
      find("input[type='submit'][id='#{text}']").click
    else
      raise Capybara::ElementNotFound, "Unable to find visible link, button, or input '#{text}'"
    end
  end
end

