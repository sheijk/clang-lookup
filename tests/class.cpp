
class Base
{
public:
    Base( int x ) : m_member( x )
    {
    }

    void foo( int i ) {}

    virtual void virtual_method( ) {}

private:
    int m_member;
};

class Derived : public Base
{
public:
    Derived() : Base( 20 )
    {
        Base b(20);
    }

    virtual void virtual_method( )
    {
        Base::virtual_method( );
    }
};

int main()
{
    Derived d;
    d.foo( 1 );
    d.virtual_method( );
    
    return 0;
}

