function Restore-WindowPosition {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false, ParameterSetName = 'AllWindowsByClassName')]
    [string[]] $ClassName = '*',
    [Parameter(Mandatory = $false, ParameterSetName = 'SpecificWindowTitle')]
    [string] $Title,
    [Parameter(Mandatory = $false, ParameterSetName = 'SpecificWindowTitle')]
    [string] $Class
  )

  $WindowList = Get-Windows -ClassName $ClassName

  $Config = Get-Content -Path $AutomateConfig | ConvertFrom-Json

  foreach ($Window in $WindowList) {
    $Key = '{0}-{1}' -f $Window.ClassName, $Window.Name
    Write-Verbose -Message ('Key is: {0}' -f $Key)

    # If the window key exists in the configuration, then use it to set the window position
    if ($Key -in (Get-Member -InputObject $Config.SavedWindows).Name) {
      $Item = $Config.SavedWindows.$Key
      Write-Verbose -Message ('Restoring window {0} to {1}' -f $Key, $Item.Rect)
      $Screen = [Au.Screen]::all | Where-Object -FilterScript { $PSItem.Handle -eq $Item.Screen.Handle.value }

      if ($Screen) {
        $null = $Window.MoveL(
          $Item.Rect.left,
          $Item.Rect.top,
          $Item.Rect.Width,
          $Item.Rect.Height
        )
      }
      else {
        Write-Verbose -Message ('Could not find screen with matching handle {0}' -f $Item.Screen.Handle.value)
      }
    }
  }
}