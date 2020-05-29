class AccountsController < ApplicationController

  before_action :parent_category

  def index
    
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
