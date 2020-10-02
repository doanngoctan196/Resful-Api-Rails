class CommentsController < ApplicationController

    before_action :set_posts, only: [:destroy ,:update, :create, :index]
    before_action :authenticate_request,  only: [:index,:update, :create, :destroy]
    before_action :comment_auth, only: [:destroy]
    
  
    def index
        @comment = @post.comments
        render json: @comment , status: 200
    end
  
    # def show
    #   @comment.user = current_user
    #   render json: @comment , status: 200
    # end
  
    # def new
    #   @comment = Comment.new(post_id: params[:post_id])
    # end
  
    # def edit
    #   @comment = Comment.find(params[:id])
    # end
  
    def create
      @comment = @post.comments.create(comment_params)
      @comment.user_id = current_user.id
      if @comment.save
        render json:{
          data: @comment,
        },status: :created
      else
        render json:{
          status: 400,
          msg: @comment.errors
        },status: :unprocessable_entity

      end
    end
  
    def update
      @comment = Comment.find(params[:id])
        if @comment.user_id == current_user.id 
            @comment.update_attributes(comment_params)
              render json:{
                data: @comment,
              },status: :created
        else
          render json:{
            status: 400,
            msg: @comment.errors
          },status: :unprocessable_entity
        end
    end
  
    def destroy
      @comment = @post.comments.find(params[:id])
      if  @comment.destroy
          render json:{
            status: 200,
            msg: "Successfully Delete Comment!"
          }
      end
    end
  
    def set_posts
      @post = Post.find(params[:post_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: {
            msg: e
        } 
    end
  
    def comment_auth
      @comment = Comment.find(params[:id])
      if @comment.user_id != current_user.id && check_user_admin
        render json:{
          msg: "Not Authorized!"
        },status: :unauthorized
      end
    end
  
    private
    def comment_params
      params.permit(:description)
    end
  end
  