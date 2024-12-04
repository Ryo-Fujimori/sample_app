require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    # サインアップの画面にアクセスできるかテスト
    get signup_path
    # ユーザ数が変わらないかどうかを検証するテスト
    # assert_no_difference :ブロック実行前後でexpressionsの値が変わっていなければ成功
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end

    #422 Unprocessable Entity　ステータスコードを返しているかテスト
    assert_response :unprocessable_entity
    #/users/new.html.erbが描画されているかどうかを検証する
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end

      # 正しくユーザー登録、画面のリダイレクトが行われているかテスト
      test "valid signup information" do
        # ユーザー数が1だけ差があればOK
        assert_difference 'User.count', 1 do
          post users_path, params: { user: { name:  "Example User",
                                             email: "user@example.com",
                                             password:              "password",
                                             password_confirmation: "password" } }
        end
        # 途中で指定されたリダイレクト先に移動するメソッド
        follow_redirect!
        # 指定テンプレートが表示されているかテスト
        assert_template 'users/show'

        assert_not flash.empty?
      end
  
end
