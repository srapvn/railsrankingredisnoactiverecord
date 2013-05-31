Railsranking::Application.routes.draw do
  resources :rankings

  root to: "rankings#index"

  get ':userid' => 'rankings#show' , :constraints => {:userid => /\d+/}, as: :showuser
  get ':userid/edit' => 'rankings#edit', as: :edituser
  get 'top10/:key' => 'rankings#index', as: :top10
  get 'myrank/:userid/:key' => 'rankings#index', as: :myrank
  delete ':userid/delete' => 'rankings#delete', as: :deleteuser
  get 'new' => 'rankings#new', as: :newuser
  put ':userid' => 'rankings#update', as: :updateuser
  post '' => 'rankings#create', as: :createuser

  # match ':userid/:auth_key' => 'rankings#show', as: :showuser_with_auth_key

  # match ':userid/edit/:auth_key' => 'rankings#edit', as: :edituser_with_auth_key

  # match 'top10/:key/:auth_key' => 'rankings#index', as: :top10_with_auth_key

  # match 'myrank/:userid/:key/:auth_key' => 'rankings#index', as: :myrank_with_auth_key

  match '*a' => 'application#render_404'

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
