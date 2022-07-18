Param
(
  [Parameter (Mandatory= $false)]
  [Object] $WebHookData
)

$TOPdeskNumber = ($WebHookData.requestbody | ConvertFrom-Json).TOPdeskNumber

$Config = @{
	TOPdeskTenant   = (Get-AutomationVariable -Name 'TOPdeskTenant')
}

Import-Module TOPdeskAAM

$ConnectTOPdesk = @{
	Url        = "https://$($Config.TOPdeskTenant).topdesk.net"
	Credential = (Get-AutomationPSCredential -Name 'TopdeskAPI')
}

Connect-TOPdeskService @ConnectTOPdesk

#
#region TOPdesk GET
#

$TOPdeskIncident = Invoke-TOPdeskMethod -EndpointUri '/incidents/number' -TargetID $TOPdeskNumber
#$TOPdeskAsset   = Invoke-TOPdeskMethod -EndpointUri '/assetmgmt/assets' -TargetID $TOPdeskIncident.asset.id
$TOPdeskRequest =  Get-TOPdeskFormValue -MemoText $TOPdeskIncident.request
$TOPdeskPerson   = Invoke-TOPdeskMethod -EndpointUri '/caller/id' -TargetID $TOPdeskIncident.requester.id

#
#endregion TOPdesk GET
#

#
#region Script
#

#
#endregion Script
#

#
#region TOPdesk POST
#

if (-not $Error) {

	$Update = @{
		action = "Dit is een actie"
		processingStatus = @{
			name = "Status"
		}
	}

	$UpdateTOPdeskIncident = @{
		EndpointURI = "/incidents/number"
		TargetID    = $TOPdeskNumber
		Method      = 'Patch'
		Body        = $Update
	}

	Invoke-TOPdeskMethod @UpdateTOPdeskIncident

} else {

	$Update = @{
		action = "Er is iets mis gegaan bij de automatische uitvoering van uw aanvraag, neem contact op met de heldesk"
		processingStatus = @{
			name = "In behandeling"
		}
	}

	$UpdateTOPdeskIncident = @{
		EndpointURI = "/incidents/number"
		TargetID    = $TOPdeskNumber
		Method      = 'Patch'
		Body        = $Update
	}

	Invoke-TOPdeskMethod @UpdateTOPdeskIncident

	Write-Verbose -Verbose "Updated TOPdesk Request $($TOPdeskNumber)"

}

#
#endregion TOPdesk POST
#
