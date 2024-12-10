module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # 現在ログイン中のユーザーを返す（いる場合）
  def current_user
    if session[:user_id]
      #インスタンス変数がnilならfind_byメソッドでユーザーを代入する
      @current_user ||= User.find_by(id: session[:user_id])
      # 下のコードと同値
      #@current_user = @current_user || User.find_by(id: session[:user_id])
        # or 左側または右側のどちらかがtrueだったらtrueを返す
        # コンピュータの原則として、左から順に処理をしていく
        # ||の左側がtrueだったら右側は実行しない(if => false)
        # ||の左側がfalse/nilだったら右側を実行する（if => true）
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

    # 現在のユーザーをログアウトする
  def log_out
    reset_session
    @current_user = nil   # 安全のため
  end
end
