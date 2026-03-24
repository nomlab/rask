# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "textcomplete" # @0.18.2
pin "eventemitter3" # @2.0.3
pin "textarea-caret" # @3.1.0
pin "undate/lib/update", to: "undate--lib--update.js" # @0.2.4
pin "tag_completion"
pin "documents", to: "documents.js"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
