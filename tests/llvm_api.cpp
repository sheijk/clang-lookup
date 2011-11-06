
#include "llvm/Support/IRBuilder.h"

int main()
{
    llvm::IRBuilder<> builder;

    &builder;

    return 0;
}

/*
 * Local variables:
 * clang-lookup-extra-args:("-I../llvm/include" "-DNDEBUG" "-D_GNU_SOURCE" "-D__STDC_LIMIT_MACROS" "-D__STDC_CONSTANT_MACROS")
 * ac-clang-flags:("-I../llvm/include")
 * End:
 *
 -I/Users/sheijk/Documents/Development/Stuff/ocaml/lang/git/tools/llvm-2.9/include
 -I/Users/sheijk/Documents/Development/Stuff/ocaml/lang/git/tools/llvm-2.9/tools/clang/include/
 -DNDEBUG -D_GNU_SOURCE -D__STDC_LIMIT_MACROS -D__STDC_CONSTANT_MACROS -O3
 -fno-exceptions -fno-rtti -fno-common -Woverloaded-virtual -Wcast-qual
 * 
 */

