//
//  Find unit digits of number
//

#include <iostream>
#include <cmath>
#include <string>

using namespace std;

int UpperBoundary = 10;
int Num = 7;

int func ( int a, int b )
{
    return pow(a,b);
}

int main ()
{
    for ( int increment = 1; increment < UpperBoundary; increment++)
    {
        string str ( to_string( func( Num, increment ) ) );
        cout << str.back() << endl;
    }
    
}
