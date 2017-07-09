require 'test_helper'

class ImageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get image_index_url
    assert_response :success
  end

  test "should get upload" do
    get image_upload_url
    assert_response :success
  end

  test "should get save" do
    get image_save_url
    assert_response :success
  end

end
