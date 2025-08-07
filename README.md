# Qt_vcpkg_manifest_example
The purpose of this repository is to build a small example project that uses vcpkg in manifest mode to build a Qt Hello World application in either Qt5 or Qt6 on Windows, Linux or macOS. This project aims to be a complete solution as it also packages the test Hello World application. 

**Note: Although macOS is listed as supported I have no access to a macOS device so I can not test.**

## Initial Setup on all OSs
1. I first created a projects folder in an appropriate location on each operating system I wanted to use.
2. I cloned vcpkg to the projects/vcpkg folder.
3. I installed the [GitHub CLI Utility](https://cli.github.com/)

## Next clone this repository
1. Open a terminal / shell and change directory to the folder you created for your projects
2. Type gh 

You can install the gh GitHub CLI client for that 

I first cloned vcpkg to the parent folder of this project so that parent/vcpkg exists.

Then I configured the project for Visual Studio 2022 with the following command typed inside the project folder:

cmake . -DCMAKE_TOOLCHAIN_FILE="..\vcpkg\scripts\buildsystems\vcpkg.cmake" -G "Visual Studio 17 2022"

To build you can type:

cmake --build . --config Debug 
or 
cmake --build . --config Release 

To do a clean build you can add the --clean-first argument at the end like this:

cmake --build . --config Release --clean-first


