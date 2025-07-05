# Main module file for "automate" module

# Configuration file path
$script:AutomateConfig = "$HOME/.pwshautomate.json"

if (!(Test-Path -Path $PSScriptRoot/libreautomate)) {
  $Request = @{
    Uri = 'https://www.nuget.org/api/v2/package/LibreAutomate/'
    OutFile = 'libreautomate.nupkg'
  }
  Invoke-WebRequest @Request
  
  # Extract the NuGet package archive so we can load the DLLs
  Expand-Archive -Path $Request.OutFile

  # Clean up the nupkg file after extraction
  Remove-Item -Path $Request.OutFile
}

$LibPath = "$PSScriptRoot/libreautomate/lib"

$LibList = Get-ChildItem -Path $LibPath -Recurse -Include *.dll

$NETVersion = [System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription

foreach ($Lib in $LibList) {
  # Write-Host -Object $Lib.FullName
  if ($Lib.FullName -like '*\net9*' -and $NETVersion -like '*NET 9*') {
    Add-Type -Path $Lib.FullName
  }
  elseif ($Lib.FullName -like '*\net8*' -and $NETVersion -like '*NET 8*') {
    Add-Type -Path $Lib.FullName
  }
}

# After loading the .NET library for LibreAutomate, if the Au.Clipboard type isn't available
# then something didn't work correctly during import.
if (![Au.clipboard]) {
  throw 'Error while importing the Automate module. Could not import LibreAutomate successfully.'
  return
}

# Load module functions
$FunctionList = Get-ChildItem -Path $PSScriptRoot/functions -Include *.ps1 -Recurse
foreach ($Function in $FunctionList) {
  . $Function.FullName
}

Initialize-Config