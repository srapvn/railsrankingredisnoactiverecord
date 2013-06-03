class RankingsController < ApplicationController

  http_basic_authenticate_with :name => "khanh", :password => "KHANH", :except => :index

  before_filter :get_ranking_by_userid, except: [:index, :new, :create, :destroy]
  # before_filter :check_auth, except: [:get_ranking, :index]

  def get_ranking_by_userid
    @ranking = Ranking.hgetall(params[:userid])
  end

  # def check_auth
  #   if params[:auth_key] != "CaXaNMZoZ3"
  #     redirect_to(rankings_path,notice: "Can't process, no auth_key")
  #   end
  # end

  # GET / , /top10/:key , /myrank/:userid/:key
  # GET /rankings.json
  def index
    @order = 0
    if params[:key]
      # self.check_auth
      if params[:userid] != nil
        @userid = params[:userid]
        @rankings = Ranking.send("myrank_#{params[:key]}", @userid )
      else
        @rankings = Ranking.send("top10_#{params[:key]}")
      end
    else
      @rankings = Ranking.send("top10_winpercentage")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rankings }
    end
  end

  # GET /1
  # GET /1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ranking }
    end
  end

  # GET /new
  # GET /new.json
  def new
    @ranking = Ranking.new
  end

  # GET /1/edit
  def edit
  end

  # POST /
  # POST /rankings.json
  def create
    rankinghash = params[:ranking]

    respond_to do |format|
      if Ranking.save2redis(rankinghash)
        format.html { redirect_to root_path, notice: 'Ranking was successfully created/updated'}
        format.json { render json: @ranking, status: :created, location: @ranking }
      else
        # format.html { render action: "edit" }
        format.html { redirect_to edituser_url(userid: params[:ranking][:userid]), notice: 'Unvalid parameter(s)' }
        format.json { render json: @ranking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /1
  # PUT /1.json
  alias_method :update, :create

  # DELETE /ranking/1
  # DELETE /ranking/1.json
  def destroy
    userid = params[:userid]

    if Ranking.destroy2redis(userid) > 0
      flash[:notice] = 'User was successfully deleted.'
    else
       flash[:notice] = 'Not successfully deleted.'
    end

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  # DELETE /1
  # DELETE /1.json
  alias_method :delete, :destroy

end
