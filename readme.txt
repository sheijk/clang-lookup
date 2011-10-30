
clang-lookup is a very simple CLI tool for navigation of C and C++ code bases
using the semantic analysis engine of the Clang compiler. Pass it a file, line
and column number on the command line and it will print warning/errors and a
line describing the location where the symbol at the given source location is
defined.

Building
========

To build you need to put a compiled version of LLVM 2.9 and Clang 2.9 into the
llvm directory. After configuring and building you should have the LLVM and
Clang binaries in llvm/Release/bin or llvm/Debug/bin.

Use "make" to create a release build of clang-extract and "make DEBUG=1" for a
debug build.

Usage
=====

Call clang_lookup like this: "./build/clang_lookup.sh file line column". It will
output a list of compiler diagnostics (warnings, errors). If the symbol at the
given location could be resolved it will print a line describing the location of
it's definition as it's last output. The format is as follows

location=file:line:column

for example

location=~/project/my_lib.h:20:6

If the symbol could not be resolved clang_lookup will print "location=" and
return a non-zero error code.

Todo
====

- add reasonable error handling
- add customizable function to setup clang arguments (include paths, etc.)
- pass compiler errors and warnings on to flymake
- support reading source from stdin

More info
=========

Send feedback, bug reports, patches etc. to the following super-obfuscated
mail address: jrehders *at* gmx *dot* net

https://github.com/sheijk/clang-lookup

http://llvm.org
http://clang.llvm.org

