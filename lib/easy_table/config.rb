module EasyTable
  class Config
    include ActiveSupport::Configurable

    config_accessor :table_html, :default_column_class

  end

end
