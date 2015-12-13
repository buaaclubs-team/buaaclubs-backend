require 'test_helper'

class InformsControllerTest < ActionController::TestCase
  setup do
    @inform = informs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:informs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create inform" do
    assert_difference('Inform.count') do
      post :create, inform: {  }
    end

    assert_redirected_to inform_path(assigns(:inform))
  end

  test "should show inform" do
    get :show, id: @inform
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @inform
    assert_response :success
  end

  test "should update inform" do
    patch :update, id: @inform, inform: {  }
    assert_redirected_to inform_path(assigns(:inform))
  end

  test "should destroy inform" do
    assert_difference('Inform.count', -1) do
      delete :destroy, id: @inform
    end

    assert_redirected_to informs_path
  end
end
