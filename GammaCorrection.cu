#include "GammaCorrection.h"
#include<math.h>
__global__ void GammaCorrection(uchar4* image, size_t height, size_t width, float gc) {
	int x = blockIdx.x * blockDim.x + threadIdx.x;
	int y = blockIdx.y * blockDim.y + threadIdx.y;
	if (x < height && y < width) {
		int idx = x * width + y;

		float r, g, b;
		r=image[idx].x ;
		g=image[idx].y  ;
		b=image[idx].z  ;
		r = 255 * pow((r / 255),(1/gc));
		g = 255 * pow((g / 255),(1/gc));
		b = 255 * pow((b / 255),(1/gc));
		image[idx].x = r;
		image[idx].y = g;
		image[idx].z = b;
	}
}

void executeGammaCorrection(uchar4* image, size_t height, size_t width, float gc) {

	uchar4* d_image;
	cudaMalloc(&d_image, height * width * sizeof(uchar4));
	cudaMemcpy(d_image, image, height * width * sizeof(uchar4), cudaMemcpyHostToDevice);
	GammaCorrection <<<dim3(1 + ((height - 1) / 32), 1 + ((width - 1) / 32), 1), dim3(32, 32, 1) >> > (d_image, height, width,gc);
	cudaMemcpy(image, d_image, height * width * sizeof(uchar4), cudaMemcpyDeviceToHost);

}