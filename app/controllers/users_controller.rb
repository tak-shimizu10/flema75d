class UsersController < ApplicationController
  def show
    @categories = Category.where(ancestry: nil)
    respond_to do |format|
      format.html 
      format.json {
        partial = render_to_string(partial:"templates/top", locals: { categories: @categories })
        render json:{html:partial}
       }
    end 
  end
end
