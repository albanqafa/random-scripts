Write-host "please log in with an Office 365 admin account" -foreground "yellow"
Write-host "edit this script and replace adminaccount@domain.tld with your O365 admin user" -foreground "yellow"
pause

Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName adminaccount@domain.tld

echo " "
Write-host "============= Setting All Users Default Calendar Permission =============" -foreground "yellow"
echo " "
$useAccess = Get-Mailbox -ResultSize Unlimited -Filter {RecipientTypeDetails -eq "UserMailbox"} | Select-object primarysmtpaddress | Export-Csv -Path .\allusers.csv 

write-host "remove unwanted mailboxes from allusers.csv then hit enter to proceed"
pause
Import-Csv allusers.csv | foreach {

echo " "
echo "USER -"
echo $($_.primarysmtpaddress+":\calendar").Trim("`n")
echo " "
write-host "Before:"
get-mailboxfolderpermission $($_.primarysmtpaddress+":\calendar").Trim("`n")

write-host "Changing..."
set-mailboxfolderpermission -identity $($_.primarysmtpaddress+":\calendar").Trim("`n") -user Default -AccessRights LimitedDetails
echo " "
write-host "After:"
get-mailboxfolderpermission $($_.primarysmtpaddress+":\calendar").Trim("`n")
echo " "
Write-Output "======================================================="
}

