#
# Modulmanifest fuer das Modul "PSIGEL"
#
# Generiert von: Falk Heiland
#
# Generiert am: 09.01.2018
#

@{

  # Die diesem Manifest zugeordnete Skript- oder Binaermoduldatei.
  RootModule           = 'PSIGEL.psm1'

  # Die Versionsnummer dieses Moduls
  ModuleVersion        = '0.10.0'

  # Unterstuetzte PSEditions
  CompatiblePSEditions = @('Desktop', 'Core')

  # ID zur eindeutigen Kennzeichnung dieses Moduls
  GUID                 = '4834fbc2-faf6-469c-b685-0195954fd878'

  # Autor dieses Moduls
  Author               = 'Falk Heiland'

  # Company or vendor of this module

  # Urheberrechtserklaerung fuer dieses Modul
  Copyright            = '(c) 2018 Falk Heiland. Alle Rechte vorbehalten.'

  # Beschreibung der von diesem Modul bereitgestellten Funktionen
  Description          = 'Powershell Wrapper for the IGEL UMS RestAPI (IMI) from IGEL Technology GmbH (https://www.igel.com/)'

  # Die fuer dieses Modul mindestens erforderliche Version des Windows PowerShell-Moduls
  PowerShellVersion    = '5.1'

  # Der Name des fuer dieses Modul erforderlichen Windows PowerShell-Hosts
  # PowerShellHostName = ''

  # Die fuer dieses Modul mindestens erforderliche Version des Windows PowerShell-Hosts
  # PowerShellHostVersion = ''

  # Die fuer dieses Modul mindestens erforderliche Microsoft .NET Framework-Version.
  # Diese erforderliche Komponente ist nur fuer die PowerShell Desktop-Edition gueltig.
  # DotNetFrameworkVersion = ''

  # Die fuer dieses Modul mindestens erforderliche Version der CLR (Common Language Runtime).
  # Diese erforderliche Komponente ist nur fuer die PowerShell Desktop-Edition gueltig.
  # CLRVersion = ''

  # Die fuer dieses Modul erforderliche Prozessorarchitektur ("Keine", "X86", "Amd64").
  # ProcessorArchitecture = ''

  # Die Module, die vor dem Importieren dieses Moduls in die globale Umgebung geladen werden muessen
  # RequiredModules = @()

  # Die Assemblys, die vor dem Importieren dieses Moduls geladen werden muessen
  # RequiredAssemblies = @()

  # Die Skriptdateien (PS1-Dateien), die vor dem Importieren dieses Moduls in der Umgebung des Aufrufers ausgefuehrt werden.
  # ScriptsToProcess = @()

  # Die Typdateien (.ps1xml), die beim Importieren dieses Moduls geladen werden sollen
  # TypesToProcess = @()

  # Die Formatdateien (.ps1xml), die beim Importieren dieses Moduls geladen werden sollen
  # FormatsToProcess = @()

  # Die Module, die als geschachtelte Module des in "RootModule/ModuleToProcess" angegebenen Moduls importiert werden sollen.
  # NestedModules = @()

  # Aus diesem Modul zu exportierende Funktionen. Um optimale Leistung zu erzielen, verwenden Sie keine Platzhalter und loeschen den Eintrag nicht.
  # Verwenden Sie ein leeres Array, wenn keine zu exportierenden Funktionen vorhanden sind.
  FunctionsToExport    = @(
    'Get-UMSDevice'
    'Get-UMSDeviceAssignment'
    'Get-UMSDeviceDirectory'
    'Get-UMSDeviceDirectoryAssignment'
    'Get-UMSDirectoryRecursive'
    'Get-UMSFirmware'
    'Get-UMSProfile'
    'Get-UMSProfileDirectory'
    'Get-UMSProfileAssignment'
    'Get-UMSStatus'
    'Move-UMSDevice'
    'Move-UMSDeviceDirectory'
    'Move-UMSProfile'
    'Move-UMSProfileDirectory'
    'New-UMSAPICookie'
    'New-UMSDevice'
    'New-UMSDeviceDirectory'
    'New-UMSProfileAssignment'
    'New-UMSProfileDirectory'
    'Remove-UMSAPICookie'
    'Remove-UMSDevice'
    'Remove-UMSDeviceDirectory'
    'Remove-UMSProfile'
    'Remove-UMSProfileAssignment'
    'Remove-UMSProfileDirectory'
    'Reset-UMSDevice'
    'Restart-UMSDevice'
    'Send-UMSDeviceSetting'
    'Start-UMSDevice'
    'Stop-UMSDevice'
    'Update-UMSDevice'
    'Update-UMSDeviceDirectory'
    'Update-UMSProfile'
    'Update-UMSProfileDirectory'
  )

  # Aus diesem Modul zu exportierende Cmdlets. Um optimale Leistung zu erzielen, verwenden Sie keine Platzhalter und loeschen den Eintrag nicht.
  # Verwenden Sie ein leeres Array, wenn keine zu exportierenden Cmdlets vorhanden sind.
  CmdletsToExport      = @()

  # Die aus diesem Modul zu exportierenden Variablen
  VariablesToExport    = @()

  # Aus diesem Modul zu exportierende Aliase. Um optimale Leistung zu erzielen, verwenden Sie keine Platzhalter und loeschen den Eintrag nicht.
  # Verwenden Sie ein leeres Array, wenn keine zu exportierenden Aliase vorhanden sind.
  AliasesToExport      = @()

  # Aus diesem Modul zu exportierende DSC-Ressourcen
  # DscResourcesToExport = @()

  # Liste aller Module in diesem Modulpaket
  # ModuleList = @()

  # Liste aller Dateien in diesem Modulpaket
  # FileList = @()

  # Die privaten Daten, die an das in "RootModule/ModuleToProcess" angegebene Modul uebergeben werden sollen.
  # Diese koennen auch eine PSData-Hashtabelle mit zusaetzlichen von PowerShell verwendeten Modulmetadaten enthalten.
  PrivateData          = @{

    PSData = @{

      # 'Tags' wurde auf das Modul angewendet und unterstuetzt die Modulermittlung in Onlinekatalogen.
      Tags         = @('IGEL', 'UMS', 'IMI')

      # Eine URL zur Lizenz fuer dieses Modul.
      LicenseUri   = 'https://github.com/IGEL-Community/PSIGEL/blob/master/LICENSE'

      # Eine URL zur Hauptwebsite fuer dieses Projekt.
      ProjectUri   = 'https://github.com/IGEL-Community/PSIGEL'

      # Eine URL zu einem Symbol, das das Modul darstellt.
      # IconUri = ''

      # 'ReleaseNotes' des Moduls
      ReleaseNotes = @'
v0.10.0 20200429
* cross platform support (Windows, Linux, MacOS)
* support for Powershell 7
* added Remove-UMSAPICookie
* set minimum Powershell Requirement for the module to 5.1
* added Site, Department, CostCenter, AssetID, InServiceDate and SerialNumber to Get-UMSDevice -Filter details
* support for Datatype Version in Get-UMSFirmware, Get-UMSStatus
* added Get-UMSDirectoryRecursive
* edited SerialNumber Length to 18
* remove *-OS* functions
* fixed reset / update empty values of devices
'@

    } # Ende der PSData-Hashtabelle

  } # Ende der PrivateData-Hashtabelle

  # HelpInfo-URI dieses Moduls
  # HelpInfoURI = ''

  # Standardpraefix fuer Befehle, die aus diesem Modul exportiert werden. Das Standardpraefix kann mit "Import-Module -Prefix" ueberschrieben werden.
  # DefaultCommandPrefix = ''

}


