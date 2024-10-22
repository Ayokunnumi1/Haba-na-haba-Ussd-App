require "test_helper"

class FamilyBeneficiariesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get family_beneficiaries_index_url
    assert_response :success
  end

  test "should get show" do
    get family_beneficiaries_show_url
    assert_response :success
  end

  test "should get new" do
    get family_beneficiaries_new_url
    assert_response :success
  end

  test "should get edit" do
    get family_beneficiaries_edit_url
    assert_response :success
  end
end
