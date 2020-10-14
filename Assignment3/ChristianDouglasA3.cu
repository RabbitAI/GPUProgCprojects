//**************************************************************
// Assignment ChristianDouglasA3
// Name: Chistian Douglas
// GPU Programming Date: 10/14/2020
//*******************************************************************
//Program finds the product of 2 arrays A and B, and assigns the 
//values to array C. Each value of array A is initialized by the
//equation 2*i and each value of Array B is initialized by the 
//equation 2*i+1. All 3 arrays are set to the size of 10240 
//elements by using the global constant N. The main function also
//contains 2 constant integers blockTwo, which is assigned the 
//value of 2 and blockTen, which is assigned the value of 10,
//these two constants are used to let the gpu know how many blocks
//to use. A integer variable called size is also in main and is 
//equal to the value of N * the size of the data type float and is 
//used when allocating space on the cpu for the pointers a_d, b_d,
//and c_d in the funtion allocArray using cudaMalloc. The pointers
//a_d, b_d, c_d point to float data types, after being allocated
//to the size of size, the values of arrays A and B are then copied
//to a_d and b_d using cudaMemcpy. dimGrid's number of blocks is 
//defined by the variable block and dimBlock's number of threads
//is set t0 1024, which is the max number of threads a block can 
//hold. The kernel of arrayProduct is then called, which then takes
//the total number of threads multiplied by the total number of 
//blocks added to the thread ID's and performs the multiplication 
//of the elements assigned to pointers a_d and b_d, assigning them
//to c_d's elements. The values in c_d are the copied to the elements
//of array C and the the memory allocated to the pointers of a_d,
//b_d, and c_d are freed using cudaFree. The function printVal prints
//the first and last value of array C. 
//*******************************************************************
#include <stdio.h>

const int N = 10240;            //number of elements in arrays

//*******************************************************************
//Method Name: allocArray
//Parameters: A, B, C, size, block
//Purpose: Allocates size of size to the local pointers a_d, b_d, and
//c_d and copies the values from the arrays A, B, and C using 
//cudaMemcyp. dimGrid size is defind by the integer block and 
//dimBlock is defined by the max number of threads, 1024, 
//arrayProduct is called, after c_d's values are copied to array C
//and the pointers are freed using cudaFree
//*******************************************************************
void allocArray(float *A, float *B, float *C, int size, int block)
{
    float *a_d, *b_d, *c_d;

    cudaMalloc((void**)a_d, size);
    cudaMalloc((void**)b_d, size);
    cudaMalloc((void**)c_d, size);

    cudaMemcpy(a_d, A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(b_d, B, size, cudaMemcpyHostToDevice);
    
    dim3 dimGrid(block, 1);
    dim3 dimBlock(1024, 1);

    arrayProduct<<<dimGrid, dimBlock>>>(a_d, b_d, c_d, size);

    cudaMemcpy(C, c_d, size, cudaMemcpyDeviceToHost);
    
    cudaFree(a_d);
    cudaFree(b_d);
    cudaFree(c_d);
}

//*******************************************************************
//Kernel Name: arrayProduct
//Parameters: a_d, b_d, c_d, size
//Purpose: Integer i is defined by the total number of threads
//multiplied by the total number of block added to the threadID 
//number. The pointers then use the value of i to access the values
//they contain and uses parallel programming to obtain all the 
//product values of pointers a_d and b_d and assigns them to c_d.
//*******************************************************************
__global__
void arrayProduct(float* a_d, float* b_d, float* c_d, int size)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    a_d[i] * b_d[i] = c_d[i];
}

//*******************************************************************
//Method Name: printVals
//Parameters: C
//Purpose: Prints the first and last elements of array C
//*******************************************************************
void printVals(float* C)
{
    printf("C[0] %s", C[0]);
    printf("%c",'\n');
    printf(" C[10239] %s", C[N-1]);
}

int main()
{
    const int TwoBlock = 2;               //used to define 2 blocks
    const int TenBlock = 10;              //used to define 10 blocks
    float A[N] = 0, B[N] = 0, C[N] = 0;   //float arrays inialized to 0
    int size = N * sizeof(float);

    for(int i = 0; i < N; i++)
    {
        A[i] = 2 * i;

        B[i] = 2 * i + 1;
    }

    allocArray(A, B, C, size, TwoBlock); //not cyclic 2 block
    printVals(C);
    for(int i = 0; i < N; i = (i + 1) * 2048) //cyclic 2 block
    {
        allocArray(&A[i], &B[i], &C[i], size/5, TwoBlock);
    }
    printVals(C);
    allocArray(A, B, C, size, TenBlock); //10 block
    printVals(C);

    return 0;
}