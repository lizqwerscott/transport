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
               )
  :components ((:file "package")
               (:file "head" :depends-on ("package"))
               (:module "server"
                        :depends-on ("package" "head")
                        :serial t
                        :components ((:file "server")))
               (:file "main" :depends-on ("package" "head" "server"))))
