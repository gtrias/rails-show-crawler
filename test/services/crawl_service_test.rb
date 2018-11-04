require 'test_helper'

class CrawlServiceTest < ActiveSupport::TestCase
  test 'it crawl a provider' do
    params = {
      media: 'test'
    }
    assert CrawlService.new(params).crawl
  end
end

