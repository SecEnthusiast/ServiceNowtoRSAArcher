# Extract Tickets from ServiceNow table via xml file.
# 1. Extract from ServiceNow API (table)
# 2. Don't use RSA Archer Data Feed HTTPS function because of import functionality for other BI Tools (PowerBI, TIBCO Spotfire Analytics, etc.)
# 3. Standardization of the fields and renaming of field names so that the input (xml file) can be made available to various tools
# 4. Log file creation for subsequent verification
# 5. Future.... ;-)

$path = "x:\Tools\script\transfer_from_ServiceNow"
$date = get-date -format "yyyy-MM-dd-HH-mm"
$file = ("Log_" + $date + ".log")
$logfile = $path + "\" + $file

function Write-Log([string]$logtext, [int]$level=0)
{
	$logdate = get-date -format "yyyy-MM-dd HH:mm:ss"
	if($level -eq 0)
	{
		$logtext = "[INFO] " + $logtext
		$text = "["+$logdate+"] - " + $logtext
		Write-Host $text
	}
	if($level -eq 1)
	{
		$logtext = "[WARNING] " + $logtext
		$text = "["+$logdate+"] - " + $logtext
		Write-Host $text -ForegroundColor Yellow
	}
	if($level -eq 2)
	{
		$logtext = "[ERROR] " + $logtext
		$text = "["+$logdate+"] - " + $logtext
		Write-Host $text -ForegroundColor Red
	}
	$text >> $logfile
}

# log something
Write-Log "this is a simple log test"

# create warning log entry
Write-Log "this is a simple log test" 2

$cmds = get-command
Write-Log "there are1 $($cmds.count) commands available"


# Eg. User name="admin", Password="admin" for this code sample.
$user = "admin"
$pass = "admin"

# Build auth header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(('{0}:{1}' -f $user, $pass)))

# Set proper headers
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
Write-Log "Header1: $($headers)"
$headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
$headers.Add('Accept','application/xml')
Write-Log "Header2: $($headers)"

# Specify endpoint uri
# complete data
$uri = "https://yourinstance.service-now.com/api/now/table/yourtablename"

# Specify HTTP method
$method = "get"
Write-Log "URL $($uri)"



{request.body ? ""$body = \"" :""}
Write-Log "Start HTTP"
# Send HTTP request
$response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri 
Write-Log "End HTTP"
#Write-Log "Response: $($response)"


# Print response
$output = $response.Content
$cmds = get-command
Write-Log "there are3 $($cmds.count) commands available"
# Replace field names for Archer
$output = $output -replace "assignment_group.name>","assignment_group>" 
$output = $output -replace "company.name>","company>" 
$output = $output -replace "location.name>","location>" 
$output = $output -replace "cmdb_ci.name>","cmdb_ci>" 
$output = $output -replace  "<result>" ,"<result><framework>name of framework</framework><service>SOC</service><On_Offshore>Offshore</On_Offshore>"
$output = $output -replace  "<made_sla>true</made_sla>", "<made_sla>In time</made_sla>"
$output = $output -replace  "<made_sla>false</made_sla>", "<made_sla>Out of time</made_sla>"
$output = $output -replace  "</sys_created_by>", "</sys_created_by><mon_enduser>Enduser</mon_enduser>"
$output = $output -replace  "<sys_created_by>ws-sem-eventrouter</sys_created_by><mon_enduser>Enduser</mon_enduser>", "<sys_created_by>ws-sem-eventrouter</sys_created_by><mon_enduser>Monitoring</mon_enduser>"


Out-File -FilePath "x:\Program Files\Archer_Data_Feed\Test_ServiceNow\Security_SOC_Offshore.xml" -InputObject $output -Encoding UTF8
Start-Sleep -s 2

# PerimeterProtection
$uri = "https://yourinstance.service-now.com/api/now/table/yourtablename"
# Specify HTTP method
$method = "get"

{request.body ? ""$body = \"" :""}

# Send HTTP request
$response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri 

# Print response
$output = $response.Content

# Replace wrong field names
$output = $output -replace "assignment_group.name>","assignment_group>" 
$output = $output -replace "company.name>","company>" 
$output = $output -replace "location.name>","location>" 
$output = $output -replace "cmdb_ci.name>","cmdb_ci>" 
$output = $output -replace  "<result>" ,"<result><framework>name from framework</framework><service>IDS/IPS</service><On_Offshore>Onshore</On_Offshore>"
$output = $output -replace  "<made_sla>true</made_sla>", "<made_sla>In time</made_sla>"
$output = $output -replace  "<made_sla>false</made_sla>", "<made_sla>Out of time</made_sla>"
$output = $output -replace  "</sys_created_by>", "</sys_created_by><mon_enduser>Enduser</mon_enduser>"
$output = $output -replace  "<sys_created_by>ws-sem-eventrouter</sys_created_by><mon_enduser>Enduser</mon_enduser>", "<sys_created_by>ws-sem-eventrouter</sys_created_by><mon_enduser>Monitoring</mon_enduser>"


Out-File -FilePath "x:\Program Files\Archer_Data_Feed\Test_SNOW\Security_PerimeterProtection.xml" -InputObject $output -Encoding UTF8
Start-Sleep -s 2

# SecureGateway
$uri = "https://yourinstance.service-now.com/api/now/table/yourtablename"
# Specify HTTP method
$method = "get"

{request.body ? ""$body = \"" :""}

# Send HTTP request
$response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri 

# Print response
$output = $response.Content

# Replace wrong field names
$output = $output -replace "assignment_group.name>","assignment_group>" 
$output = $output -replace "company.name>","company>" 
$output = $output -replace "location.name>","location>" 
$output = $output -replace "cmdb_ci.name>","cmdb_ci>" 
$output = $output -replace  "<result>" ,"<result><framework>name from framework</framework><service>Proxy</service><On_Offshore>Onshore</On_Offshore>"
$output = $output -replace  "<made_sla>true</made_sla>", "<made_sla>In time</made_sla>"
$output = $output -replace  "<made_sla>false</made_sla>", "<made_sla>Out of time</made_sla>"
$output = $output -replace  "</sys_created_by>", "</sys_created_by><mon_enduser>Enduser</mon_enduser>"
$output = $output -replace  "<sys_created_by>ws-sem-eventrouter</sys_created_by><mon_enduser>Enduser</mon_enduser>", "<sys_created_by>ws-sem-eventrouter</sys_created_by><mon_enduser>Monitoring</mon_enduser>"

Out-File -FilePath "x:\Program Files\Archer_Data_Feed\Test_SNOW\DE_Security_SecureGateway.xml" -InputObject $output -Encoding UTF8
Start-Sleep -s 2

# SecureGateway - Offshore
$uri = "https://yourinstance.service-now.com/api/now/table/yourtablename"
# Specify HTTP method
$method = "get"

{request.body ? ""$body = \"" :""}

# Send HTTP request
$response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri 

# Print response
$output = $response.Content

# Replace wrong field names
$output = $output -replace "assignment_group.name>","assignment_group>" 
$output = $output -replace "company.name>","company>" 
$output = $output -replace "location.name>","location>" 
$output = $output -replace "cmdb_ci.name>","cmdb_ci>" 
$output = $output -replace  "<result>" ,"<result><framework>name of framework</framework><service>Proxy</service><On_Offshore>Offshore</On_Offshore>"
$output = $output -replace  "<made_sla>true</made_sla>", "<made_sla>In time</made_sla>"
$output = $output -replace  "<made_sla>false</made_sla>", "<made_sla>Out of time</made_sla>"
$output = $output -replace  "</sys_created_by>", "</sys_created_by><mon_enduser>Enduser</mon_enduser>"
$output = $output -replace  "<sys_created_by>ws-sem-eventrouter</sys_created_by><mon_enduser>Enduser</mon_enduser>", "<sys_created_by>ws-sem-eventrouter</sys_created_by><mon_enduser>Monitoring</mon_enduser>"

Out-File -FilePath "x:\Program Files\Archer_Data_Feed\Test_SNOW\Security_SecureGateway_Offshore.xml" -InputObject $output -Encoding UTF8
Start-Sleep -s 2
# 

# VPS
$uri = "https://yourinstance.service-now.com/api/now/table/yourtablename"
# Specify HTTP method
$method = "get"

{request.body ? ""$body = \"" :""}

# Send HTTP request
$response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri 

# Print response
$output = $response.Content

# Replace wrong field names
$output = $output -replace "assignment_group.name>","assignment_group>" 
$output = $output -replace "company.name>","company>" 
$output = $output -replace "location.name>","location>" 
$output = $output -replace "cmdb_ci.name>","cmdb_ci>" 
$output = $output -replace  "<result>" ,"<result><framework>name of framework</framework><service>VirusProtection</service><On_Offshore>Onshore</On_Offshore>"
$output = $output -replace  "<made_sla>true</made_sla>", "<made_sla>In time</made_sla>"
$output = $output -replace  "<made_sla>false</made_sla>", "<made_sla>Out of time</made_sla>"
$output = $output -replace  "</sys_created_by>", "</sys_created_by><mon_enduser>Enduser</mon_enduser>"
$output = $output -replace  "<sys_created_by>ws-sem-eventrouter</sys_created_by><mon_enduser>Enduser</mon_enduser>", "<sys_created_by>ws-sem-eventrouter</sys_created_by><mon_enduser>Monitoring</mon_enduser>"

Out-File -FilePath "x:\Program Files\Archer_Data_Feed\Test_SNOW\DE_Security_VPS.xml" -InputObject $output -Encoding UTF8
Start-Sleep -s 2
