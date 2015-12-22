require 'test_helper'

class ClubsControllerTest < ActionController::TestCase
  setup do
    @club = clubs(:one)
  end
  test "should login club" do
       post:login, {uid: 'lingfengshe',passwd: '123456'}
       assert_response :success
  end
  test "should getabstracts club" do
       get:getabstracts, {uid: 'lingfengshe',page_id: '1'}
       assert_response :success
  end
  test "should logout club" do
        @request.headers["uid"] = "lingfengshe"
       @request.headers["token"] = Digest::MD5.hexdigest("#{"lingfengshe" + 123456.to_s}")
       get :logout

       assert_response :success
  end
  test "should get memberlist" do
       @request.headers["uid"] = "lingfengshe"
       @request.headers["token"] = Digest::MD5.hexdigest("#{"lingfengshe" + 123456.to_s}")
       post :memberlist
       assert_response :success
  end
  test "should get applicationlist" do
        @request.headers["uid"] = "lingfengshe"
       @request.headers["token"] = Digest::MD5.hexdigest("#{"lingfengshe" + 123456.to_s}")
        post :applicationlist

        assert_response :success
  end
  test "shoule accept application" do
        @request.headers["uid"] = "lingfengshe"
       @request.headers["token"] = Digest::MD5.hexdigest("#{"lingfengshe" + 123456.to_s}")
       post :acceptapplication
       assert_response :success
  end
  
  
end
'''
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clubs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create club" do
'''
 #   assert_difference('Club.count') do
 '''     
 post :create, club: { head_url: @club.head_url, introduction: @club.introduction, name: @club.name, password: @club.password }
    end

    assert_redirected_to club_path(assigns(:club))
  end

  test "should show club" do
    get :show, id: @club
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @club
    assert_response :success
  end

  test "should update club" do
    patch :update, id: @club, club: { head_url: @club.head_url, introduction: @club.introduction, name: @club.name, password: @club.password }
    assert_redirected_to club_path(assigns(:club))
  end

  test "should destroy club" do
  '''
   # assert_difference('Club.count', -1) do
''' 
     delete :destroy, id: @club
    end

    assert_redirected_to clubs_path
  end
'''

