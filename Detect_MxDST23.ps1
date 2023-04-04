<#

.Description
    Main purpose is to remove DST for devices with México's Time Zone due to changes announced by Government, in 2023 DST would not be implemented.
    Microsoft sent out update to Time Zone in March 2023 update, so, for devices with this update actions would not be necessary.
    This script checks if the Windows version and time zone configuration

    Checks for Conditions that would imply that DST would need to be disabled manually:
        1. Windows version and build number:
            - Windows 10: Build should start with "1" and revision number lower than 2728.
            - Windows 11: Build should start with "2" and revision lower than 1413.
        2. Time Zone Configuration:
            - Time Zone: Central Standard Time (Mexico)
            - UTC Offset: -6
            - Daylight Saving Time (DST) must be currently enabled

Usage:
    Deploy this script as Detection script via Intune Proactive Remediation.

To do:
    Verify that revision number is being compared as number and not as string.

#>


$Error.Clear()
$computerInfo = Get-ComputerInfo
$osVersion = [System.Version]::new($computerInfo.OsVersion)
$osHalVersion = [System.Version]::new($computerInfo.OsHardwareAbstractionLayer)
$DetectSummary = ""


# Condition 1: Check Windows version and build number
$checkVersion = $false
if (($osVersion.Major -eq 10 -and $osVersion.Build.ToString().StartsWith("1") -and $osHalVersion.Revision -lt 2728) -or
    ($osVersion.Major -eq 10 -and $osVersion.Build.ToString().StartsWith("2") -and $osHalVersion.Revision -lt 1413)) {
    $checkVersion = $true
    $DetectSummary += "March 2023 update not found. "
}

# Condition 2: Check Windows Time Zone Configuration
$checkTimeZone = $false
$timeZone = Get-TimeZone
$dstEnabled = [System.TimeZoneInfo]::Local.IsDaylightSavingTime((Get-Date))

if ($timeZone.Id -eq "Central Standard Time (Mexico)" -and $dstEnabled) {
    $checkTimeZone = $true
    $DetectSummary += "Found Mexico Central Time with DST enabled."
}


# Exit with code 1 if both conditions are met
if ($checkVersion -and $checkTimeZone) {
    Write-Host "WARNING $([datetime]::Now) : $DetectSummary"
    exit 1
}
else {
    Write-Host "OK $([datetime]::Now) : $DetectSummary."
}
