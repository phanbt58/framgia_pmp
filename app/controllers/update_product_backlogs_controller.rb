class UpdateProductBacklogsController < ApplicationController
  def update
    if ProductBacklog.update params[:product_backlogs].keys, params[:product_backlogs].values
      flash[:success] = flash_message "updated"
    else
      flash_message[:failed] = flash_message "not_updated"
    end
    redirect_to :back
  end
end
