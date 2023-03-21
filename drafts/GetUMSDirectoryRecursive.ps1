
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Id', Justification = 'false positive')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'DirectoryColl', Justification = 'false positive')]
[CmdletBinding(DefaultParameterSetName = 'Directory')]
param (
  [Parameter(Mandatory)]
  [Int]
  $Id,

  [Parameter(Mandatory)]
  $DirectoryColl,

  [Parameter(Mandatory, ParameterSetName = 'Element')]
  $ElementColl
)
$ResultDirectoryColl = {
      ($DirectoryColl).where{ $_.Id -eq $Id }
  $ChildDirColl = ($DirectoryColl).where{ $_.ParentId -eq $Id }
  foreach ($ChildDir in $ChildDirColl)
  {
    Get-UMSDirectoryRecursive -Id $ChildDir.Id -DirectoryColl $DirectoryColl
  }
}
Switch ($PsCmdlet.ParameterSetName)
{
  'Directory'
  {
    $Result = (& $ResultDirectoryColl)
  }
  'Element'
  {
    $Result = foreach ($Directory in (& $ResultDirectoryColl))
    {
      foreach ($Element in $ElementColl)
      {
        if ($Element.ParentId -eq $Directory.Id)
        {
          $Element
        }
      }
    }
  }
}
$Result
