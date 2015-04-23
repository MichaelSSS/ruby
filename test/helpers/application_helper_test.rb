require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full title' do
    assert_equal full_title, 'HopeApp'
    assert_equal full_title('About'), 'About | HopeApp'
  end
end
