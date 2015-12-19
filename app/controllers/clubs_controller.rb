class ClubsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  skip_before_action :require_user_login
  skip_before_action :require_club_login, only: [:login, :getabstracts, :exportlist]
  before_action :set_club, only: [:show, :edit, :update, :destroy]

  def exportlist
	@club = Club.where(club_account: request.headers[:uid]).take
#	 @club = Club.where(club_account: 'test1 account').take

	 if @club.nil?
           render text: 'Club not exit',status: 404
        end
        puts @club.club_account
        @members = @club.members
        if @members.length < 1
	   render text: 'Club no members',status: 404
        else
	   respond_to do |format|
		format.html{		
		  send_data(xls_content_for(@members),
			   :type => "text/excel;charset=utf-8;header=present",
			   :filename => "list_Users_#{Time.now.strftime("%Y%m%d")}.xls")
                }
	    end
        end
  end
  def memberslist
        m = []
        @club = Club.where(club_account: request.headers[:uid]).take
        if @club.nil?
           render text: 'Club not exit',status: 404
        end
        @members = @club.members
        num = @members.length - 1
        (0..num).each{|t| m<<{:uid => @members[t].stu_num,
                              :name => @members[t].name,
                              :phone_num => @members[t].phone_num,
                              :email => @members[t].email,
                              :user_head => @members[t].user_head,
                              :time => List.where({club_id: @club.id,user_id: @members[t].id}).take.created_at}}
        respond_to do |format|
         format.html { render :json=>{:txt => m}.to_json }
        end
  end  

  def forcequit
        @club = Club.where(club_account: request.headers[:uid]).take
        if @club.nil?
           render text: 'Club not exit',status: 404
        end
 	suc = false
        @members_id = JSON.parse(request.body.string)
        @members_id["uids"].each{|temp_id|
                                 member = User.find_by stu_num: temp_id
                                 find = false
                                 @club.lists.each{|temp_note| if temp_note.user_id == member.id
              							 find = true                                                                  
  								 temp_note.destroy
								 end}
                                 if !find
                                    suc = true
                                    render text: 'Member not exit',status: 404
                                 end
                                }
        if !suc
           render text: 'success',status: 200
        end
  end

  def applicationlist#获取申请人列表，注意是还没有处理的申请人列表
	apps = []
	@club = Club.where(club_account: request.headers[:uid]).take
        if @club.nil?
           render text: 'Club not exit',status: 404
        end
	@applicants = @club.applicants
        num = @applicants.length - 1
        (0..num).each{|t| if Application.where({club_id: @club.id,user_id: @applicants[t].id,accept: nil}).length < 2
                                apps << {:uid => @applicants[t].stu_num,
                                      :name => @applicants[t].name,
                                      :user_head => @applicants[t].user_head,
                                      :time => Application.where({club_id: @club.id,user_id: @applicants[t].id,accept: nil}).take.created_at,
 				      :reason => Application.where({club_id: @club.id,user_id: @applicants[t].id,accept: nil}).take.reason}
                          end
                     }
        respond_to do |format|
         	format.html { render :json=>{:txt => apps}.to_json }
        end

  end

  def acceptapplication
	@club = Club.where(club_account: request.headers[:uid]).take
        @user = User.find_by stu_num: params[:uid]
	if @club.nil?
           render text: 'Club not exit',status: 404
        end
	if @user.nil?
	   render text: 'User not exit',status: 404
        end
        if List.where(club_id: @club.id,user_id: @user.id).take.nil?
           render text: 'the person already one of club',status: 404
        end
        @Application = Application.where({club_id: @club.id,user_id: @user.id,accept: nil}).take
        if @Application.nil?
           render text: 'Application not exist',status: 404
        end
	@Application.accept = 1
        @Application.save
        @list = List.new
        @list.user_id = @user.id
	@list.club_id = @club.id
 	@list.save
	@webmail = Webmail.new
	@webmail.sender_id = -1;
	@webmail.sender_name = '系统'
	@webmail.receiver_id = @user.id
	@webmail.content = "您报名的社团" +　@club.name + "批准了您的加入请求"
	@webmail.ifread = 0;
        render text: 'success',status: 200
  end
  def refuseapplication
	@club = Club.where(club_account: request.headers[:uid]).take
	@user = User.find_by stu_num: params[:uid]
        if @club.nil?
           render text: 'Club not exit',status: 404
        end
        if @user.nil?
           render text: 'User not exit',status: 404
        end
        @Application = Application.where({club_id: @club.id,user_id: @user.id,accept: nil}).take
        if @Application.nil?
           render text: 'Application not exist',status: 404
        end
        @Application.accept = 0
	@Application.save
	@webmail = Webmail.new
        @webmail.sender_id = -1;
        @webmail.sender_name = '系统'
        @webmail.receiver_id = @user.id
        @webmail.content = "您报名的社团" +　@club.name + "拒绝了您的加入请求"
        @webmail.ifread = 0;

        render text: 'success',status: 200


  end
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

  # POST /api/clubs/infrom
  def inform
    @club = Club.find_by club_account: request.headers[:uid]
    @content = JSON.parse(request.body.string)
    @information = @content["content"]
    kind =  @content["type"].to_i
    @inform = Inform.new
    @inform.content = @information
    if kind==0 
      @inform.type = 0
      @inform.club_id = @club.id
      @content["uids"].each{|uid|
        @inform.concat(uid)
        @webmail = Webmail.new
        @webmail.sender_id =  @club.id
        @webmail.sender_name = @club.name
        @webmail.receiver_id = uid
        @webmail.receiver_type = 0
        @webmail.content = @information
        @webmail.ifread = 0
      }
    else
      if kind == 1
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
          @content["uids"].each{|uid|
            @user = User.find_by stu_num: uid
            messagexsend = MessageXSend.new(message_config)
            messagexsend.add_to("#{@user.phone_num}")
            messagexsend.set_project("DguyG")
            messagexsend.add_var("user_name", "#{@user.name}")
            messagexsend.add_var("club_name", "#{@club.name}")
            messagexsend.add_var("code", "#{@content["content"]}")
            puts messagexsend.message_xsend()
       }
      else
        @article = Article.find(@content["article_id"]).title
          @content["uids"].each{|uid|
            @user = User.find_by stu_num: uid
            if @user.email_verify ==0
               render nothing: true, status: 405
            end         
            UserMailer.inform_email(@club,@article,@information,@user).deliver_now          }
      end
    end
    render nothing: true, status: 200
  end
 
  #POST /api/clubs/articles/:article_id/comments/reply/:reply_id
  def reply
    if params[:reply_id].to_i==-1
       render nothing: true, status: 404
    end
    @club = Club.find_by club_account: request.headers[:uid]
    @content = JSON.parse(request.body.string)
    @webmail = Webmail.new
    @webmail.sender_id =  -1
    @webmail.sender_name = "system"
    @comment =  Comment.find_by sender_id: params[:reply_id]
    @webmail.receiver_id = @comment.sender_id
    @webmail.receiver_type = 0
    @webmail.content = @comment.title + " " + @comment.id + "" + @information + " " + @club.name
    @webmail.ifread = 0
    render nothing: true, status: 200
  end

  # POST /api/clubs/webmails/readall
  def readall
    @club = User.find_by club_account: request.headers[:uid]

    Webmail.all.each do |webmail|
       if webmail.receiver_id == @club.id && webmail.if_read
          webmail.show
          webmail.if_read=1;
       end
    end
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
    def xls_content_for(objs)
      xls_report = StringIO.new
      book = Spreadsheet::Workbook.new
      sheet1 = book.create_worksheet :name => "Members"
      
      blue = Spreadsheet::Format.new :color => :blue, :weight => :bold, :size => 10
      sheet1.row(0).default_format = blue
   
      sheet1.row(0).concat %w{学号 姓名 手机号 邮箱}
      count_row = 1
      objs.each do |obj|
         sheet1[count_row,0] = obj.stu_num
	 sheet1[count_row,1] = obj.name
	 sheet1[count_row,2] = obj.phone_num
         sheet1[count_row,3] = obj.email
         count_row += 1
      end
    book.write xls_report
    xls_report.string
    end
end
