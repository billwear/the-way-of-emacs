((org-mode
  . ((org-publish-project-alist
      . (("org-content"
          :base-directory "content"
          :base-extension "org"
          :publishing-directory "public"
          :recursive t
          :publishing-function org-html-publish-to-html
          :headline-levels 4
          :auto-preamble t
          :htmlized-source t)

         ("org-assets"
          :base-directory "assets"
          :base-extension "css\\|png\\|jpg\\|svg"
          :publishing-directory "public/assets"
          :recursive t
          :publishing-function org-publish-attachment)

         ("org-site" :components ("org-content" "org-assets")))))))
