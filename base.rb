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
  runy "curl -L http://github.com/ryan-allen/workflow/raw/master/lib/workflow.rb > lib/workflow.rb"

# Generate testing environment
  generate "rspec"
  generate "cucumber"

# Do some authlogic stuff here.
  if yes?("Do you want some authentication?")
    # TODO...
  end

# Save the example database config
  run "cp config/database.yml config/example_database.yml"

# Init Git
  git :init
  git :add => "."
  file ".gitignore", <<-END
.DS_Store
log/*.log
log/**/*
tmp/**/*
tmp/*
db/*.sqlite3
config/database.yml
config/mysql.database.yml
models.dot
db/*sql
db/development_structure.sql
db/schema.rb
noodle*
tmp_*
public/files/**/*
END
  git :commit => "-m 'initial commit'"  
