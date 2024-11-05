#include <stdio.h>
#include <stdlib.h>
#include <iostream>

#define SIZE 100
#define BLOCK_SIZE 128
#include <sys/time.h>

__global__ void scan(int* input, int* output){

  int gindex = threadIdx.x + blockIdx.x * blockDim.x;
 // int lindex = threadIdx.x;

  // accounting for thread size being less than array size  
  if (gindex >= SIZE){
  	return;
  }

  // do the scan
  for (int i = 0;  i < SIZE; i++) {
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
  int x; // Number of blocks to launch

  
  double t0 = get_clock();

  
 // allocate memory
	cudaMallocManaged(&input, SIZE*sizeof(int));
    cudaMallocManaged(&output, SIZE*sizeof(int));
  
  // initialize inputs
   for (int i = 0; i < SIZE; i++) {
    input[i] = 1;
   }
	
  // run the kernel
  // scan<<<1,128>>>(input, output); 
  
    // Check if SIZE is a multiple of BLOCK_SIZE
    if (SIZE % BLOCK_SIZE != 0) {
      // If not a perfect multiple, calculate the number of blocks needed
      if (SIZE > BLOCK_SIZE) {
        x = SIZE / BLOCK_SIZE + 1; // Add 1 if not perfectly divisible
        printf("Number of blocks (with extra): %d\n", x);
      }
    } else {
      x = SIZE / BLOCK_SIZE; // Perfectly divisible case
      printf("Number of blocks (perfectly divisible): %d\n", x);
    }
  // Launch the kernel with the calculated number of blocks
    scan<<<x, BLOCK_SIZE>>>(input, output);

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
