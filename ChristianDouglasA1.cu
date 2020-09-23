//Christian Douglas
#include <stdio.h>

const int arrSize = 4096;
const int blockSize = 1024;

__global__
void arrayProduct(int *a, int *b, int *c)
{
    
    c[threadIdx.x] = a[threadIdx.x] * b[threadIdx.x]; 
    

}

int main()
{
    int A[arrSize], B[arrSize], C[arrSize];
    dim3 dimGrid(3, 1);
    dim3 dimBlock(blockSize, 1);

    for(int i = 0; i < arrSize; i++)
    {
        A[i] = i;
        B[i] = (arrSize-1)+i;
    }

    for(int i = 0; i< arrSize; i*blockSize)
    {
        cudaMalloc((void**)&a_d, blockSize);
        cudaMalloc((void**)&b_d, blockSize);
        cudaMalloc((void**)&c_d, blockSize);

        cudaMemcpy(a_d, A, blockSize, cudaMemcpyHostToDevice);
        cudaMemcpy(b_d, B, blockSize, cudaMemcpyHostToDevice);
        cudaMemcpy(c_d, C, blockSize, cudaMemcpyHostToDevice);
        arrayProduct<<<dimGrid, dimBlock>>>(a_d, b_d, c_d);

        cudaMemcpy(C, c_d, blockSize, cudaMemcpyDeviceToHost);
        cudaFree(a_d);
        cudaFree(b_d);
        cudaFree(c_d);
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