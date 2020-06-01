class Api::TemplatesController < ApplicationController
  def top
    partial = render_to_string(partial:"templates/top")
    render json:{html:partial}
  end
  def logout
    partial = render_to_string(partial:"templates/logout")
    render json:{html:partial}
  end
end
