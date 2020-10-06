class UsersController < ApplicationController
    before_action :authenticate_request,  only: [:index,:show, :update, :destroy]
    before_action :set_user, only: [:update,:destroy]

    USERS_PER_PAGE = 5

    def index
        if !check_user_admin
            @users = User.offset(pagination * USERS_PER_PAGE).limit(USERS_PER_PAGE)
            render json: @users , status: :ok, except: [:password_digest]
        else
            render json:{
                msg: "Not Authorized, User Must be an Admin"
            },status: :unauthorized
        end
    end
    

    def show
        render json: current_user, except: [:password_digest]  
    end

    def create
        @user = User.create(user_params)
        if @user.save
            ExampleMailer.sample_email(@user).deliver
            render json:{
            data: @user
          },status: :created
          else
            render json:{
                error: @user.errros
            },status: :unprocessable_entity

        end
    end

      # Phương thức cập nhật người dùng. Người dùng cần phải được ủy quyền.
      def update
        if @user.id == current_user.id
            @user.update_attributes(user_params)
            render json: { 
            data: @user,
            },status: :created
        else
            render json:{
                status: 400,
                msg: @user.errors
            },status: :unprocessable_entity

        end
      end
      
      # Phương thức xóa người dùng, chỉ dành cho admin
      def destroy
        if !check_user_admin
            @user.destroy
            render json:{
                status: 200,
                msg: 'Successfully Delete User'
            }
        else
            render json:{
                msg: "Not Authorized, User Must be an Admin"
            },status: :unauthorized
        end
    end

    def set_user
        @user = User.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
        render json: {
            msg: e
        }
    end

    private    
    def user_params
        params.permit(:username, :email, :password)
    end
end
