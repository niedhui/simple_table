module SimpleTable
  class Column
    attr_accessor :name

    def initialize(name, options = {})
      @name, @options = name, options
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
      yield self
    end

    def render
      content_tag :table, class: 'table table-bordered' do
        render_head + render_body
      end
    end

    def render_head
      content_tag :thead do
        reduce_tags(@columns) { |column| content_tag(:th, @model_class.human_attribute_name(column.name)) } +
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
        reduce_tags(@columns) {|column| content_tag(:td, column.to_content(item)) } +
        reduce_tags(@ops) {|op|  content_tag(:td, template.capture(item,&op), class: :op) }
      end
    end

    def td(name, options = {})
      @columns << Column.new(name, options)
    end
    alias :column :td

    def method_missing(name, *args, &block)
      if template.respond_to? name
        template.send(name, *args, &block)
      else
        super
      end
    end

    def op(&block)
      @ops << block
    end

    private

    def reduce_tags(iter)
      iter.reduce("".html_safe) do |content, element|
        content << (yield element)
      end
    end
  end

end
