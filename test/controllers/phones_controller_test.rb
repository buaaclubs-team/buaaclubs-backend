require 'test_helper'

class PhonesControllerTest < ActionController::TestCase
  setup do
    @phone = phones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:phones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create phone" do
    assert_difference('Phone.count') do
      post :create, phone: { phone_num: @phone.phone_num, phone_verify_num: @phone.phone_verify_num }
    end

    assert_redirected_to phone_path(assigns(:phone))
  end

  test "should show phone" do
    get :show, id: @phone
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @phone
    assert_response :success
  end

  test "should update phone" do
    patch :update, id: @phone, phone: { phone_num: @phone.phone_num, phone_verify_num: @phone.phone_verify_num }
    assert_redirected_to phone_path(assigns(:phone))
  end

  test "should destroy phone" do
    assert_difference('Phone.count', -1) do
      delete :destroy, id: @phone
    end

    assert_redirected_to phones_path
  end
end
