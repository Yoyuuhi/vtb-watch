class MylistsController < ApplicationController
  before_action :redirect

  def index
    @mylists = current_user.mylists.includes(:vtubers)
  end

  def new
    @mylist = Mylist.new
  end

  def create
    @mylist = Mylist.new(mylist_params)
    if Mylist.where(id: current_user.id, name: @mylist.name) != []
      flash.now[:alert] = "mylist名は重複しています"
      render :new
    elsif @mylist.vtubers == []
      flash.now[:alert] = "vtuberを登録してください"
      render :new
    elsif @mylist.vtubers != @mylist.vtubers.distinct
      flash.now[:alert] = "登録vtuberは重複しています"
      render :new
    elsif @mylist.save
      redirect_to root_path, notice: 'マイリストを作成しました'
    else
      flash.now[:alert] = "予期しないエラー、入力情報を確認してください"
      render :new
    end
  end

  def edit
    @mylist = Mylist.includes(:vtubers).find(params[:id])
  end

  def update
    @mylist = Mylist.find(params[:id])
    if @mylist.vtubers == []
      flash.now[:alert] = "vtuberを登録してください"
      render :new
    elsif @mylist.vtubers != @mylist.vtubers.distinct
      flash.now[:alert] = "登録vtuberは重複しています"
      render :new
    elsif @mylist.update(mylist_params)
      redirect_to root_path, notice: 'マイリストを更新しました'
    else
      flash.now[:alert] = "予期しないエラー、入力情報を確認してください"
      render :new
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

    # All
    @videos_all = videos.sort_by! { |a| a[:publishedAt] }.reverse
    videos_all_today = []
    videos_all_yesterday = []
    videos_all_2daysAgo = []
    @videos_all.each do |video|
      if (video[:publishedAt].to_s.match(/#{Date.today.to_s}.+/)) and video.liveStreamingDetails != false then
        videos_all_today << video
      end
      if (video[:publishedAt].to_s.match(/#{Date.yesterday.to_s}.+/)) and video.liveStreamingDetails != false then
        videos_all_yesterday << video
      end
      if (video[:publishedAt].to_s.match(/#{Date.today.days_ago(2).to_s}.+/)) and video.liveStreamingDetails != false then
        videos_all_2daysAgo << video
      end
    @videos_all_today = videos_all_today
    @videos_all_yesterday = videos_all_yesterday
    @videos_all_2daysAgo = videos_all_2daysAgo
    end

    # ライブ配信中
    videos_onair = []
    @videos_all.each do |video|
      if video.actualStartTime != nil and video.actualEndTime == nil and video.liveStreamingDetails != false then
        videos_onair << video
      end
    end
    @videos_onair = videos_onair

    # 公開予定
    videos_planned = []
    @videos_all.each do |video|
      if video.actualStartTime == nil and video.scheduledStartTime != nil and video.liveStreamingDetails != false then
        videos_planned << video
      end
    end
    @videos_planned = videos_planned
  end

  def destroy
    @mylist = Mylist.find(params[:id])
    @mylist.destroy
    redirect_to root_path, notice: 'マイリストを削除しました'
  end

  private
  def mylist_params
    params.require(:mylist).permit(:name, vtuber_ids: []).merge(user_id: current_user.id)
  end

  # ユーザーログイン後、urlを入力して他のユーザーページへ移動することを防ぐ
  def redirect
    if params[:user_id] != nil && params[:user_id] != current_user.id.to_s
      redirect_to root_path
    end
  end
end