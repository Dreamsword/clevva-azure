$AzureDevOpsPAT = "anpeqncg5f2lmjvtmdx2e3isofood5u7srumbn4x6flhcwgi7bkq"
$organizationName = "ClevvaAzure"

$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($AzureDevOpsPAT)")) }

$uriOrga = "https://dev.azure.com/$($organizationName)/"
$uriAccount = $uriOrga + "_apis/projects?api-version=6.0"
$newCustomerName = "TestProject"

# $uriBuild = $uriOrga + "Clevva App/_apis/build/definitions/6?api-version=6.0"
# Invoke-RestMethod -Uri $uriBuild -Method get -Headers $AzureDevOpsAuthenicationHeader -ContentType "application/json" | ConvertTo-Json -Depth 5

$checkExist = Invoke-RestMethod -Uri $uriAccount -Method get -Headers $AzureDevOpsAuthenicationHeader
# $test = $uriOrga + "Clevva App/_apis/pipelines/6?api-version=6.0-preview.1"
# Invoke-RestMethod -Uri $test -Method get -Headers $AzureDevOpsAuthenicationHeader

# foreach($projects in $checkExist.PsObject.Properties.Value.name) {
#     if ($projects -like $newCustomerName) {
#         Write-Host "Found"
#         $newProject = "false"
#         break
#     }
#     else {
#         $newProject = "true"
#     }
# }
# 
# if ($newProject -match "true") {
#     $projectConfiguration = @{
#         "name" = $newCustomerName
#         "description" = ""
#         "ProjectVisibility" = "private"
#         "capabilities" = @{
#             "versioncontrol" = @{
#                 "sourceControlType" = "Git"
#             }
#             "processTemplate" = @{
#                 "templateTypeId" = "b8a3a935-7e91-48b8-a94c-606d37c3e9f2"
#             }
#         }
#     }  | ConvertTo-Json -Depth 5
# 
#     Invoke-RestMethod -Uri $uriAccount -Method Post -Headers $AzureDevOpsAuthenicationHeader -Body $projectConfiguration -ContentType "application/json"
#     $created = "false"
# 
#     do {
#         $verify = Invoke-RestMethod -Uri $uriAccount -Method get -Headers $AzureDevOpsAuthenicationHeader
#         foreach($projects in $verify.PsObject.Properties.Value.name) {
#             if ($projects -like $newCustomerName) {
#                 $created = "true"
#             }
#         }
#     } until ($created -match "true")
# 
#     $createPipeline = $uriOrga + "$newCustomerName/_apis/pipelines?api-version=6.0-preview.1"
#     $pipelineConfiguration = @{
#         "_links" = @{
#             "self" = ""
#             "web" = ""
#         }
#         "configuration" = @{
#             "path" = "azure-pipelines.yml"
#             "repository" = ""
#             "type" = "yaml"
#         }
#         "url" = "https://dev.azure.com/ClevvaAzure/d618de77-e01a-43d7-af56-705fb8419f4f/_apis/pipelines/6?revision=1"
#         "id" = "6"
#         "revision" = "1"
#         "name" = "clevva.clevva-compiled"
#         "folder"   = "\"
#     }
#     Invoke-RestMethod -Uri $createPipeline -Method Post -Headers $AzureDevOpsAuthenicationHeader -Body $pipelineConfiguration -ContentType "application/json"
# }

$Url = $uriOrga + "$newCustomerName/_apis/build/definitions?api-version=5.1"
$json = @{
    project = $newCustomerName;
    name = "My.New.Definition.Linked.To.Existing.YAML.File";
    repository = @{
        url = "https://${$CLEVVA_COMPILED_USER:$CLEVVA_COMPILED_PASS}@bitbucket.org/clevva/clevva-compiled.git";
        defaultBranch = "master";
        id = "clevva/clevva-compiled";
        type = "Bitbucket";
    };
    process = @{
        yamlFilename = "azure-pipelines.ym";
        type = 2;
    };
    path = "\\";
    type = "build";
}

$body = ($json | ConvertTo-Json -Depth 3)
Invoke-RestMethod -Uri $Url -Headers $AzureDevOpsAuthenicationHeader -Body $body -Method Post -ContentType application/json;