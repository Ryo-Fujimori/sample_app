class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      # 1: セッションidをリセット
      # 2: sessionヘルパーのログインメソッドを起動
      # 3: user画面に移動
      reset_session      # ログインの直前に必ずこれを書くこと
      #remember meチェックボックスにチェックを入れていたならrememberメソッド
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      log_in user
      # ローカル変数を渡しているが『redirect_to user_url(user)』と同じ処理
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    #logged_inがtrueの場合のみlog_outを呼び出す
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
