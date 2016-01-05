class UsersController < ApplicationController
 # before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token
  skip_before_action :require_club_login
  skip_before_action :require_user_login, only: [:register, :login, :checkuid, :detail,:statistics,:verify_phone_sendcode, :verify_phone, :verify_email, :fp_email, :fp_email_verify, :fp_phone_send, :fp_phone_verify]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # POST '/api/users/phone_num/verify/code' 手机验证发送验证码
  def verify_phone_sendcode
    @body = JSON.parse(request.body.string)
    @user = User.find_by stu_num: @body["stu_num"]
    if @user.nil?
      render text: 'User not exist', status: 404
    end
    @user.phone_verify_code = rand(9999)
    @user.save
    sendMessageVeryifyCode(@user.phone_verify_code, @user.phone_num)
    render text: 'sent', status: 200
  end
  
  # POST '/api/users/phone_num/verify'  验证验证码是否正确
  def verify_phone
    @body = JSON.parse(request.body.string)
    @user = User.find_by stu_num: @body["stu_num"]
    @code = @body["code"]
    if @user.nil?
        render text: 'User not exist', status: 404
    end
    if Digest::MD5.hexdigest("#{@user.phone_verify_code.to_s}") != @code
        @user.phone_verify = 0
        @user.save
	render text: 'verification code wrong', status: 404
    else
        @user.phone_verify = 1
        @user.save
        render text: 'succeeded', status: 200
    end
  end
  
  # POST 'GET /api/users/email/verify' 验证邮箱，给邮箱寄信
  def verify_email_send
    @body = JSON.parse(request.body.string)
    @user = User.find_by stu_num: @body["stu_num"]
	if @user.nil? then render text: 'user not exist', status: 404 end
	@user.email = @body["email"]
	@user.email_verify = 0
	@user.email_verify_code = rand(10000000)
	@user.save
	UserMailer.verify_email(@user)
	render nothing: true, status: 200
  end
  
  # GET '/api/users/email/verify/:uid/:hash_code' 验证邮箱，邮箱点击链接返回
  def verify_email
    @user = User.find_by stu_num: params[:uid]
	if @user.nil? then render text: 'user not exist', status: 404 end
	if params[:hash_code] == Digest::MD5.hexdigest("#{@user.email_verify_code.to_s + @user.stu_num}")
	  @user.email_verify = 1
	  @user.save
	  redirect_to "http://www.buaaclubs.com/myWeb/myNewHomePage.html/" # 改为有参数的登陆成功页面
	else
		redirect_to "http://www.buaaclubs.com/myWeb/myNewHomePage.html/" # 理想的应该是验证失败页面
	end
  end
  
  # POST '/api/users/forgetpassword/email' 忘记密码，邮箱
  def fp_email
    @body = JSON.parse(request.body.string)
    @user = User.find_by stu_num: @body["stu_num"]
	if @user.nil? then render text: 'user not exist', status: 404 end
	if @user.email_verify == 0 then render text: 'email not verified', status: 401 end
	@user.email_verify_code = rand(10000000)
	@user.save
	UserMailer.fp_email(@user)
	render nothing: true, status: 200
  end
  
  # GET '/api/users/forgetpassword/email/verify/:uid/:hash_code' 忘记密码，邮箱转跳
  def fp_email_verify
    @user = User.find_by stu_num: params[:uid]
	if @user.nil? then render text: 'user not exist', status: 404 end
	if params[:hash_code] == Digest::MD5.hexdigest("#{@user.email_verify_code.to_s + @user.stu_num}")
	  @user.email_verify = 1
	  @user.save
	  redirect_to "http://www.buaaclubs.com/myWeb/myNewHomePage.html/" # 改为有参数的设置密码按页面
	else
		redirect_to "http://www.buaaclubs.com/myWeb/myNewHomePage.html/" # 理想的应该是验证失败页面
	end 
  end
  
  # POST '/api/users/forgetpassword/phone_num/send' 忘记密码，手机
  def fp_phone_send
    @body = JSON.parse(request.body.string)
    @user = User.find_by stu_num: @body["stu_num"]
    if @user.nil?
      render text: 'User not exist', status: 404
    end
    if @user.phone_verify == 0 then render text: 'Phone not verified', status: 401 end
    @user.phone_verify_code = rand(9999)
    @user.save
    sendMessageVeryifyCode(@user.phone_verify_code, @user.phone_num)    
    render text: 'sent', status: 200
  end
  
  # POST '/api/users/forgetpassword/phone_num/verify' 忘记密码，手机
  def fp_phone_verify
    @body = JSON.parse(request.body.string)
    @user = User.find_by stu_num: @body["stu_num"]
    @code = @body["code"]
    if @user.nil?
	render text: 'User not exist', status: 404
    end
    if Digest::MD5.hexdigest("#{@user.phone_verify_code.to_s}") != @code
	@user.phone_verify = 0
	@user.save
	render text: 'verification failed', status: 404
    else 
	@user.phone_verify = 1
	@user.save
	redirect_to "http://www.buaaclubs.com/myWeb/myNewHomePage.html/" # 改为有参数的登陆成功页面
    end
  end
  #GET /api/users/detail
  def detail
     @user = User.find_by stu_num: params[:uid]
     if @user.nil?
        render :json => {txt:'user not exit' } ,status: 404
     else
        render :json => {:uid => @user.stu_num,:name => @user.name,:phone_num =>@user.phone_num,:email => @user.email,:user_head => @user.user_head,:phone_num_verify => @user.phone_verify,:email_verify => @user.email_verify},status: 404
     end

  end

  #POST /api/users/statistics
  def ststistics
      @user = User.find_by stu_num: params[:uid]
     if @user.nil?
        render :json => {txt:'user not exit' } ,status: 404
     else
        club_num = @user.clubs.length
        activity_num = @user.articles.length
        render :json => {:club_num => club_num,:activity_num => activity_num},status:200
     end
  end

  # GET '/api/users/register/check/:uid'
  def checkuid
     @user = User.find_by stu_num: params[:uid]
     if @user.nil?
        render :json => {txt:'uid available' } ,status: 200
     else
        render :json => {txt:'uid not available'},status: 404
     end
  end

  # POST /api/register
  def register
    
#    puts user_params
   
    @user = User.new
    @user.name = params[:name]
    @user.stu_num = params[:uid]
    @user.phone_num = params[:phone_num]
    @user.password = params[:passwd]
    @user.email = params[:email]
    @user.user_head = "http://7xob9u.com1.z0.glb.clouddn.com/defaultHead.jpg"
    @user.email_verify = 0;
    @user.phone_verify = 0;
#    puts @user.password
    if @user.save
      UserMailer.welcome_email(@user).deliver_now
      @user.log_num = rand(10000000)
      @user.save
      render :json => {:name => @user.name, :uid => @user.stu_num, :token => Digest::MD5.hexdigest("#{@user.stu_num.to_s + @user.log_num.to_s}"), :user_head =>  @user.user_head}
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

   def apply
     @club = Club.find_by club_account: params[:club_id]
    @user = User.find_by stu_num: request.headers[:uid]
     @content = JSON.parse(request.body.string)
     
     if @club.nil? or @user.nil?
         render nothing: true, status: 404
     end
     @application = Application.new
     @application.user_id = @user.id
     @application.club_id = @club.id
     @application.reason = @content["reason"]
     @application.accept = -1
     @application.save
     render nothing: true, status: 200
   end

   def inform
    @webmail = Webmail.new
    @club = Club.find_by club_account: params[:club_id]
    @user = User.find_by stu_num: request.headers[:uid]
    @webmail.sender_id = -1
    @webmail.sender_name = "system"
    @webmail.receiver_id = @club.id
    @webmail.receiver_type = 1
    @webmail.content = @user.stu_num + "quit your club!"
    @webmail.ifread = 0
   end

   #POST /api/users/clubs/articles/:article_id/comments/reply/:reply_id 用户评论
   def reply

    @comment = Comment.new
    @comment.article_id = params[:article_id]
    @comment.reply_id = params[:reply_id]
    @content = JSON.parse(request.body.string)
    @comment.content = @content["content"]
    @user = User.find_by stu_num: request.headers[:uid]
    @comment.sender_id = @user.id
    @comment.sender_type = 0
    @comment.save
    if @comment.reply_id != -1
    @comment =  Comment.find_by sender_id: params[:reply_id].to_i
    if @comment.sender_type != 1
    @webmail = Webmail.new
    @webmail.sender_id =  -1
    @webmail.sender_name = "system"
    #puts params[:article_id]
    @article = Article.find( params[:article_id].to_i)
    @webmail.receiver_id = @comment.sender_id
    @webmail.receiver_type = 0
    @webmail.content = "您在"+@article.title+"中的评论："+ @comment.content + " 收到一则回复"
    @webmail.ifread = 0
    @webmail.save
    end
    end
    render nothing: true, status: 200

  end

  #POST /api/users/webmails/readall
  def readall
    @user = User.find_by stu_num: request.headers[:uid]
    if @user.nil?
        render nothing: true, status: 404
    end
    a = []
    Webmail.all.each do |webmail|
       if webmail.receiver_id.to_s == @user.stu_num
          a<<{:webmail_id => webmail.id,:sender_id => webmail.sender_id,:sender_name=>webmail.sender_name, :receiver_id => webmail.receiver_id,:content=>webmail.content,:if_read=>webmail.ifread}
          #puts " dsffsg"
          #format.html { render :json=>{:txt => a}.to_json }
       end
    end
    render :json=>{:txt => a}.to_json,status: 200

  end 
  
   def usergetcontent
    @user = User.find_by stu_num: request.headers[:uid]
    if @user.nil?
        render nothing: true, status: 404
    end
     @webmail = Webmail.find(params[:webmail_id].to_i)
    if @webmail.nil?
       render text: 'Webmail not exit',status: 404
    end
    if @webmail.ifread==0
       @webmail.ifread=1
    end
    a = []
    a<<{:webmail_id => @webmail.id,:sender_id => @webmail.sender_id,:sender_name=>@webmail.sender_name, :receiver_id => @webmail.receiver_id,:content=>@webmail.content,:if_read=>@webmail.ifread}
    render :json=>{:txt => a}.to_json, status:200

  end


  # POST /api/users/login
  def login
#    @user = User.find_by stu_num: env["HTTP_UID"].to_i
   
    @user = User.find_by stu_num: params[:uid]
    if !@user.nil? and @user.password == params[:passwd]
      @user.log_num = rand(10000000)
      @user.save
      render :json => {:name => @user.name, :uid => @user.stu_num, :token => Digest::MD5.hexdigest("#{@user.stu_num.to_s + @user.log_num.to_s}"), :user_head => @user.user_head}
    else
      render :json =>  {txt: 'user login failed'}, status: 401
    end
  end
  
  # GET /api/users/logout
  def logout
          head = request.headers["uid"]
          
          @user = User.where(stu_num: head).take
          @user.update(log_num: nil)
          respond_to do |format|
            format.html { render nothing: true, :status => 200 }
           
            end
  end




  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:stu_num, :name, :password, :phone_num, :user_head)
    end
end
