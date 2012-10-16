module EasyTable
  class Engine < ::Rails::Engine
    initializer 'easy_table.initialize' do
      ActiveSupport.on_load(:action_view) do
        include EasyTable::TableHelper
      end
    end
  end
end
