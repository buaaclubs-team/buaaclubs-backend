class Application < ActiveRecord::Base
    belongs_to :wantedclub,class_name:'Club',inverse_of: :applications, validate: true
    belongs_to :applicant,class_name:'User',inverse_of: :applications, validate: true
    validates :wantedclub,:applicant, presence: true

 
    validates :reason,presence: true
end
