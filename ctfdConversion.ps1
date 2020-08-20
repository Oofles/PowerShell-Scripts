# Vars
$dir = Get-Location

$filenameCsv = "combined.csv"
$csv = "$dir\$filenameCsv"

$filenameChallenges = "challenges.json"
$filenameFlags = "flags.json"
$filenameHints = "hints.json"

$jsonChallenges = "$dir\$filenameChallenges"
$jsonFlags = "$dir\$filenameFlags"
$jsonHints = "$dir\$filenameHints"


# Import the Combined CSV file
$import = Import-Csv $csv


### Function -  This allows us to get a total number of items that exist. This is required for the header. ###
function countID ($name) {
    $ids = $import.$name | Sort-Object | Get-Unique | Measure-Object
    $count = $ids.Count - 1  # We have to subtract one for the one blank line
    return $count
}

# Create the counts
$challengesCount = countID("id")
$flagsCount = countID("flag_id")
$hintsCount = countID("hint_id")


### Function - Removes all the carriage returns and extra spaces
# There's gotta be a better way to do what comes next... but it's late and for whatever reason .Replace and -replace accomplish different things...
function condenseJson ($condenseFile) {
    $raw = Get-Content -Path $condenseFile
    $raw.Replace("`n","").Replace("`r","") | Set-Content $condenseFile
    $raw2 = Get-Content -Raw $condenseFile
    $raw2 -replace '\s+',' ' | Set-Content $condenseFile
}


### Function - Remove last comma in a file ###
function removeComma ($commaFile) {
    $comma = Get-Content -Path $commaFile
    $comma[-1] = $comma[-1].Replace(",","")
    $comma | Set-Content $commaFile
}


### Function - Build the challenges JSON ###
function convertChallenges {

# Create the header
$challengesHeader = '{"count":' + $challengesCount + ', "results": ['
Add-Content -Path $jsonChallenges -Value $challengesHeader

# Add all the challenges. Descriptions need new lines removed and prerequisites must exist in an array.
$result = foreach ($record in $import) {
if ($record.id.length -gt 0){
$challenges = @"
{
    "id": "$($record.id)",
    "name": "$($record.name)",
    "description": "$($record.description.Replace("`n","\r\n"))",
    "max_attempts": "$($record.max_attempts)",
    "value": "$($record.value)",
    "category": "$($record.category)",
    "type": "$($record.type)",
    "state": "$($record.state)",
    "requirements": {
        "prerequisites": [$($record.prerequisites)]
    }
},
"@
Add-Content -Path $jsonChallenges -Value $challenges
}}

# Need to remove that last pesky comma!!!
removeComma("$jsonChallenges")

# Close with the footer
Add-Content -Path $jsonChallenges -Value '], "meta": {} }'

# Finally, we get rid of all the extra spaces to make CTFd happy :)
condenseJson("$jsonChallenges")
}

# Create challenges.json
convertChallenges


### Function - Build the flags JSON ###
function convertFlags {

# Create the header
$flagsHeader = '{"count":' + $flagsCount + ', "results": ['
Add-Content -Path $jsonFlags -Value $flagsHeader

# Add all the flags. Descriptions need new lines removed and prerequisites must exist in an array.
$result = foreach ($record in $import) {
if ($record.flag_id.length -gt 0){
$flags = @"
{
    "id": "$($record.flag_id)",
    "challenge_id": "$($record.flag_challenge_id)",
    "type": "$($record.flag_type)",
    "content": "$($record.flag_content)",
    "data": "$($record.data)"
},
"@
Add-Content -Path $jsonFlags -Value $flags
}}

# Need to remove that last pesky comma!!!
removeComma("$jsonFlags")

# Close with the footer
Add-Content -Path $jsonFlags -Value '], "meta": {} }'

# Finally, we get rid of all the extra spaces to make CTFd happy :)
condenseJson("$jsonFlags")
}

# Create flags.json
convertFlags


### Function - Build the hints JSON ###
function convertHints {

# Create the header
$hintsHeader = '{"count":' + $hintsCount + ', "results": ['
Add-Content -Path $jsonHints -Value $hintsHeader

# Add all the hints. Descriptions need new lines removed and prerequisites must exist in an array.
$result = foreach ($record in $import) {
if ($record.hint_id.length -gt 0){
$hints = @"
{
    "id": "$($record.hint_id)",
    "type": "$($record.hint_type)",
    "challenge_id": "$($record.hint_challenge_id)",
    "content": "$($record.hint_content.Replace("`n","\r\n"))",
    "cost": "$($record.cost)",
    "requirements": "$($record.requirements)"
},
"@
Add-Content -Path $jsonHints -Value $hints
}}

# Need to remove that last pesky comma!!!
removeComma("$jsonHints")

# Close with the footer
Add-Content -Path $jsonHints -Value '], "meta": {} }'

# Finally, we get rid of all the extra spaces to make CTFd happy :)
condenseJson("$jsonHints")
}

# Create hints.json
convertHints
