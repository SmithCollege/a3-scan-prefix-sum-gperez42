FOR Single Threaded (Naive) CPU Approach (singleThread.c):

    Runtime Analysis:

    Our program has a runtime of O(n^2) on average. This is because while performing the scan, we have a nested for loop. In our outer loop, we go through the array N times. Then, in our inner for loop from 1 - N, we go through each element in the array N/2 times. N divided by the number of elements gives you order N. Therefore, when we multiply N and N/2, we get a runtime of O(n^2). 


    Data Scaling for Single Thread CPU:

    Array size of 100 - time per call: 0.000066 ns

    Array size of 128 - time per call: 0.000058 ns

    Array size of 500 - time per call: 0.000384 ns

    Arrazy size of 1000 - time per call: 0.001248 ns


FOR Naive Approach on GPU (naive.cu):

    Runtime Analysis:

    Our runtime from for the Naive approach on the GPU is O(n^2) since we have to iterate through our array size of n elements, and do this an n number of times.

    Data Scaling for Naive Approach GPU:

    Array size of 100 - time per call: time per call: 0.130725 ns

    Array size of 128 - time per call: 0.162019 ns

    Array size of 500 - time per call: 0.147097 ns

    Array size of 1000 - time per call: 0.147934 ns


FOR Recursive Doubling Approach (recursive_doubling.cu):

    Runtime Analysis:

    This program has a runtime of O(n log n). This is because we have n elements in an array and we have log(n) parallel iterations.

    Data Scaling:

    Array size of 100 - time per call: 0.129167 ns

    Array size of 128 - time per call: 0.122520 ns

    Array size of 500 - time per call: 0.127682 ns

    Array size of 1000 - time per call: 0.141814 ns

    Array size of 2048 - time per call: 0.127488 ns




