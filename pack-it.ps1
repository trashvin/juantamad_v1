####################################################
#  powershell script for packing the project 
#  by : trashvin
####################################################

param(
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][string]$name,
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][string]$version
)

# function : Invoke-PrepareBuild
# purpose : prepares environment for build
# returns : 
function Invoke-PrepareBuild {

    # this directory is part of gitignore

    if (Test-Path -Path $package_folder) {
        Write-Host "deleting existing directory ..."
        Remove-Item -Recurse -Force $package_folder | Out-Null
    } 
    Write-Host "creating the _build directory ..."
    New-Item -ItemType Directory -Path $package_folder | Out-Null
}

# function : New-PackageBuild
# purpose : generates the build
# returns : true or false
function New-PackageBuild {
    Write-Host "generating package ..."

    # copy the contents of bin
    Copy-Item ..\..\bin\*.* -Destination . -Recurse

    # create the source folder
    New-Item -ItemType Directory -Path "src" | Out-Null
    Set-Location -Path "src"
    New-Item -ItemType Directory -Path "JuanTamad" | Out-Null
    New-Item -ItemType Directory -Path "JuanTamadFT" | Out-Null

    Set-Location ..
    Write-Host $cur_dire
    # copy source
    Copy-Item ..\..\src\JuanTamad\*.* -Destination src\JuanTamad -Recurse
    Copy-Item ..\..\src\JuanTamadFT\*.* -Destination src\JuanTamadFT -Recurse

    Set-Location ..
}


# function : New-ZippedApplication
# purpose : generates the zipped application
# returns : 
function New-ZippedApplication {
    Write-Host "generating zipped application ..."
    $zipped_filename = $build_folder + ".zip"
    # let us zip the application
    Compress-Archive -LiteralPath $build_folder -DestinationPath "$($zipped_filename)"

    Write-Host "$($zipped_filename) was successfuly generated ..." -ForegroundColor White -BackgroundColor DarkGreen
}

# function : Invoke-Cleanup 
# purpose : cleanup no longer used files
# returns : 
function Invoke-Cleanup {
    Write-Host "cleaning up ...."
    Remove-Item -Force -Recurse $build_folder
    Set-Location ..
    # no implementation
}

#######################################################################################
# the main function 
#######################################################################################

Write-Host "package name : $($name)"
Write-Host "version : $($version)"

$package_folder = "_package"

Invoke-PrepareBuild

# create the build folder with format [name]_v[version]

$build_folder = "$($name)_v$($version)"

Set-Location -Path $package_folder

if (Test-Path -Path $build_folder) {
    Write-Host "deleting existing build directory ..."
    Remove-Item -Recurse -Force $build_folder | Out-Null
}

Write-Host "creating the build directory ..."
New-Item -ItemType Directory -Path $build_folder | Out-Null
Set-Location -Path $build_folder

New-PackageBuild
New-ZippedApplication
Invoke-Cleanup

Write-Host "COMPLETE! package generation is done. check for errors" -ForegroundColor White -BackgroundColor DarkGreen
Write-Host "##########################################################################"
Write-Host "###                                                                   ####"
Write-Host "###   the package is @ _package folder                                ####"
Write-Host "###                                                                   ####"
Write-Host "##########################################################################"
