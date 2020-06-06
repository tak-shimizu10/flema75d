class EvaluatesController < ApplicationController
    def new
        # binding.pry
        @user = User.find(params[:user_id])
        @evaluate = Evaluate.new
        @evaluates = @user.evaluates.includes(:user)
    end
    def create
        @user = User.find(params[:user_id])
        evaluate = @user.evaluates.new(evaluate_params)
        evaluate.save!
        redirect_to root_path
    end
    def destory
    end
    private
    def evaluate_params
        params.require(:evaluate)
              .permit(:rate)
              .merge(user_id: params[:user_id], evaluate_user_id: current_user.id )
    end
end
