#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

int main () {

	double sum;
	int j;
	int max = (int) 1e8;

	sum = 0;
	
	#pragma omp parallel for reduction(+:sum)
	for( j = 0; j < max; j++ ) {
		sum += sin(j*M_PI/max);
	}

	printf("%.10f\n",sum*M_PI/max);

	return EXIT_SUCCESS;

}
