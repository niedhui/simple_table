require "easy_table/version"
require "easy_table/config"
require "easy_table/base"
require "easy_table/column"
require "easy_table/table_builder"
require "easy_table/model_table_builder"
require "easy_table/table_helper"

module EasyTable
  Config.default_column_class = Column
end


require "easy_table/engine"
