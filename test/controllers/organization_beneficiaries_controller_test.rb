require "test_helper"

class OrganizationBeneficiariesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get organization_beneficiaries_index_url
    assert_response :success
  end

  test "should get show" do
    get organization_beneficiaries_show_url
    assert_response :success
  end

  test "should get new" do
    get organization_beneficiaries_new_url
    assert_response :success
  end

  test "should get edit" do
    get organization_beneficiaries_edit_url
    assert_response :success
  end
end
