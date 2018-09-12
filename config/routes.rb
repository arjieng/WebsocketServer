Rails.application.routes.draw do
  # mount_devise_token_auth_for 'User', at: 'auth'

  scope :api do
    scope :v1, path: '' do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        token_validations:  'api/v1/sessions',
        sessions: 'api/v1/sessions',
        registrations: 'api/v1/registrations'
      }
    end
  end

  namespace :api do
  	namespace :v1, path: '' do
  		resources :group, only: [:member_list] do
        get 'group_members' => 'groups#member_list'
      end
      get 'check_group' => 'groups#check_group'
      get 'get_chatrooms' => 'groups#get_chatrooms'


      post 'update_account' => 'users#update_account'
      get 'user_images' => 'users#user_images'
      post 'upload_user_avatar' => 'users#upload_user_avatar'
      get 'get_user_info' => 'users#get_user_info'


      post 'update_profile' => 'users#update_profile'
      post 'create_prayer' => 'prayers#create'
      get 'prayers' => 'prayers#index'
      post 'update_prayer' => 'prayers#update'
      get 'answered_prayers' => 'prayers#answered_prayers'
      get 'unanswered_prayers' => 'prayers#unanswered_prayers'
      get 'prayer_comments' => 'prayers#prayer_comments'
      post 'add_prayer_comment' => 'prayers#add_prayer_comment'
      get 'hide_prayer' => 'prayers#hide_prayer'
      get 'get_all_prayers'=>'prayers#get_all_prayers'

      
      post 'add_event' => 'events#create'
      get 'all_events' => 'events#index'
      post 'update_event' => 'events#update'
      get 'add_attendee' => 'events#add_attendee'
      get 'attendees' => 'events#get_attendees'
      get 'remove_attendee' => 'events#remove_attendee'
      # resources :prayers, only:
  	end
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
