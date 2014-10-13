bashopts
========

Command line utilities for bash.

opts.sh
-------

Parse command line options in bash.

Simple starting point to parse commandline options to a bash script. Handles long and short style options.

To use, copy opts.sh to your application and modify to handle your own options.

Currently handles short and long options that may take values. Short options are single characters that are prefixed by a single hyphen. Short options may be concatenated together. If a short option expects a value, the value may be either appended to the option or separated with a space.

Long options are strings prefixed by double dashes. If a long option expects a value, the value may be appended with an equal sign or a space.

Examples:

```bash
$ # short flag -f takes no argument, -x takes an argument
$ # the following are the equivalent:
$ cmd -f -x value  # separated options, separated value
$ cmd -fx value    # concatenated options, separated value
$ cmd -f -xvalue    # separated options, concatenated value
$ cmd -fxvalue      # concatenated options, concatenated value

$ # long options: --flag takes no argument, --xopt takes an argument
$ cmd --flag --xopt=value # value is appended with =
$ cmd --flag --xopt value # value is separated with space
```

iterate.sh
----------

Emit the cross product, or every combination of some options.

Example:

```bash
$ iterate.sh myprogram -i '1 2' -x 'x y'
$ myprogram -i 1 -x x
$ myprogram -i 1 -x y
$ myprogram -i 2 -x x
$ myprogram -i 2 -x y
```

This is useful where the user may want to specify all combinations
easily in a single command, but where the actual command was written
to expect just one combination.

