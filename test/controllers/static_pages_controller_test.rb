require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  def setup
    @title = ' | HopeApp'
  end
  
  test "should get home" do
    get :home
    assert_response :success
    assert_select 'title' , 'HopeApp'
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select 'title' , "Help#{@title}"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select 'title' , "About#{@title}"
  end

  test "should get contacts" do
    get :contacts
    assert_response :success
    assert_select 'title' , "Contacts#{@title}"
  end  
end
