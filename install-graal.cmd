@echo off
@REM restore the normal current directory in case script was run with 'Run as Admin'
pushd "%~dp0"

@REM install GraalVM

set GRAAL_VERSION=19.2.1
set GRAAL_FILE=graalvm-ce-windows-amd64-%GRAAL_VERSION%.zip
set GRAAL_URL=https://github.com/oracle/graal/releases/download/vm-%GRAAL_VERSION%
set CACHE_DIR=%USERPROFILE%\.m2\caches\info.picocli.graal

if exist "%CACHE_DIR%\graalvm\graalvm-ce-%GRAAL_VERSION%\" GOTO graal_already_installed
mkdir "%CACHE_DIR%\graalvm\graalvm-ce-%GRAAL_VERSION%\"
echo Downloading %GRAAL_FILE%. This may take a while.
pushd "%CACHE_DIR%\"
powershell -Command "(New-Object Net.WebClient).DownloadFile('%GRAAL_URL%/%GRAAL_FILE%', 'graalvm.zip')"
powershell -Command "Expand-Archive graalvm.zip graalvm"
popd
goto install-windows-sdk-7.1

:graal_already_installed
echo %CACHE_DIR%\graalvm\graalvm-ce-%GRAAL_VERSION%\ exists: skipping GraalVM download

@REM install windows-sdk-7.1 and C++ compilers if necessary
:install-windows-sdk-7.1
if not exist "C:\Program Files\Microsoft SDKs\Windows\v7.1\" choco install windows-sdk-7.1 kb2519277

@REM activate the sdk-7.1 environment:

call "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd"

@REM The above starts a new Command Prompt, with the sdk-7.1 environment enabled.
@REM The Maven build command (`mvnw clean verify`) must be run in this Command Prompt window.

echo Setting JAVA_HOME=%CACHE_DIR%\graalvm\graalvm-ce-%GRAAL_VERSION%\
set JAVA_HOME=%CACHE_DIR%\graalvm\graalvm-ce-%GRAAL_VERSION%\
%JAVA_HOME%\bin\java -version

echo "You can now run the build with: mvnw clean verify"
