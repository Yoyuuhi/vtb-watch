class Vtubers::SearchesController < ApplicationController
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
end
