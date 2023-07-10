Rails.application.routes.draw do
  root 'employees#index'
  get 'employees/search', to: 'employees#search', as: :search_employee
  resources :employees
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
