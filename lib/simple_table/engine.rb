module SimpleTable
  class Engine < ::Rails::Engine
    initializer 'simple_table.initialize' do
      ActiveSupport.on_load(:action_view) do
        include SimpleTable::TableHelper
      end
    end
  end
end