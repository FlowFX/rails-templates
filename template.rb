# template.rb
# https://guides.rubyonrails.org/rails_application_templates.html#route-routing-codex


# haml-rails
# https://github.com/indirect/haml-rails

gem 'haml-rails', '~>2.0'

generate('haml:application_layout', 'convert')
rails_command 'generate haml:application_layout convert'
run 'rm app/views/layouts/application.html.erb'

# convert all existing views
rails_command 'haml:erb2haml'

# rspec-rails
gem_group :development, :test do
  gem 'rspec-rails', '~>3.8'
end

bundle install
generate('rspec:install')

bundle binstubs rspec-core

generate(:controller, 'Home', 'main')

route "root to: 'home#main'"

after_bundle do
  git :init
  git add: '.'
  git commit: %Q{ -m 'Initial commit' }
end
