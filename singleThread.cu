#include <stdio.h>
#include <stdlib.h>

#define SIZE 128
#include <sys/time.h>

double get_clock() {
  struct timeval tv; 
  int ok;
  ok = gettimeofday(&tv, (void *) 0);
  if (ok<0) { 
  	printf("gettimeofday error"); 
  }
  return (tv.tv_sec * 1.0 + tv.tv_usec * 1.0E-6);
}

int N;
int* times;

int main() {
  int i;
  
  double t0 = get_clock();
  for (i=0; i<N; i++) {
  	times[i] = get_clock();
  }
  
  // allocate memory
  int* input = (int*) malloc(sizeof(int) * SIZE);
  int* output = (int*) malloc(sizeof(int) * SIZE);

  // initialize inputs
  for (int i = 0; i < SIZE; i++) {
    input[i] = 1;
   }

  // do the scan
  for (int i = 0; i < SIZE; i++) {
   int value = 0;
   for (int j = 0; j <= i; j++) {
     value += input[j];
   }
    output[i] = value;
  }

  // check results
  for (int i = 0; i < SIZE; i++) {
    printf("%d ", output[i]);
  }
  printf("\n");

  // synchronize 
  cudaDeviceSynchronize();

  double t1 = get_clock();
  printf("time per call: %f ns\n", t1-t0);

  // free mem
  free(input);
  free(output);

  return 0;
}
