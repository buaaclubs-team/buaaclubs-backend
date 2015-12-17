class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # 如果不需要验证，需要在控制器前注明 skip_before_action :user_or_club_login, only:[:方法]
  before_action :require_user_login, :require_club_login, :add_access_allow

  private

  def add_access_allow
    response.headers['Access-Control-Allow-Origin'] = "*"
  end

  # 验证用户账户登录信息
  def require_user_login
#    puts "------------------------"
 #   puts request.headers["uid"]
  #  puts request.headers["token"]
    
   # puts "------------------------"
    @user  = User.find_by stu_num: request.headers["uid"]
    if @user.nil? or  request.headers["token"] != Digest::MD5.hexdigest("#{@user.stu_num + @user.log_num.to_s}") then render text: 'Invalid User', status: 401
    end
  end

  # 验证社团账户登录信息
  def require_club_login
 # puts "------------------------"
  #  puts request.headers["uid"]
   # puts request.headers["token"]

    #puts "------------------------"

    @club = Club.find_by club_account: request.headers["uid"]
    puts "######################33"
    puts Digest::MD5.hexdigest("#{@club.club_account + @club.log_num.to_s}")
    if @club.nil? or request.headers["token"] != Digest::MD5.hexdigest("#{@club.club_account + @club.log_num.to_s}") then render text: 'Invalid Club', status: 401
    end
  end

  def sendMessageVeryifyCode(code, phone)
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
    
    messagexsend = MessageXSend.new(message_config)
    messagexsend.add_to("#{phone}")
    messagexsend.set_project("HpBVJ4")
    messagexsend.add_var("code", "#{code}")
    puts messagexsend.message_xsend()}
	render nothing: true, status: 200
  end
end
