# frozen_string_literal: true

require 'json'

module ProxySupport
  HEADERS = {
        'Access-Control-Allow-Methods' => 'GET',
        'Access-Control-Allow-Headers' => 'X-Requested-With, X-Prototype-Version, Content-Type',
        'Access-Control-Allow-Origin'  => '*'
      }.freeze

  def stub_json(url, file)
    Billy.proxy.stub(url).and_return({
      body: open(file).read,
      code: 200,
      headers: HEADERS.dup
    })
  end

  def stub_status(url, status)
    Billy.proxy.stub(url).and_return({
      body: '',
      code: status,
      headers: HEADERS.dup
    })
  end

  def stub_page(url, file)
    Billy.proxy.stub(url).and_return(
      body: open(file).read,
      content_type: 'text/html',
      code: 200
    )
  end

  def stub_js(url, file)
    Billy.proxy.stub(url).and_return(
      body: open(file).read,
      content_type: 'application/javascript',
      code: 200
    )
  end
end
