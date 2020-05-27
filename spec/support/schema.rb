ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: true do |t|
    t.string(:email, null: false)
    t.timestamps
  end

  create_table :comments, force: true do |t|
    t.integer(:user_id)
    t.timestamps
  end

  create_table :subscribers, force: true do |t|
    t.integer(:newsletter_id)
    t.integer(:user_id)
    t.timestamps
  end
end
