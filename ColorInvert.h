#ifndef COLORINVERT
#define COLORINVERT

#include <cuda.h>
#include <cuda_runtime.h>

#include <stdio.h>
#include "device_launch_parameters.h"
#include "Dispatch.h"

void executeColorInvert(uchar4* image, size_t height, size_t width);


#endif