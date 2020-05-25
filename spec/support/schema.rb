ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: true do |t|
    t.string(:email, null: false)
  end

  create_table :comments, force: true do |t|
    t.integer(:user_id)
  end
end
