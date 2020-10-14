//Christian Douglas
#include <stdio.h>

const int N = 10240;
const int numThread = 1024;

__global__
void arrProduct(int* a, int* b, int* c)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;

    c[i] = (a[i]*(i<N))*(b[i]*(i<N));

}

int main()
{
    int A[N], B[N], C[N];
    int *a_d, *b_d, *c_d;
    int index = 0, twoblock = 2, tenblock = 10;
    while(index != 2)
    {
        for(int i = 0; i < N; i++)
        {
            A[i] = 2 * i;
            B[i] = (2*i)+1;
        }

        cudaMalloc((void**)&a_d, N);
        cudaMalloc((void**)&b_d, N);
        cudaMalloc((void**)&c_d, N);
        cudaMemcpy(a_d, A, N, cudaMemcpyHostToDevice);
        cudaMemcpy(b_d, B, N, cudaMemcpyHostToDevice);
        cudaMemcpy(c_d, C, N, cudaMemcpyHostToDevice);

        if(index != 2) {dim3 dimGrid(twoblock, 1);}
        else {dim3 dimGrid(tenblock,1);}

        dim3 dimBlock(numThread,1);

        arrProduct<<<dimGrid, dimBlock>>>(a_d, b_d, c_d);

        cudaMemcpy(C, c_d, N, cudaMemcpyDeviceToHost);

        cudaFree(a_d);
        cudaFree(b_d);
        cudaFree(c_d);
        
        if(index != 2) { printf("%d", twoblock);}
        else { printf("%d", tenblock);}
        printf("%s Blocks (C[0], C[");
        printf("%d",N);
        printf("%s] = (");
        printf("%d", C[0]);
        printf("%s, ");
        printf("%d", C[N-1]);
        printf("%s)\n");


        index++;
    }
    return 0;
}