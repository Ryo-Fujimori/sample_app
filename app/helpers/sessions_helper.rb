module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # 永続的セッションのためにユーザーをデータベースに記憶する
  # 1. トークンを作成、DBにトークンに紐づくダイジェストを保存する
  # 2. ブラウザに暗号化されたユーザーIDをキーとしてユーザーIDを保存
  # 3. ブラウザにトークンを保存
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 現在ログイン中のユーザーを返す（いる場合）
  def current_user
    if session[:user_id]
      #ここのifでは比較ではなく比較ではなく「（ユーザーIDにユーザーIDのセッションを代入した結果）
      #ユーザーIDのセッションが存在すれば」となっている
      if (user_id = session[:user_id]) 
        @current_user ||= User.find_by(id: user_id)
      elsif (user_id = cookies.encrypted[:user_id])
        user = User.find_by(id: user_id)
        if user && user.authenticated?(cookies[:remember_token])
          log_in user
          @current_user = user
        end
      end      
      # @current_user ||= User.find_by(id: user_id)　下のコードと同値
      #@current_user = @current_user || User.find_by(id: session[:user_id])
        # or 左側または右側のどちらかがtrueだったらtrueを返す
        # コンピュータの原則として、左から順に処理をしていく
        # ||の左側がtrueだったら右側は実行しない(if => false)
        # ||の左側がfalse/nilだったら右側を実行する（if => true）
        # 
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

    # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil   # 安全のため
  end
end
