module SimpleTable
  module TableHelper
    def simple_table_for(item_or_items, options = {}, &block)
      if item_or_items.respond_to? :each 
        SimpleTable::TableBuilder.new(self, item_or_items, options, &block).render
      else
        SimpleTable::ModelTableBuilder.new(self, item_or_items, options, &block).render
      end
    end
  end
end

