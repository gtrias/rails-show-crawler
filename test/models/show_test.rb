require 'test_helper'

class ShowTest < ActiveSupport::TestCase
  test "should not save tvshow without name" do
    show = Show.new
    assert_not show.save, "Saved the show without a name"
  end
end
