#Connect-AzureAD

if (!(Get-AzureADGroup -SearchString "Teacher" -ErrorVariable notPresent -ErrorAction SilentlyContinue)) {
  New-AzureADGroup -DisplayName "Teacher" -MailEnabled $false -SecurityEnabled $true -MailNickName "NotSet"
}

if (!(Get-AzureADGroup -SearchString "Student" -ErrorVariable notPresent -ErrorAction SilentlyContinue)) {
  New-AzureADGroup -DisplayName "Student" -MailEnabled $false -SecurityEnabled $true -MailNickName "NotSet"
}

$gusers = Get-AzureADUser -All $true 

foreach ($guser in $gusers) {
  $hash = Get-AzureADUser -ObjectId $guser.UserPrincipalName | Select -ExpandProperty Extensionproperty
  foreach($key in $hash.Keys) {
      $value = $hash.$key
      if ($key -like '*_employeeType' -and $value -eq 'Student') {
        write-host "Schüler gefunden: " $guser.UserprincipalName " --> schiebe in Student Gruppe"
        Add-AzureADGroupMember -
      }
      if ($key -like '*_employeeType' -and $value -eq 'Teacher') {
        write-host "Lehrer gefunden: " $guser.UserprincipalName " --> schiebe in Teacher Gruppe"
      }
  }
}