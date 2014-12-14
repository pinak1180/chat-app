Rails.application.routes.draw do
  namespace :api do
  namespace :v1 do
    namespace :authentication do
      get 'users/sign_up'
      end
    end
  end

  get 'api_help/index'

  devise_for :users, :controllers => {:sessions => "sessions", omniauth_callbacks: 'omniauth_callbacks'}
  root 'home#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  namespace :api, :defaults => {:format => 'json'} do
    scope :module => :v1 do      
      namespace :authentication do
        post 'login'  => 'sessions#create', :as => :login
        get  'logout' => 'sessions#destroy', :as => :logout
        post 'forgot_password' => 'passwords#create', :as => :forgot_password
        post 'change_password' => 'passwords#change_password', :as => :change_password
        post 'sign_up' => "users#sign_up",:as => :signup
        get  'get_content' => "users#get_content", :as => :get_content
        post 'send_friend_request' => "users#send_friend_request", :as => :send_friend_request
        post 'confirm_friend_request' => "users#confirm_friend_request", :as => :confirm_friend_request
      end
    end
  end
end
