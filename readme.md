# Soundcubes - Project assignment for Experimental User Interfaces course
## Installation
1. Download and install [NyARToolkit for Processing 2.1.0](https://github.com/nyatla/NyARToolkit-for-Processing/releases/tag/v2.1.0).
2. If needed, [calibrate your camera with ARToolkit](http://artoolkit.org/documentation/doku.php?id=2_Configuration:config_camera_calibration) and replace the default **data/front_camera_para.dat**.
3. Print the first 13 tracking markers from **data/gif**.
4. If you are not using a Surface Pro 3, change the following line in **soundcubes.pde**: `cam = new Capture(this, camWidth, camHeight, "Microsoft LifeCam Front", 30);`

## License
The MIT License (MIT)

Copyright (c) [2016] 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.