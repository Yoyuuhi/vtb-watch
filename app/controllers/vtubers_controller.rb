class VtubersController < ApplicationController
  def show
    @mylist = Mylist.find(params[:mylist_id])
  end

end
