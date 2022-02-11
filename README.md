# org-dial
Softphone support for Emacs Org mode

`org-dial.el` defines the new link type `tel` for telephone
numbers in contacts (refer to org-contacts).  Calling this link type
leads to the execution of a Linphone command dialing this number.

## Installation ##

Put org-dial.el into a load path.

`(require 'org-dial)`

## Usage ##

Clicking on a phone link of the form:

`[[tel:+12 345 678-90]]` will call the the program defined in the
custom variable `org-dial-program`.  By default Linphone will be used.

`org-dial-from-property` with point on a headline will ask for a
property key with a telephone number to dial.  If point is on an
appropriate property, the phone number in this property will be dialed immediately.

The following forms of phone numbers are accepted:

* [[tel:(0351) 412 95-35]]
* [[tel:+49 351/412-95-35]]
* [[tel:+493514129535]]
* [[tel:+49-351-41295-35]]
* [[tel:+49 (0)351-41295-35]]

## References ##
Please refer to
http://lists.gnu.org/archive/html/emacs-orgmode/2013-03/msg02022.html
and http://comments.gmane.org/gmane.emacs.orgmode/98536 for
discussions about similar libraries.
