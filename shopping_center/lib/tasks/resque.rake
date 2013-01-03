require 'resque/tasks'
require 'resque'
require 'rails'
require 'resque_scheduler/tasks'

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"
task "resque:setup" => :environment
task "resque:scheduler_setup" => :environment
