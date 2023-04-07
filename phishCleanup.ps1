Import-Module ExchangeOnlineManagement
Connect-IPPSSession

$newSearchName = "phish purge test, take three"
$newSearchDescription = "find and delete test emails"
$newSearchMatchText = "(From:joeuser@domain.com) AND (subject:'take three test phish')"

New-ComplianceSearch -Name $newSearchName -Description $newSearchDescription -ExchangeLocation All -ContentMatchQuery $newSearchMatchText
Start-ComplianceSearch -Identity $newSearchName

# open Edge to the Security & Compliance Center search console to check status of search
Start-Process -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" https://compliance.microsoft.com/contentsearchv2?viewid=search

$confirmation = "n"
while($confirmation -ne "y")
{
    $confirmation = Read-Host "Press 'y' when *SEARCH* has completed to delete message from all mailboxes"
}
write-host "Deleting all instances of bad message, assuming the search completed"

New-ComplianceSearchAction -SearchName $newSearchName -Purge -PurgeType SoftDelete -Confirm:$false

# this will show you the status of (all) search/purges
Get-ComplianceSearchAction

$confirmation = "n"
while($confirmation -ne "y")
{
    $confirmation = Read-Host "Press 'y' when *PURGE* has completed, to disconnect from Exchange Online"
}

# if you don't disconnect, you might use up the sessions (3) and script won't work for a while
Disconnect-ExchangeOnline -Confirm:$false

# more SearchMatch examples:
# $newSearchMatchText = "From:lbart1@lsuhsc.edu"
# $newSearchMatchText = "Subject:'Work From Home'"
# $newSearchMatchText = "(From:lbart1@lsuhsc.edu) AND (Subject:'Work From Home')"

