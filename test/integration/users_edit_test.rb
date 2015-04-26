require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  test 'unsuccessful edit' do
    log_in_as @user
    patch user_path(@user), user: {
      name: '',
      email: 'foo@invalid.com',
      password: 'foo',
      password_confirmation: 'bar'
    }
    assert_template 'users/edit'
  end
  
  test 'successful edit with friendly redirect' do
    get edit_user_path(@user)
    assert_redirected_to login_path
    log_in_as @user
    assert_redirected_to edit_user_path(@user)
    name = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@user), user: {
      name: name,
      email: email
    }
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
end