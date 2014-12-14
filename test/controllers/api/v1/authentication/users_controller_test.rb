require 'test_helper'

class Api::V1::Authentication::UsersControllerTest < ActionController::TestCase
  test "should get sign_up" do
    get :sign_up
    assert_response :success
  end

end
