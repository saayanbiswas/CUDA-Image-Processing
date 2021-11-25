#include <iostream>
#include <vector>
#include <sstream>

//#include "InteractivePrompt.h"

#include "blackWhite.h"
#include "ColorInvert.h"
#include "GammaCorrection.h"


auto main() -> int
{
	//InteractivePrompt prompt;
	//prompt.promptLoop();
	uchar4* image;
	size_t height, width;
	Dispatch::loadImageRGBA(".\\resources\\mri.jpg", &image, &height, &width);
	//executeColorInvert(image, height, width);
	
	//executeGammaCorrection(image, height, width, 2.2f);
	//executeBlackWhite(image, height, width);
	executeColorInvert(image, height, width);
	Dispatch::saveImageRGBA(image, height, width, ".\\resources\\mriSharpenFiltered.jpg");
}