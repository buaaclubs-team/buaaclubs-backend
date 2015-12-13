class Note < ActiveRecord::Base
  belongs_to :article, inverse_of: :notes, validate: true
  belongs_to :user, inverse_of: :notes, validate: true
  validates :user,:article, presence: true
end
