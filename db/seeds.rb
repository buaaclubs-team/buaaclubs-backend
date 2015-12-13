# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


#
 # Club.create(name: "lingfeng",introduction: "lingfeng is a club")

#  Club.create(name: "MIMIs", introduction: "MIMI is a club",club_account: "mimi")
#  (1..5).each{ |i| Article.create(club_id:"##{i}",title: "WJH ##{i}",abstract: "ACE ##{i}",content: "ACEWJH ##{i}")}

#   (5..5).each do |i| 
       User.create(stu_num: 88888888,name: "窝窝头",password: "12345678",phone_num: "12345678901")
       Club.create(name:"凌峰社",introduction:"凌峰社是一个社团",club_account: "lingfeng",password:"lingfeng")
  #  e
#(1..5).each{|i| Note.create(user_id: i,article_id: 21,content: "participate ")}



# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
