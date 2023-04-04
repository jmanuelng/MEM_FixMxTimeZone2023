<#

.Description
    Main purpose is to remove DST for devices with México's Time Zone due to changes announced by Government, in 2023 DST would not be implemented.
    Microsoft sent out update to Time Zone in March 2023 update, so, for devices with this update actions would not be necessary.
    
    This script disables DST for Time Zone ID "Central Standard Time (Mexico)" using tzutil

Usage:
    Deploy this script as Remediation script via Intune Proactive Remediation.

#>

$currentTimeZone = [System.TimeZoneInfo]::Local
$isDST = $currentTimeZone.IsDaylightSavingTime((Get-Date))

if ($currentTimeZone.Id -eq "Central Standard Time (Mexico)" -and $isDST) {
    tzutil.exe /s "Central Standard Time (Mexico)_dstoff"
}