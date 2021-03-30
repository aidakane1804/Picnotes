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


  def get_tag_info(tag)
    ActsAsTaggableOn::Tag.where(name: tag).last
    # => [#<ActsAsTaggableOn::Tag:0x000055aa6cea0788 id: 298, name: "papi_cho", taggings_count: 1>]
  end

end
