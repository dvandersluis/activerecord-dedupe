require 'spec_helper'

RSpec.describe ActiveRecord::Dedupe do
  it do
    User.create!(email: 'foo@bar.com')
    expect(User.count).to eq(1)
  end
end
