module EasyTable
  module TableHelper
    def easy_table_for(item_or_items, options = {}, &block)
      if item_or_items.respond_to? :each
        EasyTable::TableBuilder.new(self, item_or_items, options, &block).render
      else
        EasyTable::ModelTableBuilder.new(self, item_or_items, options, &block).render
      end
    end
  end
end

