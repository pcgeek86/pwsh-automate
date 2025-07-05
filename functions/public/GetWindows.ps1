function Get-Windows {
  [OutputType([Au.Wnd])]
  <#
  .SYNOPSIS
  Retrieves a list of all the windows on the Windows system.

  .PARAMETER ClassName
  Specify one or more window "class" names that you'd like to filter the results for.
  #>
  [CmdletBinding()]
  param (
    [string[]] $ClassName = '*'
  )

  $WindowList = [Au.wnd+getwnd]::allWindows()

  # Filter window list to class name, if parameter is specified
  if ($PSBoundParameters.ContainsKey('ClassName') -and $ClassName -ne '*') {
    $WindowList = $WindowList | Where-Object -FilterScript { $PSItem.ClassName -in $ClassName -or $PSItem.ClassName -eq $ClassName }
  }

  return $WindowList
}