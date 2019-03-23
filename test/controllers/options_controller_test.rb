require 'test_helper'

class OptionsControllerTest < ActionDispatch::IntegrationTest
  test "should get get" do
    get options_get_url
    assert_response :success
  end

end
