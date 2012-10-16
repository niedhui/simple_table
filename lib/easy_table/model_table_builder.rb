module EasyTable
  class AttrTr
    attr_accessor :name, :options

    def initialize(name, model_class, template, options = {}, &block)
      @name, @model_class , @template, @options = name, model_class, template, options.to_options
      @content_block = block if block_given?
    end

    def label
      @options[:label] || @model_class.human_attribute_name(name)
    end


    def to_content(model)
      content_proc = @options[:content]
      if content_proc
        content_proc.call(model)
      elsif @content_block
        @template.capture(model, &@content_block)
      else
        model.send(name)
      end
    end

  end


  class ModelTableBuilder
    attr_accessor :template

    def initialize(template,item, options = {}, &proc)
      @template, @item = template, item
      @attrs = []
      @model_class = item.class
      yield self
    end

    def render
      content_tag :table, class: 'easy-table table table-bordered' do
        render_body
      end
    end

    def render_body
      content_tag :tbody do
        reduce_tags(@attrs) { |attr| render_tr(attr) } +
        render_op
      end
    end

    def render_tr(attr)
      content_tag(:tr) do
        content_tag(:td, attr.label) +
        content_tag(:td, attr.to_content(@item),attr.options[:value_td_html])
      end
    end

    def render_op
      if @op_block
        content_tag(:tr) do
          content_tag(:td,template.capture(@item,&@op_block), class: 'op', colspan: 2)
        end
      end
    end

    # name
    #  attribute_name
    # options:
    #   value_td_html
    def tr(name, options = {}, &block)
      @attrs << AttrTr.new(name, @model_class, template, options, &block)
    end

    alias :attr :tr

    def op(&block)
      @op_block = block
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
