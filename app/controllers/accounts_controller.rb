class AccountsController < ApplicationController

  before_action :parent_category

  def index
    @users = current_user.nickname
  end
  
  def show
  end

  def edit
  end

  def logout
    
  end

  private
  def parent_category
    @categories = Category.where(ancestry: nil)
  end

end
