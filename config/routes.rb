Rails.application.routes.draw do
  resources :employees
  root 'employees#index'
  get 'employees/search', to: 'employees#search', as: :search_employee
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
