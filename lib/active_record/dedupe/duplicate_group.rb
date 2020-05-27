module ActiveRecord
  module Dedupe
    class DuplicateGroup
      attr_reader :ids, :group_values, :additional_values

      # Takes an array of data from pluck and coerces it into a value object
      def initialize(ids, *values, model:, group_columns:, additional_columns: [])
        @model = model
        @ids = ids.split(',').map(&:to_i)
        @group_values = group_columns.zip(values.shift(group_columns.size)).to_h
        @additional_values = additional_columns.zip(values).to_h
      end

      def records
        model.find(ids)
      end

    private

      attr_reader :model, :values, :columns
    end
  end
end
