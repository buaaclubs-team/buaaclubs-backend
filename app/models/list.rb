class List < ActiveRecord::Base
	belongs_to :member,class_name: 'User',inverse_of: :lists,validate: true
        belongs_to :club, class_name: 'Club',inverse_of: :lists,validate: true
        validates :member,:club,presence: true

        
end
