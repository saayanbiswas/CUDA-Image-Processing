#include "Smoothen.h"

__global__ void Smoothen(uchar4* image, size_t height, size_t width) {
	int x = blockIdx.x * blockDim.x + threadIdx.x;
	int y = blockIdx.y * blockDim.y + threadIdx.y;
	if (x < height && y < width) {
		int idx = x * width + y;
		unsigned char val = 0.299 * image[idx].x + 0.587 * image[idx].y + 0.114 * image[idx].z;
		image[idx].x = val;
		image[idx].y = val;
		image[idx].z = val;
	}
}

void executeSmoothen(uchar4* image, size_t height, size_t width) {

	uchar4* d_image;
	cudaMalloc(&d_image, height * width * sizeof(uchar4));
	cudaMemcpy(d_image, image, height * width * sizeof(uchar4), cudaMemcpyHostToDevice);
	Smoothen <<<dim3(1 + ((height - 1) / 32), 1 + ((width - 1) / 32), 1), dim3(32, 32, 1) >>> (d_image, height, width);
	cudaMemcpy(image, d_image, height * width * sizeof(uchar4), cudaMemcpyDeviceToHost);

}