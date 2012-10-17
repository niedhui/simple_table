module EasyTable
  class Base
    attr_reader :columns, :actions
    def initialize
      @columns = []
      @actions = []
    end

    # options
    #   label:
    #   th_html:
    #   td_html:
    #   using: column_class
    def td(name, options = {}, &block)
      column_class = options[:using] || Config.default_column_class
      @columns << column_class.new(name, options, &block)
    end
    alias :column :td

    def action(&block)
      @actions << block
    end
    alias :op :action

    def has_actions?
      ! actions.empty?
    end

  end

end
