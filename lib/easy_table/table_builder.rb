module EasyTable
  class TableBuilder
    attr_reader :options
    attr_accessor :template

    # options:
    #  model_class
    #  using:
    #  table_html: {}
    #  tr_html: {}
    def initialize(template, items, options = {}, &proc)
      @template, @items = template, items
      @options = options
      @model_class = @options.delete(:model_class)
      @op_td_class = ([:op] << options.delete(:op_td_class)).join(" ")
      @table = (options[:using] || Class.new(Base)).new
      yield @table if block_given?
    end

    def render
      content_tag :table, Config.table_html.merge(options[:table_html] || {})  do
        render_head + render_body
      end
    end

    def render_head
      content_tag :thead do
        reduce_tags(@table.columns) { |column| content_tag(:th, column.label(@model_class),column.options[:th_html] ) }.tap do |html|
          html << content_tag(:th) unless @table.has_actions?
        end
      end
    end

    def render_body
      content_tag :tbody do
        reduce_tags(@items) { |item| render_tr(item) }
      end
    end

    def render_tr(item)
      tr_html = eval_html_attrs(options[:tr_html], item)
      content_tag(:tr, tr_html) do
        reduce_tags(@table.columns) {|column| content_tag(:td, column.content(item, template), column.options[:td_html]) } +
        reduce_tags(@table.actions) {|op|  content_tag(:td, template.capture(item,&op), class: @op_td_class) }
      end
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

    def eval_html_attrs(attrs, model = nil)
      return {} if attrs.blank?
      attrs.reduce({}) do |hash,(k,v)|
        value = v.respond_to?(:call) ? v.call(model) : v
        hash[k] = value
        hash
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
