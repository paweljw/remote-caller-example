# frozen_string_literal: true

require 'watir/rspec'
require 'watir'
require 'billy/watir/rspec'

module BrowserSupport
  def self.browser
    @browser ||= TempBrowser.new
  end

  def self.configure(config)
    config.around(:each) do |example|
      BrowserSupport.browser.kill if example.metadata[:clean]
      @browser = BrowserSupport.browser.get
      @browser.cookies.clear
      @browser.driver.manage.timeouts.implicit_wait = 30
      example.run
    end

    config.after(:suite) do
      BrowserSupport.browser.kill
    end
  end

  class TempBrowser
    def get
      @browser ||= Watir::Browser.new(web_driver)
    end

    def kill
      @browser.close if @browser
      @browser = nil
    end

    private

    def web_driver
      Selenium::WebDriver.for(:chrome, options: options)
    end

    def options
      Selenium::WebDriver::Chrome::Options.new.tap do |options|
        options.add_argument '--auto-open-devtools-for-tabs'
        options.add_argument "--proxy-server=#{Billy.proxy.host}:#{Billy.proxy.port}"
      end
    end
  end
end
