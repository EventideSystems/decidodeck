class AddAcceptedTermsAtToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :accepted_terms_at, :datetime
  end
end
