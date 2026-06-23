# Get new certificate using domain and issue date
$dnsName = "localhost"
$newCert = Get-ChildItem Cert:\LocalMachine\My |
    Where-Object { $_.Subject -like "*CN=$dnsName*" } |
    Sort-Object NotBefore -Descending |
    Select-Object -First 1
$newCertThumbprint = $newCert.Thumbprint.ToLower()
Write-Host "Thumbprint (lowercase): " $newCertThumbprint

# Get old certificate using name
$oldCert = Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.FriendlyName -eq "TestCert-Original" }
$oldCertThumbprint = $oldCert.Thumbprint.ToLower()
Write-Host "Currently bound certificate thumbprint: " $oldCertThumbprint

# Connect to SSRS via WMI
$ssrs = Get-WmiObject -Namespace "root\Microsoft\SqlServer\ReportServer\RS_SSRS\v16\Admin" -Class MSReportServer_ConfigurationSetting

# Remove old binding
$ssrs.RemoveSSLCertificateBindings("ReportServerWebService", $oldCertThumbprint, "0.0.0.0", 443, 1033)
$ssrs.RemoveSSLCertificateBindings("ReportServerWebService", $oldCertThumbprint, "::", 443, 1033)

# Add new binding
$ssrs.CreateSSLCertificateBinding("ReportServerWebService", $newCertThumbprint, "0.0.0.0", 443, 1033)
$ssrs.CreateSSLCertificateBinding("ReportServerWebService", $newCertThumbprint, "::", 443, 1033)
