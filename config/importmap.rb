# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
# Importmapを使ってプロジェクトのカスタムJavaScriptコードがapp/javascript/customにあることをRailsに認識させる設定
pin_all_from "app/javascript/custom",      under: "custom"
