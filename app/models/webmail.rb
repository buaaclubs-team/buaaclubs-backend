class Webmail < ActiveRecord::Base
    validates :sender_id, :sender_name, :receiver_id, :receiver_type, :content, :ifread, presence: true
end
