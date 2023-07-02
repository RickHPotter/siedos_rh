Rails.application.routes.draw do
  get 'employees/search', to: 'employees#search', as: :search_employee
  resources :employees
  root 'employees#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

