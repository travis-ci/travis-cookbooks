;; https://github.com/technomancy/leiningen/issues/747#issuecomment-8024136
(swap! leiningen.core.project/default-profiles
       update-in [:base] assoc :repositories
       [["clojars" {:url "https://clojars.org/repo/"}]])
