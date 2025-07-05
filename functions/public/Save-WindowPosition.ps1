function Save-WindowPosition {
  <#
  .SYNOPSIS
  Saves the window position for the specified window titles.

  .PARAMETER ClassName
  Filter the windows with the specified ClassName property.
  #>
  [CmdletBinding()]
  param (
    [string[]] $ClassName = '*'
  )

  # Read the current configuration
  $Config = Get-Content -Path $AutomateConfig | ConvertFrom-Json

  $WindowList = Get-Windows -ClassName $ClassName

  foreach ($Window in $WindowList) {
    # We are assuming that each applicaiton will only have a single window with the same name (title).
    # Probably not a great assumption, but we will go with it for now. Not sure how else to uniquely identify
    # an application across multiple instances, as they will have different process IDs, etc.
    $Key = '{0}-{1}' -f $Window.ClassName, $Window.Name

    # Define the window properties that will be persisted to the module config file
    $SavedWindow = @{
      Rect = $Window.Rect
      Screen = $Window.Screen
    }
    
    
    # Update the saved window configuration if it exists, or add a new entry if it doesn't.
    if (Get-Member -InputObject $Config.SavedWindows -Name $Key) {
      $Config.SavedWindows.$Key = $SavedWindow
    }
    else {
      $Config.SavedWindows | Add-Member -MemberType NoteProperty -Name $Key -Value $SavedWindow
    }
  }

  Set-Content -Path $AutomateConfig -Value ($Config | ConvertTo-Json -Depth 6)
}