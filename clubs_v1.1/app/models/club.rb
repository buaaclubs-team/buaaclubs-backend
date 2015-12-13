class Club < ActiveRecord::Base
  has_many :articles, inverse_of: :club, dependent: :destroy
  has_and_belongs_to_many :users

  validates :name, :introduction,:password, :club_account,presence: true
  validates :club_account, :name, uniqueness: true
#  validates :password ,length: {in: 6..20}
  
end
