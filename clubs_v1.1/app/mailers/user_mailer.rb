class UserMailer < ApplicationMailer
  default from: 'wowotoubuaa@sina.com'

  def welcome_email(user)
    @user = user
    @url  = 'http://www.buaaclubs.com/myWeb/myNewHomePage.html'
    mail(to: @user.email, subject: 'Welcome to BuaaClubs!')
  end

  def inform_email(club,article,information,user)
	@club = club
	@article = article
	@information = information
	@user = user
	mail(to: @user.email, subject: '您参加的活动有新的通知！')
  end
end
