
#include <stdio.h>
#include "local_testlib.h"

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
    local_void_int( abc );
    local_int_float( 1.2f );

    return abc + 1;
}

