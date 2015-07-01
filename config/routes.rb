Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'default#index'

  
  # The api routes
  namespace :api, defaults: { format: :json } do
    scope :v1 do

      # user
      scope :user do
        get '/' => 'user#index'
        post '/' => 'user#create'
      end

    end
  end

end
