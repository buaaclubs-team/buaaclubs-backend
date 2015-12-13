require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "user attributes must no be empty" do
      user = User.new
      assert user.invalid?
      assert user.errors[:stu_num].any?
      assert user.errors[:name].any?
      assert user.errors[:password].any?
      assert user.errors[:phone_num].any?
  end
  test "stu_num must be eight" do
      user = User.new(:stu_num => "123")
      assert user.invalid?
      assert user.errors[:stu_num].any?
  end
  test "stu_num should be unique" do
      user = User.new(:stu_num => "1306111",
                      :name => "sd",
                      :password => "sdsd",
                      :phone_num => "1233")
      assert !user.save
  end
end
