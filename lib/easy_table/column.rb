module EasyTable
  class Column
    attr_reader :name, :view, :options
    attr_accessor :th_class, :td_class

    def initialize(name, options, &block)
      @name     = name
      @options  = options
      options[:content] = block if block_given?
    end

    def label(model_class = nil)
      options[:label] || if model_class
        model_class.human_attribute_name(name)
      else
        name.to_s.humanize
      end
    end

    def content(object, view)
      value_proc = options[:content]
      if value_proc
        view.capture(object, &value_proc)
      else
        object.send(name)
      end
    end

  end
end
