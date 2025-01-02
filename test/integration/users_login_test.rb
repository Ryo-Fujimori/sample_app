require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
# 　fixtureからテスト用のユーザーを取得
  def setup
    @user = users(:michael)
  end

# 1 リダイレクト先が存在するかチェック
# 2 移動する
# 3 showテンプレートが表示されていることを確認
# 4 ログインしているのでログイン用のリンクが表示されていないことを確認
# 5 ログインしているのでログアウト用リンクが表示されていることを確認
# 6 ログインしているので
  test "login with valid information followed by logout" do
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_url
    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  # 1 ログイン用のパスを開く
  # 2 新しいセッションのフォームが正しく表示されたことを確認する
  # 3 わざと無効なparamsハッシュを使ってセッション用パスにPOSTする
  # 4 新しいセッションのフォームが正しいステータスを返し、再度表示されることを確認する
  # 5 フラッシュメッセージが表示されることを確認する
  # 6 別のページ（Homeページなど） にいったん移動する
  # 7 移動先のページでフラッシュメッセージが表示されていないことを確認する
  test "login with valid email/invalid password" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email, password: "invalid" } }
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "should still work after logout in second window" do
    delete logout_path
    assert_redirected_to root_url
  end
end
