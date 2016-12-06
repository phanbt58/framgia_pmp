class UpdateProductBacklogsController < ApplicationController
  def update
    if ProductBacklog.update params[:product_backlogs].keys,
      params[:product_backlogs].values
      respond_to do |format|
        format.html{redirect_to :back}
        format.json{render json: {}}
      end
    end
  end
end
