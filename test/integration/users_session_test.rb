require "test_helper"

class UsersSessionTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "create session with valid email/invalid password" do
    get sessions_new_path
    assert_template "sessions/new"
    post sessions_create_path, params: { session: { email: @user.email, password: "invalid" } }
    assert_not logged_in?
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "create session with valid information followed by logout" do
    get sessions_new_path
    post sessions_create_path, params: { session: { email: @user.email, password: "password" } }
    assert logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", sessions_new_path, count: 0
    assert_select "a[href=?]", sessions_destroy_path
    assert_select "a[href=?]", user_path(@user)
    delete sessions_destroy_path
    assert_not logged_in?
    assert_redirected_to root_url
    # Simulate a user click logout in a second window
    delete sessions_destroy_path
    follow_redirect!
    assert_select "a[href=?]", sessions_new_path
    assert_select "a[href=?]", sessions_destroy_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    create_session_for(@user, remember_me: "1")
    assert_not_nil cookies["remember_token"]
  end

  test "login without remembering" do
    create_session_for(@user, remember_me: "1")
    create_session_for(@user, remember_me: "0")
    assert_empty cookies["remember_token"]
  end
end
