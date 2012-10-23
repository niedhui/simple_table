module EasyTable
  class Base
    def initialize
    end

    # options
    #   label:
    #   th_html:
    #   td_html:
    #   using: column_class
    def td(name, options = {}, &block)
      self.class.add_column(name, options, &block)
    end
    alias :column :td

    def action(&block)
      self.class.add_action(&block)
    end
    alias :op :action

    def columns
      self.class.columns
    end

    def actions
      self.class.actions
    end

    def has_actions?
      actions.empty?
    end

    class << self
      def add_column(name, options = {}, &block)
        column_class = options[:using] || Config.default_column_class
        columns << column_class.new(name, options, &block)
      end

      def columns
        @columns ||= []
      end

      def add_action(&block)
        actions << block
      end

      def actions
        @actions ||= []
      end

    end

  end

end
