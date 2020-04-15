class VtubersController < ApplicationController
  before_action :set_company
  
  def show
    @mylist = Mylist.find(params[:mylist_id])
  end

  def new
    @vtuber = Vtuber.new
  end

  def create
    @vtuber = Vtuber.new(vtuber_params)
    if @vtuber.save
      redirect_to root_path, notice: '新しいvtuber情報を作成しました'
    else
      render :new
    end
  end

  def edit
    @vtuber = Vtuber.find(params[:id])
  end

  def update
    @vtuber = Vtuber.find(params[:id])
    if @vtuber.update(vtuber_params)
      redirect_to root_path, notice: 'vtuber情報を更新しました'
    else
      render :update
    end
  end

  private
  def vtuber_params
    company_id = Company.find_by(name: params.require(:vtuber)[:company])[:id]
    return params.require(:vtuber).permit(:name, :twitter, :channel).merge(company_id: company_id)
  end

  def set_company
    @companies = Company.pluck('name')
  end

end
