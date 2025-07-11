# NOTE: Write-Verbose still doesn't work in .psm1 files: https://github.com/PowerShell/PowerShell/issues/4568
# Use Write-Host for debugging instead, and comment out as necessary, or maybe consider adding a log file
# that can be enabled / activated using arguments passed into the Import-Module command? 🤔

# Main module file for "automate" module

# Configuration file path
$script:AutomateConfig = "$HOME/.pwshautomate.json"

function Get-LibreAutomate {
  <#
  .SYNOPSIS
  Internal helper function to retrieve the LibreAutomate NuGet package, extract it, 
  and load the DLL for the correct .NET Runtime version.
  #>

  if (!(Test-Path -Path $PSScriptRoot/libreautomate)) {
    $Request = @{
      Uri = 'https://www.nuget.org/api/v2/package/LibreAutomate/'
      OutFile = 'libreautomate.nupkg'
    }
    Invoke-WebRequest @Request
    
    # Extract the NuGet package archive so we can load the DLLs
    $ArchiveDestination = '{0}/libreautomate' -f $PSScriptRoot
    Expand-Archive -Path $Request.OutFile -DestinationPath $ArchiveDestination
  
    # Clean up the nupkg file after extraction
    Remove-Item -Path $Request.OutFile
  }

  $LibPath = '{0}/libreautomate/lib' -f $PSScriptRoot
  
  $LibList = Get-ChildItem -Path $LibPath -Recurse -Include *.dll
  
  $NETVersion = [System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription
  # Write-Host -Object ('.NET Runtime version is {0}' -f $NETVersion)
  
  foreach ($Lib in $LibList) {
    if ($Lib.FullName -like '*net9*' -and $NETVersion -like '*NET 9*') {
      # Write-Host -Object ('Attempting to import .NET DLL: {0}' -f $Lib.FullName)
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
  
}

# Download and import the LibreAutomate dependency
Get-LibreAutomate

# Load module functions
$FunctionList = Get-ChildItem -Path $PSScriptRoot/functions -Include *.ps1 -Recurse
foreach ($Function in $FunctionList) {
  . $Function.FullName
}

Initialize-Config