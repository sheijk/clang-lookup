
#include <stdio.h>
#include "local_testlib.h"
#include "include/cl_test_lib.h"

void f_same_file(int i) {}

// A little test for clang-lookup
int foo(int abc)
{
    printf( "foobar baz\n" );

    // nested scopes, hiding names
    {
        int abc = 0;
        f_same_file( abc );
    }

    /* check if stuff in other headers is found */
    api_make_S( 1, 2, 3 );

    return abc + 1;
}

/*
 * Local variables:
 * clang-lookup-extra-args:("-I./api_dir")
 * End:
 */
