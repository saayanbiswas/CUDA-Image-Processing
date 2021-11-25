#ifndef SMOOTHEN
#define SMOOTHEN

#include <cuda.h>
#include <cuda_runtime.h>

#include <stdio.h>
#include "device_launch_parameters.h"
#include "Dispatch.h"

void executeSmoothen(uchar4* image, size_t height, size_t width);


#endif