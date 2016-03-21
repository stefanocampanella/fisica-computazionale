#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define L 200

int main (int argc, char * argv[]) {

  int i, j, k; //, L;
  double M = 0;

//  L = atoi(argv[1]);

  for (i = 1; i < L; i++) {
    for (j = 1; j < L; j++) {
      for (k = 1; k < L; k++) {
        if ((i+j+k)%2 == 0) {
          M += 1/sqrt(pow(i,2)+pow(j,2)+pow(k,2));
        }
        else {
          M -= 1/sqrt(pow(i,2)+pow(j,2)+pow(k,2));
        }
      }
    }
  }

  M = 8*M-6*log(2);

  printf("The Madelung constant for NaCl is %.10f\n", M);

  return EXIT_SUCCESS;
}
