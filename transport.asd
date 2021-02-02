(defsystem "transport"
  :version "0.0.0"
  :author "lizqwer scott"
  :license "GPL"
  :description "transport the file"
  :depends-on ("uiop"
               ;;threads
               "bordeaux-threads"
               ;;json
               "cl-json"
               "flexi-streams"
               ;;web
               "usocket"
               "usocket-server"
               ;;id
               "uuid"
               ;;events
               )
  :components ((:file "package")
               (:file "head" :depends-on ("package"))
               (:file "webhead" :depends-on ("head"))
               (:module "server"
                        :depends-on ("package" "head" "webhead")
                        :serial t
                        :components ((:file "server")))
               (:module "client"
                        :depends-on ("package" "head" "webhead")
                        :serial t
                        :components ((:file "client")))
               (:file "main" :depends-on ("package" "head" "webhead" "server" "client"))))
