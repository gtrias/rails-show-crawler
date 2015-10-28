require 'test_helper'

class ChapterTest < ActiveSupport::TestCase
  test "should not save chapter without number" do
    chapter = Chapter.new
    assert_not chapter.save, "Saved the chapter without chapter number"
  end
end
