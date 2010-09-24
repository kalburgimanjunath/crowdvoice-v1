Crowdvoice::Application.routes.draw do 
  # =================
  # = User sessions =
  # =================
  controller :user_sessions do
    get 'login' => :new, :as => :login
    post 'login' => :create, :as => :user_sessions
    get 'logout' => :destroy, :as => :logout
  end

  # ================
  # = Static Pages =
  # ================
  controller :static_pages do
    get 'about' => :about, :as => :about
    get 'sitemap.:format' => :sitemap, :as => :sitemap, :requirements => { :format => 'xml' }
  end

  match '/.:format' => "voices#index", :requirements => {:format => 'rss'}
  match '/show.:format' => "voices#show", :requirements => {:format => 'rss'}
  
  # ================
  # = Admin routes =
  # ================
  namespace :admin do
    resources :users
    resources :announcements
    resources :voices do
      collection do
        get 'fetch_feeds' => :fetch_feeds
      end
    end
    resources :settings
  end

  get 'admin' => 'admin/announcements#index', :as => :admin_root

  resources :contents, :only => [:index], :constraints => {:format => 'rss'}

  # =======================
  # = Public voice routes =
  # =======================
  
  resources :voices, :path => "/", :only => [:index, :show] do
    collection do
      get 'all' => redirect('/#all-voices')
    end
    
    member do
      get 'offset/:offset' => :show, :as => :offset

      controller :twitter do

        scope 'share' do
          get 'retweet/:tweet_id' => :retweet, :as => :retweet
          post 'twitter' => :twitter_share, :as => :twitter_share

          scope 'callbacks' do
            get '/retweet/:tweet_id' => :retweet_callback, :as => :retweet_callback
            get '/twitter' => :twitter_share_callback, :as => :twitter_share_callback
          end

        end
      end
    end

    resources :subscriptions, :only => [:create] do
      member do
        get 'unsubscribe' => :destroy, :as => :unsubscribe
      end
    end

    resources :contents, :only => [:create, :destroy] do
      member do
        match '/vote/:rating' => :vote, :via => :put, :as => :vote
        delete :reset_score
      end
    end
  end

  # =================
  # = Widget        =
  # =================
  match "/widget/:id" => "widget#show"

  match '/link/remote_page_info(.:format)' => 'contents#remote_page_info', :as => :remote_page_info

  root :to => "voices#index"
end
