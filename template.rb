# Create a new rails app using:
# => rails new [app] -J -T -m /path/to/this/file

#--------------------------
# BASIC GEMS
#--------------------------
gem "rspec-rails", :group => [:development, :test]
gem "ruby-debug"
gem "awesome_print"
gem "annotate-models"

#--------------------------
# FACTORY_GIRL
#--------------------------
gem "rails3-generators", :group => [:development, :test]
gem "factory_girl_rails", :group => [:development, :test]
# Generate factories using the rails3-generator for factory-girl.
generators = <<-GENERATORS

    config.generators do |g|
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end
GENERATORS
application generators

#--------------------------
# JQUERY
#--------------------------
gem "jquery-rails"
# Set the :defaults in javascript tags to load jquery
gsub_file 'config/application.rb', 'config.action_view.javascript_expansions[:defaults] = %w()', 'config.action_view.javascript_expansions[:defaults] = %w(jquery.js rails.js)'

#--------------------------
# HAML
#--------------------------
gem "haml-rails", ">= 0.3.4"
# Replace the erb application layout with haml one.
layout = <<-LAYOUT
!!!
%html
  %head
    %title #{app_name.humanize}
    = stylesheet_link_tag :all
    = javascript_include_tag :defaults
    = csrf_meta_tag
  %body
    = yield
LAYOUT
remove_file "app/views/layouts/application.html.erb"
create_file "app/views/layouts/application.html.haml", layout

#--------------------------
# INSTALL GEMS
#--------------------------
run 'bundle install'
generate 'jquery:install'
generate 'rspec:install'

#--------------------------
# POSTGRES
#--------------------------
# Note: pg gem causes trouble with rspec install
# so it has to be loaded after.
# Create a database.yml for postgres
postgres_pass = ask("\r\nEnter your postgres password:")
remove_file "config/database.yml"
create_file "config/database.yml", <<-DATABASE
development:
  adapter: postgresql
  encoding: unicode
  database: #{app_name}_development
  pool: 5
  username: postgres
  password: #{postgres_pass}

test:
  adapter: postgresql
  encoding: unicode
  database: #{app_name}_test
  pool: 5
  username: postgres
  password: #{postgres_pass}

production:
  adapter: postgresql
  encoding: unicode
  database: #{app_name}_production
  pool: 5
  username: postgres
  password: #{postgres_pass}
DATABASE
# Create databases
rake "db:create:all"
# Install pg gem.
gem 'pg'
run 'bundle install'

#--------------------------
# CLEANUP
#--------------------------
remove_file 'public/index.html'
remove_file 'public/images/rails.png'

#--------------------------
# GIT
#--------------------------
# Create a standard .gitignore file.
remove_file ".gitignore"
create_file '.gitignore', <<-FILE
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
public/uploads/*
gems/*
!gems/cache
!gems/bundler
FILE
# Initialize a git repository.
git :init
git :submodule => "init"
git :add => '.'
git :commit => "-a -m 'Initial commit'"