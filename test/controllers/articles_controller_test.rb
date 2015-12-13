require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  setup do
    @article = articles(:one)
  end
#  test "should cutlist article" do 
 #   @request.headers["uid"] = "lingfengshe"
  #  @request.headers["token"] = Digest::MD5.hexdigest("#{"lingfengshe" + 123456.to_s}")
  #  @request.body << '{article_id:980190962,{uids:[13061196]}}'
  #  a = []
  #  a << '13061196'
  #  post :cutlist,{article_id:'980190962'}
  #  assert_response :success      
 # end
  test "should list article" do
    
    @request.headers["uid"] = "lingfengshe"
    @request.headers["token"] = Digest::MD5.hexdigest("#{"lingfengshe" + 123456.to_s}")
    post :list,{:article_id => 980190962 }
    assert_response :success
  end
  test "should abstracts article"do
    get :abstracts, {page_id: '1'}
    assert_response :success
  end
  test"should detail article" do
    get :detail,{article_id: 980190962}
    assert_response :success
  end
  test"should show article"do
     @request.headers["uid"] = "lingfengshe"
    @request.headers["token"] = Digest::MD5.hexdigest("#{"lingfengshe" + 123456.to_s}")
    post:show,{article_id: 980190962}
  end
 # test"shoould create article"do
  #   @request.headers["uid"] = "lingfengshe"
  #  @request.headers["token"] = Digest::MD5.hexdigest("#{"lingfengshe" + 123456.to_s}")
  #  request.body<< "{'title':'asdasda','content':'asdasdasd','abstract':'ajsdhjasdhk'}"
  #  assert_difference('Article.count') do

   # post:create,{title:'asdasda',content:'asdasdasd',abstract:'adhjasdhk'}
   # end
#    assert_response :success
#  end
 # test"should update article"do
  #    @request.headers["uid"] = "lingfengshe"
   #   @request.headers["token"] = Digest::MD5.hexdigest("#{"lingfengshe" + 123456.to_s}")
    #  @request.body = {title:'asdasda',content:'asdasdasd',abstract:'ajsdhjasdhk',article_id: 980190962} 
    # post:update
    # assert_response :success

 # end
  test "should destroy article"do
      @request.headers["uid"] = "lingfengshe"
    @request.headers["token"] = Digest::MD5.hexdigest("#{"lingfengshe" + 123456.to_s}")
    post:destroy,{article_id: 980190962}
    assert_response :success

  end
'''
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create article" do
'''
   # assert_difference('Article.count') do
'''    
  post :create, article: { abstract: @article.abstract, content: @article.content, title: @article.title }
    end

    assert_redirected_to article_path(assigns(:article))
  end

  test "should show article" do
    get :show, id: @article
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @article
    assert_response :success
  end

  test "should update article" do
    patch :update, id: @article, article: { abstract: @article.abstract, content: @article.content, title: @article.title }
    assert_redirected_to article_path(assigns(:article))
  end

  test "should destroy article" do
'''   
 #assert_difference('Article.count', -1) do
  
'''    delete :destroy, id: @article
    end

    assert_redirected_to articles_path
  end
'''
end
