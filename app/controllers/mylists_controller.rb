class MylistsController < ApplicationController
  def index
  end

  def new
    @mylist = Mylist.new
  end

  def create
    @mylist = Mylist.new(mylist_params)
    if @mylist.save
      redirect_to root_path, notice: 'マイリストを作成しました'
    else
      render :new
    end
  end

  def edit
    @mylist = Mylist.find(params[:id])
  end

  def update
    @mylist = Mylist.find(params[:id])
    if @mylist.update(mylist_params)
      redirect_to root_path, notice: 'マイリストを更新しました'
    else
      render :edit
    end
  end

  def show
    @mylist = Mylist.find(params[:id])
  end

  private
  def mylist_params
    params.require(:mylist).permit(:name, vtuber_ids: []).merge(user_id: current_user.id)
  end
end
