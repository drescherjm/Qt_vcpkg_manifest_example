# Qt_vcpkg_manifest_example
This is a simple vcpkg manifest example that creates a small test Qt5 or Qt6 project.

I first cloned vcpkg to the parent folder of this project so that parent/vcpkg exists.

Then I configured the project for Visual Studio 2022 with the following command typed inside the project folder:

cmake . -DCMAKE_TOOLCHAIN_FILE="..\vcpkg\scripts\buildsystems\vcpkg.cmake" -G "Visual Studio 17 2022"

To build you can type:

cmake --build . --config Debug 
or 
cmake --build . --config Release 

To do a clean build you can add the --clean-first argument at the end like this:

cmake --build . --config Release --clean-first


