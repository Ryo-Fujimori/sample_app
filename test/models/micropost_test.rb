require "test_helper"

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    # fixtureのユーザーと紐づけてマイクロポストを作成
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    #マイクロポストが有効かチェック
    assert @micropost.valid?
  end

  test "user id should be present" do
    #user_idの存在性のバリデーションに対するテスト
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    #contentの存在性の検証
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    #micropostの文字数の検証 140文字以内
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    #表示順序のテスト
    assert_equal microposts(:most_recent), Micropost.first
  end
end
