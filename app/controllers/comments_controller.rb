class CommentsController < ApplicationController

    before_action :find_commentable, only: [:destroy, :create,:index,:update]
    before_action :authenticate_request,  only: [:index,:update, :create, :destroy]
    before_action :comment_auth, only: [:destroy]
    
    COMMENT_PER_PAGE = 5

    def index
        @comments = @commentable.comments.offset(pagination * COMMENT_PER_PAGE).limit(COMMENT_PER_PAGE)
        render json: @comments , status: 200, include: :comments
    end

    def create
      @comment = @commentable.comments.build(comment_params)
      @comment.post_id = @commentable.id
      @comment.user_id = current_user.id
        if @comment.save
          @commentable.update(:updated_at => @comment.created_at)
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
      @comment = @commentable.comments.find_by(id: params[:id])
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
  
    def find_commentable
      if params[:comment_id]
        @commentable = Comment.find_by_id(params[:comment_id])
      elsif params[:post_id]
        @commentable = Post.find_by_id(params[:post_id])
      end
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
  