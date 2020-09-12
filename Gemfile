source 'https://rubygems.org'
# Heroku Ruby Version Production
# ruby '2.4.5'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# continues updating sitemap.xml
gem 'sitemap_generator'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# Password
gem 'bcrypt', '~> 3.1.7'

# Forms
gem 'simple_form'

# CarrierWave image-upload
gem 'carrierwave', '~> 1.0'
# Compressing and resizing photos
gem 'mini_magick'

# Storing on Amazon
gem "fog-aws"
gem 'fog'
gem 'will_paginate'
gem 'bootstrap-will_paginate', '~> 0.0.10'

# Tags in notes
gem 'acts-as-taggable-on'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# user privilledges
gem 'cancancan'

#front end
gem 'bootstrap'
gem 'jquery-rails'
gem 'chosen-rails'
group :production do
  gem 'rails_12factor'
end
gem 'font-awesome-rails'
gem 'font-awesome-sass', '~> 5.11.2'

# Voting (like / dislike)
gem 'acts_as_votable', '~> 0.12.0'

# Facebook
gem 'omniauth-facebook'
gem 'thin'

# Google Auth
gem 'omniauth-google-oauth2'

# Mailers
gem 'mail_form'

# Droppings files into box for upload * not used
gem 'dropzonejs-rails'

# Meta Tags
gem 'meta-tags'

# Error 404
gem 'activeadmin'
gem "devise"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'interactive_editor'
  gem 'hirb'
  gem 'awesome_print', :require => 'ap'
  gem 'pry'
  gem 'pry-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
