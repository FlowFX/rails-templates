# frozen_string_literal: true

# https://guides.rubyonrails.org/rails_application_templates.html
# https://www.sitepoint.com/rails-application-templates-real-world/

# Add the current directory to the path Thor uses to look up files
def source_paths
  Array(super) + [__dir__]
end

## BUILDING a new Gemfil
remove_file 'Gemfile'
run 'touch Gemfile'
add_source 'https://rubygems.org'

gem 'rails', '~> 6.0.0.rc1 '
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
# No more erb foo
gem 'haml-rails'

# rspec-rails
gem_group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger
  # console.
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails', '~>3.8'
end

gem_group :development do
  # Access an interactive console on exception pages or by calling 'console'
  # anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the
  # background.
  gem 'spring'
  # cf. https://flowfx.de/blog/speeding-up-rspec-with-bundler-standalone-and-springified-binstubs/
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
end

gem_group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Use my own .gitignore file
remove_file '.gitignore'
copy_file '.gitignore'

after_bundle do
  # We're using RSpec
  remove_dir 'test'

  # We don't need no helper specs.
  application do
    <<-RUBY
    config.generators do |g|
      g.view_specs true
      g.helper_specs false
    end
    RUBY
  end

  # Install HAML and convert existing views.
  generate('haml:application_layout', 'convert')
  rails_command 'generate haml:application_layout convert'
  run 'rm app/views/layouts/application.html.erb'

  # #convert all existing views
  # run 'HAML_RAILS_DELETE_ERB=true rails haml:erb2haml'

  # Install RSpec
  generate('rspec:install')
  run 'bundle binstubs rspec-core'

  # Create default controller for the home page
  generate(:controller, 'Home', 'main')
  route "root to: 'home#main'"

  # Commit everything to the Git repository
  git :init
  git add: '.'
  git commit: %( -m 'Initial commit' )
end
