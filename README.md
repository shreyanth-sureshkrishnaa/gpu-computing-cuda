# GPU Computing

CPU vs. GPU performance benchmarks for parallel computing patterns using C++ and CUDA.

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/1_8UBNYvN97R-UvYkrrM5SjjQkFt-qrb9?usp=sharing)

## Project Structure

```text
gpu-computing/
├── src/
│   ├── cpu/
│   │   └── vector_add.cpp     # Single-threaded CPU 
│   └── gpu/
│       └── vector_add.cu      # CUDA kernel implementation
```

## Prerequisites

- GCC / G++ (C++17 recommended)
- NVIDIA CUDA Toolkit (`nvcc`)
- NVIDIA GPU with compatible compute capability

**If you do not have a CUDA-compatible GPU, you can run it on a T4 GPU on Colab. Link above.**

## Build and Run

### CPU Implementation

```bash
g++ -O3 src/cpu/vector_add.cpp -o vector_add_cpu
./vector_add_cpu
```

### GPU Implementation (CUDA)

```bash
nvcc -O3 src/gpu/vector_add.cu -o vector_add_gpu
./vector_add_gpu
```
