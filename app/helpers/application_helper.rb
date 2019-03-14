module ApplicationHelper
  def cp(path)
    'current' if current_page?(path)
  end

  def strip_url(target_url)
  target_url.gsub("http://", "")
            .gsub("https://", "")
            .gsub("www.", "")
end
end
