require "grape"

module Twitter
  class API_V1 < Grape::API

    version 'v1', using: :path, vendor: 'twitter'
    format :json
    prefix :api


    resource :users do
      desc "Return all users."
      get :get_all do
        User.all
      end

      desc 'create a user'
      params do
        requires :name, type: String, desc: "Your name."
        requires :email, type: String, desc: "Your email."
        requires :password, type: String, desc: "Your password."
      end
      post :create do
        User.create(name: params[:name], email: params[:email], password: params[:password])
      end

    end

  end
end