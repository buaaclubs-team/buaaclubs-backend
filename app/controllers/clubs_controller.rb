class ClubsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  skip_before_action :require_user_login
  skip_before_action :require_club_login, only: [:login, :getabstracts]
  before_action :set_club, only: [:show, :edit, :update, :destroy]
  
# POST 
  def sendemail
	@club = Club.where(club_account: request.headers[:uid]).take.name
	
	@content = JSON.parse(request.body.string)
	
	
	@article = Article.find(@content["article_id"]).title
	@information = @content["content"]
	@content["uids"].each{|uid|
	  
	  
	  @user = User.find_by stu_num: uid
	  UserMailer.inform_email(@club,@article,@information,@user).deliver_now
	render nothing: true, status: 200
	}
  end

  def sendmessage
     $LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))
    require 'submail'
   
    mail_config = {}
    mail_config["appid"] = "10660"
    mail_config["appkey"] = "bdd389b857d160c4e73396dbcdd9c455"
    mail_config["signtype"] = "md5"
    message_config = {}
    message_config["appid"] = "10660"
    message_config["appkey"] = "bdd389b857d160c4e73396dbcdd9c455"
    message_config["signtype"] = "md5"
   
    #message xsend
    
    @club = Club.find_by club_account: request.headers[:uid]
    @content = JSON.parse(request.body.string)
    @content["uids"].each{|uid|
      @user = User.find_by stu_num: uid
      messagexsend = MessageXSend.new(message_config)
      messagexsend.add_to("#{@user.phone_num}")
      messagexsend.set_project("DguyG")
      messagexsend.add_var("user_name", "#{@user.name}")
      messagexsend.add_var("club_name", "#{@club.name}")
      messagexsend.add_var("code", "#{@content["content"]}")
      puts messagexsend.message_xsend()}
	render nothing: true, status: 200
  end
  # POST /api/clubs/login
  def login
    @club = Club.find_by club_account: params[:uid]
    if !@club.nil? and params[:passwd] == @club.password
      @club.update(log_num: rand(10000000))
      render :json => {:name => @club.name, :headurl => @club.head_url,:uid => @club.club_account, :token => Digest::MD5.hexdigest("#{@club.club_account + @club.log_num.to_s}")}
    else
      render nothing: true, status: 401
    end
  end

  # GET /api/clubs/:uid/articles/:page_id
  def getabstracts
    a = []
    @club = Club.where(club_account: params[:uid]).take
    puts "-----------------------"
    puts @club.id
    x = params[:page_id].to_i
    if x>1
      x = (x-1)*5
    else
      x = 0
    end
        
	@articles = @club.articles.reverse
        puts @articles.length
        if @articles.length - x - 1 < 0
           render :json => {txt: "Not Record"}, :status => 404
        else 
	y = @articles.length - 1
	(x..x+4).each{|t| (y-t>=0)?a<<{:article_title => @articles[t].title,:article_abstract => @articles[t].abstract,:article_id => @articles[t].id} : break}
    respond_to do |format|
         format.html { render :json=>{:txt => a}.to_json }
	 end
        end
  end

  #GET /api/clubs/logout
  def logout
          head = request.headers["uid"]
          Club.where(club_account: head).exists?
          @club = Club.where(club_account: head).take
          @club.update(log_num: nil)
          
          respond_to do |format|
             format.html { render nothing: true,:status => 200 }
          end
  end

  # GET /clubs
  # GET /clubs.json
  def index
    @clubs = Club.all
  end

  # GET /clubs/1
  # GET /clubs/1.json
  def show
  end

  # GET /clubs/new
  def new
    @club = Club.new
  end

  # GET /clubs/1/edit
  def edit
  end

  # POST /clubs
  # POST /clubs.json
  def create
    @club = Club.new(club_params)

    respond_to do |format|
      if @club.save
        format.html { redirect_to @club, notice: 'Club was successfully created.' }
        format.json { render :show, status: :created, location: @club }
      else
        format.html { render :new }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clubs/1
  # PATCH/PUT /clubs/1.json
  def update
    respond_to do |format|
      if @club.update(club_params)
        format.html { redirect_to @club, notice: 'Club was successfully updated.' }
        format.json { render :show, status: :ok, location: @club }
      else
        format.html { render :edit }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clubs/1
  # DELETE /clubs/1.json
  def destroy
    @club.destroy
    respond_to do |format|
      format.html { redirect_to clubs_url, notice: 'Club was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_club
      @club = Club.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def club_params
      params.require(:club).permit(:club_account,:name, :password, :introduction, :head_url)
    end
end
