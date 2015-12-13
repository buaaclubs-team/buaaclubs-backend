require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
 test "note attributes must not be empty" do
     note = Note.new
     assert note.invalid?
     assert note.errors[:user].any?
     assert note.errors[:article].any?
     assert !note.errors[:content].any?

 end
 test "user and club should be unique" do
     note = Note.new(:user_id => 1,:article_id => 1,:content => "sksksks")
     assert !note.save
 end
end
