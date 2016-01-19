class Inform < ActiveRecord::Base
     self.inheritance_column = ""
     belongs_to :club, inverse_of: :informs,touch: true,validate: true
     validates :users,:content,:type, presence: true
end
