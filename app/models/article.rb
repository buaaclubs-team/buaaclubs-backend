class Article < ActiveRecord::Base
  self.inheritance_column = ""
  belongs_to :club, inverse_of: :articles,touch: true,validate: true
#  has_and_belongs_to_many :users
  has_many :notes, inverse_of: :article, dependent: :destroy
  has_many :users, through: :notes
  has_many :comments, inverse_of: :article, dependent: :destroy

  validates :club, presence: true
  validates :title, :abstract, :content,  presence: true
end
