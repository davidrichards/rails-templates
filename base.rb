# TODO:
# Root route
# registration routes
# reset password
# registration/login views
# basic template (possibly a purchased one)
# email integration, configuration
# break this into chunks

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
  run "mkdir -p public/stylesheets/sass"

# Bring gems local
  rake("gems:install", :sudo => true)
  
# Use Workflow as a single-file solution
  run "curl -L http://github.com/ryan-allen/workflow/raw/master/lib/workflow.rb > lib/workflow.rb"

# Generate testing environment
  generate "rspec"
  generate "cucumber"

# Do some authlogic stuff here.
  if yes?("Do you want some authentication?")
    load_template "http://github.com/davidrichards/rails-templates/raw/master/authentication.rb"
  end

# Save the example database config
  run "cp config/database.yml config/example_database.yml"

# Generate an information controller for the standard static stuff.
  generate "rspec_controller", "info"
  
  file "app/views/info/index.html.erb", ''
  file "app/views/info/about.html.erb", ''
  file "app/views/info/terms.html.erb", ''
  file "app/views/info/contact.html.erb", ''

# Setup a root route
  route "map.root :controller => 'info'"

# Run any migrations
  rake "db:migrate"
  
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
