# Qt_vcpkg_manifest_example
The purpose of this repository is to build a small example project that uses vcpkg in manifest mode to build a Qt Hello World application in either Qt5 or Qt6 on Windows, Linux or macOS. This project aims to be a complete solution as it also packages the test Hello World application. 

**Note: Although macOS is listed as supported I have no access to a macOS device so I can not test.**

## Initial Setup on all OSs
1. Create a projects folder in an appropriate location on each operating system you want to use.
2. Clone [vcpkg](https://github.com/microsoft/vcpkg) to the projects/vcpkg folder. 
3. Open a terminal / shell and change directory to the projects/vcpkg folder.
4. Execute the bootstrap script in the vcpkg folder. On Windows this file is **bootstrap-vcpkg.bat** and its **bootstrap-vcpkg.sh** on all other supported OSs.
5. Install the [GitHub CLI Utility](https://cli.github.com/) if you don't already have it. On Linux it should be in your package manager.

## Next clone this repository
1. Open a terminal / shell and change directory to the folder you created for your projects
2. Type **gh repo clone drescherjm/Qt_vcpkg_manifest_example** to clone this repository. This will create a projects/Qt_vcpkg_manifest_example folder.
   
## Create the build folder

1. On all operating systems please create a build folder inside the Qt_vcpkg_manifest_example folder such that **projects/Qt_vcpkg_manifest_example/build** exists.
2. Change directory in your terminal / console to the build folder.

## Configure and build the vcpkg dependencies.

# Windows 11 using msvc and Visual Studio 2022:
In the build folder type the following to build a Qt5 configure the project and install the vcpkg dependencies:
```
cmake -S .. -B . -DSELECT_QT_VERSION="Qt5" -DCMAKE_TOOLCHAIN_FILE="..\vcpkg\scripts\buildsystems\vcpkg.cmake" -G "Visual Studio 17 2022"  
```
Or for Qt6:
```
cmake -S .. -B . -DSELECT_QT_VERSION="Qt6" -DCMAKE_TOOLCHAIN_FILE="..\vcpkg\scripts\buildsystems\vcpkg.cmake" -G "Visual Studio 17 2022"
```
# Linux - Ubuntu 25.04
In the build folder type the following to build a Qt5 configure the project and install the vcpkg dependencies:
```
cmake -S .. -B . -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake -DVCPKG_MANIFEST_FEATURES="qt5"
```
Or for Qt6:
```
cmake -S .. -B . -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake -DVCPKG_MANIFEST_FEATURES="qt5"
```


I first cloned vcpkg to the parent folder of this project so that parent/vcpkg exists.

Then I configured the project for Visual Studio 2022 with the following command typed inside the project folder:

cmake . -DCMAKE_TOOLCHAIN_FILE="..\vcpkg\scripts\buildsystems\vcpkg.cmake" -G "Visual Studio 17 2022"

To build you can type:

cmake --build . --config Debug 
or 
cmake --build . --config Release 

To do a clean build you can add the --clean-first argument at the end like this:

cmake --build . --config Release --clean-first


