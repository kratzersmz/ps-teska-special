# Code mostly copied and pasted from sources on the internet + scripts from j. albani

function plink
{
  [CmdletBinding()]
  PARAM
  (
    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [string] $remoteHost,

    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [string] $login,

    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [string] $passwd,

    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [string] $command)

  & \\Backup\opsi_depot_rw\Update71\exe\plink.exe -ssh $remoteHost -l $login -pw $passwd $command
  return
}

# set to $false to disable lehrer from blackhole e-mail Adress settings...
$lehrerblackhole = $true

$remoteHost = "10.1.0.1"
$login = "root"
$passwd = Read-Host "Enter Password for $login"
plink -remoteHost $remoteHost -login $login -command $command1 -passwd $passwd

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
           $command1 = "udm users/contact modify --dn uid=$($sname),CN=schueler,CN=users,OU=schule,DC=paedml-linux,DC=lokal --set e-mail=$($sname)@blackhole.belwue.de"
           write-host "Add $($sname)@blackhole.belwue.de to $($sname)" -ForegroundColor DarkGreen
           plink -remoteHost $remoteHost -login $login -command $command1 -passwd $passwd
           sleep 0.5
        }
    }
    
 }

# Lehrer Stuff
if ($lehrerblackhole) {
    $pfadlehrer = [ADSI]"LDAP://cn=lehrer,cn=users,ou=schule,dc=paedml-linux,dc=lokal"    
    foreach($lehrer in $pfadlehrer.Children.distinguishedName){
          $lname = ($lehrer.Split("=")[1]).Split(",")[0]
          $command2 = "udm users/contact modify --dn uid=$($lname),CN=lehrer,CN=users,OU=schule,DC=paedml-linux,DC=lokal --set e-mail=$($lname)@blackhole.belwue.de"
           write-host "Add $($lname)@blackhole.belwue.de to $($lname)" -ForegroundColor DarkGreen
           plink -remoteHost $remoteHost -login $login -command $command2 -passwd $passwd
           sleep 0.5
      }
}
   