require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

#  test "should register user" do
#      assert_difference('User.count') do
#      post :register, { name: 'wk', passwd: '123456', phone_num: '11111111111', uid: '11111111',email: '1234567890@qq.com' }
#    end
#      assert_response :success
#  end
  
  test "should login user" do


       
       post:login, {uid: '13061196',passwd: 'fushuai'}
       assert_response :success
  end
  test "should login failed" do
       post:login, {uid: '13061196',passwd: 'fushuaisb'}
       assert_response 401
  end

  test "should logout user" do
      

       @request.headers["uid"] = "13061196"
       @request.headers["token"] = Digest::MD5.hexdigest("#{"13061196" + 1234.to_s}")
       get :logout

       assert_response :success
  end
  test "should logout user failed" do


       @request.headers["uid"] = "13061196"
       @request.headers["token"] = "1"
       get :logout

       assert_response 401
  end
  

'''
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end
  test "should create user" do
'''
   #   assert_difference('User.count') do
'''
      post :create, user: { name: @user.name, password: @user.password, phone_num: @user.phone_num, stu_num: @user.stu_num }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { name: @user.name, password: @user.password, phone_num: @user.phone_num, stu_num: @user.stu_num }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
'''
   # assert_difference('User.count', -1) do
'''
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
'''
end
