$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dep_updater'
require 'pry'
require 'ap'

RSpec.configure do |c|
  c.filter_run_including focus: true
  c.run_all_when_everything_filtered = true
end
