module ApplicationHelper
  def cp(path)
    'current' if current_page?(path)
  end

#   def og_image_path
#   if @note.present?
#     @note.image.url
#   end
# end
#
# def og_url_path
#   if @note.present?
#     # "http://www.picnotes.org/notes/" + @note.id.to_param
#   end
# end
end
