<#
.SYNOPSIS
    Updates the SSRS SSL certificate binding using thumbprints passed directly from WIN-ACME.

.DESCRIPTION
    This script is intended to be called by win-acme's post-renewal "external script" hook.
    win-acme automatically substitutes {CertThumbprint} and {OldCertThumbprint} with the new
    and previous certificate's thumbprints, removing the need for this script to search the
    windows certificate store.

.PARAMETER NewThumbprint
    The newly issued certificate's thumbprint, passed in by win-acme as {CertThumbprint}.

.PARAMETER OldThumbprint
    The previous certificate's thumbprint, passed in by win-acme as {OldCertThumbprint}.

.EXAMPLE
    Configured in win-acme as:
    Parameters: -NewThumbprint {CertThumbprint} -OldThumbprint {OldCertThumbprint}
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$NewThumbprint,

    [Parameter(Mandatory = $true)]
    [string]$OldThumbprint
)

$application   = "ReportServerWebService"
$port          = 443
$lcid          = 1033
$ssrsNamespace = "root\Microsoft\SqlServer\ReportServer\RS_SSRS\v16\Admin"

# SSRS' WMI provider accepts certificate hash only in lowercase
$newThumbprintLower = $NewThumbprint.ToLower()
$oldThumbprintLower = $OldThumbprint.ToLower()

Write-Host "New certificate thumbprint: $newThumbprintLower"
Write-Host "Old certificate thumbprint: $oldThumbprintLower"

# Connect to SSRS via WMI
$ssrs = Get-WmiObject -Namespace $ssrsNamespace -Class MSReportServer_ConfigurationSetting

# Remove previous binding
$ssrs.RemoveSSLCertificateBindings($application, $oldThumbprintLower, "0.0.0.0", $port, $lcid) #IPv4
$ssrs.RemoveSSLCertificateBindings($application, $oldThumbprintLower, "::", $port, $lcid) #IPv6

# Create new binding
$ssrs.CreateSSLCertificateBinding($application, $newThumbprintLower, "0.0.0.0", $port, $lcid) #IPv4
$ssrs.CreateSSLCertificateBinding($application, $newThumbprintLower, "::", $port, $lcid) #IPv6