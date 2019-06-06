# Credit goes to Jeff Melnick
# https://blog.netwrix.com/2018/06/07/how-to-create-new-active-directory-users-with-powershell/
 
# Import the Active Directory Module - necessary for "New-ADUser"
Import-Module ActiveDirectory

#Enter a path to your import CSV file
$ADUsers = Import-csv .\users.csv

foreach ($User in $ADUsers)
{

       $Username    = $User.username
       $Password    = $User.password
       $Firstname   = $User.firstname
       $Lastname    = $User.lastname
       $Department  = $User.department

       #Check if the user account already exists in AD
       if (Get-ADUser -F {SamAccountName -eq $Username})
       {
               #If user does exist, output a warning message
               Write-Warning "A user account $Username has already exist in Active Directory."
       }
       else
       {
       #If a user does not exist then create a new user account
          
       #Change the domain name in the"-UserPrincipalName" variable to your domain name
              New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@yourdomain.com" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -ChangePasswordAtLogon $False `
            -DisplayName "$Lastname, $Firstname" `
            -Department $Department `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force)
       }
}
