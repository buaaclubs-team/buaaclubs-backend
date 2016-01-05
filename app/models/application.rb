class Application < ActiveRecord::Base
    belongs_to :wantedclub,class_name:'Club',foreign_key: 'club_id',inverse_of: :applications, validate: true
    belongs_to :applicant,class_name:'User',foreign_key: 'user_id',inverse_of: :applications, validate: true
    validates :wantedclub,:applicant, presence: true

 
    validates :reason,presence: true
end
