This is an idea from Ryan Bates.  Create my own Rails templates and put them on GitHub, so that I can use them wherever I go.  Probably I have a few local dependencies that would be a bit of a pain for anyone else to use these, but it's a good idea (I think) to have things like Haml, Cucumber, and Webrat on a development machine.

There is a function that I also borrowed from Ryan that makes this more useful.  This is adjusted for my repositories.

  function railsapp {
    template=$1
    appname=$2
    shift 2
    rails $appname -m http://github.com/davidrichards/rails-templates/raw/master/$template.rb $@
  }
