//Christian Douglas
#include <stdio.h>

const int arrSize = 4096;          //max size desired for each array used
const int blockSize = 1024;        //largest number of threads in a block

__global__
void allocArrays(float *A, float *B, float *C)
{
    float *a_d, *b_d, *c_d;
    int size = arrSize * sizeof(float);

    //allocating pointers to size 4096
    cudaMalloc((void**)&a_d, size);
    cudaMalloc((void**)&b_d, size);
    cudaMalloc((void**)&c_d, size);

    //moves values from A, B to their respective pointers and moves the 
    //values to the gpu
    cudaMemcpy(a_d, A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(b_d, B, size, cudaMemcpyHostToDevice);

    //grid is set to 4 blocks and block is set to 1024 threads
    dim3 dimGrid(4, 1);
    dim3 dimBlock(blockSize, 1);

    //calls the function arraySum to add the values allocated in the pointers
    arraySum<<<dimGrid, dimBlock>>>(a_d, b_d, c_d, size);

    //the values from the c pointer are moved back to C array and moved back 
    //to the cpu
    cudaMemcpy(C, c_d, size, cudaMemcpyDeviceToHost);

    //deallocates the pointers to prevent memory leaks
    cudaFree(a_d);
    cudaFree(b_d);
    cudaFree(c_d);
}

//kernal function to get the value for each thread allocated to pointers
//a, b, and c and adds the values from a and b and assigns them to c
__device__
void arraySum(float *a, float *b, float *c, float size)
{ 
    int i = blockIdx.x * blockDim.x + threadIdx.x;

    if(i < size) c[i] = a[i] + b[i]; 
}

int main()
{
    float A[arrSize], B[arrSize], C[arrSize]; 
    
    //Initializes each element of A from 0 - 4095 
    //and B from 4095 to 8191
    for(int i = 0; i < arrSize; i++)
    {
        A[i] = i;
        B[i] = (arrSize-1)+i;
    }

    allocArrays(A, B, C);

    //Prints the first and last values of the C array
    //The values should be 4095 and 12186
    printf("%s", "Array C's first element: ");
    printf("%d", C[0]);
    printf("%c", '\n');
    printf("%s", "Last Element: ");
    printf("%d", C[arrSize-1]);
    printf("%c", '\n');

    return 0;
}