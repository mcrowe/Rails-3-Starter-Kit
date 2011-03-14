Ruby on Rails Setup

Assumptions
-----------
XCode / Developer Kit, Git, Textmate already installed.

Basic Install
-------------

Install rvm:

> mkdir -p ~/.rvm/src/ && cd ~/.rvm/src && rm -rf ./rvm/ && git clone git://github.com/wayneeseguin/rvm.git && cd rvm && ./install

Add the following to your ~/.profile:
# Load RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

Load your .profile:
> source ~/.profile
> rvm -v
> rvm list

Install ruby 1.8.7:
> rvm install 1.8.7
> rvm 1.8.7 --default
> ruby -v
> rvm list
> rvm gemdir
> gem -v
> gem list

Make gem install not compile rdoc or ri, add the following to ~/.gemrc:
gem: --no-ri --no-rdoc

Install rails:
> gem install rails
> rails -v

Postgres Setup
--------------

Install Postgres:

Get the one click installer at: http://www.postgresql.org/download/macosx   (> v 9.0.3), and run the app inside the dmg. (Note: I had to restart my system and re-run the installer). Use the default settings, set the password to postgres. Don't run stack builder at the end.

Add the following to your ~/.profile:
# Add Postgres binaries to the path
export PATH=$PATH:/Library/PostgreSQL/9.0/bin

Reload your ~/.profile:

>$ source ~/.profile

Create a new rails app using postgres

Create a new app with a database.yml setup for postgres, and the pg gem added in Gemfile:

>$ rails new pgtest -d postgresql

Edit your database.yml: Set the proper username and password for each db, and remove all the annoying comments. 

Create your databases.
>$ rake db:create:all

Add postgres to an existing rails app

Add pg gem to Gemfile

> gem ‘pg’

Replace config/database.yml with:
  
>  development:
>    adapter: postgresql
>    encoding: unicode
>    database: [appname]_development
>    pool: 5
>    username: postgres
>    password: [password]
>
>  test:
>    adapter: postgresql
>    encoding: unicode
>    database: [appname]_test
>    pool: 5
>    username: postgres
>    password: [password]
>
>  production:
>    adapter: postgresql
>    encoding: unicode
>    database: [appname]_production
>    pool: 5
>    username: postgres
>    password: [password]

Create your databases.
> rake db:create:all

Optional: Install navicat for administering postgres

Download navicat lite for administering postgres: 
	http://www.navicat.com/en/download/download.html

Pimp Your Console

Add awesome printing (colors and formatting of console output)

Add to Gemfile in each rails app:
group :development, :test do
  gem 'awesome_print'
end

Try it in rails console:
> ap { :a => 1, :b => 2 }

Nice console prompt, logging to console, console indenting

Setup your ~.irbrc to look like:

%w{rubygems}.each do |lib| 
  begin 
    require lib 
  rescue LoadError => err
    $stderr.puts "Couldn't load #{lib}: #{err}"
  end
end

# Prompt behavior
IRB.conf[:AUTO_INDENT] = true

# Loaded when we fire up the Rails console
# => Set a special rails prompt.
# => Redirect logging to STDOUT.   
if defined?(Rails.env)
  rails_env = Rails.env
  rails_root = File.basename(Dir.pwd)
  prompt = "#{rails_root}[#{rails_env.sub('production', 'prod').sub('development', 'dev')}]"
  IRB.conf[:PROMPT] ||= {}
  IRB.conf[:PROMPT][:RAILS] = {
    :PROMPT_I => "#{prompt}>> ",
    :PROMPT_S => "#{prompt}* ",
    :PROMPT_C => "#{prompt}? ",
    :RETURN   => "=> %s\n" 
  }
  IRB.conf[:PROMPT_MODE] = :RAILS
  # Redirect log to STDOUT, which means the console itself
  IRB.conf[:IRB_RC] = Proc.new do
    logger = Logger.new(STDOUT)
    ActiveRecord::Base.logger = logger
    ActiveResource::Base.logger = logger
    ActiveRecord::Base.instance_eval { alias :[] :find }
  end
end


Setup Fast, Continuous RSpec Testing

Create a new app with rspec

Create a new app without test-unit:
> rails new myapp -T

Include rspec-rails gem. Add the following to Gemfile:
group :development, :test do
  gem 'rspec-rails'
end

Install rspec:
> bundle
> rails g rspec:install

The generator creates a few files. Namely:
.rspec - a config file where we can store extra command line options for the rspec command line tool. By default it contains --colour which turns on colored output from RSpec.
spec - a directory that will store all of the various model, controller, view, acceptance and other specs for your app
spec/spec_helper.rb - a file that's loaded by every spec (not in any automatic way but most have require 'spec_helper' at the top). It sets the test environment, contains app level RSpec configuration items, loads support files, and more.

You can now run specs by using ‘rake’ or ‘rake spec’, and spec scaffolds are auto generated for you when using rails generators.

Install rspec textmate bundle

(For syntax highlighting and running of an open test file in tm using cmd-r with a nice html output)

Follow the instuctions here:
http://rspec.info/documentation/tools/extensions/editors/textmate.html

or here:
http://stackoverflow.com/questions/3532538/installing-rspec-bundle-for-textmate

Install autotest

First, make sure you have growl installed and running on login.

> gem install autotest-standalone
> gem install autotest-fsevent
> gem install autotest-growl

Setup autotest to use fsevent and growl. Create ~/.autotest with:
	require 'autotest/fsevent'
	require 'autotest/growl'

Make sure you have growl configured to accept the autotest application.

Run autotest:
> autotest

It will watch for changes to specs and source code of all your apps and run any required tests.

Optional: Install spork to increase your test speed.

Follow the instructions here:
http://www.rubyinside.com/how-to-rails-3-and-rspec-2-4336.html


Install factory_girl

Update Gemfile to include:
group :development, :test do
  gem 'rails3-generators'
  gem 'factory_girl_rails'
end

Setup generators to create factories when we generate a model. In application.rb add:
config.generators do |g|
	g.fixture_replacement :factory_girl, :dir => "spec/factories"
end


Install ruby debugger

Add to Gemfile:
	gem ‘ruby-debug’

Add ‘debugger’ command where you want to enter debugger. Run server using:
> rails s --debug


Install jQuery

Create app with no prototype
> rails new my_app -J

Install jQuery
Add to Gemfile:
	gem ‘jquery-rails’, ‘>= 0.2.6’

> bundle
> rails g jquery:install (--ui)

Add jquery to the default javascript loaded. 

Edit the following line in application.rb:
	config.action_view.javascript_expansions[:defaults] = %w()
To read:
	config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

Optional: Load jQuery and jQuery-UI from google

See: http://code.google.com/apis/libraries/devguide.html 
and add script tags to load the desired libraries. Remove :defaults, and add the scripts you want to load manually.

jquery-ui css is hosted at:
	http://ajax.googleapis.com/ajax/libs/jqueryui/[UI.VERSION]/themes/[THEME-NAME]/jquery-ui.css


Install Haml

Add to Gemfile:
	gem ‘haml-rails’

> bundle

Generators for haml views are included and invoked by default.

Replace default application layout with a haml one.



