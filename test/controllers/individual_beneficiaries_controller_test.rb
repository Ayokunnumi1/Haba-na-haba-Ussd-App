require "test_helper"

class IndividualBeneficiariesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get individual_beneficiaries_index_url
    assert_response :success
  end

  test "should get show" do
    get individual_beneficiaries_show_url
    assert_response :success
  end

  test "should get new" do
    get individual_beneficiaries_new_url
    assert_response :success
  end

  test "should get edit" do
    get individual_beneficiaries_edit_url
    assert_response :success
  end
end
