require 'test_helper'

class SeasonTest < ActiveSupport::TestCase
  test "should not save season without number" do
    show = Show.new
    assert_not show.save, "Saved the show without a number"
  end
end
