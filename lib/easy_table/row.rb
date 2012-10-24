# encoding: utf-8
module EasyTable
  class Row
    include RenderUtil
    attr_reader :item, :html, :view

    delegate :content_tag, :capture, to: :view

    def initialize(table, view, item, options = {})
      @item = item
      @table = table
      @view = view
      @html = eval_html_attrs(options[:html], item)
      @op_td_class = options[:op_td_class]
    end

    def render
      content_tag(:tr, :html) do
        reduce_tags(@table.columns) {|column| content_tag(:td, column.content(item, @view), column.options[:td_html]) } +
        reduce_tags(@table.actions) {|op|  content_tag(:td, capture(item, @view, &op), class: @op_td_class) }
      end

    end

  end

end
