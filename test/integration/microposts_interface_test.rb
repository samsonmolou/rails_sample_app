require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    create_session_for(@user)
    get root_path
    assert_select "nav.pagination"
    assert_select "input[type=file]"
    # Invalid submission
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select "div.field_with_errors"
    # assert_select "span a[href=?]", "microposts/?page=2" # Correct pagination link
    # Valid submission
    content = "This micropost really ties the room together"
    image = fixture_file_upload("test/fixtures/kitten.jpg", "image/jpeg")
    assert_difference "Micropost.count", 1 do
      post microposts_path, params: { micropost: { content: content, image: image } }
    end
    # assert micropost.image.attached?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete post
    assert_select "a", text: "delete"
    @pagy, first_page_of_microposts = pagy(@user.microposts, page: 1)
    first_micropost = first_page_of_microposts.first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(first_micropost)
    end
    # Visit different user (no delete links)
    get user_path(users(:archer))
    assert_select "a", text: "delete", count: 0
  end

  test "micropost sidebar count" do
    create_session_for(@user)
    get root_path
    assert_match @user.microposts.count.to_s, response.body
    # User with zero microposts
    other_user = users(:malory)
    create_session_for(other_user)
    get root_path
    assert_match "0", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match other_user.microposts.count.to_s, response.body
  end
end
