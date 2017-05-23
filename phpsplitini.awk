#!/usr/bin/awk -f
#
# name: splitini_php
# description: An AWK script splits a PHP.ini file into smaller components.
# Maintainer: Kevin Williams <llslim@gmail.com>
#
@load "filefuncs"

BEGIN {
    USR_W=000200;
    default_dir="conf.d";

    # set the target directory(tdir) with either the default directory or
    # the directory (target) specified on the command line with -v.
    if (target == "" || target==default_dir)  tdir=default_dir;
    else tdir=target;

    # retrieve the file syatem information for the target directory.
    rc=stat(tdir,fstat);
    err=ERRNO;

    # if the target directory doesn't exsist.
    if(rc < 0) {
        # create the default directory
        if(tdir==default_dir) {
            if(rc2=(("mkdir " tdir) | getline) == 0) stat(tdir,fstat);
        } else {
            printf("error reading %s; %d %s\n", tdir, rc, err);
            exit -1;
        }
    }

    # if the target directory is a symlink, then stat the value of the symlink.
    if(fstat["type"] == "symlink") stat(fstat["linkval"],fstat);

    if ((fstat["type"] != "directory") || (and(fstat["mode"],USR_W) <= 0)) {
        printf("the file: %s with type %s and permissions %o is not writable. %o\n", tdir, fstat["type"], fstat["mode"], and(fstat["mode"],USR_W));
        exit -1;
    }


    for (i = 1; i < ARGC; i++) {
        if (ARGV[i] == "-m") {
           mode=1;
           print "spliting up a PHP config subsection"
       } else if (ARGV[i] ~ /^-./) {
            e = sprintf("%s: unrecognized option -- %c",
            ARGV[0], substr(ARGV[i], 2, 1))
            print e > "/dev/stderr"
        }
        else break;
        delete ARGV[i]
    }
}

# awk main that applies to every record aka $0
{
  if (mode && $0 ~ /;{2,}/) {
  # mode 1: create files based on comment headings within sections (i.e. mod_php.ini)
    # create comment title.
    comment = $0;
    getline;
    comment = comment"\n"$0"\n"comment;

    # convert proper PHP heading text
    sub(/^;[[:space:]]*/,"PHP_");
    gsub(/[;.[:space:]]/,"");

    # set heading text as filename
    filename = tolower($0)".ini";

    # Add required heading brackets and comment title.
    sub(/^/,"[");
    sub(/$/,"]");
    heading=$0"\n"comment"\n";

    getline; # account for bottom of comment title.

    #set line to new text
    $0 = heading;

  } else if (mode < 1 && $0 ~ /^[[:space:]]*\[.*\][[:space:]]*$/ && $0 !~ /^[[:space:]]*\[HOST\=.*|PATH\=.*/) {
  # default mode creating files based on section headings in php.ini, and
  # bypassing special [HOST= ] and [PATH= ] headings

    # create filename for php module from section heading
    filename=$0;
    gsub(/^\[|\]$/,"",filename);
    gsub(/[[:space:]]/,"_",filename);
    filename ="mod_"tolower(filename)".ini";
  }

  # redirect the output to the file with the 'filename'.

    if ( filename != "" ) {
      fn2 = (tdir "/" filename)
      print > fn2
    }
}
