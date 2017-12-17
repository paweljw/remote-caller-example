# frozen_string_literal: true

describe 'Remote calling' do
  let(:page_url) { 'http://myfancypage.local/index.html' }
  let(:js_url) { 'http://myfancypage.local/dist/remote-caller-example.js' }

  let(:page_path) { './dist/index.html' }
  let(:js_path) { './dist/remote-caller-example.js' }

  before do
    stub_page page_url, page_path
    stub_js js_url, js_path
  end

  context 'with correct response' do
    before do
      stub_json %r{http://poloniex.com/public(.*)}, './spec/fixtures/remote.json'
      goto page_url
      Watir::Wait.until { browser.execute_script('return window.logs.length === 2') }
    end

    it 'logs proper data' do
      expect(browser.execute_script('return window.logs')).to(
        eq(['[EXAMPLE] Remote fetch successful', '[EXAMPLE] BTC to ETH: 0.03619999'])
      )
    end
  end

  context 'with failed response' do
    before do
      stub_status %r{http://poloniex.com/public(.*)}, 404
      goto page_url
      Watir::Wait.until { browser.execute_script('return window.logs.length === 1') }
    end

    it 'logs failure' do
      expect(browser.execute_script('return window.logs')).to(
        eq(['[EXAMPLE] Remote fetch failed'])
      )
    end
  end
end
