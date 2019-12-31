module ApplicationHelper
  def cp(path)
    'current' if current_page?(path)
  end
  def top_writer
    User.find(2)
  end
end
