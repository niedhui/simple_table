module SimpleTable
  class Column
    attr_accessor :name, :th_class, :td_class

    def initialize(name, options = {})
      @name, @options = name, options.to_options
      @th_class = @options.delete(:th_class)
      @td_class = @options.delete(:td_class)
    end

    def to_content(model)
      content_proc = @options[:content]
      if content_proc
        content_proc.call(model)
      else
        model.send(name)
      end
    end

  end
  class TableBuilder
    attr_accessor :template

    def initialize(template,items, options = {}, &proc)
      @template, @items = template, items
      @columns , @ops = [], []
      @model_class = options.delete(:model_class)
      @op_td_class = ([:op] << options.delete(:op_td_class)).join(" ")
      yield self
    end

    def render
      content_tag :table, class: 'simple-table table table-bordered' do
        render_head + render_body
      end
    end

    def render_head
      content_tag :thead do
        reduce_tags(@columns) { |column| content_tag(:th, @model_class.human_attribute_name(column.name), class: column.th_class) } +
        content_tag(:th) unless @ops.empty?
      end
    end

    def render_body
      content_tag :tbody do
        reduce_tags(@items) { |item| render_tr(item) }
      end
    end

    def render_tr(item)
      content_tag(:tr) do
        reduce_tags(@columns) {|column| content_tag(:td, column.to_content(item), class: column.td_class) } +
        reduce_tags(@ops) {|op|  content_tag(:td, template.capture(item,&op), class: @op_td_class) }
      end
    end

    # options:
    #   th_class
    #   td_class
    def td(name, options = {})
      @columns << Column.new(name, options)
    end
    alias :column :td

    def op(&block)
      @ops << block
    end

    def method_missing(name, *args, &block)
      if template.respond_to? name
        template.send(name, *args, &block)
      else
        super
      end
    end


    private

    def reduce_tags(iter)
      iter.reduce("".html_safe) do |content, element|
        content << (yield element)
      end
    end
  end

end
