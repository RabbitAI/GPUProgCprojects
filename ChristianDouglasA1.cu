//Christian Douglas
#include <stdio.h>

const int arrSize = 4096;
const int blockSize = 1024;

__global__
void arraySum(int *a, int *b, int *c)
{
    i = blockIdx.x*dimBlock.x+threadIdx.x;

    c[i] = a[i] + b[i]; 
}

int main()
{
    int A[arrSize], B[arrSize], C[arrSize];
    int *a_d, *b_d, *c_d;
    dim3 dimGrid(4, 1);
    dim3 dimBlock(blockSize, 1);

    for(int i = 0; i < arrSize; i++)
    {
        A[i] = i;
        B[i] = (arrSize-1)+i;
    }


    cudaMalloc((void**)&a_d, arrSize);
    cudaMalloc((void**)&b_d, arrSize);
    cudaMalloc((void**)&c_d, arrSize);

    cudaMemcpy(a_d, A, arrSize, cudaMemcpyHostToDevice);
    cudaMemcpy(b_d, B, arrSize, cudaMemcpyHostToDevice);
    cudaMemcpy(c_d, C, arrSize, cudaMemcpyHostToDevice);
    arraySum<<<dimGrid, dimBlock>>>(a_d, b_d, c_d);

    cudaMemcpy(C, c_d, arrSize, cudaMemcpyDeviceToHost);

    cudaFree(a_d);
    cudaFree(b_d);
    cudaFree(c_d);
    

    printf("%s", "Array C's first element: ");
    printf("%d", C[0]);
    printf("%c", '\n');
    printf("%s", "Last Element: ");
    printf("%d", C[arrSize-1]);
    

    return 0;
}