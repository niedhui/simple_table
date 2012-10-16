module EasyTable
  class TableBuilder
    attr_accessor :template

    # options:
    #  model_class
    #  talbe_class
    #  tr_class
    def initialize(template,items, options = {}, &proc)
      @template, @items = template, items
      @columns , @ops = [], []
      @model_class = options.delete(:model_class)
      @table_class = (Array(options[:table_class]) << 'easy-table table table-bordered').join(' ')
      @op_td_class = ([:op] << options.delete(:op_td_class)).join(" ")
      @tr_class = options.delete(:tr_class)
      yield self
    end

    def render
      content_tag :table, class: @table_class  do
        render_head + render_body
      end
    end

    def render_head
      content_tag :thead do
        reduce_tags(@columns) { |column| content_tag(:th, column.label(@model_class), class: column.th_class) }.tap do |html|
          html << content_tag(:th) unless @ops.empty?
        end

      end
    end

    def render_body
      content_tag :tbody do
        reduce_tags(@items) { |item| render_tr(item) }
      end
    end

    def render_tr(item)
      tr_class = eval_css_class(@tr_class, item)
      content_tag(:tr, class: tr_class) do
        reduce_tags(@columns) {|column| content_tag(:td, column.content(item, template), class: column.td_class) } +
        reduce_tags(@ops) {|op|  content_tag(:td, template.capture(item,&op), class: @op_td_class) }
      end
    end

    # options:
    #   th_class
    #   td_class
    #   label:
    def td(name, options = {}, &block)
      @columns << Column.new(name, options, &block)
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

    def eval_css_class(css_class, model)
      case css_class
      when String
        css_class
      when Array
        css_class.join(" ")
      when Proc
        css_class.call(model)
      end
    end
  end

end
