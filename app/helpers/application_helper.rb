module ApplicationHelper
  # 根据不同情况返回 title
  def full_title(page_title)
    base_title = "Hick"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end
