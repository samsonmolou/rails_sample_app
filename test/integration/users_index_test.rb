require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test "index including pagination and delete links" do
    create_session_for(@admin)
    get users_path
    assert_template "users/index"
    assert_select "nav.pagination"
    @pagy, first_page_of_users = pagy(User.all, page: 1)
    first_page_of_users.each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      assert_select "a[href=?]", user_path(user), text: "delete" unless user == @admin
    end
    assert_difference "User.count", -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    create_session_for(@non_admin)
    get users_path
    assert_select "a", text: "delete", count: 0
  end
end
