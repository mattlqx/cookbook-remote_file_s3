# frozen_string_literal: true

require 'chefspec'
require 'chefspec/berkshelf'
require 'simplecov'

SimpleCov.start
SimpleCov.minimum_coverage 100

at_exit { ChefSpec::Coverage.report! }
