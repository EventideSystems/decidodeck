# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# --- Example Users ---
admin = User.find_or_create_by!(email: 'system_admin@obsekio.org') do |u|
  u.password = 'password'
  u.password_confirmation = 'password'
  u.system_role = 'admin'
end

user1 = User.find_or_create_by!(email: 'user1@example.com') do |u|
  u.password = 'password'
  u.password_confirmation = 'password'
  u.system_role = 'member'
end

user2 = User.find_or_create_by!(email: 'user2@example.com') do |u|
  u.password = 'password'
  u.password_confirmation = 'password'
  u.system_role = 'member'
end


# --- Example Workspaces ---
ws1 = Workspace.find_or_create_by!(name: 'Demo Workspace')
ws2 = Workspace.find_or_create_by!(name: 'Research Workspace')

# --- Example Stakeholder Types ---
st1 = StakeholderType.find_or_create_by!(name: 'Business', workspace: ws1)
st2 = StakeholderType.find_or_create_by!(name: 'Research', workspace: ws2)

# --- Example Organisations ---
org1 = Organisation.find_or_create_by!(name: 'Acme Corp', workspace: ws1, stakeholder_type: st1)
org2 = Organisation.find_or_create_by!(name: 'Globex Inc', workspace: ws2, stakeholder_type: st2)

# Assign users to workspaces
WorkspacesUser.find_or_create_by!(user: admin, workspace: ws1, workspace_role: 'admin')
WorkspacesUser.find_or_create_by!(user: user1, workspace: ws1, workspace_role: 'member')
WorkspacesUser.find_or_create_by!(user: user2, workspace: ws2, workspace_role: 'admin')

# --- Import Data Models from YAML ---
Dir.glob(Rails.root.join('db/data_models/*.yml')).each do |yml|
  DataModels::Import.call(filename: yml)
end


# --- Example Data Model Reference (Workspace-specific) ---
public_sdg_model = DataModel.where(public_model: true).find_by(name: 'Sustainable Development Goals and Targets')
ws1_sdg_model = DataModel.find_or_create_by!(name: 'Sustainable Development Goals and Targets', workspace: ws1) do |dm|
  dm.description = public_sdg_model&.description
  dm.status = :active
  dm.color = public_sdg_model&.color
  dm.short_name = public_sdg_model&.short_name
  dm.license = public_sdg_model&.license
  dm.author = public_sdg_model&.author
  dm.metadata = public_sdg_model&.metadata
end

# Optionally, copy focus area groups, focus areas, and characteristics if not present
if public_sdg_model && ws1_sdg_model.focus_area_groups.empty?
  public_sdg_model.focus_area_groups.each do |group|
    new_group = ws1_sdg_model.focus_area_groups.create!(group.attributes.slice('name', 'short_name', 'description', 'code', 'color', 'position'))
    group.focus_areas.each do |fa|
      new_fa = new_group.focus_areas.create!(fa.attributes.slice('name', 'short_name', 'description', 'code', 'color', 'position'))
      fa.characteristics.each do |char|
        new_fa.characteristics.create!(char.attributes.slice('name', 'short_name', 'description', 'code', 'position'))
      end
    end
  end
end

# --- Example Scorecard, Initiative, and Characteristics Creation ---
if ws1_sdg_model && ws1
  scorecard = Scorecard.find_or_create_by!(
    workspace: ws1,
    data_model: ws1_sdg_model,
    name: 'Demo Scorecard',
    description: 'Example scorecard using SDG structure'
  )

  # Create an initiative for the scorecard
  initiative = Initiative.find_or_create_by!(
    scorecard: scorecard,
    name: 'Demo Initiative',
    description: 'An example initiative for the demo scorecard.'
  )

  # Attach characteristics (indicators) from the data model to the initiative
  # We'll use the first 3 characteristics for demonstration
  indicators = ws1_sdg_model.characteristics.limit(3)
  indicators.each do |indicator|
    initiative.characteristics << indicator unless initiative.characteristics.include?(indicator)
  end
end
