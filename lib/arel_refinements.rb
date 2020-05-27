require 'active_record'

module ArelRefinements
  refine ::ActiveRecord::Base.singleton_class do
    def [](col)
      arel_table[col]
    end
  end
end
