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

ActiveRecord::Schema[7.0].define(version: 2021_06_03_184445) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "subsidiary_id"
    t.string "category_type"
    t.index ["subsidiary_id"], name: "index_categories_on_subsidiary_id"
  end

  create_table "cities", force: :cascade do |t|
    t.bigint "country_id"
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "place_id"
    t.index ["country_id"], name: "index_cities_on_country_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "user_id"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["order_id"], name: "index_comments_on_order_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "components", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "code_scan"
    t.string "slug"
    t.bigint "thing_id"
    t.bigint "subsidiary_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["subsidiary_id"], name: "index_components_on_subsidiary_id"
    t.index ["thing_id"], name: "index_components_on_thing_id"
  end

  create_table "corporations", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "address"
    t.string "email"
    t.string "identification"
    t.string "corporate_initials"
    t.bigint "status_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "urlavatar"
    t.string "web_page"
    t.string "principal_activity"
    t.string "document_type"
    t.index ["status_id"], name: "index_corporations_on_status_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "country_code"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "place_id"
  end

  create_table "heat_maps", force: :cascade do |t|
    t.string "path"
    t.string "click_type"
    t.float "offset_x"
    t.float "offset_y"
    t.text "xpath"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "histories", force: :cascade do |t|
    t.text "description"
    t.string "origin"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "tecnic_id"
    t.bigint "order_id"
    t.text "photos"
    t.decimal "price", precision: 10, scale: 2
    t.string "warranty"
    t.time "time_install"
    t.integer "quantity"
    t.integer "discount"
    t.integer "supervisor_id"
    t.integer "customer_id"
    t.integer "out_thing_id"
    t.bigint "substatus_id"
    t.index ["customer_id"], name: "index_histories_on_customer_id"
    t.index ["order_id"], name: "index_histories_on_order_id"
    t.index ["out_thing_id"], name: "index_histories_on_out_thing_id"
    t.index ["substatus_id"], name: "index_histories_on_substatus_id"
    t.index ["supervisor_id"], name: "index_histories_on_supervisor_id"
    t.index ["tecnic_id"], name: "index_histories_on_tecnic_id"
  end

  create_table "logs", force: :cascade do |t|
    t.string "action"
    t.string "username"
    t.string "status_description"
    t.string "data_log", limit: 2000, default: "--- []\n"
    t.bigint "order_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["order_id"], name: "index_logs_on_order_id"
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "maintenances", force: :cascade do |t|
    t.datetime "maintenance_date", precision: nil
    t.integer "frequency"
    t.bigint "out_thing_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["out_thing_id"], name: "index_maintenances_on_out_thing_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "slug"
    t.string "order_internal_id"
    t.string "order_status"
    t.string "order_slug"
    t.datetime "read_at", precision: nil
    t.boolean "readed", default: false
    t.integer "supervisor_id"
    t.string "supervisor_name"
    t.integer "user_id"
    t.string "user_name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "subsidiary_id"
    t.index ["slug"], name: "index_notifications_on_slug"
    t.index ["subsidiary_id"], name: "index_notifications_on_subsidiary_id"
    t.index ["supervisor_id"], name: "index_notifications_on_supervisor_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "order_rates", force: :cascade do |t|
    t.text "comments"
    t.string "slug"
    t.boolean "active", default: true
    t.string "question_1"
    t.string "question_2"
    t.string "question_3"
    t.string "question_4"
    t.string "question_5"
    t.integer "answer_1"
    t.integer "answer_2"
    t.integer "answer_3"
    t.integer "answer_4"
    t.integer "answer_5"
    t.integer "month"
    t.integer "year"
    t.bigint "user_id"
    t.bigint "order_id"
    t.bigint "subsidiary_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["order_id"], name: "index_order_rates_on_order_id"
    t.index ["subsidiary_id"], name: "index_order_rates_on_subsidiary_id"
    t.index ["user_id"], name: "index_order_rates_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.text "description"
    t.string "address"
    t.integer "priority"
    t.boolean "sync"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "supervisor_id"
    t.integer "customer_id"
    t.integer "tecnic_id"
    t.bigint "status_id"
    t.date "install_date"
    t.time "install_time"
    t.integer "city_id"
    t.datetime "limit_time", precision: nil
    t.bigint "subsidiary_id"
    t.bigint "category_id"
    t.string "slug"
    t.string "internal_id"
    t.string "things_ids", default: "--- []\n"
    t.string "order_type", default: "Single"
    t.boolean "parent", default: false
    t.integer "parent_order"
    t.string "origin", default: "Operation"
    t.string "customer_id_order"
    t.bigint "substatus_id"
    t.text "comment"
    t.integer "out_thing_id"
    t.string "contact"
    t.string "phone_contact"
    t.index ["category_id"], name: "index_orders_on_category_id"
    t.index ["city_id"], name: "index_orders_on_city_id"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["out_thing_id"], name: "index_orders_on_out_thing_id"
    t.index ["status_id"], name: "index_orders_on_status_id"
    t.index ["subsidiary_id"], name: "index_orders_on_subsidiary_id"
    t.index ["substatus_id"], name: "index_orders_on_substatus_id"
    t.index ["supervisor_id"], name: "index_orders_on_supervisor_id"
    t.index ["tecnic_id"], name: "index_orders_on_tecnic_id"
  end

  create_table "out_things", force: :cascade do |t|
    t.integer "customer_id"
    t.integer "stock"
    t.bigint "thing_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["customer_id"], name: "index_out_things_on_customer_id"
    t.index ["thing_id"], name: "index_out_things_on_thing_id"
    t.index ["user_id"], name: "index_out_things_on_user_id"
  end

  create_table "position_logs", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.bigint "position_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["position_id"], name: "index_position_logs_on_position_id"
    t.index ["user_id"], name: "index_position_logs_on_user_id"
  end

  create_table "positions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "thing_id"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "out_thing_id"
    t.index ["out_thing_id"], name: "index_positions_on_out_thing_id"
    t.index ["thing_id"], name: "index_positions_on_thing_id"
    t.index ["user_id"], name: "index_positions_on_user_id"
  end

  create_table "referrals", force: :cascade do |t|
    t.text "comment"
    t.text "signature"
    t.string "full_name"
    t.datetime "final_time", precision: nil
    t.string "email"
    t.bigint "order_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["order_id"], name: "index_referrals_on_order_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "type_status"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "subsidiaries", force: :cascade do |t|
    t.bigint "status_id"
    t.string "name"
    t.string "phone"
    t.string "address"
    t.string "email"
    t.string "identification"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "password"
    t.string "subsidiary_initials"
    t.bigint "corporation_id"
    t.string "urlavatar"
    t.string "web_page"
    t.string "principal_activity"
    t.string "document_type"
    t.index ["corporation_id"], name: "index_subsidiaries_on_corporation_id"
    t.index ["status_id"], name: "index_subsidiaries_on_status_id"
  end

  create_table "substatuses", force: :cascade do |t|
    t.string "slug"
    t.boolean "visible", default: false
    t.string "substatus_type", default: "order_status"
    t.string "description"
    t.bigint "status_id"
    t.bigint "subsidiary_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["status_id"], name: "index_substatuses_on_status_id"
    t.index ["subsidiary_id"], name: "index_substatuses_on_subsidiary_id"
  end

  create_table "things", force: :cascade do |t|
    t.bigint "status_id"
    t.bigint "order_id"
    t.string "name"
    t.text "description"
    t.string "code_scan"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "photos"
    t.bigint "subsidiary_id"
    t.string "slug"
    t.bigint "user_id"
    t.string "order_ids", default: "--- []\n"
    t.bigint "category_id"
    t.string "internal_id"
    t.text "comments"
    t.string "position_ids", default: "--- []\n"
    t.bigint "substatus_id"
    t.decimal "final_price", precision: 15, scale: 2
    t.decimal "cost_price", precision: 15, scale: 2
    t.integer "stock"
    t.integer "weight"
    t.string "unit_weight"
    t.integer "serial_number"
    t.datetime "start_warranty", precision: nil
    t.datetime "finish_warranty", precision: nil
    t.string "urlavatar"
    t.datetime "start_time", precision: nil
    t.string "notification_time"
    t.index ["category_id"], name: "index_things_on_category_id"
    t.index ["code_scan"], name: "index_things_on_code_scan"
    t.index ["order_id"], name: "index_things_on_order_id"
    t.index ["status_id"], name: "index_things_on_status_id"
    t.index ["subsidiary_id"], name: "index_things_on_subsidiary_id"
    t.index ["substatus_id"], name: "index_things_on_substatus_id"
    t.index ["user_id"], name: "index_things_on_user_id"
  end

  create_table "tool_comments", force: :cascade do |t|
    t.text "comment"
    t.bigint "user_id"
    t.bigint "tool_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["tool_id"], name: "index_tool_comments_on_tool_id"
    t.index ["user_id"], name: "index_tool_comments_on_user_id"
  end

  create_table "tool_useless", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "code_scan"
    t.boolean "daily_use"
    t.string "slug"
    t.integer "tecnic_id"
    t.bigint "user_id"
    t.bigint "status_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["status_id"], name: "index_tool_useless_on_status_id"
    t.index ["user_id"], name: "index_tool_useless_on_user_id"
  end

  create_table "tools", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "code_scan"
    t.boolean "daily_use"
    t.string "slug"
    t.integer "tecnic_id"
    t.bigint "user_id"
    t.bigint "status_id"
    t.bigint "subsidiary_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["status_id"], name: "index_tools_on_status_id"
    t.index ["subsidiary_id"], name: "index_tools_on_subsidiary_id"
    t.index ["user_id"], name: "index_tools_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "document_number"
    t.string "first_name"
    t.string "last_name"
    t.string "auth_token"
    t.string "phone_number_1"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.integer "role"
    t.bigint "city_id"
    t.bigint "subsidiary_id"
    t.bigint "status_id"
    t.boolean "active"
    t.string "token_message"
    t.string "urlavatar"
    t.bigint "corporation_id"
    t.string "document_type"
    t.string "company_name"
    t.string "principal_activity"
    t.text "priority_user"
    t.string "web_page"
    t.string "address_1"
    t.string "address_2"
    t.string "phone_number_2"
    t.boolean "as_supervisor", default: false
    t.string "provider"
    t.string "uid"
    t.index ["city_id"], name: "index_users_on_city_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["corporation_id"], name: "index_users_on_corporation_id"
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["status_id"], name: "index_users_on_status_id"
    t.index ["subsidiary_id"], name: "index_users_on_subsidiary_id"
  end

  add_foreign_key "categories", "subsidiaries"
  add_foreign_key "cities", "countries"
  add_foreign_key "comments", "orders"
  add_foreign_key "comments", "users"
  add_foreign_key "components", "subsidiaries"
  add_foreign_key "components", "things"
  add_foreign_key "corporations", "statuses"
  add_foreign_key "histories", "orders"
  add_foreign_key "histories", "substatuses"
  add_foreign_key "histories", "users", column: "tecnic_id"
  add_foreign_key "logs", "orders"
  add_foreign_key "logs", "users"
  add_foreign_key "maintenances", "out_things"
  add_foreign_key "notifications", "subsidiaries"
  add_foreign_key "order_rates", "orders"
  add_foreign_key "order_rates", "subsidiaries"
  add_foreign_key "order_rates", "users"
  add_foreign_key "orders", "categories"
  add_foreign_key "orders", "statuses"
  add_foreign_key "orders", "subsidiaries"
  add_foreign_key "orders", "substatuses"
  add_foreign_key "out_things", "things"
  add_foreign_key "out_things", "users"
  add_foreign_key "position_logs", "positions"
  add_foreign_key "position_logs", "users"
  add_foreign_key "positions", "things"
  add_foreign_key "positions", "users"
  add_foreign_key "referrals", "orders"
  add_foreign_key "subsidiaries", "corporations"
  add_foreign_key "subsidiaries", "statuses"
  add_foreign_key "substatuses", "statuses"
  add_foreign_key "substatuses", "subsidiaries"
  add_foreign_key "things", "categories"
  add_foreign_key "things", "orders"
  add_foreign_key "things", "statuses"
  add_foreign_key "things", "subsidiaries"
  add_foreign_key "things", "substatuses"
  add_foreign_key "things", "users"
  add_foreign_key "tool_comments", "tool_useless", column: "tool_id"
  add_foreign_key "tool_comments", "users"
  add_foreign_key "tools", "statuses"
  add_foreign_key "tools", "subsidiaries"
  add_foreign_key "tools", "users"
  add_foreign_key "users", "cities"
  add_foreign_key "users", "corporations"
  add_foreign_key "users", "statuses"
  add_foreign_key "users", "subsidiaries"
end
