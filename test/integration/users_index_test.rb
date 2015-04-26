require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @user = users(:archer)
  end
  
  test 'index as admin with pagination and delete links' do
    log_in_as @admin
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1, per_page: 10).each do |u|
      assert_select 'a[href=?]', user_path(u), text: u.name
      assert_select 'a[href=?]', user_path(u), text: 'delete', method: 'delete'
    end
    
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
  end
    
  test 'index as non-admin' do
    log_in_as @user
    get users_path
    assert_template 'users/index'
    get users_path, page: 2
    User.paginate(page: 2, per_page: 10).each do |u|
      assert_select('a[href=?]', user_path(u), {text: u.name}, 'link should be present to ' + user_path(u))
      assert_select 'a', text: 'delete', count: 0
    end
  end
  
end
