require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "article attributes must not be empty" do
       article = Article.new
       assert article.invalid?
       assert article.errors[:club].any?
       assert article.errors[:title].any?
       assert article.errors[:content].any?
       assert article.errors[:abstract].any?
  end
  test "article belongs to validate" do
      article = Article.new(:title => "qqq",
                            :content => "sadd",
                            :abstract => "123",
                            :club_id => 3)
      assert article.invalid?
      assert article.errors[:club].any?
  end
  test "Insert not unique title" do
      article = Article.new(:title => "qqq",
                            :content => "sadd",
                            :abstract => "123",
                            :club_id => 1)
      article.save
      assert article.errors.any?
      article1 = Article.new(:title => "qqq",
                            :content => "sadd",
                            :abstract => "123",
                            :club_id => 1)
      assert !article1.save
      #还需要进一步判断！！！！！！！！！！！！！！！！！
     # assert article1.errors.any?


  end
end
