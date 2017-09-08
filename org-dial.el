;;; -*- lexical-binding: t; -*-

;;; org-dial.el --- Provide org links to dial with the softphone
;;; application linphone

;; Copyright (C) 2011-2014  Michael Strey

;; Author: Michael Strey <mstrey@strey.biz>
;; Keywords: dial, phone, softphone, contacts, hypermedia

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

;; `org-dial.el' defines the new link type `tel' for telephone
;; numbers in contacts (refer to org-contacts).  Calling this link type
;; leads to the execution of a linphone command dialing this number.
;;

(require 'org)

;;; Code:

(org-add-link-type "tel" 'org-dial)

(defgroup org-dial nil
  "Options about softphone support."
  :group 'org)

;; Replace "linphonecsh dial " with "Skype.exe /callto:" to make this work with Skype on Microsoft Windows
(defcustom org-dial-program "linphonecsh dial "
  "Name of the softphone executable used to dial a phone number in a `tel:' link."
  :type '(string)
  :group 'org-dial)

(defcustom org-dial-phone-key "\\(Phone.*Value\\)"
  "Regular expression for the key of a property containing a phone number.

The default is following the Google Contacts scheme of key naming, where we have
for instance:

:Phone 1 - Type: Work
:Phone 1 - Value: +49 1234 5678
:Phone 2 - Type: Home
:Phone 2 - Value: +49 56781234

Another common scheme

:MOBILE:   0043/664/123456789
:HOMEPHONE: 0043/664/123456789
:WORKPHONE: 0043/664/123456789
:PHONE: 0043/664/123456789

would be matched by the expression

':\\(MOBILE\\|.*PHONE\\):'"
  :type '(string)
  :group 'org-dial)

(defun org-dial (phone-number)
  "Dial the phone number.  The variable PHONE-NUMBER should contain only numbers,
whitespaces, backslash, parenthesis and maybe a `+' at the beginning."
  (shell-command
   (concat org-dial-program (org-dial-trim-phone-number phone-number))))

(defun org-dial-trim-phone-number (phone-number)
  "Sanitize PHONE-NUMBER by removing whitespaces, slashes, hyphens and parentheses."
  (mapconcat 'identity
             (split-string
              (mapconcat 'identity
                         (split-string phone-number "(0)") "") "[()/ -]") ""))

(defun org-dial-from-property (&optional prop)
  "Dial a property value with ORG-DIAL.  PROP is the appropriate property key.
If point is within the property line containing the phone number or PROP is
explicitly given, the function will dial immediately.
Otherwise it will ask for a property to use."
  (interactive)
  (let* ((props (org-entry-properties))
         (prop (or prop
                   (when (org-at-property-p)
                     (org-match-string-no-properties 2))
                   (org-completing-read
                    "Get property: "
                    props t)))
         (val (org-entry-get-with-inheritance prop)))
    (if val
        (org-dial val)
      (message "No valid value for %s" prop))))

(provide 'org-dial)

;;; org-dial.el ends here
