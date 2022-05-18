#include <math.h>
#include <stdio.h>


char msg[] = "RESULT\nCLIB: %lf\n";


int main(){
        float b = 0.5;
        float a = cos(b);
        printf(msg, a);
        return 0;
}
