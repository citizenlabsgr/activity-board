# This file is used by Rack-based servers to start the application.

require 'rbtrace'

require 'semantic-ui-sass'

require ::File.expand_path('../config/environment', __FILE__)
run CodeTriage::Application
