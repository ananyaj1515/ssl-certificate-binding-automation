# Get new certificate using FriendlyName
$newCert = Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.FriendlyName -eq "TestCert-Renewed" }
$testCertRenewedThumbprint = $newCert.Thumbprint.ToLower() # WMI expects certificate thumbprint in lowercase
Write-Host "TestCert-Renewed thumbprint (lowercase): " $testCertRenewedThumbprint

# Get old certificate using FriendlyName
$oldCert = Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.FriendlyName -eq "TestCert-Original" }
$testCertOriginalThumbprint = $oldCert.Thumbprint.ToLower()
Write-Host "TestCert-Original thumbprint (lowercase): " $testCertOriginalThumbprint

# Connect to SSRS via WMI 
$ssrs = Get-WmiObject -Namespace "root\Microsoft\SqlServer\ReportServer\RS_SSRS\v16\Admin" -Class MSReportServer_ConfigurationSetting

# Remove old certificate bindings
$ssrs.RemoveSSLCertificateBindings("ReportServerWebService", $testCertOriginalThumbprint, "0.0.0.0", 443, 1033) #IPv4
$ssrs.RemoveSSLCertificateBindings("ReportServerWebService", $testCertOriginalThumbprint, "::", 443, 1033) #IPv6

# Create new certificate bindings
$ssrs.CreateSSLCertificateBinding("ReportServerWebService", $testCertRenewedThumbprint, "0.0.0.0", 443, 1033) #IPv4
$ssrs.CreateSSLCertificateBinding("ReportServerWebService", $testCertRenewedThumbprint, "::", 443, 1033) #IPv6



