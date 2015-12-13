class Club < ActiveRecord::Base
  has_many :articles, inverse_of: :club, dependent: :destroy
#  has_and_belongs_to_many :members,class_name: "User",foreign_key: 'user_id'

  validates :name, :introduction,:password, :club_account,presence: true
  validates :club_account, :name, uniqueness: true

  has_many :applicants,class_name: 'User',through: :applications
  has_many :applications, inverse_of: :club,dependent: :destroy

  has_many :members,class_name: 'User',through: :lists
  has_many :lists, inverse_of: :club,dependent: :destroy
 
  has_many :informs,inverse_of: :club, dependent: :destroy
  
#  validates :password ,length: {in: 6..20}
  
end
