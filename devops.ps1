$AzureDevOpsPAT = "anpeqncg5f2lmjvtmdx2e3isofood5u7srumbn4x6flhcwgi7bkq"
$organizationName = "ClevvaAzure"

$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($AzureDevOpsPAT)")) }

$uriOrga = "https://dev.azure.com/$($organizationName)/"
$uriAccount = $uriOrga + "_apis/projects?api-version=6.0"
$newCustomerName = "TestProject"

$checkExist = Invoke-RestMethod -Uri $uriAccount -Method get -Headers $AzureDevOpsAuthenicationHeader
foreach($projects in $checkExist.PsObject.Properties.Value.name) {
    if ($projects -like $newCustomerName) {
        Write-Host "Found"
        $newProject = "false"
        break
    }
    else {
        $newProject = "true"
    }
}

if ($newProject -match "true") {
    $projectConfiguration = @{
        "name" = $newCustomerName
        "description" = ""
        "ProjectVisibility" = "private"
        "capabilities" = @{
            "versioncontrol" = @{
                "sourceControlType" = "Git"
            }
            "processTemplate" = @{
                "templateTypeId" = "b8a3a935-7e91-48b8-a94c-606d37c3e9f2"
            }
        }
    }  | ConvertTo-Json -Depth 5

    Invoke-RestMethod -Uri $uriAccount -Method Post -Headers $AzureDevOpsAuthenicationHeader -Body $projectConfiguration -ContentType "application/json"
    
    $created = "false"
    do {
        $verify = Invoke-RestMethod -Uri $uriAccount -Method get -Headers $AzureDevOpsAuthenicationHeader
        foreach($createProjects in $verify.PsObject.Properties.Value) {
            if ($createProjects.name -like $newCustomerName) {
                $created = "true"
                $newProjectId = $createProjects.id
                break
            }
        }
    } until ($created -match "true")

    $createServicePrincipal = $uriOrga + "_apis/serviceendpoint/endpoints?api-version=6.0-preview.4"
    $servicePrincipalBody = @"
    {
        "data": {},
        "name": "ClevvaServiceEndpoint",
        "type": "bitbucket",
        "url": "https://bitbucket.org",
        "authorization": {
            "parameters": {
                "username": "Hein_Reyneke",
                "password": "Sxd6gDSbn85kHB9kyyrY"
            },
            "scheme": "UsernamePassword"
        },
        "isShared": false,
        "isReady": true,
        "serviceEndpointProjectReferences": [
            {
                "projectReference": {
                    "id": "$newProjectId",
                    "name": "$newCustomerName"
                },
                "name": "$newCustomerName-ClevvaServiceEndpoint"
            }
        ]
    }
"@
    Invoke-RestMethod -Uri $createServicePrincipal -Method Post -Headers $AzureDevOpsAuthenicationHeader -Body $servicePrincipalBody -ContentType "application/json"

    $getServicePrincipal = $uriOrga + "$newCustomerName/_apis/serviceendpoint/endpoints?api-version=6.0-preview.4"
    $servicePrincipal = Invoke-RestMethod -Uri $getServicePrincipal -Method get -Headers $AzureDevOpsAuthenicationHeader
    $servicePrincipalId = $servicePrincipal.PsObject.Properties.Value.id

    $createPipeline = $uriOrga + "$newCustomerName/_apis/build/definitions?api-version=6.0"
    $jsonPipeline = @{
        project = $newCustomerName;
        name = "Clevva Pipeline";
        repository = @{
            url = "https://bitbucket.org/clevva/clevva-compiled.git";
            defaultBranch = "master";
            id = "clevva/clevva-compiled";
            type = "Bitbucket";
            properties = @{
                connectedServiceId = "$servicePrincipalId"
            }
        };
        process = @{
            yamlFilename = "azure-pipelines.yml";
            type = 2;
        };
        path = "\\";
        type = "build";
    }
    
    $pipelineBody = ($jsonPipeline | ConvertTo-Json -Depth 3)
    Invoke-RestMethod -Uri $createPipeline -Headers $AzureDevOpsAuthenicationHeader -Body $pipelineBody -Method Post -ContentType application/json;
}