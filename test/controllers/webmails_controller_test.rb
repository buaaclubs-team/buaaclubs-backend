require 'test_helper'

class WebmailsControllerTest < ActionController::TestCase
  setup do
    @webmail = webmails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:webmails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create webmail" do
    assert_difference('Webmail.count') do
      post :create, webmail: { content: @webmail.content, ifread: @webmail.ifread, receiver_id: @webmail.receiver_id, receiver_type: @webmail.receiver_type, sender_id: @webmail.sender_id, sender_name: @webmail.sender_name }
    end

    assert_redirected_to webmail_path(assigns(:webmail))
  end

  test "should show webmail" do
    get :show, id: @webmail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @webmail
    assert_response :success
  end

  test "should update webmail" do
    patch :update, id: @webmail, webmail: { content: @webmail.content, ifread: @webmail.ifread, receiver_id: @webmail.receiver_id, receiver_type: @webmail.receiver_type, sender_id: @webmail.sender_id, sender_name: @webmail.sender_name }
    assert_redirected_to webmail_path(assigns(:webmail))
  end

  test "should destroy webmail" do
    assert_difference('Webmail.count', -1) do
      delete :destroy, id: @webmail
    end

    assert_redirected_to webmails_path
  end
end
