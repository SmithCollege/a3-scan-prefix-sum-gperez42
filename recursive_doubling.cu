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

  int* source;
  int* destination; 

  source = &input[0];
  destination = &output[0];
  int* temp;

  // j is my stride, threadIdx is gindex
  for (int j=1; j <= SIZE; j*=2) {
    __syncthreads();
    if (gindex < j){
     	destination[gindex] = source[gindex];
     }
     else{
	    destination[gindex] = source[gindex] + source[gindex-j];
		temp = destination;
		destination = source;
		source = temp;
	}
  }
  output[gindex] = source[gindex];
 
  //__syncthreads();
}



double get_clock() {
  struct timeval tv; 
  int ok = gettimeofday(&tv, (void *) 0);
  if (ok<0) { 
  	printf("gettimeofday error"); 
  }
  return (tv.tv_sec * 1.0 + tv.tv_usec * 1.0E-6);
}

int main(void) {
  // int N = 100;
  // Our SIZE is N (array size)
 
  int *input, *output;
  
  double t0 = get_clock();

  
 // allocate memory
	cudaMallocManaged(&input, SIZE*sizeof(int));
    cudaMallocManaged(&output, SIZE*sizeof(int));
  
  // initialize inputs
   for (int i = 0; i < SIZE; i++) {
    input[i] = 1;
   }
	
  // run the kernel
  scan<<<1,128>>>(input, output); 

  // synchronize 
  cudaDeviceSynchronize();

  double t1 = get_clock();
  printf("time per call: %f ns\n", t1-t0);

   // check results
  for (int i = 0; i < SIZE; i++) {
    printf("%d ", output[i]);
  }
  printf("\n");


  printf("%s\n", cudaGetErrorString(cudaGetLastError()));
	
  // free mem
  cudaFree(input);
  cudaFree(output);

  return 0;
}
