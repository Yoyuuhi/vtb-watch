class MylistsController < ApplicationController
  def index
    @mylists = current_user.mylists.includes(:vtubers)
  end

  def new
    @mylist = Mylist.new
  end

  def create
    # binding.pry
    @mylist = Mylist.new(mylist_params)
    if @mylist.save
      redirect_to root_path
      # , notice: 'マイリストを作成しました'
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
    @vtubers = @mylist.vtubers.includes(:videos)
    videos = []
    @vtubers.each do |vtuber|
      vtuber.videos.each do |video|
        videos << video
      end
    end
    @videos_all = videos.sort_by! { |a| a[:publishedAt] }.reverse
    @videos_all_page = Kaminari.paginate_array(@videos_all).page(params[:page]).per(10)
    
    videos_onair = []
    @videos_all.each do |video|
      if video.actualStartTime != nil and video.actualEndTime == nil then
        videos_onair << video
      end
    end
    @videos_onair = Kaminari.paginate_array(videos_onair).page(params[:page]).per(10)

    videos_planned = []
    @videos_all.each do |video|
      if video.actualStartTime == nil and video.scheduledStartTime != nil then
        videos_planned << video
      end
    end
    @videos_planned = Kaminari.paginate_array(videos_planned).page(params[:page]).per(10)
  end

  def destroy
    @mylist = Mylist.find(params[:id])
    @mylist.destroy
    redirect_to root_path
  end

  private
  def mylist_params
    params.require(:mylist).permit(:name, vtuber_ids: []).merge(user_id: current_user.id)
  end
end
