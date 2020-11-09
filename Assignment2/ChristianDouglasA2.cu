using <stdio.h>
using <math.h>

#define Pi 3.14159265

const int N = 8;

int Range = (N/2)-1;

__global__
void ctFFT(float **even_d, float **odd_d, float *real_d, float *imag_d)
{
       int n = threadIdx.x; 
       evenComplex(n, even_d, real_d, imag_d);
       oddComplex(n, odd_d, real_d, imag_d);
}

__device__
void evenComplex(int n; float **even_d, float *real_d, float *imag_d)
{
       real_d[n]= (2*n)*cos(((2*Pi)*(2*n))/N);
       imag[n]= -1*((2*n)*sin((((2*Pi)*(2*n))/N));
       even_d[n][0]= real_d[n];
       even_d[n][1]=imag_d[n];
}

__device__
void oddComplex(int n; float **odd_d, float *real_d, float *imag_d)
{
       real_d[n]= (2*n+1)*cos(((2*Pi)*(2*n+1))/N);
       imag[n]= -1*((2*n+1)*sin((((2*Pi)*(2*n+1))/N));
       odd_d[n][0]= real_d[n];
       odd_d[n][1]=imag_d[n];
}

int main()
{
  float even[Range][2], odd[Range][2], real[Range], imag[Range];
  float **even_d, **odd_d, *real_d, *imag_d;

  for(int i = 0; i < Range; i++)
  {
      even[i] = 2 * i;
      odd[i] = 2 * i + 1;
  }

  cudaMalloc((void**)even_d[Range], 2);
  cudaMalloc((void**)odd_d[Range], 2);
  cudaMalloc((void**)real_d, Range);
  cudaMalloc((void**)imag_d, Range);

  cudaMemcpy(even_d, even, Range, cudaMemcpyHostToDevice);
  cudaMemcpy(odd_d, odd, Range, cudaMemcpyHostToDevice);

  dim3 dimGrid(1,1);
  dim3 dimBlock(Range, Range);

  ctFFT<<<dimGrid, dimBlock>>>(even_d, odd_d, real, imag);

  return 0;
}