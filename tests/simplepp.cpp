
void f_overloaded( int i );
void f_overloaded( float f );

void bar( int iarg, float farg )
{
    f_overloaded( iarg );
    f_overloaded( farg );
}


