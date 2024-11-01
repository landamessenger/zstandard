REM Eliminar el directorio build si existe
if exist build (rmdir /S /Q build)

REM Crear el directorio build y continuar con el proceso
mkdir build && cd build

cmake -G "Visual Studio 17 2022" ..

cmake --build . --config Release

REM Crear el directorio lib/bin si no existe y mover el DLL
cd Release

move zstandard_windows.dll ../../../lib/src/bin/
