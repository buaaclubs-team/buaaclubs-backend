require 'test_helper'

class PhoneNumsControllerTest < ActionController::TestCase
  setup do
    @phone_num = phone_nums(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:phone_nums)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create phone_num" do
    assert_difference('PhoneNum.count') do
      post :create, phone_num: { phone_num: @phone_num.phone_num, phone_verify_num: @phone_num.phone_verify_num }
    end

    assert_redirected_to phone_num_path(assigns(:phone_num))
  end

  test "should show phone_num" do
    get :show, id: @phone_num
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @phone_num
    assert_response :success
  end

  test "should update phone_num" do
    patch :update, id: @phone_num, phone_num: { phone_num: @phone_num.phone_num, phone_verify_num: @phone_num.phone_verify_num }
    assert_redirected_to phone_num_path(assigns(:phone_num))
  end

  test "should destroy phone_num" do
    assert_difference('PhoneNum.count', -1) do
      delete :destroy, id: @phone_num
    end

    assert_redirected_to phone_nums_path
  end
end
