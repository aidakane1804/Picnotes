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

  def current_user_liked_card?(obj)
    obj.card_likes.where(user: current_user).last.present?
  end
  def current_user_comment_on_card?(obj)
    obj.card_comment_likes.where(user: current_user).last.present?
  end

end
