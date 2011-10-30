///
/// Simple CLI utility which will lookup the definition location of a symbol at
/// a given source location
///

extern "C" {
#include "clang-c/Index.h"
}

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define APP_NAME "clang_lookup"

int main( int argc, char* argv[] )
{
    if ( argc == 2 && strcmp( "--version", argv[0] ) != 0 )
    {
        printf( APP_NAME " version 0.1\n" );
        return 0;
    }
    else if( argc < 4 )
    {
        printf( "Expected " APP_NAME " file line column");
        return 1;
    }

    const char* file_name = argv[1];
    const int line = atoi( argv[2] );
    const int column = atoi( argv[3] );

    CXIndex index = clang_createIndex( 0, 0 );
    CXTranslationUnit tu = clang_parseTranslationUnit(
        index, file_name, argv+3, argc-3, 0, 0, CXTranslationUnit_None );

    bool had_errors = false;

    for ( unsigned i = 0, n = clang_getNumDiagnostics(tu); i != n; ++i )
    {    
        CXDiagnostic diag = clang_getDiagnostic( tu, i );
        CXString msg = clang_formatDiagnostic( diag,
            clang_defaultDiagnosticDisplayOptions() );
        fprintf(stderr, "%s\n", clang_getCString(msg) );
        clang_disposeString( msg );

        CXDiagnosticSeverity sev = clang_getDiagnosticSeverity( diag );
        had_errors |= sev >= CXDiagnostic_Error;

        // TODO: handle fixits?
        // clang_getDiagnosticNumFixIts, clang_getDiagnosticFixIt
    }

    CXString def_file_name_cx = { 0 };
    unsigned def_line = 0, def_column = 0, def_offset = 0;
    const char* def_file_name = 0;

    if ( ! had_errors )
    {
        CXFile file = clang_getFile( tu, file_name );
        CXSourceLocation lookup_loc = clang_getLocation( tu, file, line, column );
        CXCursor sym = clang_getCursor( tu, lookup_loc );
        CXCursor definition = clang_getCursorReferenced( sym );
        CXSourceLocation def_loc = clang_getCursorLocation( definition );

        CXFile def_file;
        clang_getSpellingLocation( def_loc, &def_file, &def_line, &def_column, &def_offset );
        def_file_name_cx = clang_getFileName( def_file );
        def_file_name = clang_getCString( def_file_name_cx );
    }

    if( def_file_name != 0 )
    {
        printf( "location=%s:%d:%d\n", def_file_name, def_line, def_column );
    }
    else
    {
        printf( "location=\n" );
    }

    clang_disposeString( def_file_name_cx );
    clang_disposeTranslationUnit( tu );
    clang_disposeIndex( index );

    return had_errors ? 1 : 0;
}

