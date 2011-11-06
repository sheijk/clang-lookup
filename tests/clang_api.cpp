
extern "C" {
#include "clang-c/Index.h"
}

int main()
{
    CXIndex index = clang_createIndex( 0, 0 );
    clang_disposeIndex( index );

    return 0;
}

/*
 * Local variables:
 * clang-lookup-extra-args:("-I../llvm/tools/clang/include")
 * ac-clang-flags:("-I../llvm/tools/clang/include")
 * End:
 */
