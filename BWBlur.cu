#include "BWBlur.h"
#include<math.h>
__global__ void BWBlur(uchar4* image, uchar4* out, size_t height, size_t width) {
	int x = blockIdx.x * blockDim.x + threadIdx.x;
	int y = blockIdx.y * blockDim.y + threadIdx.y;
	if (x < height && y < width) {
		int idx = x * width + y;

		int idx = x * width + y;

		image[idx].x = 255 - out[idx].x;
		image[idx].y = 255 - out[idx].y;
		image[idx].z = 255 - out[idx].z;


		/*int count = 0;
		int sum = 0;
		
		for (int i = y - 1; i <= y + 1; i++)
		{
			for (int j = x - 1; j <= x + 1; j++)
			{
				 int ind = x * width + y;
				if (i >= 0 && i < width && j >= 0 && j < height)
				{
					count+=1;
					sum = sum + image[ind].x;
				}
				
			}
		}
		int val = (sum / count);
		out[idx].x = val;
		out[idx].y = val;
		out[idx].z = val;*/

		
	}
}

void executeBWBlur(uchar4* image, size_t height, size_t width, float gc) {

	uchar4* d_image;
	uchar4* d_out;
	cudaMalloc(&d_image, height * width * sizeof(uchar4));
	cudaMalloc(&d_out, height * width * sizeof(uchar4));
	cudaMemcpy(d_image, image, height * width * sizeof(uchar4), cudaMemcpyHostToDevice);
	BWBlur <<<dim3(1 + ((height - 1) / 32), 1 + ((width - 1) / 32), 1), dim3(32, 32, 1) >>> (d_image, d_out, height, width);
	cudaMemcpy(image, d_out, height * width * sizeof(uchar4), cudaMemcpyDeviceToHost);

}