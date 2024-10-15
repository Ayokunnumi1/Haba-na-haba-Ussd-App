require 'test_helper'

class DistrictsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get districts_index_url
    assert_response :success
  end

  test 'should get show' do
    get districts_show_url
    assert_response :success
  end

  test 'should get new' do
    get districts_new_url
    assert_response :success
  end

  test 'should get edit' do
    get districts_edit_url
    assert_response :success
  end
end
