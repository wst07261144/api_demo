class UsersController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def create
    if params[:access_token] == '3001'
      User.create(name: params[:name], email: params[:name], password: params[:password])
      render json: {code: 200}
    end
  end

  def index
    render json: {users: User.all}
  end

end
