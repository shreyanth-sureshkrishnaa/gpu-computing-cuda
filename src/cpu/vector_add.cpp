#include <iostream>
#include <vector>
#include <chrono>

int main(){
    const int N = 1000000;

    // Allocating three arrays:
    std::vector<float> A(N, 2.0f);
    std::vector<float> B(N, 3.0f);
    std::vector<float> C(N, 0.0f);

    // Start timer:
    auto start = std::chrono::high_resolution_clock::now();
    
    for (int i = 0; i < N; i++){
        C[i] = A[i] + B[i];
    }

    auto end = std::chrono::high_resolution_clock::now();

    auto duration = std::chrono::duration<double, std::milli>(end - start).count();

    std::cout << "Vector Add (CPU)" << std::endl;
    std::cout << "Vector size: " << N << std::endl;
    std::cout << "Execution Time: " << duration << " ms" << std::endl;
}