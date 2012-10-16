module Easy
  # params:
  #  sorter:
  #    name:
  #    order: :asc | :desc
  def for_easy_talbe(params)
    sorter = params[:sorter]
    name = sorter[:name]
    order = (sorter[:order] || :asc).intern
    [:asc, :desc].delete(order)


  end

end
