module ActiveRecord
  module Dedupe
    class Relation < ActiveRecord::Relation
      using ArelRefinements

      attr_reader :model, :columns

      delegate :name, to: :model

      def initialize(model, *columns)
        @model = model
        @columns = columns

        raise ArgumentError, 'model cannot be blank' if model.blank?
        raise ArgumentError, 'at least one column must be provided' if columns.compact.blank?

        super(model)
        apply_scope
      end

      def pluck(*column_names)
        super(*select_values, *column_names.delete_if(&:blank?)).map do |(*values)|
          DuplicateGroup.new(
            *values,
            model: model,
            group_columns: columns,
            additional_columns: column_names
          )
        end
      end

    private

      def apply_scope
        group!(columns).having!(Arel.star.count.gt(1))._select!(projections)
      end

      def projections
        [
          model[:id].group_concat.as('ids'),
          *columns
        ].delete_if(&:blank?)
      end
    end
  end
end
