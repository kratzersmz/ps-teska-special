# Script for getting Usernames out of paedml linux
# Schülerstuff
write-host 'Write File to export ' $env:USERPROFILE '\schueler.csv'
Add-Content -Path $env:USERPROFILE\schueler.csv  -Value '"Schüler"'

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
           $loginname = [String]($sname+$schulsuffix)
           write-host $loginname  " adding to to Schueler"
           @($loginname) | foreach { Add-Content -Path $env:USERPROFILE\schueler.csv -Value $_ }
        
        }
    }
    
 }


# Lehrerstuff
write-host "Write File to export " ${env:USERPROFILE} "lehrer.csv"
Add-Content -Path $env:USERPROFILE\lehrer.csv  -Value '"Lehrer"'

$pfadlehrer = [ADSI]"LDAP://cn=lehrer,cn=users,ou=schule,dc=paedml-linux,dc=lokal"    
foreach($lehrer in $pfadlehrer.Children.distinguishedName){
          $lname = ($lehrer.Split("=")[1]).Split(",")[0]
          write-host $lname  " adding to to Lehrer"
           @($lname) | foreach { Add-Content -Path $env:USERPROFILE\lehrer.csv -Value $_ }
}

