# Set the host name for URL creation
require 'sitemap_generator'


# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.picnotes.org/"
# pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = 'tmp/'
# store on S3 using Fog (pass in configuration values as shown above if needed)
# SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(fog_provider: 'AWS',
                                                                    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'] || '',
                                                                    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] || '',
                                                                    fog_directory: "picnotes-2019",
                                                                    fog_region: 'us-west-1')
# inform the map cross-linking where to find the other maps
# SitemapGenerator::Sitemap.sitemaps_host = "http://picnotes-2019.s3.amazonaws.com/"
SitemapGenerator::Sitemap.sitemaps_host = "http://s3-us-west-1.amazonaws.com/picnotes-2019/"
# pick a namespace within your bucket to organize your maps
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
# SitemapGenerator::Sitemap.default_host = "https://www.picnotes.org/"
# SitemapGenerator::Sitemap.publicpath = 'tmp/'

SitemapGenerator::Sitemap.create do

  # Put links creation logic here.
  # add "https://www.picnotes.org", priority: 1.00 , :lastmod => Time.now
  add "password_resets/new", priority: 0.80 , :lastmod => Time.now
  add "notes/about_us" ,priority: 0.80 , :lastmod => Time.now
  add "notes/community_guideline", priority: 0.80 , :lastmod => Time.now
  add "notes/terms_and_conditions", priority: 0.80 , :lastmod => Time.now
  add "notes/contact_us", priority: 0.80 , :lastmod => Time.now
  add "notes/what_is_picnotes", priority: 0.64 , :lastmod => Time.now
  add "notes/educational_organizations", priority: 0.64 , :lastmod => Time.now
  add "notes/freelance_research",   priority: 0.64 , :lastmod => Time.now
  add "notes/message_from_the_founder", priority: 0.64 , :lastmod => Time.now
  add "notes/sharing_your_knowledge",  priority: 0.64 , :lastmod => Time.now
  add "notes/optimizing_your_dashboard", priority: 0.64 , :lastmod => Time.now
  add "notes/what_type_of_topics_you_should_share", priority: 0.64 , :lastmod => Time.now
  add "notes/communication_and_interaction", priority: 0.64 , :lastmod => Time.now
  Note.find_each do |note|
    add note_path(note.title_slug),  priority: 0.80 ,changefreq: 'daily', lastmod: note.updated_at
  end
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'daily',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #"https://www.picnotes.org/notes"+note.title_slug

end
