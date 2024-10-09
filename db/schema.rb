# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_10_09_123705) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "branches", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.bigint "district_id", null: false
    t.bigint "county_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_branches_on_county_id"
    t.index ["district_id"], name: "index_branches_on_district_id"
  end

  create_table "counties", force: :cascade do |t|
    t.string "name"
    t.bigint "district_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["district_id"], name: "index_counties_on_district_id"
  end

  create_table "districts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_users_on_event_id"
    t.index ["user_id"], name: "index_event_users_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.bigint "district_id", null: false
    t.bigint "county_id", null: false
    t.bigint "sub_county_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_events_on_county_id"
    t.index ["district_id"], name: "index_events_on_district_id"
    t.index ["sub_county_id"], name: "index_events_on_sub_county_id"
  end

  create_table "family_beneficiaries", force: :cascade do |t|
    t.integer "family_members"
    t.integer "male"
    t.integer "female"
    t.integer "children"
    t.text "adult_age_range"
    t.text "children_age_range"
    t.bigint "district_id", null: false
    t.bigint "county_id", null: false
    t.bigint "sub_county_id", null: false
    t.text "residence_address"
    t.text "village"
    t.text "parish"
    t.text "phone_number"
    t.text "case_name"
    t.text "case_description"
    t.text "fathers_name"
    t.text "mothers_name"
    t.text "fathers_occupation"
    t.text "mothers_occupation"
    t.integer "number_of_meals_home"
    t.integer "number_of_meals_school"
    t.text "basic_FEH"
    t.text "basic_FES"
    t.bigint "request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_family_beneficiaries_on_county_id"
    t.index ["district_id"], name: "index_family_beneficiaries_on_district_id"
    t.index ["request_id"], name: "index_family_beneficiaries_on_request_id"
    t.index ["sub_county_id"], name: "index_family_beneficiaries_on_sub_county_id"
  end

  create_table "individual_beneficiaries", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "gender"
    t.string "residence_address"
    t.string "village"
    t.string "parish"
    t.string "phone_number"
    t.string "case_name"
    t.text "case_description"
    t.string "fathers_name"
    t.string "mothers_name"
    t.string "sur_name"
    t.bigint "district_id", null: false
    t.bigint "county_id", null: false
    t.bigint "sub_county_id", null: false
    t.bigint "request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_individual_beneficiaries_on_county_id"
    t.index ["district_id"], name: "index_individual_beneficiaries_on_district_id"
    t.index ["request_id"], name: "index_individual_beneficiaries_on_request_id"
    t.index ["sub_county_id"], name: "index_individual_beneficiaries_on_sub_county_id"
  end

  create_table "organization_beneficiaries", force: :cascade do |t|
    t.text "organization_name"
    t.integer "male"
    t.integer "female"
    t.text "adult_age_range"
    t.text "children_age_range"
    t.bigint "district_id", null: false
    t.bigint "county_id", null: false
    t.bigint "sub_county_id", null: false
    t.text "residence_address"
    t.text "village"
    t.text "parish"
    t.text "phone_number"
    t.text "case_name"
    t.text "case_description"
    t.text "registration_no"
    t.text "organization_no"
    t.text "directors_name"
    t.text "head_of_institution"
    t.integer "number_of_meals_home"
    t.text "basic_FEH"
    t.bigint "request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_organization_beneficiaries_on_county_id"
    t.index ["district_id"], name: "index_organization_beneficiaries_on_district_id"
    t.index ["request_id"], name: "index_organization_beneficiaries_on_request_id"
    t.index ["sub_county_id"], name: "index_organization_beneficiaries_on_sub_county_id"
  end

  create_table "requests", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "request_type"
    t.string "residence_address"
    t.string "village"
    t.string "parish"
    t.boolean "is_selected"
    t.bigint "district_id", null: false
    t.bigint "county_id", null: false
    t.bigint "sub_county_id", null: false
    t.bigint "branch_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_requests_on_branch_id"
    t.index ["county_id"], name: "index_requests_on_county_id"
    t.index ["district_id"], name: "index_requests_on_district_id"
    t.index ["sub_county_id"], name: "index_requests_on_sub_county_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "sub_counties", force: :cascade do |t|
    t.string "name"
    t.bigint "county_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_sub_counties_on_county_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "role"
    t.bigint "branch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_users_on_branch_id"
  end

  add_foreign_key "branches", "counties"
  add_foreign_key "branches", "districts"
  add_foreign_key "counties", "districts"
  add_foreign_key "event_users", "events"
  add_foreign_key "event_users", "users"
  add_foreign_key "events", "counties"
  add_foreign_key "events", "districts"
  add_foreign_key "events", "sub_counties"
  add_foreign_key "family_beneficiaries", "counties"
  add_foreign_key "family_beneficiaries", "districts"
  add_foreign_key "family_beneficiaries", "requests"
  add_foreign_key "family_beneficiaries", "sub_counties"
  add_foreign_key "individual_beneficiaries", "counties"
  add_foreign_key "individual_beneficiaries", "districts"
  add_foreign_key "individual_beneficiaries", "requests"
  add_foreign_key "individual_beneficiaries", "sub_counties"
  add_foreign_key "organization_beneficiaries", "counties"
  add_foreign_key "organization_beneficiaries", "districts"
  add_foreign_key "organization_beneficiaries", "requests"
  add_foreign_key "organization_beneficiaries", "sub_counties"
  add_foreign_key "requests", "branches"
  add_foreign_key "requests", "counties"
  add_foreign_key "requests", "districts"
  add_foreign_key "requests", "sub_counties"
  add_foreign_key "requests", "users"
  add_foreign_key "sub_counties", "counties"
  add_foreign_key "users", "branches"
end
