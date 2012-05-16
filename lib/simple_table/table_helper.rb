module SimpleTable
  module TableHelper
    def simple_table_for(items, options = {}, &block)
      SimpleTable::TableBuilder.new(self, items, options, &block).render
    end
  end
end

