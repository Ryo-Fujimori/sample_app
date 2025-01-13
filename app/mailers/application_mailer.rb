class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  # メーラー用のレイアウト
  layout 'mailer'
end
