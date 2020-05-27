require 'bundler/setup'
require 'active_record/dedupe'

require 'factory_bot'
require 'logger'
require 'pry'

RSpec.configure do |config|
  config.expect_with(:rspec) do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
    mocks.yield_receiver_to_any_instance_implementation_blocks = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching(:focus)
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!

  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  # Wrap each example in a transaction
  config.before do
    ActiveRecord::Base.connection.begin_transaction(joinable: false, requires_new: true)
  end

  config.after do
    ActiveRecord::Base.connection.rollback_transaction
  end
end

# This connection will do for database-independent bug reports.
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.logger = Logger.new(STDOUT) unless ENV['QUIET'] || ENV['CI']

load File.dirname(__FILE__) + '/support/schema.rb'
require File.dirname(__FILE__) + '/support/models.rb'
