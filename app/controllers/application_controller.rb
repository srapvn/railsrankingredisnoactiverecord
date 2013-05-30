class ApplicationController < ActionController::Base
  protect_from_forgery


  # unless Rails.application.config.consider_all_requests_local
      # rescue_from Exception do |exception|
      #     respond_to do |type|
      #       type.html { redirect_to root_path, notice: "#{exception}" }
      #       type.json  { render json: "#{exception}" , :status => 404 }
      #     end
      # end
      #   rescue_from ActionController::RoutingError, with: :render_404
      #   rescue_from ActionController::UnknownController, with: :render_404
      #   rescue_from ActionController::UnknownAction, with: :render_404
      #   rescue_from ActiveRecord::RecordNotFound, with: :render_404
   # end

   def render_404
     respond_to do |type|
         type.html { redirect_to root_path, notice: "404: Path Not Found" }
         type.json  { render json: "404: Path Not Found" , :status => 404 }
      end
   end

end
