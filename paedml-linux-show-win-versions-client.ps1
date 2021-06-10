# base script von johannes
# very hackish script, ignore all the styles
$gruppen = [adsi]"LDAP://CN=computers,ou=schule,dc=paedml-linux,dc=lokal" 
foreach($klasse in $gruppen.Children.distinguishedName){  
    $winver = "unknown"
    $test = [adsi]"LDAP://$klasse"
    if (([String]($test.operatingSystemVersion)) -match "19042") { $winver = "20h2" }
    if (([String]($test.operatingSystemVersion)) -match "18363") { $winver = "1909" }
    if (([String]($test.operatingSystemVersion)) -match "19041") { $winver = "2004" }
    if (([String]($test.operatingSystemVersion)) -match "17763") { $winver = "1809" }
    if ($winver -eq "1909") {
    write-host ([String]($test.sAMAccountName)) "-" $winver "-" ([String]($test.operatingSystemVersion)) -ForegroundColor Green
    }
    else {
    write-host ([String]($test.sAMAccountName)) "-" $winver "-" ([String]($test.operatingSystemVersion)) -ForegroundColor RED
    }
}
