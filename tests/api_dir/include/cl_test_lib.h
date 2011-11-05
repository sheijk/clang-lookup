#ifndef CL_TEST_LIB_H_2011_10_31_INCLUDED
#define CL_TEST_LIB_H_2011_10_31_INCLUDED

void api_void( void );
int api_int_int( int arg0 );

enum api_Enum
{
    api_A, api_B, api_C
};

struct api_Struct
{
    int field_a, field_b;
    enum api_Enum field_e;
};

struct api_Struct api_make_S( int a, int b, enum api_Enum e );

#endif
// end of CL_TEST_LIB_H_2011_10_31_INCLUDED
