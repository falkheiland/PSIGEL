function New-UMSFilterString
{
  <#
  .EXAMPLE
  New-UMSFilterString -Filter 'short' -Whatif

  .EXAMPLE
  New-UMSFilterString -Filter 'full'

  .EXAMPLE
  New-UMSFilterString -Filter 'online'

  .EXAMPLE
  New-UMSFilterString -Filter 'shadow'

  .EXAMPLE
  New-UMSFilterString -Filter 'children'
  
  .EXAMPLE
  New-UMSFilterString -Filter 'deviceattributes'
  
  .EXAMPLE
  New-UMSFilterString -Filter 'networkadapters'

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
