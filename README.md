# PHP Split INI
An AWK script that splits a php.ini file into multiple subsection files.

## Usage
__Split php.ini by subsection into the config.d directory__  
phpsplitini.awk -v target=config.d  php.ini

__Split subsection file by comment heading__  
phpsplitini.awk -m mod\_php.ini

### Script Flags
- \-v target=config.d ; result directory for split subsection config files
- \-m ; split a subsection file by comment headings

## phpini.bash
pulls a copy of php.ini-production and php.ini-development from the [PHP Source Repository](https://github.com/php/php-src/).
