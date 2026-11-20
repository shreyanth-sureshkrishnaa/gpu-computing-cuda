#include <iostream>
#include <vector>
#include <cuda_runtime.h>
#include <chrono>

// GPU Kernel

__global__ void vector_add(const float* A, const float* B, float* C, int N){

    // Find an independent ID for each thread, so it can do one element. 
    int i = blockIdx.x * blockDim.x + threadIdx.x;

    // Make sure that it doesn't go out of bounds. 
    if (i < N){
        C[i] = A[i] + B[i];
    }
}

int main(){
    const int N = 1000000;
    const size_t bytes = N * sizeof(float);

    // CPU Memory Allocation

    std::vector<float> A(N, 2.0f);
    std::vector<float> B(N, 3.0f);
    std::vector<float> C(N, 0.0f);

    // GPU Memory Pointers:
    float *d_A, *d_B, *d_C;

    auto cpu_start = std::chrono::high_resolution_clock::now();

    // Allocate memory on the GPU:
    cudaMalloc(&d_A, bytes);
    cudaMalloc(&d_B, bytes);
    cudaMalloc(&d_C, bytes);

    // Copy input data from CPU -> GPU: 
    cudaMemcpy(d_A, A.data(), bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B.data(), bytes, cudaMemcpyHostToDevice);

    int threads_per_block = 256;

    // Ceiling division, so that some parts don't get dropped off. 
    int num_blocks = (N + threads_per_block - 1) / threads_per_block;

    // CUDA Events for timing:
    cudaEvent_t gpu_start, gpu_stop;

    cudaEventCreate(&gpu_start);
    cudaEventCreate(&gpu_stop);

    // Record starting event:
    cudaEventRecord(gpu_start);

    // Launch the kernel: 
    vector_add<<<num_blocks, threads_per_block>>>(d_A, d_B, d_C, N);

    // Record stopping event
    cudaEventRecord(gpu_stop);

    // Wait for GPU execution
    cudaEventSynchronize(gpu_stop);

    // Calculate GPU kernel execution time
    float gpu_time_ms = 0.0f;

    cudaEventElapsedTime(
        &gpu_time_ms, gpu_start, gpu_stop
    );
    
    // Wait for GPU computation: 
    cudaDeviceSynchronize();

    // Copy result from GPU -> CPU:
    cudaMemcpy(C.data(), d_C, bytes, cudaMemcpyDeviceToHost);

    auto cpu_end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> duration = cpu_end - cpu_start;

    // Display results:
    std::cout << "Vector size: " << N << '\n';
    std::cout << "C[0]: " << C[0] << '\n';
    std::cout << "C[1]: " << C[1] << '\n';
    std::cout << "C[N-1]: " << C[N-1] << '\n';
    std::cout << "Application execution time: " << duration.count() << " ms\n";
    std::cout << "GPU kernel time: "<< gpu_time_ms << " ms\n";


    // Destroy the CUDA Events:
    cudaEventDestroy(gpu_start);
    cudaEventDestroy(gpu_stop);
    
    // Release GPU memory:
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    return 0;

}