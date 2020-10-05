class ApplicationController < ActionController::API
    before_action :authenticate_request
    attr_reader :current_user
  
    private
  
    def authenticate_request
      @current_user = AuthorizeApiRequest.call(request.headers).result
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end

    def check_user_admin
      @current_user = AuthorizeApiRequest.call(request.headers).result unless @current_user.role == "admin"
    end

    def pagination
      @page = params.fetch(:page,0).to_i
    end
end
