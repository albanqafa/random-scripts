Get-ADUser -Filter * -Properties SamAccountname,DisplayName,Enabled,PasswordNeverExpires,CannotChangePassword,accountExpires,pwdLastSet,LogonHours,memberof | % {
New-Object PSObject -Property @{
DisplayName= $_.DisplayName
SamAccountname= $_.SamAccountname
Enabled= $_.Enabled
PasswordNeverExpires= $_.PasswordNeverExpires
CannotChangePassword= $_.CannotChangePassword
AccountDoesNotExpire= ($_.accountExpires -eq 0)
ChangePasswordAtNextLogon= ($_.pwdLastSet -eq 0)
LogonHours= $_.LogonHours
Groups = ($_.memberof | Get-ADGroup | Select -ExpandProperty Name) -join 
","}
} | Select SamAccountname,DisplayName,Enabled,PasswordNeverExpires,CannotChangePassword,AccountDoesNotExpire,ChangePasswordAtNextLogon,LogonHours,Groups | format-table -autosize | Out-String -Width 10000 | out-file ./test.txt
