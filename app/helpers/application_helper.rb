module ApplicationHelper
  def cp(path)
    'current' if current_page?(path)
  end
  def top_writer
    User.find(2)
  end

  def get_fullname data
  	return "#{data.first_name} #{data.last_name}"
  end

end
