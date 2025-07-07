$TempModuleDir = '{0}/automate' -f $PSScriptRoot

# Remove temp publishing folder if it exists
if (Test-Path -Path $TempModuleDir) {
  Remove-Item -Path $TempModuleDir -Recurse -Force
}

# Recreate the empty temp directory
$null = New-Item -ItemType Directory -Path $TempModuleDir

$Exclude = @(
  '.git'
  '.gitignore'
  'automate'
  (Get-ChildItem -Path $PSSCriptRoot/libreautomate -Recurse).Name
  'libreautomate'
  'publish.ps1'
  '*xml'
  'README.md'
)
Copy-Item -Path $PSScriptRoot/* -Exclude $Exclude -Destination $TempModuleDir -Recurse

# Publish the module
$NuGetApiKey = Read-Host -Prompt 'Enter your NuGet API Key'
Publish-Module -Path $TempModuleDir -NuGetApiKey $NuGetApiKey

# Clean up temporary publishing folder
#Remove-Item -Path $TempModuleDir -Recurse -Force