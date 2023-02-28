
require 'sidekiq/web'

Rails.application.routes.draw do

  resources :maintenances
  devise_for :users, :controllers => { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords'}
  #devise normal

  # customize devise authentication routes
  # devise_for :users, controllers: {sessions: 'users/sessions',
  #                                  passwords: 'users/passwords'},
  #                                  skip: [:registrations]
  #
  as :user do
    # get 'users/cancel', to: 'users/registrations#cancel', as: 'cancel_user_registration'
    # get 'jT6RGfksNKwmWgsa/W82SE8xVACu3BWdyJcPU/3CuJrWcwEeBYOYuUCzXJsN2P8eAAPtCHgZIjzEVx9rLP5TykCrPwJeyUOU8ZxsbGcd8ykG743aC6phOnRP5t4hRLCIrpTzX8pOgx', to: 'users/registrations#new'
    # get 'users/edit', to: 'users/registrations#edit', as: 'edit_user_registration'
    # patch 'users', to: 'users/registrations#update', as: 'user_registration'
    # put 'users', to: 'users/registrations#update'
    # delete 'users', to: 'users/registrations#destroy'
    get 'users/complete', to: 'users/registrations#complete'
  end

  # root path route
  root to: "home#index"

  # dashboard for supervisors
  get 'dashboard', action: :index, controller: 'dashboard'

  # demo request route
  post 'demo_request', to: 'home#demo_request', as: 'demo_request'

  # resources routes
  resources :categories
  resources :subsidiaries
  resources :corporations
  resources :positions
  resources :histories
  resources :categories
  resources :comments
  resources :statuses

  # notifications routes
  get 'notifications', to: 'notifications#index', as: "notifications"
  get 'notifications/read-all', to: 'notifications#read_notifications', as: "read_all_notifications"
  get 'notifications/delete-all', to: 'notifications#delete_notifications', as: "delete_all_notifications"
  get 'notifications/delete-readed', to: 'notifications#delete_readed_notifications', as: "delete_readed_notifications"
  get 'notifications/:slug', to: 'notifications#show', as: "show_notification", param: :slug

  # things routes
  resources :things, :except => [:show, :edit, :destroy]
  get 'things/:slug', to: 'things#show', as: 'show_thing', param: :slug
  get 'things/:slug/edit', to: 'things#edit', as: 'edit_thing', param: :slug
  delete 'things/:slug', to: 'things#destroy', as: 'destroy_thing', param: :slug

  #tool routes
  resources :tools, :except => [:show, :edit, :destroy]
  get 'tools/:slug', to: 'tools#show', as: 'show_tool', param: :slug
  get 'tools/:slug/edit', to: 'tools#edit', as: 'edit_tool', param: :slug
  delete 'tools/:slug', to: 'tools#destroy', as: 'destroy_tool', param: :slug
  put 'tools/:slug/comment', to: 'tools#create_comment', as: 'tool_comment', param: :slug

  # substatus routes
  resources :substatuses, :except => [:show, :edit, :destroy]
  get 'substatuses/:slug', to: 'substatuses#show', as: 'show_substatus', param: :slug
  get 'substatuses/:slug/edit', to: 'substatuses#edit', as: 'edit_substatus', param: :slug
  delete 'substatuses/:slug', to: 'substatuses#destroy', as: 'destroy_substatuses', param: :slug

  # orders routes
  resources :orders, :except => [:show, :edit, :destroy]
  get 'orders/:slug', to: 'orders#show', as: 'show_order', param: :slug
  get 'orders/:slug/edit', to: 'orders#edit', as: 'edit_order', param: :slug
  delete 'orders/:slug', to: 'orders#destroy', as: 'destroy_order', param: :slug
  put 'orders/status/:slug', to: 'orders#update_status', as: 'update_status_order'
  put 'orders/close/:slug', to: 'orders#close_order', as: 'close_order'
  put 'orders/reassign/:slug', to: 'orders#reassign_tecnic', as: 'reassign_tecnic'

  # users routes
  resources :users , :except => [:create]
  put '/users/status/:id', to: 'users#active'
  patch '/as-supervisor', to: 'users#as_supervisor', as: "act_as_supervisor"
  # city search
  get '/citiesautocomplete', to: 'users#cities'

  # order rates routes
  resources :order_rates, :only => [:index, :update]
  get '/order_rates/:slug/answer-poll', to: 'order_rates#edit', as: 'edit_order_rate', param: :slug

  # components for things
  post 'things/:slug/components', to: 'things/components#create'
  get 'things/:slug/components/new', to: 'things/components#new', as: 'new_things_component'
  patch 'things/:slug/components/:slug', to: 'things/components#update', as: 'things_component'
  put 'things/:slug/components/:slug', to: 'things/components#update'
  get 'things/:slug/components/:slug/edit', to: 'things/components#edit', as: 'things_edit_component', param: :slug
  delete 'things/:slug/components/:slug', to: 'things/components#destroy', as: 'things_destroy_component', param: :slug
  get 'things/:slug/components/qr_code', to: 'things#qr_code', as: 'get_qr_code_single', param: :slug
  get 'things/components/qr_code', to: 'things#qr_code', as: 'get_qr_code'

  # csv routes for things
  get 'things/:slug/components/import-csv', to: 'things/components#import_csv_form', as: 'components_import_csv_form'
  get 'things/:slug/components/components-layout-csv', to: 'things/components#download_csv', as: 'components_layout_csv'
  post 'things/:slug/components/import-csv', to: 'things/components#import_csv'

  get 'qr/index', to: "qr_generator#index", as: 'qr_index'
  get 'qr/index/qr_code', to: "qr_generator#company_qr_codes", as: 'company_qr_codes'

  # privacy policy route
  get '/privacy_policy', to: 'privacy_policy#policy'
  # habeas data route
  get '/habeas_data', to: 'privacy_policy#habeas'
  # terms and conditions route
  get '/terminos-y-condiciones', to: 'privacy_policy#terms'
  # price landing
  get '/prices', to: 'privacy_policy#prices'

  get '/import-users', to: 'users#import_csv_form', as: 'users_import_csv_form'
  get '/user-layout-csv', to: 'users#download_csv', as: 'users_layout_csv'
  post '/users/import-csv', to: 'users#import_csv'

  mount Sidekiq::Web => '/sidekiq'
  mount ActionCable.server => '/cable'

  # customers orders routes
  get 'customers/orders', to: 'customers/orders#index', as: 'customers_orders'
  post 'customers/orders', to: 'customers/orders#create', as: 'customer_create'
  get 'customers/orders/new', to: 'customers/orders#new', as: 'new_customer_order'
  get 'customers/orders/:slug/edit', to: 'customers/orders#edit', as: 'edit_customer_order', param: :slug
  get 'customers/orders/:slug', to: 'customers/orders#show', as: 'customer_order', param: :slug
  put 'customers/orders/:slug', to: 'customers/orders#update', as: 'customer_update', param: :slug
  delete 'customers/orders/:slug', to: 'customers/orders#destroy', as: 'customer_destroy', param: :slug
  # customers dashboard
  get 'customers/dashboard', to: 'customers/dashboard#index', as: 'customers_dashboard'
  # customers things routes
  get 'customers/things', to: 'customers/things#index', as: 'customers_things'
  # customers contact route
  get 'customers/contact-company', to: 'customers/dashboard#contact_company', as: 'contact_company'

  # admin corporations routes
  get 'admins/corporations/:id', to: 'admins/corporations#show', as: 'admins_show_corporation'
  get 'admins/corporations/:id/edit', to: 'admins/corporations#edit', as: 'admins_edit_corporation'
  put 'admins/corporations/:id', to: 'admins/corporations#update', as: 'admins_corporation_update'
  # admin subsidiaries routes
  get 'admins/subsidiaries', to: 'admins/subsidiaries#index', as: 'admins_subsidiaries'
  post 'admins/subsidiaries', to: 'admins/subsidiaries#create', as: 'admins_subsidiary_create'
  get 'admins/subsidiaries/new', to: 'admins/subsidiaries#new', as: 'admins_subsidiary_new'
  get 'admins/subsidiaries/:id', to: 'admins/subsidiaries#show', as: 'admins_subsidiary_show'
  get 'admins/subsidiaries/:id/edit', to: 'admins/subsidiaries#edit', as: 'admins_subsidiary_edit'
  put 'admins/subsidiaries/:id', to: 'admins/subsidiaries#update', as: 'admins_subsidiary_update'
  put 'admins/subsidiaries/status/:id', to: 'admins/subsidiaries#active', as: 'admins_subsidiary_active'
  # admin users routes
  get 'admins/users', to: 'admins/users#index', as: 'admins_users'

  # reports
  get 'reports/orders', to: 'reports#orders', as: 'order_reports'
  get 'reports/orders-to-csv', to:'reports#orders_to_csv', as: 'orders_to_csv'


  # api v1 routes
  namespace :api do
    namespace :v1 do
      # thing endpoints
      resources :things
      get '/things/search/', to: 'things#search'
      get '/things/histories/:code_scan', to: 'things#histories'
      post '/things/search_devise', to: 'things#out_thing_search'

      get '/notifications/read/:id', to: 'notifications#read'

      # city endpoints
      get '/cities', to: 'cities#index'
      get '/cities/:id', to: 'cities#show'

      # user endpoints
      resources :users
      get '/customers', to: 'users#customers'

      # order endpoints
      resources :orders
      post '/orders-sync/', to: 'orders#sync'
      put '/orders-desync/:id', to: 'orders#desync'
      put '/orders-arrive/:id', to: 'orders#arrives'
      put '/orders/notify-status/:id', to: 'orders#notify_status'
      get '/substatus', to: 'substatuses#index'
      get '/substatus/done', to: 'substatuses#done_substatuses'
      get '/substatus/pending', to: 'substatuses#pending_substatuses'
      get '/substatus/receivable', to: 'substatuses#receivable_substatuses'
      get '/substatus/service', to: 'substatuses#service_center_substatuses'

      # tecnic-availability endpoint
      get '/tecnic-available/:tecnic_id', to: 'orders#tecnic_availability'


      # login endpoint
      post '/auth/login', to: 'authentication#login'

      # position endpoints
      post '/send_gps', to: 'positions#send_gps'
      get '/all_positions', to: 'positions#index'
      post '/absence', to: 'positions#absence'

      # referral endpoints
      post '/referrals/', to: 'referrals#get_data'
    end
  end

  # api v1 routes
  namespace :api do
    namespace :v2 do
      # login endpoint
      post '/auth/login', to: 'authentication#login'

      # # thing endpoints

      # resources :things
      get '/subsidiaries', to: 'subsidiaries#index'
      #
      # get '/notifications/read/:id', to: 'notifications#read'
      #
      # # city endpoints
      # get '/cities', to: 'cities#index'
      # get '/cities/:id', to: 'cities#show'
      #
      # # user endpoints
      # resources :users
      # get '/customers', to: 'users#customers'
      #
      # # order endpoints
      # resources :orders
      # post '/orders-sync/', to: 'orders#sync'
      # put '/orders-desync/:id', to: 'orders#desync'
      # put '/orders-arrive/:id', to: 'orders#arrives'
      # put '/orders/notify-status/:id', to: 'orders#notify_status'
      get '/substatus', to: 'substatuses#index'
      # get '/substatus/done', to: 'substatuses#done_substatuses'
      # get '/substatus/pending', to: 'substatuses#pending_substatuses'
      # get '/substatus/receivable', to: 'substatuses#receivable_substatuses'
      # get '/substatus/service', to: 'substatuses#service_center_substatuses'
      #
      # # tecnic-availability endpoint
      # get '/tecnic-available/:tecnic_id', to: 'orders#tecnic_availability'

      # # position endpoints
      # post '/send_gps', to: 'positions#send_gps'
      # get '/all_positions', to: 'positions#index'
      # post '/absence', to: 'positions#absence'
      #
      # # referral endpoints
      post '/inventory/', to: 'inventories#get_data'
      post '/out_product/', to: 'inventories#out_product'
      # cateogiries
      get '/categories', to: 'categories#index'
    end
  end




  get '*path', to: 'errors#not_found'

  # scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
  #
  # end
end
