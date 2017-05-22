# PHP Split INI
An AWK script that splits a php.ini file into multiple subsection files.

## Usage
phpsplitini.awk -v target=config.d -m php.ini

- \-v target=config.d ; result directory for split subsection config files
- \-m ; split a subsection file by comment headings

## Comment Heading
A comment Heading look as follows:

;;;;;;;;;;;;;;;;;;;
; Comment Heading ;
;;;;;;;;;;;;;;;;;;;


