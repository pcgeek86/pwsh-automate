@{
  RootModule = 'automate.psm1'
  Author = 'Trevor Sullivan <trevor@trevorsullivan.net>'
  CompanyName = 'Trevor Sullivan'
  ModuleVersion = '0.3'
  GUID = '4c68e01f-daf0-4091-8be0-84a182893da2'
  Copyright = '2025 Trevor Sullivan'
  Description = 'This module helps perform various automation tasks on the Windows platform'
  PowerShellVersion = '7.0'
  FunctionsToExport = @(
    'Save-WindowPosition'
    'Restore-WindowPosition'
    'Get-Windows'
  )
  # AliasesToExport = @('')
  # VariablesToExport = @('')
  PrivateData = @{
    PSData = @{
      Tags = @('windows', 'automation', 'GUI')
      LicenseUri = 'https://github.com/pcgeek86/pwsh-automate'
      ProjectUri = 'https://github.com/pcgeek86/pwsh-automate'
      # IconUri = ''
      ReleaseNotes = @'
'@
    }
  }
  # HelpInfoURI = ''
}