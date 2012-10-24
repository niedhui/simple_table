module EasyTable
  class TableBuilder
    include RenderUtil
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
      @op_td_class = ([:op] << options.delete(:op_td_class)).join(" ")
      @table_clazz = options[:using] || Class.new(Base)
      @table_clazz.configure do |config|
        config.table_html = Config.table_html.merge(options[:table_html] || {})
        config.tr_html = options[:tr_html]
        config.td_html = options[:td_html]
        model_clazz_option = options[:model_class] || options[:model_clazz]
        config.model_clazz = model_clazz_option unless model_clazz_option.blank?
      end
      @table = @table_clazz.new
      yield @table if block_given?
    end

    def render
      content_tag :table, @table.table_html do
        render_head + render_body
      end
    end

    def render_head
      content_tag :thead do
        reduce_tags(@table.columns) { |column| content_tag(:th, column.label(@table.model_clazz),column.options[:th_html] ) }.tap do |html|
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
      Row.new(@table, template, item, html: options[:tr_html], op_td_class: @op_td_class).render
    end

    def method_missing(name, *args, &block)
      if template.respond_to? name
        template.send(name, *args, &block)
      else
        super
      end
    end
  end

end
