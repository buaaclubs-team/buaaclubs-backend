class User < ActiveRecord::Base
#  has_and_belongs_to_many :clubs
  has_many :notes, inverse_of: :user,dependent: :destroy
  has_many :articles, through: :notes

  validates :stu_num, :name, :password, :phone_num, presence: true
  validates :stu_num, length: {is: 8}
 # validates :stu_num, length: {is: 8}
#  validate :stu_num_is_eight
 # validates :password, length: {in: 6..20}
 # validates :stu_num, format: {with: /([0-9]){8}/}

  has_many :applications, inverse_of: :user, dependent: :destroy
  has_many :wantedclubs, class_name: 'Club',through: :applications,source: :wantedclub

  has_many :lists, inverse_of: true, dependent: :destroy
  has_many :clubs, through: :lists
'''
 def stu_num_is_eight
     if stu_num.to_s.size != 8
       errors.add(:stu_num, "should be 8 bit")
     end
 end
'''
end
