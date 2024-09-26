function New-UMSFilterString
{
  <#
  .SYNOPSIS
    Creates a filter string to add to a request

  .DESCRIPTION
    Creates a filter string to add to a request

  .PARAMETER Filter
    Filter can be one of the following: 'short', 'details', 'online', 'shadow', 'children', 'deviceattributes', 'networkadapters'

  .INPUTS
    System.String

  .OUTPUTS
    System.String

  .EXAMPLE
    New-UMSFilterString -Filter 'online'

  #>

  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
  param (
    [Parameter(Mandatory)]
    [ValidateSet('short', 'details', 'online', 'shadow', 'children', 'deviceattributes', 'networkadapters')]
    [String]
    $Filter
  )

  begin
  {
  }
  process
  {
    if ($PSCmdlet.ShouldProcess($Filter))
    {
      $Result = '?facets={0}' -f $Filter
    }
    $Result
  }
  end
  {
  }
}
