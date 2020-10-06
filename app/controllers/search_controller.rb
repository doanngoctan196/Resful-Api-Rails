class SearchController < ApplicationController
  skip_before_action :authenticate_request

    def index
        if params[:keywords].nil? || params[:keywords].blank?
          render json: @posts = []
        else
          @posts = Post.search(params[:keywords])

          render json: @posts, status: 200
        end
      end
end
