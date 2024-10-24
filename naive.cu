#include <stdio.h>
#include <stdlib.h>
#include <iostream>

#define SIZE 128
#include <sys/time.h>

__global__ void scan(int* input, int* output){

  int gindex = threadIdx.x + blockIdx.x * blockDim.x;
 // int lindex = threadIdx.x;

  // accounting for thread size being less than array size  
  if (gindex >= SIZE){
  	return;
  }

  // do the scan
  for (int i = SIZE;  i < SIZE; i++) {
   int value = 0;
   for (int j = 0; j <= i; j++) {
     value += input[j];
   }
    output[i] = value;
  }	

 
  __syncthreads();
}



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
//int* times;

int main(void) {
  // int N = 100;
  // int i;
  // int *input, *output
  
  double t0 = get_clock();

  /*
 // allocate memory
	cudaMallocManaged(&input, N*sizeof(int));
    cudaMallocManaged(&output, N*sizeof(int));
 */
 
  // allocate memory
  int* input = (int*) malloc(sizeof(int) * SIZE);
  int* output = (int*) malloc(sizeof(int) * SIZE);

  
  // initialize inputs
   for (int i = 0; i < SIZE; i++) {
    input[i] = 1;
   }
	
  // run the kernel
  scan<<<1, 128>>>(input, output); 

  // synchronize 
  cudaDeviceSynchronize();

  double t1 = get_clock();
  printf("time per call: %f ns\n", t1-t0);

   // check results
  for (int i = 0; i < SIZE; i++) {
    printf("%d ", output[i]);
  }
  printf("\n");

  // free mem
  cudaFree(input);
  cudaFree(output);

  return 0;
}
