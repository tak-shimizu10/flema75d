class Api::TemplatesController < ApplicationController
  def logout
    partial = render_to_string(partial:"templates/logout")
    render json:{html:partial}
  end
end
