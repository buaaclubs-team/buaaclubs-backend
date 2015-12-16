class List < ActiveRecord::Base
	belongs_to :member,class_name: 'User',foreign_key: 'user_id',inverse_of: :lists,validate: true
        belongs_to :club, class_name: 'Club',foreign_key: 'club_id',inverse_of: :lists,validate: true
	validates :member,:club,presence: true
        
end
