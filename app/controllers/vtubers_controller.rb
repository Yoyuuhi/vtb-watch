class VtubersController < ApplicationController
  before_action :set_company

  # インクリメンタルサーチ用メソッド
  def index
    return nil if params[:keyword] == ""
    @CompanyId = Company.where('name LIKE :KEY', KEY: "%#{params[:keyword]}%").ids

    # 名前、twitter、所属会社でvtuberを検索する
    @vtubers = Vtuber.includes(:company).where('(name LIKE ?) OR (twitter LIKE ?) OR (company_id = ?)', "%#{params[:keyword]}%", "%#{params[:keyword]}%", @CompanyId).limit(10)
    return @vtubers
    respond_to do |format|
      format.json
    end
  end

  # vtuberとmylist対応関係をアップデートするメソッド
  def update
    @vtuber = Vtuber.find(params[:id])
    @vtuber.update(check_params)
  end

  def show
    @vtuber = Vtuber.find(params[:id])
    videos = @vtuber.videos.order(publishedAt: "DESC")
    videos_all_today = []
    videos_all_yesterday = []
    videos_all_2daysAgo = []
    videos.each do |video|
      if (video[:created_at].to_s.match(/#{Date.today.to_s}.+/)) 
        videos_all_today << video
      end
      if (video[:created_at].to_s.match(/#{Date.yesterday.to_s}.+/))
        videos_all_yesterday << video
      end
      if (video[:created_at].to_s.match(/#{Date.today.days_ago(2).to_s}.+/)) 
        videos_all_2daysAgo << video
      end
    @videos_all_today = videos_all_today
    @videos_all_yesterday = videos_all_yesterday
    @videos_all_2daysAgo = videos_all_2daysAgo
    end
    @videos_onair = videos.where.not(actualStartTime: nil).where(actualEndTime: nil)
    @videos_planned = videos.where(actualStartTime: nil).where(liveStreamingDetails: nil)
    # サイドバー用ユーザー所有mylist情報
    @mylists = current_user.mylists
    @mylist = Mylist.new
  end

  private
  def set_company
    @companies = Company.pluck('name')
  end

  def check_params
    params.require(:vtuber).permit(:id, mylist_ids: [])
  end
end
