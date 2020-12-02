$AzureDevOpsPAT = "anpeqncg5f2lmjvtmdx2e3isofood5u7srumbn4x6flhcwgi7bkq"
$organizationName = "ClevvaAzure"

$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($AzureDevOpsPAT)")) }

$uriOrga = "https://dev.azure.com/$($organizationName)/"
$uriAccount = $uriOrga + "_apis/projects?api-version=6.0"
$newCustomerName = "TestProject"

$test = "https://dev.azure.com/$($organizationName)/Clevva App/_apis/pipelines?api-version=6.0-preview.1"
Invoke-RestMethod -Uri $test -Method get -Headers $AzureDevOpsAuthenicationHeader | ConvertTo-Json -Depth 5

# $check = Invoke-RestMethod -Uri $uriAccount -Method get -Headers $AzureDevOpsAuthenicationHeader
# foreach($projects in $check.PsObject.Properties.Value.name) {
#     if ($projects -like $newCustomerName) {
#         Write-Host "Found"
#     }
#     else {
#         $projectConfiguration = @{
#             "name" = $newCustomerName
#             "description" = ""
#             "ProjectVisibility" = "private"
#             "capabilities" = @{
#                 "versioncontrol" = @{
#                     "sourceControlType" = "Git"
#                 }
#                 "processTemplate" = @{
#                     "templateTypeId" = "b8a3a935-7e91-48b8-a94c-606d37c3e9f2"
#                 }
#             }
#         }  | ConvertTo-Json -Depth 5
# 
#         Invoke-RestMethod -Uri $uriAccount -Method Post -Headers $AzureDevOpsAuthenicationHeader -Body $projectConfiguration -ContentType "application/json"
#     }
# }
