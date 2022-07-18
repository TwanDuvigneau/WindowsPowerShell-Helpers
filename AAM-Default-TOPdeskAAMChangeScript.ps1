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

$TOPdeskChange  = Invoke-TOPdeskMethod -EndpointUri '/operatorChanges'  -TargetID $TOPdeskNumber
#$TOPdeskAsset   = Invoke-TOPdeskMethod -EndpointUri '/assetmgmt/assets' -TargetID $TOPdeskChange.asset.id
$TOPdeskRequest = Invoke-TOPdeskMethod -EndpointUri '/operatorChanges'  -TargetID "$($TOPdeskChange.id)/requests" | Get-TOPdeskFormValue
$TOPdeskPerson  = Invoke-TOPdeskMethod -EndpointUri '/persons/id'       -TargetID $TOPdeskChange.requester.id

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

	$Update = @(
		@{
			'op'    = "add"
			'path'  = "/progressTrail"
			'value' = "Dit is een memo text"
		},
		@{
			'op'    = "replace"
			'path'  = "/status"
			'value' = "Afgesloten"
		}
	)

	$UpdateTOPdeskChange = @{
		EndpointURI = "/operatorChanges"
		TargetID    = $TOPdeskNumber
		Method      = 'Patch'
		ContentType = 'application/json-patch+json'
		Body        = $Update
	}

	Invoke-TOPdeskMethod @UpdateTOPdeskChange

} else {

	$Update = @(
		@{
			'op'    = "add"
			'path'  = "/progressTrail"
			'value' = "Er is iets mis gegaan bij de automatische uitvoering van uw aanvraag, neem contact op met de heldesk"
		},
		@{
			'op'    = "replace"
			'path'  = "/status"
			'value' = "In behandeling"
		}
	)

	$UpdateTOPdeskChange = @{
		EndpointURI = "/operatorChanges"
		TargetID    = $TOPdeskNumber
		Method      = 'Patch'
		ContentType = 'application/json-patch+json'
		Body        = $Update
	}

	Invoke-TOPdeskMethod @UpdateTOPdeskChange

	Write-Verbose -Verbose "Updated TOPdesk Request $($TOPdeskNumber)"

}

#
#endregion TOPdesk POST
#
