# Script to add class land city as ldap attribute in paedml linux, useful for ldap/moodle
$gruppen = [adsi]"LDAP://CN=klassen,CN=schueler,CN=groups,ou=schule,dc=paedml-linux,dc=lokal"
$stadt = 'Karlsruhe'
$land = 'Deutschland'
foreach($klasse in $gruppen.Children.distinguishedName){    
$bezeichnung=($klasse.Split("=")[1]).Split(",")[0] -replace 'schule-' 
$klasse=$bezeichnung    
write-host "################### Verarbeite Klasse " $bezeichnung"####################"-ForegroundColor Green    
$pfad ="LDAP://CN=schule-$($bezeichnung),CN=klassen,CN=schueler,CN=groups,ou=schule,dc=paedml-linux,dc=lokal"    
$SuS = [adsi]$pfad    
#Remove-MsolGroup -ObjectId $gruppenID    
foreach($s in $SuS.member){         
if($s -notmatch "lehrer"){
           $sname = ($s.Split("=")[1]).Split(",")[0]
           $schueler = [adsi]"LDAP://$s"
           $loginname = [String]($sname+$schulsuffix)
           write-host "Processing $($loginname)" 
           $schueler.put("streetAddress", $land) 
           $schueler.setinfo()
           $schueler.put("l", $stadt)
           $schueler.setinfo()
           $schueler.put("postalCode", $klasse)
           $schueler.setinfo()
           Write-Host "Changing City to $($stadt)/$($land) and putting into class $($klasse)"
        }
    }
 }
