;;; adjust-parens-tests.el --- Tests of adjust-parens package

;; Copyright (C) 2013  Free Software Foundation, Inc.

;; Author: Barry O'Reilly <gundaetiapo@gmail.com>

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

;;; Code:

(require 'ert)
(require 'adjust-parens)

(defun apt-check-buffer (text-before-point text-after-point)
  (should (string= text-before-point
                   (buffer-substring-no-properties (point-min)
                                                   (point))))
  (should (string= text-after-point
                   (buffer-substring-no-properties (point)
                                                   (point-max)))))

(ert-deftest apt-near-bob-test ()
  (with-temp-buffer
    (emacs-lisp-mode)
    (insert "(foo)\n")
    (lisp-indent-adjust-parens)
    (apt-check-buffer "(foo\n " ")")))

(ert-deftest apt-indent-dedent-test ()
  (with-temp-buffer
    (emacs-lisp-mode)
    (setq indent-tabs-mode nil)
    (insert ";;\n"
            "(let ((x 10) (y (some-func 20))))\n"
            "; Comment")
    (beginning-of-line)
    (lisp-indent-adjust-parens)
    (apt-check-buffer (concat ";;\n"
                              "(let ((x 10) (y (some-func 20)))\n"
                              "  ")
                      "); Comment")
    (lisp-indent-adjust-parens 3)
    (apt-check-buffer (concat ";;\n"
                              "(let ((x 10) (y (some-func 20\n"
                              "                           ")
                      ")))); Comment")
    (lisp-dedent-adjust-parens 2)
    (apt-check-buffer (concat ";;\n"
                              "(let ((x 10) (y (some-func 20))\n"
                              "      ")
                      ")); Comment")))

;;; adjust-parens-tests.el ends here
