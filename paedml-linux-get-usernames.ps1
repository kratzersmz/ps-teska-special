# Script for getting Usernames out of paedml linux
# Schülerstuff
# Script for getting Usernames out of paedml linux
## Schülerstuff
write-host 'Write File to export ' $env:USERPROFILE '\schueler.csv'
$gruppen = [adsi]"LDAP://CN=klassen,CN=schueler,CN=groups,ou=schule,dc=paedml-linux,dc=lokal"
foreach($klasse in $gruppen.Children.distinguishedName){    
  $bezeichnung=($klasse.Split("=")[1]).Split(",")[0] -replace 'schule-' 
  $klasse=$bezeichnung
  $pfad ="LDAP://CN=schule-$($bezeichnung),CN=klassen,CN=schueler,CN=groups,ou=schule,dc=paedml-linux,dc=lokal"    
  $SuS = [adsi]$pfad    
  foreach($s in $SuS.member){ 
    if($s -notmatch "lehrer"){        
           $sname = ($s.Split("=")[1]).Split(",")[0]
           $schueler = [adsi]"LDAP://$s"
           $klasseschueler = $klasse
           $vorname = $schueler.givenName
           $nachname = $schueler.sn
           $loginname = [String]($sname+$schulsuffix)
           write-host $loginname  " adding to to Schueler"
           Add-Content -Path $env:USERPROFILE\schueler.csv "$loginname,$vorname,$nachname,$klasseschueler"
        
     }
   }
 }

## Lehrerstuff
write-host "Write File to export " ${env:USERPROFILE} "\lehrer.csv"
$pfadlehrer = [ADSI]"LDAP://cn=lehrer,cn=users,ou=schule,dc=paedml-linux,dc=lokal"    
foreach($l in $pfadlehrer.Children.distinguishedName){
          $lname = ($l.Split("=")[1]).Split(",")[0]
          $lehrer = [adsi]"LDAP://$l"
          $vorname = $lehrer.givenName
          $nachname = $lehrer.sn
          write-host $lname  " adding to to Lehrer"
          Add-Content -Path $env:USERPROFILE\lehrer.csv "$lname,$vorname,$nachname"
}

