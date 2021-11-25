#include "ColorInvert.h"
#include<stdlib.h>
__constant__ int mask[3 * 3];

__global__ void ColorInvert(uchar4* image, uchar4* out, size_t height, size_t width) {
	int x = blockIdx.x * blockDim.x + threadIdx.x;
	int y = blockIdx.y * blockDim.y + threadIdx.y;
	if (x < height && y < width) 
	{
		int idx = x * width + y;

		int start_r = x - 1;
		int start_c = y - 1;

		int tempr = 0;
		int tempb = 0;
		int tempg = 0;
		for (int i = 0; i < 3; i++)
		{
			for (int j = 0; j < 3; j++)
			{
				if ((start_r + i) >= 0 && (start_r + i) < height) 
				{
					if ((start_c + j) >= 0 && (start_c + j) < width)
					{
						tempr += image[(start_r + i) * width + (start_c + j)].x * mask[i * 3 + j];
						tempg += image[(start_r + i) * width + (start_c + j)].y * mask[i * 3 + j];
						tempb += image[(start_r + i) * width + (start_c + j)].z * mask[i * 3 + j];
					}
				}
			}
		}
		
		int div = 9;
		/*out[idx].x = (tempr / div > 255) ? 255:(tempr / div);
		out[idx].y = (tempg / div > 255) ? 255: tempg / div;
		out[idx].z = (tempb / div > 255) ? 255: tempb / div;*/
		out[idx].x = image[idx].x + tempr / div;
		out[idx].y = image[idx].y + tempg / div;
		out[idx].z = image[idx].z + tempb / div;


	}
}

void executeColorInvert(uchar4* image, size_t height, size_t width) {

	uchar4* d_image;
	uchar4* d_out;
	int filter[]= {	-1,-1,-1,
					-1,9,-1,
					-1,-1,-1};
	size_t bytes_m = 3 * 3 * sizeof(int);
	cudaMalloc(&d_image, height * width * sizeof(uchar4));
	cudaMalloc(&d_out, height * width * sizeof(uchar4));
	cudaMemcpyToSymbol(mask, filter, bytes_m);
	cudaMemcpy(d_image, image, height * width * sizeof(uchar4), cudaMemcpyHostToDevice);
	ColorInvert <<<dim3(1 + ((height - 1) / 32), 1 + ((width - 1) / 32), 1), dim3(32, 32, 1) >>> (d_image,d_out, height, width);
	cudaMemcpy(image, d_out, height * width * sizeof(uchar4), cudaMemcpyDeviceToHost);

}