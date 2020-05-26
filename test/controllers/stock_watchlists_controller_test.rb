require 'test_helper'

class StockWatchlistsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get stock_watchlists_create_url
    assert_response :success
  end

end
