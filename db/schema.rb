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

ActiveRecord::Schema[7.1].define(version: 2024_12_12_094414) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "branch_districts", force: :cascade do |t|
    t.bigint "branch_id", null: false
    t.bigint "district_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id", "district_id"], name: "index_branch_districts_on_branch_id_and_district_id", unique: true
    t.index ["branch_id"], name: "index_branch_districts_on_branch_id"
    t.index ["district_id"], name: "index_branch_districts_on_district_id"
  end

  create_table "branches", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.time "start_time"
    t.time "end_time"
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
    t.bigint "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "branch_id"
    t.decimal "provided_food"
    t.integer "event_id"
    t.index ["branch_id"], name: "index_family_beneficiaries_on_branch_id"
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
    t.bigint "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "branch_id"
    t.decimal "provided_food"
    t.integer "event_id"
    t.index ["branch_id"], name: "index_individual_beneficiaries_on_branch_id"
    t.index ["county_id"], name: "index_individual_beneficiaries_on_county_id"
    t.index ["district_id"], name: "index_individual_beneficiaries_on_district_id"
    t.index ["request_id"], name: "index_individual_beneficiaries_on_request_id"
    t.index ["sub_county_id"], name: "index_individual_beneficiaries_on_sub_county_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.string "donor_name"
    t.string "donor_type"
    t.date "collection_date"
    t.string "food_name"
    t.date "expire_date"
    t.bigint "district_id", null: false
    t.bigint "county_id", null: false
    t.bigint "sub_county_id", null: false
    t.string "residence_address"
    t.string "phone_number"
    t.decimal "amount"
    t.bigint "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "branch_id"
    t.decimal "collection_amount"
    t.integer "event_id"
    t.string "cloth_condition"
    t.string "cloth_name"
    t.string "cloth_size"
    t.integer "cloth_quantity"
    t.string "donation_type"
    t.integer "food_quantity"
    t.string "food_type"
    t.string "place_of_collection"
    t.decimal "cost_of_food"
    t.string "cloth_type"
    t.string "other_items_condition"
    t.string "other_items_name"
    t.integer "other_items_quantity"
    t.string "organization_name"
    t.string "organization_contact_person"
    t.string "organization_contact_phone"
    t.string "family_name"
    t.integer "family_member_count"
    t.index ["branch_id"], name: "index_inventories_on_branch_id"
    t.index ["county_id"], name: "index_inventories_on_county_id"
    t.index ["district_id"], name: "index_inventories_on_district_id"
    t.index ["request_id"], name: "index_inventories_on_request_id"
    t.index ["sub_county_id"], name: "index_inventories_on_sub_county_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "notifiable_type", null: false
    t.bigint "notifiable_id", null: false
    t.string "message"
    t.boolean "read", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["user_id"], name: "index_notifications_on_user_id"
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
    t.bigint "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "branch_id"
    t.decimal "provided_food"
    t.integer "event_id"
    t.index ["branch_id"], name: "index_organization_beneficiaries_on_branch_id"
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
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
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
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "gender"
    t.string "location"
    t.index ["branch_id"], name: "index_users_on_branch_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "branch_districts", "branches"
  add_foreign_key "branch_districts", "districts"
  add_foreign_key "counties", "districts"
  add_foreign_key "event_users", "events"
  add_foreign_key "event_users", "users"
  add_foreign_key "events", "counties"
  add_foreign_key "events", "districts"
  add_foreign_key "events", "sub_counties"
  add_foreign_key "family_beneficiaries", "branches"
  add_foreign_key "family_beneficiaries", "counties"
  add_foreign_key "family_beneficiaries", "districts"
  add_foreign_key "family_beneficiaries", "requests"
  add_foreign_key "family_beneficiaries", "sub_counties"
  add_foreign_key "individual_beneficiaries", "branches"
  add_foreign_key "individual_beneficiaries", "counties"
  add_foreign_key "individual_beneficiaries", "districts"
  add_foreign_key "individual_beneficiaries", "requests"
  add_foreign_key "individual_beneficiaries", "sub_counties"
  add_foreign_key "inventories", "branches"
  add_foreign_key "inventories", "counties"
  add_foreign_key "inventories", "districts"
  add_foreign_key "inventories", "requests"
  add_foreign_key "inventories", "sub_counties"
  add_foreign_key "notifications", "users"
  add_foreign_key "organization_beneficiaries", "branches"
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
