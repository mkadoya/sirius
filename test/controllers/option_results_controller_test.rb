require 'test_helper'

class OptionResultsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get option_results_index_url
    assert_response :success
  end

end
