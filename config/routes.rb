Qa::Application.routes.draw do


 resources :categories, :only => [:index] do
   member do
     get 'question'
   end
 end
   

  #UserSession Routes
  resource :user_session, :only => [:new, :create, :destroy]

  # User Routes
  resources :users do
    resources :questions
    
    collection do
      get "my_qa"
    end
  end

  match "/activate/:token", :to => "users#activate", :as => "activate"

  resources :questions do
    resources :answers, :except => [:show, :new] do
      resources :comments, :except => [:show, :new, :edit, :index]
    end
    resources :comments, :except => [:show, :new, :edit, :index]
  end

  match "/register", :to => "users#new", :as => "register"
  #Pages Routes
  match "pages/about", :to => "pages#about", :as => "about"
  match "pages/contact_us", :to => "pages#contact_us", :as => "contact_us"
  match "pages/message", :to => "pages#message", :as => "message"
  root :to => "pages#landing"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
