//Christian Douglas
#include <stdio.h>

const int arrSize = 4096;
const int blockSize = 1024;

__global__
void arrayProduct()
{
    

    

}

int main()
{
    const THREADSIZE = 1023;
    int A[arrSize], B[arrSize], C[arrSize];
    
    for(int i = 0; i < arrSize; i++)
    {
        A[i] = i;
        B[i] = (arrSize-1)+i;
    }

    for(int i = 0; i< 4; i++)
    {
        cudaMalloc((void**)&a_d, blockSize);
        cudaMalloc((void**)&b_d, blockSize);
        cudaMalloc((void**)&c_d, blockSize);

        cudaMemcpy(a_d, A, THREADSIZE, cudaMemcpyHostToDevice);
        cudaMemcpy(b_d, B, THREADSIZE, cudaMemcpyHostToDevice);
        cudaMemcpy(c_d, C, THREADSIZE, cudaMemcpyHostToDevice);
    }
    // printf("%d", A[0]);
    // printf("%c", ' ');
    // printf("%d", A[arrSize-1]);
    // printf("%c", '\n');
    // printf("%d", B[0]);
    // printf("%c", ' ');
    // printf("%d", B[arrSize-1]);

    return 0;
}