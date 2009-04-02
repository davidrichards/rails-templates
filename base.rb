# Delete unnecessary files
  run "rm README"
  run "rm public/index.html"
  run "rm public/favicon.ico"
  run "rm public/robots.txt"
  run "rm -f public/javascripts/*"
 
# Download JQuery
  run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.2.6.min.js > public/javascripts/jquery.js"
  run "curl -L http://jqueryjs.googlecode.com/svn/trunk/plugins/form/jquery.form.js > public/javascripts/jquery.form.js"

# Install plugins
  plugin 'rspec',  :git => 'git://github.com/dchelimsky/rspec.git'
  plugin 'rspec-rails', :git => 'git://github.com/dchelimsky/rspec-rails.git'
  plugin 'exception_notifier', :git => 'git://github.com/rails/exception_notification.git'
  run "haml --rails ."

# Bring gems local
  rake("gems:install", :sudo => true)
  
# Use Workflow as a single-file solution
  run "curl -L http://github.com/ryan-allen/workflow/raw/master/lib/workflow.rb > lib/workflow.rb"

# Generate testing environment
  generate "rspec"
  generate "cucumber"

# Do some authlogic stuff here.
  if yes?("Do you want some authentication?")
    gem 'authlogic'
    file 'config/environment.rb',
%q{# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  config.gem "authlogic"
end
}
  generate "session", "user_session"
  file "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S_create_users.rb')}",
%q{class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :email,               :null => false
      t.string    :crypted_password,    :null => false
      t.string    :password_salt,       :null => false
      t.string    :persistence_token,   :null => false
      t.string    :single_access_token, :null => false
      t.string    :perishable_token,    :null => false
      t.integer   :login_count,         :null => false, :default => 0
      t.integer   :failed_login_count,  :null => false, :default => 0
      t.datetime  :last_request_at
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.string    :current_login_ip
      t.string    :last_login_ip
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
}
  run "mkdir -p app/models"
  file "app/models/user.rb",
%q{class User < ActiveRecord::Base
  acts_as_authentic do |c|
    # c.my_config_option = my_value
  end
end
}
  run "mkdir -p spec/models"
  file "spec/models/user_spec.rb",
%q{require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @valid_attributes = {
      :email => "user@example.com",
      :password => "password",
      :confirm_password => "password",
      :persistence_token => "value for persistence_token",
      :single_access_token => "value for single_access_token",
      :perishable_token => "value for perishable_token"
    }
  end

  it "should create a new instance given valid attributes" do
    user_model
  end
end

def user_model(opts={})
  @user = User.create!(@valid_attributes.merge(opts))
end
}

  end

# Save the example database config
  run "cp config/database.yml config/example_database.yml"

# Init Git
  file ".gitignore",
%q{
.DS_Store
log/*.log
log/**/*
tmp/**/*
tmp/*
db/*sql
db/*.sqlite3
config/database.yml
config/mysql.database.yml
models.dot
db/schema.rb
}

  git :init
  git :add => "."
  git :commit => "-m 'initial commit'"  
