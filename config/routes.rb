Rails.application.routes.draw do

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :sessions,      only: [:new, :create, :destroy]
  resources :microposts,    only: [:create, :destroy, :show]
  resources :relationships, only: [:create, :destroy]
  resources :password_resets
  resources :feed_items

  root 'static_pages#home'
  # match '/users/:id/following', to: 'users#following', via: 'get'  # to można by dać zamiast resources :users do member do get :following end end
  match '/signup',                  to: 'users#new',                    via: 'get'
  match '/signin',                  to: 'sessions#new',                 via: 'get'
  match '/signout',                 to: 'sessions#destroy',             via: 'delete'
  match '/help',                    to: 'static_pages#help',            via: 'get'
  match '/about',                   to: 'static_pages#about',           via: 'get'
  match '/contact',                 to: 'static_pages#contact',         via: 'get'
  match '/activate/:token',         to: 'users#activate_account',       via: 'get', as: :activate_account
  match '/reactivate/:id',          to: 'sessions#reactivate_account',  via: 'get', as: :reactivate
  match '/feed',                    to: 'microposts#index',             via: 'get', as: :feed,             defaults: { :format => 'atom' }
  match '/rss/:rss_token',          to: 'users#rss',                    via: 'get', as: :rss,              defaults: { :format => 'atom' }

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
end
