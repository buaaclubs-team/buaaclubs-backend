class UserMailer < ApplicationMailer
  default from: 'wowotoubuaa@sina.com'

  def welcome_email(user)
    @user = user
    @url  = 'http://www.buaaclubs.com/api/users/email/verify/' + Digest::MD5.hexdigest("#{@user.email_verify_code.to_s + @user.stu_num}")
    mail(to: @user.email, subject: 'Welcome to BuaaClubs!')
  end

  def inform_email(club,information,user)
	@club = club
	@information = information
	@user = user
	mail(to: @user.email, subject: '您有新的社团通知！')
  end

  def verify_email(user)
    @user = user
    @url  = 'http://www.buaaclubs.com/api/users/email/verify/' + Digest::MD5.hexdigest("#{@user.email_verify_code.to_s + @user.stu_num}")
    mail(to: @user.email, subject: '您收到来自BuaaClubs的验证邮件！')
  end

  def fp_email(user)
    @user = user
    @url  = 'http://www.buaaclubs.com/api/users/forgetpassword/email/verify/' + Digest::MD5.hexdigest("#{@user.email_verify_code.to_s + @user.stu_num}")
    mail(to: @user.email, subject: '请确认您是否忘记密码！')
  end
end
