Get-ADUser -Filter 'enabled -eq $true' -Properties SamAccountname,DisplayName,PasswordNeverExpires,CannotChangePassword,AccountExpirationDate,pwdLastSet,LogonHours,memberof | % {
New-Object PSObject -Property @{
DisplayName= $_.DisplayName
SamAccountname= $_.SamAccountname
PasswordNeverExpires= $_.PasswordNeverExpires
CannotChangePassword= $_.CannotChangePassword
AccountDoesNotExpire= ($null -eq $_.AccountExpirationDate)
ChangePasswordAtNextLogon= ($pwdLastSet -eq 0)
LogonHours= $_.LogonHours
Groups = ($_.memberof | Get-ADGroup | Select -ExpandProperty Name) -join 
","}
} | Select SamAccountname,DisplayName,PasswordNeverExpires,CannotChangePassword,AccountDoesNotExpire,ChangePasswordAtNextLogon,LogonHours,Groups | format-table -autosize | Out-String -Width 10000 | out-file ./test.txt
