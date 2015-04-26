require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: { name:  "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'users/new'
  end

  test "valid signup information with acount activation" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count' do
      post users_path, user: { name:  "Nnn Fff",
                               email: "user@valid.mail",
                               password:              "foobar",
                               password_confirmation: "foobar" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    
    log_in_as user
    assert_not is_logged_in
    
    get edit_account_activation_path('invalid token')
    assert_not is_logged_in

    get edit_account_activation_path(user.activation_token, email: 'wrong email')
    assert_not is_logged_in
    
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    assert is_logged_in
    follow_redirect!    
    assert_template 'users/show'
  end
end
