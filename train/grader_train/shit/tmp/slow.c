# include <stdio.h>
# define N 285000000
# define M 4900000

//int data[M];

int f(int a) {
    if ( a==0 ) return 0;
    if ( a%1000==0 )
        printf("%d\n",a);
    f(a-1);
}

int main() {
    printf("HI\n");
    int a,b=0,i;
//    int *x = (int*)malloc(4*M);
//    a = a/b;
//    f(N);
//    freopen("boza.txt","w",stdout);
//rew;
    for ( i=0 ; i<N ;i++ ) {
		a = a+b;
		b = b+a;    
//		if ( i<M ) {
	//	    x[i] = a;
	  //  	data[i] = a;
//		}
//	if ( i<1*M )
//            printf("%d %d",a,b);
	
    }
    

    return 0;
}
