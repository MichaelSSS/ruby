require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'M G', email: 'mgrov@yandex.ru',
    password: 'foobar', password_confirmation: 'foobar')
  end
  
  test 'validation' do
    assert @user.valid?
  end
  
  test 'name should be present' do
    @user.name = '    '
    assert_not @user.valid?
  end
  
  test 'email should be present' do
    @user.email = ' '
    assert_not @user.valid?
  end
  
  test 'name should not be too long' do
    @user.name = 'a'*51
    assert_not @user.valid?
  end
  
  test 'email should not be too long' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test 'email addresses should be unique' do
    dupl = @user.dup
    dupl.email = dupl.email.upcase
    dupl.save
    assert_not @user.valid?
  end
  
  test 'password should not be too short' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end
  
  test 'email downcase' do
    mixed_case_email = 'UuU@gGg.cOM'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
end
