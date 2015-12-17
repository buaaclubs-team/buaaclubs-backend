class Comment < ActiveRecord::Base
    belongs_to :article, inverse_of: :comments, validate: true
    validates :reply_id, :content, :sender_id, :sender_type, presence: true
end
