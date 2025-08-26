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

ActiveRecord::Schema[8.0].define(version: 2025_08_29_062829) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "hstore"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_stat_statements"
  enable_extension "tablefunc"

  create_table "account_members", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "user_id", null: false
    t.string "role", default: "member", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "user_id"], name: "index_account_members_on_account_id_and_user_id"
    t.index ["user_id", "account_id"], name: "index_account_members_on_user_id_and_account_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.citext "name"
    t.string "description"
    t.bigint "default_workspace_id"
    t.string "default_workspace_grid_mode", default: "classic", null: false
    t.integer "max_users", default: 1
    t.integer "max_impact_cards", default: 1
    t.date "expires_on"
    t.date "expiry_initial_reminder_sent_on"
    t.date "expiry_final_reminder_sent_on"
    t.integer "expiry_initial_reminder_days", default: 30
    t.integer "expiry_final_reminder_days", default: 3
    t.string "subscription_type", default: "invoiced", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "log_data"
    t.integer "owner_id"
    t.index ["default_workspace_id"], name: "index_accounts_on_default_workspace_id"
    t.index ["owner_id"], name: "index_accounts_on_owner_id"
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", id: :serial, force: :cascade do |t|
    t.string "trackable_type"
    t.integer "trackable_id"
    t.string "owner_type"
    t.integer "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.integer "recipient_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "workspace_id"
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["workspace_id"], name: "index_activities_on_workspace_id"
  end

  create_table "characteristics", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "focus_area_id"
    t.integer "position"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "code"
    t.string "short_name"
    t.string "color"
    t.index ["deleted_at"], name: "index_characteristics_on_deleted_at"
    t.index ["focus_area_id", "code"], name: "index_characteristics_on_focus_area_id_and_code", unique: true
    t.index ["focus_area_id"], name: "index_characteristics_on_focus_area_id"
    t.index ["position"], name: "index_characteristics_on_position"
  end

  create_table "checklist_item_changes", force: :cascade do |t|
    t.bigint "checklist_item_id", null: false
    t.bigint "user_id", null: false
    t.string "starting_status"
    t.string "ending_status"
    t.string "comment"
    t.string "action"
    t.string "activity"
    t.datetime "created_at"
    t.index ["checklist_item_id"], name: "index_checklist_item_changes_on_checklist_item_id"
    t.index ["user_id"], name: "index_checklist_item_changes_on_user_id"
  end

  create_table "checklist_items", id: :serial, force: :cascade do |t|
    t.boolean "checked"
    t.text "comment"
    t.integer "characteristic_id"
    t.integer "initiative_id"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "status", default: "no_comment"
    t.bigint "user_id"
    t.bigint "previous_characteristic_id"
    t.index ["characteristic_id"], name: "index_checklist_items_on_characteristic_id"
    t.index ["deleted_at"], name: "index_checklist_items_on_deleted_at"
    t.index ["initiative_id"], name: "index_checklist_items_on_initiative_id"
    t.index ["user_id"], name: "index_checklist_items_on_user_id"
  end

  create_table "communities", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "workspace_id"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "color", default: "#14b8a6", null: false
    t.index ["deleted_at"], name: "index_communities_on_deleted_at"
    t.index ["workspace_id"], name: "index_communities_on_workspace_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "data_models", force: :cascade do |t|
    t.string "name", null: false
    t.string "short_name"
    t.string "description"
    t.string "status", default: "active", null: false
    t.string "color", default: "#0d9488", null: false
    t.bigint "workspace_id"
    t.boolean "public_model", default: false
    t.datetime "deleted_at"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "author"
    t.string "license"
    t.index ["name", "workspace_id"], name: "index_data_models_on_name_and_workspace_id", unique: true, where: "((workspace_id IS NOT NULL) AND (deleted_at IS NULL))"
    t.index ["workspace_id"], name: "index_data_models_on_workspace_id"
  end

  create_table "deprecated_checklist_item_comments", force: :cascade do |t|
    t.bigint "checklist_item_id"
    t.string "comment"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "actual"
    t.index ["checklist_item_id"], name: "index_deprecated_checklist_item_comments_on_checklist_item_id"
  end

  create_table "focus_area_groups", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "position"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "deprecated_scorecard_type", default: "TransitionCard"
    t.bigint "deprecated_workspace_id"
    t.bigint "data_model_id"
    t.string "code"
    t.string "short_name"
    t.string "color"
    t.index ["data_model_id", "code"], name: "index_focus_area_groups_on_data_model_id_and_code", unique: true
    t.index ["data_model_id"], name: "index_focus_area_groups_on_data_model_id"
    t.index ["deleted_at"], name: "index_focus_area_groups_on_deleted_at"
    t.index ["deprecated_scorecard_type"], name: "index_focus_area_groups_on_deprecated_scorecard_type"
    t.index ["deprecated_workspace_id"], name: "index_focus_area_groups_on_deprecated_workspace_id"
    t.index ["position"], name: "index_focus_area_groups_on_position"
  end

  create_table "focus_areas", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "focus_area_group_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "position"
    t.datetime "deleted_at", precision: nil
    t.string "icon_name", default: ""
    t.string "color"
    t.string "code"
    t.string "short_name"
    t.index ["deleted_at"], name: "index_focus_areas_on_deleted_at"
    t.index ["focus_area_group_id", "code"], name: "index_focus_areas_on_focus_area_group_id_and_code", unique: true
    t.index ["focus_area_group_id"], name: "index_focus_areas_on_focus_area_group_id"
    t.index ["position"], name: "index_focus_areas_on_position"
  end

  create_table "initiatives", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "scorecard_id"
    t.date "started_at"
    t.date "finished_at"
    t.boolean "dates_confirmed"
    t.string "contact_name"
    t.string "contact_email"
    t.string "contact_phone"
    t.string "contact_website"
    t.string "contact_position"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "old_notes"
    t.boolean "linked", default: false
    t.datetime "archived_on"
    t.index ["archived_on"], name: "index_initiatives_on_archived_on"
    t.index ["deleted_at"], name: "index_initiatives_on_deleted_at"
    t.index ["finished_at"], name: "index_initiatives_on_finished_at"
    t.index ["name"], name: "index_initiatives_on_name"
    t.index ["scorecard_id"], name: "index_initiatives_on_scorecard_id"
    t.index ["started_at"], name: "index_initiatives_on_started_at"
  end

  create_table "initiatives_organisations", id: :serial, force: :cascade do |t|
    t.integer "initiative_id", null: false
    t.integer "organisation_id", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_initiatives_organisations_on_deleted_at"
    t.index ["initiative_id", "organisation_id"], name: "index_initiatives_organisations_on_initiative_organisation_id", unique: true
    t.index ["initiative_id"], name: "index_initiatives_organisations_on_initiative_id"
  end

  create_table "initiatives_subsystem_tags", id: :serial, force: :cascade do |t|
    t.integer "initiative_id", null: false
    t.integer "subsystem_tag_id", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_initiatives_subsystem_tags_on_deleted_at"
    t.index ["initiative_id", "subsystem_tag_id"], name: "idx_initiatives_subsystem_tags_initiative_and_subsystem_tag_id", unique: true
  end

  create_table "organisations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "workspace_id"
    t.integer "stakeholder_type_id"
    t.string "weblink"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_organisations_on_deleted_at"
    t.index ["workspace_id"], name: "index_organisations_on_workspace_id"
  end

  create_table "scorecards", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "community_id"
    t.integer "workspace_id"
    t.integer "wicked_problem_id"
    t.string "shared_link_id"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "deprecated_type", default: "TransitionCard"
    t.integer "linked_scorecard_id"
    t.boolean "share_ecosystem_map", default: true
    t.boolean "share_thematic_network_map", default: true
    t.bigint "data_model_id"
    t.jsonb "stakeholder_network_cache", default: {}, null: false
    t.index ["data_model_id"], name: "index_scorecards_on_data_model_id"
    t.index ["deleted_at"], name: "index_scorecards_on_deleted_at"
    t.index ["deprecated_type"], name: "index_scorecards_on_deprecated_type"
    t.index ["workspace_id"], name: "index_scorecards_on_workspace_id"
  end

  create_table "stakeholder_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "color"
    t.integer "workspace_id"
    t.index ["workspace_id"], name: "index_stakeholder_types_on_workspace_id"
  end

  create_table "subsystem_tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "workspace_id"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "color", default: "#14b8a6", null: false
    t.index ["deleted_at"], name: "index_subsystem_tags_on_deleted_at"
    t.index ["workspace_id"], name: "index_subsystem_tags_on_workspace_id"
  end

  create_table "targets_network_mappings", force: :cascade do |t|
    t.bigint "focus_area_id"
    t.bigint "characteristic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "data_model_id"
    t.index ["characteristic_id"], name: "index_targets_network_mappings_on_characteristic_id"
    t.index ["focus_area_id"], name: "index_targets_network_mappings_on_focus_area_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "invitation_token"
    t.datetime "invitation_created_at", precision: nil
    t.datetime "invitation_sent_at", precision: nil
    t.datetime "invitation_accepted_at", precision: nil
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.datetime "deleted_at", precision: nil
    t.string "profile_picture"
    t.integer "system_role", default: 0
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "time_zone", default: "Adelaide"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true, where: "(deleted_at IS NULL)"
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["name"], name: "index_users_on_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["system_role"], name: "index_users_on_system_role"
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "old_object"
    t.datetime "created_at", precision: nil
    t.integer "workspace_id"
    t.jsonb "object"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["workspace_id"], name: "index_versions_on_workspace_id"
  end

  create_table "wicked_problems", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "workspace_id"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "color", default: "#14b8a6", null: false
    t.index ["deleted_at"], name: "index_wicked_problems_on_deleted_at"
    t.index ["workspace_id"], name: "index_wicked_problems_on_workspace_id"
  end

  create_table "workspace_members", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "workspace_id"
    t.string "role", default: "member"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_workspace_members_on_user_id"
    t.index ["workspace_id", "user_id"], name: "index_workspace_members_on_workspace_id_and_user_id", unique: true
    t.index ["workspace_id"], name: "index_workspace_members_on_workspace_id"
  end

  create_table "workspaces", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "deprecated_weblink"
    t.text "deprecated_welcome_message"
    t.boolean "deactivated"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.date "deprecated_expires_on"
    t.integer "max_users", default: 1
    t.integer "max_scorecards", default: 1
    t.boolean "deprecated_solution_ecosystem_maps"
    t.boolean "deprecated_allow_transition_cards", default: true
    t.boolean "deprecated_allow_sustainable_development_goal_alignment_cards", default: false
    t.date "deprecated_expiry_warning_sent_on"
    t.string "transition_card_model_name", default: "Transition Card"
    t.string "transition_card_focus_area_group_model_name", default: "Focus Area Group"
    t.string "transition_card_focus_area_model_name", default: "Focus Area"
    t.string "transition_card_characteristic_model_name", default: "Characteristic"
    t.string "sdgs_alignment_card_model_name", default: "SDGs Alignment Card"
    t.string "sdgs_alignment_card_focus_area_group_model_name", default: "Focus Area Group"
    t.string "sdgs_alignment_card_focus_area_model_name", default: "Focus Area"
    t.string "sdgs_alignment_card_characteristic_model_name", default: "Targets"
    t.boolean "classic_grid_mode", default: false
    t.bigint "account_id"
    t.jsonb "log_data"
    t.index ["account_id"], name: "index_workspaces_on_account_id"
  end

  add_foreign_key "accounts", "workspaces", column: "default_workspace_id"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "checklist_item_changes", "checklist_items"
  add_foreign_key "checklist_item_changes", "users"
  add_foreign_key "checklist_items", "characteristics", column: "previous_characteristic_id"
  add_foreign_key "checklist_items", "users"
  add_foreign_key "data_models", "workspaces"
  add_foreign_key "focus_area_groups", "data_models"
  add_foreign_key "focus_area_groups", "workspaces", column: "deprecated_workspace_id"
  add_foreign_key "scorecards", "data_models"
  add_foreign_key "workspaces", "accounts"

  create_view "events_checklist_item_checkeds", sql_definition: <<-SQL
      SELECT DISTINCT ON (versions.id) 'updated_checked'::text AS event,
      checklist_items.id AS checklist_item_id,
      ''::text AS comment,
      COALESCE(((next_versions.object ->> 'updated_at'::text))::timestamp without time zone, checklist_items.updated_at) AS occurred_at,
          CASE (versions.object ->> 'checked'::text)
              WHEN 'true'::text THEN 'checked'::text
              ELSE 'unchecked'::text
          END AS from_status,
          CASE COALESCE(((next_versions.object ->> 'checked'::text) = 'true'::text), checklist_items.checked)
              WHEN true THEN 'checked'::text
              ELSE 'unchecked'::text
          END AS to_status
     FROM ((versions
       LEFT JOIN versions next_versions ON (((versions.item_id = next_versions.item_id) AND ((versions.item_type)::text = (next_versions.item_type)::text) AND ((next_versions.object ->> 'checked'::text) IS NOT NULL) AND (versions.id < next_versions.id))))
       JOIN checklist_items ON (((versions.item_id = checklist_items.id) AND ((versions.item_type)::text = 'ChecklistItem'::text) AND ((versions.event)::text = 'update'::text) AND (
          CASE (versions.object ->> 'checked'::text)
              WHEN 'true'::text THEN 'checked'::text
              ELSE 'unchecked'::text
          END <>
          CASE COALESCE(((next_versions.object ->> 'checked'::text) = 'true'::text), checklist_items.checked)
              WHEN true THEN 'checked'::text
              ELSE 'unchecked'::text
          END))));
  SQL
  create_view "events_checklist_item_first_comments", sql_definition: <<-SQL
      SELECT DISTINCT ON (checklist_items.id) 'first_comment'::text AS event,
      checklist_items.id AS checklist_item_id,
      COALESCE((versions.object ->> 'comment'::text), (deprecated_checklist_item_comments.comment)::text) AS comment,
      COALESCE(((versions.object ->> 'created_at'::text))::timestamp without time zone, deprecated_checklist_item_comments.created_at) AS occurred_at,
      NULL::text AS from_status,
      COALESCE((versions.object ->> 'status'::text), (deprecated_checklist_item_comments.status)::text) AS to_status
     FROM ((checklist_items
       JOIN deprecated_checklist_item_comments ON ((checklist_items.id = deprecated_checklist_item_comments.checklist_item_id)))
       LEFT JOIN versions ON (((deprecated_checklist_item_comments.id = versions.item_id) AND ((versions.item_type)::text = 'ChecklistItemComment'::text) AND ((versions.event)::text = 'update'::text))))
    ORDER BY checklist_items.id DESC, deprecated_checklist_item_comments.created_at, versions.created_at;
  SQL
  create_view "events_checklist_item_new_comments", sql_definition: <<-SQL
      SELECT DISTINCT ON (deprecated_checklist_item_comments.id) 'new_comment'::text AS event,
      checklist_items.id AS checklist_item_id,
      COALESCE((versions.object ->> 'comment'::text), (deprecated_checklist_item_comments.comment)::text) AS comment,
      COALESCE(((versions.object ->> 'created_at'::text))::timestamp without time zone, deprecated_checklist_item_comments.created_at) AS occurred_at,
      NULL::text AS from_status,
      COALESCE((versions.object ->> 'status'::text), (deprecated_checklist_item_comments.status)::text) AS to_status
     FROM (((checklist_items
       JOIN deprecated_checklist_item_comments ON ((checklist_items.id = deprecated_checklist_item_comments.checklist_item_id)))
       LEFT JOIN versions ON (((deprecated_checklist_item_comments.id = versions.item_id) AND ((versions.item_type)::text = 'ChecklistItemComment'::text) AND ((versions.event)::text = 'update'::text))))
       JOIN deprecated_checklist_item_comments previous_comments ON (((checklist_items.id = previous_comments.checklist_item_id) AND (previous_comments.id < deprecated_checklist_item_comments.id))))
    ORDER BY deprecated_checklist_item_comments.id DESC, deprecated_checklist_item_comments.created_at, versions.created_at;
  SQL
  create_view "events_checklist_item_updated_comments", sql_definition: <<-SQL
      SELECT DISTINCT ON (versions.id) 'updated_comment'::text AS event,
      deprecated_checklist_item_comments.checklist_item_id,
      COALESCE((next_versions.object ->> 'comment'::text), (deprecated_checklist_item_comments.comment)::text) AS comment,
      COALESCE(((next_versions.object ->> 'updated_at'::text))::timestamp without time zone, deprecated_checklist_item_comments.updated_at) AS occurred_at,
      (versions.object ->> 'status'::text) AS from_status,
      COALESCE((next_versions.object ->> 'status'::text), (deprecated_checklist_item_comments.status)::text) AS to_status
     FROM ((versions
       LEFT JOIN versions next_versions ON (((versions.item_id = next_versions.item_id) AND ((versions.item_type)::text = (next_versions.item_type)::text) AND (versions.id < next_versions.id))))
       JOIN deprecated_checklist_item_comments ON (((versions.item_id = deprecated_checklist_item_comments.id) AND ((versions.item_type)::text = 'ChecklistItemComment'::text) AND ((versions.event)::text = 'update'::text) AND ((versions.object ->> 'status'::text) IS NOT NULL))));
  SQL
  create_view "events_checklist_item_activities", sql_definition: <<-SQL
      SELECT events_checklist_item_first_comments.event,
      events_checklist_item_first_comments.checklist_item_id,
      events_checklist_item_first_comments.comment,
      events_checklist_item_first_comments.occurred_at,
      events_checklist_item_first_comments.from_status,
      events_checklist_item_first_comments.to_status
     FROM events_checklist_item_first_comments
  UNION
   SELECT events_checklist_item_updated_comments.event,
      events_checklist_item_updated_comments.checklist_item_id,
      events_checklist_item_updated_comments.comment,
      events_checklist_item_updated_comments.occurred_at,
      events_checklist_item_updated_comments.from_status,
      events_checklist_item_updated_comments.to_status
     FROM events_checklist_item_updated_comments
  UNION
   SELECT events_checklist_item_new_comments.event,
      events_checklist_item_new_comments.checklist_item_id,
      events_checklist_item_new_comments.comment,
      events_checklist_item_new_comments.occurred_at,
      events_checklist_item_new_comments.from_status,
      events_checklist_item_new_comments.to_status
     FROM events_checklist_item_new_comments
  UNION
   SELECT events_checklist_item_checkeds.event,
      events_checklist_item_checkeds.checklist_item_id,
      events_checklist_item_checkeds.comment,
      events_checklist_item_checkeds.occurred_at,
      events_checklist_item_checkeds.from_status,
      events_checklist_item_checkeds.to_status
     FROM events_checklist_item_checkeds;
  SQL
  create_view "events_transition_card_activities", sql_definition: <<-SQL
      SELECT transition_card_id,
      transition_card_name,
      initiative_id,
      initiative_name,
      characteristic_name,
      event,
      comment,
      occurred_at,
      from_status,
      to_status
     FROM ( SELECT scorecards.id AS transition_card_id,
              scorecards.name AS transition_card_name,
              initiatives.id AS initiative_id,
              initiatives.name AS initiative_name,
              characteristics.name AS characteristic_name,
              events_checklist_item_activities.event,
              events_checklist_item_activities.comment,
              events_checklist_item_activities.occurred_at,
              events_checklist_item_activities.from_status,
              events_checklist_item_activities.to_status
             FROM ((((events_checklist_item_activities
               JOIN checklist_items ON ((checklist_items.id = events_checklist_item_activities.checklist_item_id)))
               JOIN characteristics ON ((characteristics.id = checklist_items.characteristic_id)))
               JOIN initiatives ON ((initiatives.id = checklist_items.initiative_id)))
               JOIN scorecards ON ((scorecards.id = initiatives.scorecard_id)))
          UNION
           SELECT scorecards.id AS transition_card_id,
              scorecards.name AS transition_card_name,
              initiatives.id AS initiative_id,
              initiatives.name AS initiative_name,
              NULL::character varying AS "varchar",
              'initiative_created'::text AS text,
              NULL::text AS text,
              initiatives.created_at,
              NULL::text AS text,
              NULL::text AS text
             FROM (initiatives
               JOIN scorecards ON ((scorecards.id = initiatives.scorecard_id)))
          UNION
           SELECT scorecards.id AS transition_card_id,
              scorecards.name AS transition_card_name,
              initiatives.id AS initiative_id,
              initiatives.name AS initiative_name,
              NULL::character varying AS "varchar",
              'initiative_deleted'::text AS text,
              NULL::text AS text,
              initiatives.deleted_at,
              NULL::text AS text,
              NULL::text AS text
             FROM (initiatives
               JOIN scorecards ON ((scorecards.id = initiatives.scorecard_id)))
            WHERE (initiatives.deleted_at IS NOT NULL)
          UNION
           SELECT scorecards.id AS transition_card_id,
              scorecards.name AS transition_card_name,
              NULL::integer AS int4,
              NULL::character varying AS "varchar",
              NULL::character varying AS "varchar",
              'transition_card_created'::text AS text,
              NULL::text AS text,
              scorecards.created_at,
              NULL::text AS text,
              NULL::text AS text
             FROM scorecards) events_transition_card_activities_v02;
  SQL
  create_view "checklist_item_updated_comments_view", sql_definition: <<-SQL
      SELECT DISTINCT ON (versions.id) 'updated_comment'::text AS event,
      deprecated_checklist_item_comments.checklist_item_id,
      COALESCE((next_versions.object ->> 'comment'::text), (deprecated_checklist_item_comments.comment)::text) AS comment,
      COALESCE(((next_versions.object ->> 'updated_at'::text))::timestamp without time zone, deprecated_checklist_item_comments.updated_at) AS occuring_at,
      (versions.object ->> 'status'::text) AS from_status,
      COALESCE((next_versions.object ->> 'status'::text), (deprecated_checklist_item_comments.status)::text) AS to_status
     FROM ((versions
       LEFT JOIN versions next_versions ON (((versions.item_id = next_versions.item_id) AND ((versions.item_type)::text = (next_versions.item_type)::text) AND (versions.id < next_versions.id))))
       JOIN deprecated_checklist_item_comments ON (((versions.item_id = deprecated_checklist_item_comments.id) AND ((versions.item_type)::text = 'ChecklistItemComment'::text) AND ((versions.event)::text = 'update'::text) AND ((versions.object ->> 'status'::text) IS NOT NULL))));
  SQL
  create_view "scorecard_changes", sql_definition: <<-SQL
      SELECT initiatives.scorecard_id,
      initiatives.created_at AS occurred_at,
      initiatives.name AS initiative_name,
      ''::character varying AS characteristic_name,
      'initiative_created'::character varying AS action,
      ''::character varying AS activity,
      ''::character varying AS from_value,
      ''::character varying AS to_value,
      ''::character varying AS comment
     FROM initiatives
  UNION
   SELECT initiatives.scorecard_id,
      checklist_item_changes.created_at AS occurred_at,
      initiatives.name AS initiative_name,
      characteristics.name AS characteristic_name,
      checklist_item_changes.action,
      checklist_item_changes.activity,
      checklist_item_changes.starting_status AS from_value,
      checklist_item_changes.ending_status AS to_value,
      checklist_item_changes.comment
     FROM (((checklist_item_changes
       JOIN checklist_items ON ((checklist_items.id = checklist_item_changes.checklist_item_id)))
       JOIN characteristics ON ((characteristics.id = checklist_items.characteristic_id)))
       JOIN initiatives ON ((initiatives.id = checklist_items.initiative_id)))
    ORDER BY 1, 2 DESC;
  SQL
  create_view "scorecard_type_characteristics", sql_definition: <<-SQL
      SELECT characteristics.id,
      characteristics.name,
      characteristics.description,
      characteristics.focus_area_id,
      characteristics."position",
      characteristics.deleted_at,
      characteristics.created_at,
      characteristics.updated_at,
      characteristics.code,
      characteristics.short_name,
      characteristics.color,
      focus_area_groups.data_model_id,
      data_models.workspace_id
     FROM (((characteristics
       JOIN focus_areas ON ((characteristics.focus_area_id = focus_areas.id)))
       JOIN focus_area_groups ON ((focus_areas.focus_area_group_id = focus_area_groups.id)))
       JOIN data_models ON ((focus_area_groups.data_model_id = data_models.id)))
    WHERE ((characteristics.deleted_at IS NULL) AND (focus_areas.deleted_at IS NULL) AND (focus_area_groups.deleted_at IS NULL))
    ORDER BY focus_areas."position", characteristics."position";
  SQL
  create_function :logidze_capture_exception, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.logidze_capture_exception(error_data jsonb)
       RETURNS boolean
       LANGUAGE plpgsql
      AS $function$
        -- version: 1
      BEGIN
        -- Feel free to change this function to change Logidze behavior on exception.
        --
        -- Return `false` to raise exception or `true` to commit record changes.
        --
        -- `error_data` contains:
        --   - returned_sqlstate
        --   - message_text
        --   - pg_exception_detail
        --   - pg_exception_hint
        --   - pg_exception_context
        --   - schema_name
        --   - table_name
        -- Learn more about available keys:
        -- https://www.postgresql.org/docs/9.6/plpgsql-control-structures.html#PLPGSQL-EXCEPTION-DIAGNOSTICS-VALUES
        --

        return false;
      END;
      $function$
  SQL
  create_function :logidze_compact_history, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.logidze_compact_history(log_data jsonb, cutoff integer DEFAULT 1)
       RETURNS jsonb
       LANGUAGE plpgsql
      AS $function$
        -- version: 1
        DECLARE
          merged jsonb;
        BEGIN
          LOOP
            merged := jsonb_build_object(
              'ts',
              log_data#>'{h,1,ts}',
              'v',
              log_data#>'{h,1,v}',
              'c',
              (log_data#>'{h,0,c}') || (log_data#>'{h,1,c}')
            );

            IF (log_data#>'{h,1}' ? 'm') THEN
              merged := jsonb_set(merged, ARRAY['m'], log_data#>'{h,1,m}');
            END IF;

            log_data := jsonb_set(
              log_data,
              '{h}',
              jsonb_set(
                log_data->'h',
                '{1}',
                merged
              ) - 0
            );

            cutoff := cutoff - 1;

            EXIT WHEN cutoff <= 0;
          END LOOP;

          return log_data;
        END;
      $function$
  SQL
  create_function :logidze_filter_keys, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.logidze_filter_keys(obj jsonb, keys text[], include_columns boolean DEFAULT false)
       RETURNS jsonb
       LANGUAGE plpgsql
      AS $function$
        -- version: 1
        DECLARE
          res jsonb;
          key text;
        BEGIN
          res := '{}';

          IF include_columns THEN
            FOREACH key IN ARRAY keys
            LOOP
              IF obj ? key THEN
                res = jsonb_insert(res, ARRAY[key], obj->key);
              END IF;
            END LOOP;
          ELSE
            res = obj;
            FOREACH key IN ARRAY keys
            LOOP
              res = res - key;
            END LOOP;
          END IF;

          RETURN res;
        END;
      $function$
  SQL
  create_function :logidze_logger, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.logidze_logger()
       RETURNS trigger
       LANGUAGE plpgsql
      AS $function$
        -- version: 5
        DECLARE
          changes jsonb;
          version jsonb;
          full_snapshot boolean;
          log_data jsonb;
          new_v integer;
          size integer;
          history_limit integer;
          debounce_time integer;
          current_version integer;
          k text;
          iterator integer;
          item record;
          columns text[];
          include_columns boolean;
          detached_log_data jsonb;
          -- We use `detached_loggable_type` for:
          -- 1. Checking if current implementation is `--detached` (`log_data` is stored in a separated table)
          -- 2. If implementation is `--detached` then we use detached_loggable_type to determine
          --    to which table current `log_data` record belongs
          detached_loggable_type text;
          log_data_table_name text;
          log_data_is_empty boolean;
          log_data_ts_key_data text;
          ts timestamp with time zone;
          ts_column text;
          err_sqlstate text;
          err_message text;
          err_detail text;
          err_hint text;
          err_context text;
          err_table_name text;
          err_schema_name text;
          err_jsonb jsonb;
          err_captured boolean;
        BEGIN
          ts_column := NULLIF(TG_ARGV[1], 'null');
          columns := NULLIF(TG_ARGV[2], 'null');
          include_columns := NULLIF(TG_ARGV[3], 'null');
          detached_loggable_type := NULLIF(TG_ARGV[5], 'null');
          log_data_table_name := NULLIF(TG_ARGV[6], 'null');

          -- getting previous log_data if it exists for detached `log_data` storage variant
          IF detached_loggable_type IS NOT NULL
          THEN
            EXECUTE format(
              'SELECT ldtn.log_data ' ||
              'FROM %I ldtn ' ||
              'WHERE ldtn.loggable_type = $1 ' ||
                'AND ldtn.loggable_id = $2 '  ||
              'LIMIT 1',
              log_data_table_name
            ) USING detached_loggable_type, NEW.id INTO detached_log_data;
          END IF;

          IF detached_loggable_type IS NULL
          THEN
              log_data_is_empty = NEW.log_data is NULL OR NEW.log_data = '{}'::jsonb;
          ELSE
              log_data_is_empty = detached_log_data IS NULL OR detached_log_data = '{}'::jsonb;
          END IF;

          IF log_data_is_empty
          THEN
            IF columns IS NOT NULL THEN
              log_data = logidze_snapshot(to_jsonb(NEW.*), ts_column, columns, include_columns);
            ELSE
              log_data = logidze_snapshot(to_jsonb(NEW.*), ts_column);
            END IF;

            IF log_data#>>'{h, -1, c}' != '{}' THEN
              IF detached_loggable_type IS NULL
              THEN
                NEW.log_data := log_data;
              ELSE
                EXECUTE format(
                  'INSERT INTO %I(log_data, loggable_type, loggable_id) ' ||
                  'VALUES ($1, $2, $3);',
                  log_data_table_name
                ) USING log_data, detached_loggable_type, NEW.id;
              END IF;
            END IF;

          ELSE

            IF TG_OP = 'UPDATE' AND (to_jsonb(NEW.*) = to_jsonb(OLD.*)) THEN
              RETURN NEW; -- pass
            END IF;

            history_limit := NULLIF(TG_ARGV[0], 'null');
            debounce_time := NULLIF(TG_ARGV[4], 'null');

            IF detached_loggable_type IS NULL
            THEN
                log_data := NEW.log_data;
            ELSE
                log_data := detached_log_data;
            END IF;

            current_version := (log_data->>'v')::int;

            IF ts_column IS NULL THEN
              ts := statement_timestamp();
            ELSEIF TG_OP = 'UPDATE' THEN
              ts := (to_jsonb(NEW.*) ->> ts_column)::timestamp with time zone;
              IF ts IS NULL OR ts = (to_jsonb(OLD.*) ->> ts_column)::timestamp with time zone THEN
                ts := statement_timestamp();
              END IF;
            ELSEIF TG_OP = 'INSERT' THEN
              ts := (to_jsonb(NEW.*) ->> ts_column)::timestamp with time zone;

              IF detached_loggable_type IS NULL
              THEN
                log_data_ts_key_data = NEW.log_data #>> '{h,-1,ts}';
              ELSE
                log_data_ts_key_data = detached_log_data #>> '{h,-1,ts}';
              END IF;

              IF ts IS NULL OR (extract(epoch from ts) * 1000)::bigint = log_data_ts_key_data::bigint THEN
                  ts := statement_timestamp();
              END IF;
            END IF;

            full_snapshot := (coalesce(current_setting('logidze.full_snapshot', true), '') = 'on') OR (TG_OP = 'INSERT');

            IF current_version < (log_data#>>'{h,-1,v}')::int THEN
              iterator := 0;
              FOR item in SELECT * FROM jsonb_array_elements(log_data->'h')
              LOOP
                IF (item.value->>'v')::int > current_version THEN
                  log_data := jsonb_set(
                    log_data,
                    '{h}',
                    (log_data->'h') - iterator
                  );
                END IF;
                iterator := iterator + 1;
              END LOOP;
            END IF;

            changes := '{}';

            IF full_snapshot THEN
              BEGIN
                changes = hstore_to_jsonb_loose(hstore(NEW.*));
              EXCEPTION
                WHEN NUMERIC_VALUE_OUT_OF_RANGE THEN
                  changes = row_to_json(NEW.*)::jsonb;
                  FOR k IN (SELECT key FROM jsonb_each(changes))
                  LOOP
                    IF jsonb_typeof(changes->k) = 'object' THEN
                      changes = jsonb_set(changes, ARRAY[k], to_jsonb(changes->>k));
                    END IF;
                  END LOOP;
              END;
            ELSE
              BEGIN
                changes = hstore_to_jsonb_loose(
                      hstore(NEW.*) - hstore(OLD.*)
                  );
              EXCEPTION
                WHEN NUMERIC_VALUE_OUT_OF_RANGE THEN
                  changes = (SELECT
                    COALESCE(json_object_agg(key, value), '{}')::jsonb
                    FROM
                    jsonb_each(row_to_json(NEW.*)::jsonb)
                    WHERE NOT jsonb_build_object(key, value) <@ row_to_json(OLD.*)::jsonb);
                  FOR k IN (SELECT key FROM jsonb_each(changes))
                  LOOP
                    IF jsonb_typeof(changes->k) = 'object' THEN
                      changes = jsonb_set(changes, ARRAY[k], to_jsonb(changes->>k));
                    END IF;
                  END LOOP;
              END;
            END IF;

            -- We store `log_data` in a separate table for the `detached` mode
            -- So we remove `log_data` only when we store historic data in the record's origin table
            IF detached_loggable_type IS NULL
            THEN
                changes = changes - 'log_data';
            END IF;

            IF columns IS NOT NULL THEN
              changes = logidze_filter_keys(changes, columns, include_columns);
            END IF;

            IF changes = '{}' THEN
              RETURN NEW; -- pass
            END IF;

            new_v := (log_data#>>'{h,-1,v}')::int + 1;

            size := jsonb_array_length(log_data->'h');
            version := logidze_version(new_v, changes, ts);

            IF (
              debounce_time IS NOT NULL AND
              (version->>'ts')::bigint - (log_data#>'{h,-1,ts}')::text::bigint <= debounce_time
            ) THEN
              -- merge new version with the previous one
              new_v := (log_data#>>'{h,-1,v}')::int;
              version := logidze_version(new_v, (log_data#>'{h,-1,c}')::jsonb || changes, ts);
              -- remove the previous version from log
              log_data := jsonb_set(
                log_data,
                '{h}',
                (log_data->'h') - (size - 1)
              );
            END IF;

            log_data := jsonb_set(
              log_data,
              ARRAY['h', size::text],
              version,
              true
            );

            log_data := jsonb_set(
              log_data,
              '{v}',
              to_jsonb(new_v)
            );

            IF history_limit IS NOT NULL AND history_limit <= size THEN
              log_data := logidze_compact_history(log_data, size - history_limit + 1);
            END IF;

            IF detached_loggable_type IS NULL
            THEN
              NEW.log_data := log_data;
            ELSE
              detached_log_data = log_data;
              EXECUTE format(
                'UPDATE %I ' ||
                'SET log_data = $1 ' ||
                'WHERE %I.loggable_type = $2 ' ||
                'AND %I.loggable_id = $3',
                log_data_table_name,
                log_data_table_name,
                log_data_table_name
              ) USING detached_log_data, detached_loggable_type, NEW.id;
            END IF;
          END IF;

          RETURN NEW; -- result
        EXCEPTION
          WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_sqlstate = RETURNED_SQLSTATE,
                                    err_message = MESSAGE_TEXT,
                                    err_detail = PG_EXCEPTION_DETAIL,
                                    err_hint = PG_EXCEPTION_HINT,
                                    err_context = PG_EXCEPTION_CONTEXT,
                                    err_schema_name = SCHEMA_NAME,
                                    err_table_name = TABLE_NAME;
            err_jsonb := jsonb_build_object(
              'returned_sqlstate', err_sqlstate,
              'message_text', err_message,
              'pg_exception_detail', err_detail,
              'pg_exception_hint', err_hint,
              'pg_exception_context', err_context,
              'schema_name', err_schema_name,
              'table_name', err_table_name
            );
            err_captured = logidze_capture_exception(err_jsonb);
            IF err_captured THEN
              return NEW;
            ELSE
              RAISE;
            END IF;
        END;
      $function$
  SQL
  create_function :logidze_logger_after, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.logidze_logger_after()
       RETURNS trigger
       LANGUAGE plpgsql
      AS $function$
        -- version: 5


        DECLARE
          changes jsonb;
          version jsonb;
          full_snapshot boolean;
          log_data jsonb;
          new_v integer;
          size integer;
          history_limit integer;
          debounce_time integer;
          current_version integer;
          k text;
          iterator integer;
          item record;
          columns text[];
          include_columns boolean;
          detached_log_data jsonb;
          -- We use `detached_loggable_type` for:
          -- 1. Checking if current implementation is `--detached` (`log_data` is stored in a separated table)
          -- 2. If implementation is `--detached` then we use detached_loggable_type to determine
          --    to which table current `log_data` record belongs
          detached_loggable_type text;
          log_data_table_name text;
          log_data_is_empty boolean;
          log_data_ts_key_data text;
          ts timestamp with time zone;
          ts_column text;
          err_sqlstate text;
          err_message text;
          err_detail text;
          err_hint text;
          err_context text;
          err_table_name text;
          err_schema_name text;
          err_jsonb jsonb;
          err_captured boolean;
        BEGIN
          ts_column := NULLIF(TG_ARGV[1], 'null');
          columns := NULLIF(TG_ARGV[2], 'null');
          include_columns := NULLIF(TG_ARGV[3], 'null');
          detached_loggable_type := NULLIF(TG_ARGV[5], 'null');
          log_data_table_name := NULLIF(TG_ARGV[6], 'null');

          -- getting previous log_data if it exists for detached `log_data` storage variant
          IF detached_loggable_type IS NOT NULL
          THEN
            EXECUTE format(
              'SELECT ldtn.log_data ' ||
              'FROM %I ldtn ' ||
              'WHERE ldtn.loggable_type = $1 ' ||
                'AND ldtn.loggable_id = $2 '  ||
              'LIMIT 1',
              log_data_table_name
            ) USING detached_loggable_type, NEW.id INTO detached_log_data;
          END IF;

          IF detached_loggable_type IS NULL
          THEN
              log_data_is_empty = NEW.log_data is NULL OR NEW.log_data = '{}'::jsonb;
          ELSE
              log_data_is_empty = detached_log_data IS NULL OR detached_log_data = '{}'::jsonb;
          END IF;

          IF log_data_is_empty
          THEN
            IF columns IS NOT NULL THEN
              log_data = logidze_snapshot(to_jsonb(NEW.*), ts_column, columns, include_columns);
            ELSE
              log_data = logidze_snapshot(to_jsonb(NEW.*), ts_column);
            END IF;

            IF log_data#>>'{h, -1, c}' != '{}' THEN
              IF detached_loggable_type IS NULL
              THEN
                NEW.log_data := log_data;
              ELSE
                EXECUTE format(
                  'INSERT INTO %I(log_data, loggable_type, loggable_id) ' ||
                  'VALUES ($1, $2, $3);',
                  log_data_table_name
                ) USING log_data, detached_loggable_type, NEW.id;
              END IF;
            END IF;

          ELSE

            IF TG_OP = 'UPDATE' AND (to_jsonb(NEW.*) = to_jsonb(OLD.*)) THEN
              RETURN NULL;
            END IF;

            history_limit := NULLIF(TG_ARGV[0], 'null');
            debounce_time := NULLIF(TG_ARGV[4], 'null');

            IF detached_loggable_type IS NULL
            THEN
                log_data := NEW.log_data;
            ELSE
                log_data := detached_log_data;
            END IF;

            current_version := (log_data->>'v')::int;

            IF ts_column IS NULL THEN
              ts := statement_timestamp();
            ELSEIF TG_OP = 'UPDATE' THEN
              ts := (to_jsonb(NEW.*) ->> ts_column)::timestamp with time zone;
              IF ts IS NULL OR ts = (to_jsonb(OLD.*) ->> ts_column)::timestamp with time zone THEN
                ts := statement_timestamp();
              END IF;
            ELSEIF TG_OP = 'INSERT' THEN
              ts := (to_jsonb(NEW.*) ->> ts_column)::timestamp with time zone;

              IF detached_loggable_type IS NULL
              THEN
                log_data_ts_key_data = NEW.log_data #>> '{h,-1,ts}';
              ELSE
                log_data_ts_key_data = detached_log_data #>> '{h,-1,ts}';
              END IF;

              IF ts IS NULL OR (extract(epoch from ts) * 1000)::bigint = log_data_ts_key_data::bigint THEN
                  ts := statement_timestamp();
              END IF;
            END IF;

            full_snapshot := (coalesce(current_setting('logidze.full_snapshot', true), '') = 'on') OR (TG_OP = 'INSERT');

            IF current_version < (log_data#>>'{h,-1,v}')::int THEN
              iterator := 0;
              FOR item in SELECT * FROM jsonb_array_elements(log_data->'h')
              LOOP
                IF (item.value->>'v')::int > current_version THEN
                  log_data := jsonb_set(
                    log_data,
                    '{h}',
                    (log_data->'h') - iterator
                  );
                END IF;
                iterator := iterator + 1;
              END LOOP;
            END IF;

            changes := '{}';

            IF full_snapshot THEN
              BEGIN
                changes = hstore_to_jsonb_loose(hstore(NEW.*));
              EXCEPTION
                WHEN NUMERIC_VALUE_OUT_OF_RANGE THEN
                  changes = row_to_json(NEW.*)::jsonb;
                  FOR k IN (SELECT key FROM jsonb_each(changes))
                  LOOP
                    IF jsonb_typeof(changes->k) = 'object' THEN
                      changes = jsonb_set(changes, ARRAY[k], to_jsonb(changes->>k));
                    END IF;
                  END LOOP;
              END;
            ELSE
              BEGIN
                changes = hstore_to_jsonb_loose(
                      hstore(NEW.*) - hstore(OLD.*)
                  );
              EXCEPTION
                WHEN NUMERIC_VALUE_OUT_OF_RANGE THEN
                  changes = (SELECT
                    COALESCE(json_object_agg(key, value), '{}')::jsonb
                    FROM
                    jsonb_each(row_to_json(NEW.*)::jsonb)
                    WHERE NOT jsonb_build_object(key, value) <@ row_to_json(OLD.*)::jsonb);
                  FOR k IN (SELECT key FROM jsonb_each(changes))
                  LOOP
                    IF jsonb_typeof(changes->k) = 'object' THEN
                      changes = jsonb_set(changes, ARRAY[k], to_jsonb(changes->>k));
                    END IF;
                  END LOOP;
              END;
            END IF;

            -- We store `log_data` in a separate table for the `detached` mode
            -- So we remove `log_data` only when we store historic data in the record's origin table
            IF detached_loggable_type IS NULL
            THEN
                changes = changes - 'log_data';
            END IF;

            IF columns IS NOT NULL THEN
              changes = logidze_filter_keys(changes, columns, include_columns);
            END IF;

            IF changes = '{}' THEN
              RETURN NULL;
            END IF;

            new_v := (log_data#>>'{h,-1,v}')::int + 1;

            size := jsonb_array_length(log_data->'h');
            version := logidze_version(new_v, changes, ts);

            IF (
              debounce_time IS NOT NULL AND
              (version->>'ts')::bigint - (log_data#>'{h,-1,ts}')::text::bigint <= debounce_time
            ) THEN
              -- merge new version with the previous one
              new_v := (log_data#>>'{h,-1,v}')::int;
              version := logidze_version(new_v, (log_data#>'{h,-1,c}')::jsonb || changes, ts);
              -- remove the previous version from log
              log_data := jsonb_set(
                log_data,
                '{h}',
                (log_data->'h') - (size - 1)
              );
            END IF;

            log_data := jsonb_set(
              log_data,
              ARRAY['h', size::text],
              version,
              true
            );

            log_data := jsonb_set(
              log_data,
              '{v}',
              to_jsonb(new_v)
            );

            IF history_limit IS NOT NULL AND history_limit <= size THEN
              log_data := logidze_compact_history(log_data, size - history_limit + 1);
            END IF;

            IF detached_loggable_type IS NULL
            THEN
              NEW.log_data := log_data;
            ELSE
              detached_log_data = log_data;
              EXECUTE format(
                'UPDATE %I ' ||
                'SET log_data = $1 ' ||
                'WHERE %I.loggable_type = $2 ' ||
                'AND %I.loggable_id = $3',
                log_data_table_name,
                log_data_table_name,
                log_data_table_name
              ) USING detached_log_data, detached_loggable_type, NEW.id;
            END IF;
          END IF;

          IF detached_loggable_type IS NULL
          THEN
            EXECUTE format('UPDATE %I.%I SET "log_data" = $1 WHERE ctid = %L', TG_TABLE_SCHEMA, TG_TABLE_NAME, NEW.CTID) USING NEW.log_data;
          END IF;

          RETURN NULL;

        EXCEPTION
          WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_sqlstate = RETURNED_SQLSTATE,
                                    err_message = MESSAGE_TEXT,
                                    err_detail = PG_EXCEPTION_DETAIL,
                                    err_hint = PG_EXCEPTION_HINT,
                                    err_context = PG_EXCEPTION_CONTEXT,
                                    err_schema_name = SCHEMA_NAME,
                                    err_table_name = TABLE_NAME;
            err_jsonb := jsonb_build_object(
              'returned_sqlstate', err_sqlstate,
              'message_text', err_message,
              'pg_exception_detail', err_detail,
              'pg_exception_hint', err_hint,
              'pg_exception_context', err_context,
              'schema_name', err_schema_name,
              'table_name', err_table_name
            );
            err_captured = logidze_capture_exception(err_jsonb);
            IF err_captured THEN
              return NEW;
            ELSE
              RAISE;
            END IF;
        END;
      $function$
  SQL
  create_function :logidze_snapshot, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.logidze_snapshot(item jsonb, ts_column text DEFAULT NULL::text, columns text[] DEFAULT NULL::text[], include_columns boolean DEFAULT false)
       RETURNS jsonb
       LANGUAGE plpgsql
      AS $function$
        -- version: 3
        DECLARE
          ts timestamp with time zone;
          k text;
        BEGIN
          item = item - 'log_data';
          IF ts_column IS NULL THEN
            ts := statement_timestamp();
          ELSE
            ts := coalesce((item->>ts_column)::timestamp with time zone, statement_timestamp());
          END IF;

          IF columns IS NOT NULL THEN
            item := logidze_filter_keys(item, columns, include_columns);
          END IF;

          FOR k IN (SELECT key FROM jsonb_each(item))
          LOOP
            IF jsonb_typeof(item->k) = 'object' THEN
               item := jsonb_set(item, ARRAY[k], to_jsonb(item->>k));
            END IF;
          END LOOP;

          return json_build_object(
            'v', 1,
            'h', jsonb_build_array(
                    logidze_version(1, item, ts)
                  )
            );
        END;
      $function$
  SQL
  create_function :logidze_version, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.logidze_version(v bigint, data jsonb, ts timestamp with time zone)
       RETURNS jsonb
       LANGUAGE plpgsql
      AS $function$
        -- version: 2
        DECLARE
          buf jsonb;
        BEGIN
          data = data - 'log_data';
          buf := jsonb_build_object(
                    'ts',
                    (extract(epoch from ts) * 1000)::bigint,
                    'v',
                    v,
                    'c',
                    data
                    );
          IF coalesce(current_setting('logidze.meta', true), '') <> '' THEN
            buf := jsonb_insert(buf, '{m}', current_setting('logidze.meta')::jsonb);
          END IF;
          RETURN buf;
        END;
      $function$
  SQL


  create_trigger :logidze_on_workspaces, sql_definition: <<-SQL
      CREATE TRIGGER logidze_on_workspaces BEFORE INSERT OR UPDATE ON public.workspaces FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION logidze_logger('null', 'updated_at')
  SQL
  create_trigger :logidze_on_accounts, sql_definition: <<-SQL
      CREATE TRIGGER logidze_on_accounts BEFORE INSERT OR UPDATE ON public.accounts FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION logidze_logger('null', 'updated_at')
  SQL
end
