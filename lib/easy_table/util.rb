# encoding: utf-8
module EasyTable
  module RenderUtil
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

  module Util
    extend RenderUtil
  end


end
