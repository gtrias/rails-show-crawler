require 'test_helper'
require 'mocha/test_unit'

require 'nokogiri'
require 'open-uri'

class CrawlServiceTest < ActiveSupport::TestCase
  test 'it crawl a provider' do

    doc = Nokogiri::HTML(open(Rails.root + 'test/support/mejortorrent.html'))

    crawl_service = CrawlService.new()
    crawl_service.stubs(:open).returns(doc)
    assert crawl_service.crawl('test')
  end
end

