require 'test_helper'

class BranchesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get branches_index_url
    assert_response :success
  end

  test 'should get show' do
    get branches_show_url
    assert_response :success
  end

  test 'should get new' do
    get branches_new_url
    assert_response :success
  end

  test 'should get edit' do
    get branches_edit_url
    assert_response :success
  end
end
