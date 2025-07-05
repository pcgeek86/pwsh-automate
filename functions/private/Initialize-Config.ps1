function Initialize-Config {

  if (!(Test-Path -Path $AutomateConfig)) {
    $InitialConfig = @{
      SavedWindows = @{ }
    }
    Set-Content -Path $AutomateConfig -Value ($InitialConfig | ConvertTo-Json)
  }
}