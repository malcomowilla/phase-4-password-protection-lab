class UsersController < ApplicationController
# before_action :authorize
def create_users
    user = User.create(user_params)
    session[:user_id] = user.id
    
    if user.valid?
        render json: user, status: :created
    else
        render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end
end


def create
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
        session[:user_id] = user.id
        render json: user, status: :created
        
    else
        render json: {error: 'Invalid username or password'}, status: :unauthorized
    end

    
end
def show
    user = User.find_by(id:session[:user_id])
if user
        render json: user

else
    render json: {error: 'Not authorized'}, status: :unauthorized
end
end

def destroy
    session.delete :user_id
    head :no_content
end
private

# def authorize
#     return render json: {error: 'Not autorized'}, status: :unauthorized unless session.include? :user_id
# end
def user_params
    params.permit(:username, :password, :password_confirmation)
end
end
