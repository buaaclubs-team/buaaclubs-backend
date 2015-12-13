require 'test_helper'

class ClubTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "club attributes must not be empty" do
      club = Club.new
      assert club.invalid?
      assert club.errors[:name].any?
      assert club.errors[:introduction].any?
      assert club.errors[:club_account].any?
      assert club.errors[:password].any?
  end
  test "club_account should be unique" do
      club = Club.new(:name => "凌峰社",
                      :password => "asddas",
                      :introduction => "ajdhshd",
                      :club_account => "jshdj")
      assert !club.save
  end
  test "name shoule be unique" do
      club = Club.new(:name => "sdsd",
                      :password => "asddas",
                      :introduction => "ajdhshd",
                      :club_account => "lingfengshe")
      assert !club.save
  end
end
