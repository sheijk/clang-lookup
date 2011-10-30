
clang-lookup is a very simple CLI tool to resolve an identifier using
Clang. Pass it a file, line and column number on the command line and it will
print warning/errors and a line describing the location where the symbol at the
given source location is defined.

Building
========

To build you need to put a compiled version of LLVM 2.9 and Clang 2.9 into the
llvm directory. After configuring and building you should have the LLVM and
Clang binaries in llvm/Release/bin or llvm/Debug/bin.

Use "make" to create a release build of clang-extract and "make DEBUG=1" for a
debug build.

Usage
=====

Call clang_lookup like this: "./build/clang_lookup.sh file line column".

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

http://llvm.org
http://clang.llvm.org

