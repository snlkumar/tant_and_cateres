Rails.application.routes.draw do
  devise_for :admins
  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }
  # devise_for :users
  # scope "/admin" do
  #   resources :users
  # end
  class SubdomainConstraint
    def self.matches?(request)
      subdomains = %w{ www admin }
      request.subdomain.present? && !subdomains.include?(request.subdomain)
    end
  end
  # root to: 'home#index'
  root to: 'home#index'
  constraints SubdomainConstraint do
    resources :items do
      collection do
        get :search_items, :filter_items
      end
    end
    resources :orders do
      member do
        get :items, :complete
        put :order_dispatched
      end
      collection do
        get :search
      end
    end
    resources :order_items do
      collection do
        get :mark_complete
      end
      member do        
        put :change_quantity
      end

    end
    resources :calanders
  end
  resources :dashboards do
    collection do
      get :demo, format: :json
    end
  end

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
