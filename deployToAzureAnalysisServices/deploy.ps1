
#Requires -Module SqlServer
[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlaintext')]
Param()

Import-Module (Join-Path $PSScriptRoot 'ps_modules\VstsAzureHelpers_\VstsAzureHelpers_.psm1') -DisableNameChecking
Initialize-Azure

$connectedServiceName = (Get-VstsInput -Name 'connectedServiceName').Trim()
$serviceEndpoint = Get-VstsEndpoint -Name "$connectedServiceName"

## Log authentication inputs
Write-Verbose "Auth Scheme: $($serviceEndpoint.Auth.Scheme)"
Write-Verbose "SubscriptionId: $($serviceEndpoint.Data.SubscriptionId)"

if ($serviceEndpoint.Auth.Scheme -ne 'ServicePrincipal') {
    Write-Error 'Only Service Principal connection is supported.'
}

$spnId = $serviceEndpoint.Auth.Parameters.ServicePrincipalId
$spnSecret = $serviceEndpoint.Auth.Parameters.ServicePrincipalKey
$password = ConvertTo-SecureString $spnSecret -AsPlainText -Force
$pscredential = New-Object System.Management.Automation.PSCredential($spnId, $password)

$azureAnalysisServerName = (Get-VstsInput -Name 'azureAnalysisServerName').Replace(' ', '')
$xmlaFilePath = (Get-VstsInput -Name 'xmlaFilePath')
if (-not (Test-Path $xmlaFilePath)) {
    Write-Error "XMLA file does not exist at path '$xmlaFilePath'"
}

Write-Verbose "Deploying to Azure Analyis Server $azureAnalysisServerName using XMLA file from path '$xmlaFilePath'" -Verbose
Invoke-ASCmd -InputFile $xmlaFilePath -Server $azureAnalysisServerName -Credential $pscredential -ServicePrincipal
