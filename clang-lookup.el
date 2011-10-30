;;; clang-lookup.el --- Goto symbol definition using clang

;; Copyright 2011 Jan Rehders
;; 
;; Author: Jan Rehders <cmdkeen@gmx.de>
;; Version: 0.1
;;
;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:
;;
;; A simple minor mode to use clang to navigate to a symbol's definition
;; Add something like this to your .emacs:
;;
;; (autoload 'clang-goto-symbol-at-point "clang-lookup")
;; (define-key 'c++-mode-map (kbd "M-.") 'clang-goto-symbol-at-point)
;;
;; This is a very early version lacking reasonable error handling etc.
;;

(defcustom clang-lookup-ld-libclang-path
  ""
  "Path to libclang.so"
  :type 'string
  :group 'clang-lookup)

(defcustom clang-lookup-exe
  "clang_lookup.exe"
  "clang_lookup executable"
  :type 'string
  :group 'clang-lookup)

(defun clang-lookup ()
  (interactive)
  (let* ((file (buffer-file-name))
         (line (1+ (current-line)))
         (column (1+ (current-column)))
         (output (shell-command-to-string
                 (format "LD_LIBRARY_PATH=%s %s %s %s %s"
                         clang-lookup-ld-libclang-path
                         clang-lookup-exe
                         file line column))))
    (let ((sym-file nil)
          (sym-line nil)
          (sym-column nil)
          (lines (split-string output "\n")))
      (dolist (line lines)
        (let* ((tokens (split-string line "[=:]"))
               (hd (nth 0 tokens)))
          (when (equal "location" hd)
            (setq sym-file (nth 1 tokens))
            (setq sym-line (string-to-number (nth 2 tokens)))
            (setq sym-column (string-to-number (nth 3 tokens))))))
      (if (and sym-file sym-line sym-column)
          (list :file sym-file :line sym-line :column sym-column)
        (list :error "Symbol not found")))))

(defun clang-goto-symbol-at-point ()
  (interactive)
  (condition-case nil
      (destructuring-bind (:file file :line line :column column) (clang-lookup)
        (message "loc %s:%s:%s" file line column)
        (find-file file)
        (goto-line line)
        (beginning-of-line 1)
        (forward-char (- column 1))
        )
    (error "Symbol not found")))

(provide 'clang-lookup)


