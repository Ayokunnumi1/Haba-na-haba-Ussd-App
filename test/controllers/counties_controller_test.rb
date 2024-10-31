require 'test_helper'

class CountiesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get counties_index_url
    assert_response :success
  end

  test 'should get show' do
    get counties_show_url
    assert_response :success
  end

  test 'should get new' do
    get counties_new_url
    assert_response :success
  end

  test 'should get edit' do
    get counties_edit_url
    assert_response :success
  end
end
