class PostsController < ApplicationController
    before_action :authenticate_request,  only: [:index, :show, :update, :create,:destroy]
    before_action :post_auth, only: [:destroy]
    before_action :current_post, only: [:update, :destroy,:show]

    POST_PER_PAGE = 5

    def index
        @page = params.fetch(:page,0).to_i
        @posts = Post.offset(@page * POST_PER_PAGE).limit(POST_PER_PAGE)
        render json: @posts, status: 200, include: :comments
    end

    def show
        render json: @post , status: 200, include: :comments
    end

    def create
        @post = Post.new(post_params)
        @post.user = current_user
        if @post.save
            render json:{
                data: @post,
            },status: :created
        else
            render json:{
                status: 400,
                msg: @post.errors
            },
            status: :unprocessable_entity
        end
    end

    def update
        if  @post.user_id == current_user.id
            @post.update_attributes(post_params)
            render json:{
                data: @post,
            },status: :created
        else
            render json:{
                status: 400,
                msg: @post.errors
            },status: :unprocessable_entity
        end
    end

    def destroy
        if @post.destroy
            render json:{
                status: 200,
                msg: "Successffuly Deleted Post"
            }
        end
    end

    def current_post
        @post = Post.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
        render json: {
            msg: e
        }
    end

    def post_auth
        @post = Post.find_by(id: params[:id])
        if @post.user_id != current_user.id && check_user_admin
            render json: {
                msg: "Not Authorized!"
            },status: :unauthorized
        end
    end

    private
    def post_params
        params.permit(:title, :description)
    end
end
