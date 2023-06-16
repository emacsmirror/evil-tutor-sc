;;; evil-tutor-sc.el --- Simplified Chinese Vimtutor adapted to Evil and wrapped in a major-mode

;; Copyright (C) 2023 clsty
;;
;; Author: clsty <ph-tyhu@outlook.com>
;; Keywords: convenience editing evil Chinese
;; Created: 14 June 2023
;; Version: 0.1
;; Package-Requires: ((evil "1.0.9") (evil-tutor "0.1"))
;; URL: https://github.com/clsty/evil-tutor-sc

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Vimtutor adapted for Evil.

;;     M-x evil-tutor-sc-start

;; This will create a working file in `evil-tutor-sc-working-directory' (defaults
;; to `~/.emacs.d/.tutor-sc')

;; Features:
;; - restore last working fil
;; - fast navigation between lessons with `C-j' and `C-k'

;;; Code:

(require 'evil)
(require 'evil-tutor)

(defcustom evil-tutor-sc-working-directory
  (file-name-as-directory (expand-file-name ".tutor-sc" user-emacs-directory))
  "The directory where to create working files."
  :type 'string
  :group 'evil)

(define-derived-mode evil-tutor-mode text-mode "evil-tutor"
  "Major mode for evil-tutor.")

;;;###autoload
(defun evil-tutor-sc-start ()
  "Start a evil-tutor-sc session."
  (interactive)
  (evil-tutor-sc-restore-or-create-working-file)
  (evil-tutor-mode)
  (evil-mode))

;;;###autoload
(defalias 'evil-tutor-sc-resume 'evil-tutor-sc-start)

;; (set-keymap-parent evil-tutor-mode-map text-mode-map)
;; (define-key evil-tutor-mode-map (kbd "C-j") 'evil-tutor-goto-next-lesson)
;; (define-key evil-tutor-mode-map (kbd "C-k") 'evil-tutor-goto-previous-lesson)

(defun evil-tutor-sc-restore-or-create-working-file ()
  "Create a new working buffer and save it in `evil-tutor-sc-working-directory'.

If a working file already exists in `evil-tutor-sc-working-directory' then the
found file is visited instead of creating a brand new buffer.

For now the point location is not saved but this is a functionality which can
be handled by minor modes."
  (let* ((files (if (file-exists-p evil-tutor-sc-working-directory)
                    (directory-files evil-tutor-sc-working-directory t nil t)))
         (previous-file (evil-tutor--find-first-working-file files)))
    (message "load: %s" (symbol-file 'evil-tutor-mode))
    (if previous-file
           (find-file previous-file)
      (let* ((date (format-time-string "%d%m%Y"))
             (working-file-name (format "evil-tutor-sc-%s.txt" date))
             (tutor-file (concat (file-name-directory (symbol-file
                                                       'evil-tutor-mode))
                                 "tutor-sc.txt")))
        (switch-to-buffer (get-buffer-create "working-file-name"))
        (set-visited-file-name (concat evil-tutor-sc-working-directory
                                       working-file-name))
           (insert-file-contents tutor-file)
        (make-directory evil-tutor-sc-working-directory 'parents)
        (save-buffer 0)))))

;; (defun evil-tutor--find-first-working-file (files)
;;   "Return the first saved working file or nil if there is no such file.

;; This function expects full path for each file in FILES."
;;   (when files
;;     (catch 'break
;;       (dolist (f files)
;;         (if (string= ".txt" (file-name-extension f 'period))
;;             (throw 'break f)))
;;       nil)))

;; (defun evil-tutor-goto-next-lesson (&optional arg)
;;   "Move the next lesson.

;; If ARG is nil then move to the next lesson,
;; If ARG is positive then move the ARGth version after the current one,
;; If ARG is negative then move the ARGth version before the current one."
;;   (interactive "p")
;;   (let ((i 0)
;;         (regexp "^~.*~$")
;;         (count (if arg (abs arg) 1))
;;         (recenter-positions '(top)))
;;     (dotimes (i count)
;;       (if (or (not arg)
;;               (> arg 0))
;;           (re-search-forward regexp (buffer-end 1) 'noerror)
;;         (re-search-backward regexp (buffer-end -1) 'noerror)))
;;     (beginning-of-line)
;;     (next-line)
;;     (recenter-top-bottom)))

;; (defun evil-tutor-goto-previous-lesson (&optional arg)
;;   "Move to the previous lession.

;; If ARG is nil then move to the previous lesson.
;; If ARG is positive then move to the ARGth lesson before the current one."
;;   (interactive "p")
;;   ;; -1 because we have to skip the current lesson
;;   (evil-tutor-goto-next-lesson (- (if arg (- (abs arg)) -1) 1)))

(provide 'evil-tutor-sc)

;;; evil-tutor-sc.el ends here
