class UsersController < ApplicationController
 # before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token
  skip_before_action :require_club_login
  skip_before_action :require_user_login, only: [:register, :login, :checkuid]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

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
#    puts @user.password
    if @user.save
      UserMailer.welcome_email(@user).deliver_now
      @user.log_num = rand(10000000)
      render :json => {:name => @user.name, :uid => @user.stu_num, :token => Digest::MD5.hexdigest("#{@user.stu_num.to_s + @user.log_num.to_s}"), :user_head =>  @user.user_head}
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

   def inform
    @webmail = Webmail.new
    @club = Club.find_by club_account: params[:club_id]
    @user = User.find_by stu_num: request.headers[:uid]
    @webmail.sender_id = -1
    @webmail.sender_name = "system"
    @webmail.receiver_id = @club.id
    @webmail.receiver_type = 1
    @webmail.content = @user.stu_num.to_s + "quit your club!"
    @webmail.ifread = 0
    @webmail.save
    render nothing: true, status: 200
   end

   #POST /api/users/clubs/articles/:article_id/comments/reply/:reply_id
   def reply
    if params[:reply_id].to_i==-1
       render nothing: true, status: 404
    end
    @user = User.find_by stu_num: request.headers[:uid]
    @content = JSON.parse(request.body.string)
    @webmail = Webmail.new
    @webmail.sender_id =  -1
    @webmail.sender_name = "system"
    @comment =  Comment.find_by sender_id: params[:reply_id].to_i
    #puts params[:article_id]
    @article = Article.find( params[:article_id].to_i)
    @webmail.receiver_id = @comment.sender_id
    @webmail.receiver_type = 0
    @webmail.content = @article.abstract+ @comment.content + " " + @comment.id.to_s + "" + @content["content"] + " " + @user.stu_num.to_s
    @webmail.ifread = 0
    @webmail.save
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
    a<<{:webmail_id => @webmail.id,:sender_id => @webmail.sender_id,:sender_name=>@webmail.sender_name, :receiver_id => @webmail.receiver_id,:receiver_id,:content=>@webmail.content,:if_read=>@webmail.ifread}
    render :json=>{:txt => a}.to_json, status:200
 
  end

  # POST /api/users/login
  def login
#    @user = User.find_by stu_num: env["HTTP_UID"].to_i
   
    @user = User.find_by stu_num: request.headers[:uid]
    puts request.headers[:uid]
    puts request.headers[:passwd]
    if !@user.nil? and @user.password == request.headers[:passwd]
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
