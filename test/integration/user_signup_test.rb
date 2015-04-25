require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'users/new'
  end

  test "valid signup information" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count' do
      post_via_redirect users_path, user: { name:  "Nnn Fff",
                               email: "user@valid.mail",
                               password:              "foobar",
                               password_confirmation: "foobar" }
    end
    assert_template 'users/show'
  end
  
  test 'error messages' do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_select '#error_explanation'
    assert_select '.alert-danger'
    assert_select '#error_explanation > ul > li:nth-child(2)', 'Email is invalid'
  end
  
  test "successful signup flash" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count' do
      post_via_redirect users_path, user: { name:  "Nnn Fff",
                               email: "user@valid.mail",
                               password:              "foobar",
                               password_confirmation: "foobar" }
    end
    assert_template 'users/show'
    assert_not flash.empty?
    assert_select 'div.alert-success'
    assert_select 'div.alert-success', 1
  end
end
