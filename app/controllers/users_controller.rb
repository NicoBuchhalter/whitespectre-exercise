class UsersController < ApplicationController
  
  def create
  	user = User.create(users_params)
  	return render json: { errors: user.errors.messages }, status: :bad_request unless user.valid?
  	render json: user, status: :created
  end

  def index
  	render json: users, meta: pagination_meta(users)
  end

  def show
  	render json: user, status: :ok
  end

  private

  def users_params
  	params.require(:user).permit(:email, :name)
  end

  def user
  	@_user ||= User.find(params[:id])
  end

  def users
  	@_users ||= User.all.page(params[:page]).per(params[:per_page])
  end
end
