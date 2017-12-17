# frozen_string_literal: true

require 'rubygems'
require 'bundler'
Bundler.require

Dir['./spec/support/**/*.rb'].each { |f| require f }

TEST_LOGGER = Logger.new(STDOUT)

RSpec.configure do |config|
  config.before(:suite) { Cocaine::CommandLine.new('npm', 'run build', logger: TEST_LOGGER).run }

  config.include Watir::RSpec::Helper
  config.include Watir::RSpec::Matchers

  config.include ProxySupport

  config.order = :random
  BrowserSupport.configure(config)
end

Billy.configure do |c|
  c.cache = false
  c.cache_request_headers = false
  c.persist_cache = false
  c.record_stub_requests = true
  c.logger = Logger.new(File.expand_path('../log/billy.log', __FILE__))
end
