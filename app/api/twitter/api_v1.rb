require "grape"

module Twitter
  class API_V1 < Grape::API

    version 'v1', using: :path, vendor: 'twitter'
    format :json
    prefix :api

    helpers do
      def authenticate!
        error!('Unauthorized. Invalid or expired token.', 401) unless current_user
      end

      def current_user
        api_key = ApiKey.find_by(access_token: params[:token])
        api_key && !api_key.expired? ? @current_user = User.find(api_key.user_id) : false
      end
    end

    resource :auth do

      desc "Creates and returns access_token if valid login"
      params do
        requires :email, type: String, desc: "email"
        requires :password, type: String, desc: "Password"
      end
      post :login do
        user = User.find_by(email: params[:email].downcase, password: params[:password])
        if user
          user.api_key.blank? ? user.create_api_key : user.api_key.update_access_token
          {access_token: user.api_key.access_token}
        else
          error!('Unauthorized.', 401)
        end
      end

      desc "update access_token if valid login"
      params do
        requires :email, type: String, desc: "email"
        requires :password, type: String, desc: "Password"
      end
      post :update do
        user = User.find_by(email: params[:email].downcase, password: params[:password])
        user.api_key.update_access_token
        {access_token: user.api_key.access_token}
      end

      desc "Returns pong if logged in correctly"
      params do
        requires :token, type: String, desc: "Access token."
      end
      get :ping do
        authenticate!
        { message: "pong" }
      end
    end

  end
end