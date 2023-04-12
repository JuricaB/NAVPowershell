$user = ""
#$token = $env:SYSTEM_ACCESSTOKEN #use this in a build pieline
$token = "<PAT>" #https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))
#$orgUrl = $env:SYSTEM_COLLECTIONURI #use this in a build pieline
$orgUrl = "https://dev.azure.com/theta-dyn365"
#$teamProject = $env:SYSTEM_TEAMPROJECT #use this in a build pieline
$teamProject = "DevOps"
#$repoName = $env:BUILD_REPOSITORY_NAME #use this in a build pieline
$repoName = "erp-ext-root"

$removeWithAhead = $false # update to $true to remove branches with not delivered commits

$restApiGetHeads = "$orgUrl/$teamProject/_apis/git/repositories/$repoName/refs?filter=heads/&api-version=6.1-preview.1"
$restApiGetCommit = "$orgUrl/$teamProject/_apis/git/repositories/$repoName/commits/{commitId}?api-version=6.1-preview.1"
$restApiGetDiff = "$orgUrl/$teamProject/_apis/git/repositories/$repoName/diffs/commits?baseVersion=master&targetVersion={branchname}&api-version=6.1-preview.1"
$restApiGetPolicies = "$orgUrl/$teamProject/_apis/git/policy/configurations?repositoryId={repoId}&refName={refName}&api-version=6.1-preview.1"
$restApiGetRepo = "$orgUrl/$teamProject/_apis/git/repositories/$repoName"+"?api-version=5.0"

function InvokeGetRequest ($GetUrl)
{    
    return Invoke-RestMethod -Uri $GetUrl -Method Get -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}    
}

function ReplaceSpecialCharacters([string] $itemName)
{
    #replace special characters for url

    $itemNameUrl = $itemName.Replace('$', '%24') 
    $itemNameUrl = $itemNameUrl.Replace('&', '%26') 
    $itemNameUrl = $itemNameUrl.Replace('+', '%2B') 
    $itemNameUrl = $itemNameUrl.Replace(',', '%2C') 
    $itemNameUrl = $itemNameUrl.Replace(':', '%3A') 
    $itemNameUrl = $itemNameUrl.Replace(';', '%3B') 
    $itemNameUrl = $itemNameUrl.Replace('=', '%3D') 
    $itemNameUrl = $itemNameUrl.Replace('?', '%3F') 
    $itemNameUrl = $itemNameUrl.Replace('@', '%40') 

    return $itemNameUrl
}

function ListRemovableBranches
{
    $dtNow = Get-Date
    #Set the date to compare
    $dtFilter = $dtNow.AddDays(-180)

    #Get all branches
    $branches = InvokeGetRequest $restApiGetHeads

    Write-Host "Total Branches count" $branches.count

    Write-Host $branches

    foreach ($branch in $branches.value)
    {
        #The default remove status
        $removeStatus = "NO"
        
        #Get the last commit info
        $cmturl =  $restApiGetCommit.Replace("{commitId}", $branch.objectId)
        $cmt = InvokeGetRequest $cmturl
           
        Write-Host "BRANCH" $branch.name $cmt.committer.date $cmt.committer.name
        $branchDate = [DateTime] $cmt.committer.date

        #Process a branch to the resulting list if the last commit date in our scope
        if ($dtFilter -gt $branchDate)
        {            
            $removeStatus = "YES"
            Write-Host "Check branch" $branch.name
            $branchShortName = $branch.name.Replace("refs/heads/", "")

            if ($true -eq $branch.isLocked)            
            {
                #A branch is locked - do not remove
                $removeStatus = "LOCKED"
            }
            else {
                #Get branch policies
                $branchPUrl = $restApiGetPolicies -replace "{refName}", $branch.name
                
                $branchPolicies = InvokeGetRequest $branchPUrl

                if ($branchPolicies.Count -gt 0)
                {
                    #A branch contains policies - do not remove
                    $removeStatus = "POLICIES"
                }
            }

            if ($removeStatus -eq "YES" -and $removeWithAhead -eq $false)
            {
                #Get behind/ahead to master
                $branchShortNameUrl = ReplaceSpecialCharacters $branchShortName
                $diffUrl = $restApiGetDiff.Replace("{branchname}", $branchShortNameUrl) 
                $diffRes = InvokeGetRequest $diffUrl            
                
                if ($diffRes.aheadCount -gt 0)
                {
                    $removeStatus = "AHEAD " + $diffRes.aheadCount
                }
            }

            if ($removeStatus -eq "YES")
            {
                Write-Host "Branch can be removed $branchShortName"

            } 
            else {
                Write-Host "Branch can not be removed $branchShortName $removeStatus"
            }                                        
        }
    }
}

#get the repo id to use in the get policies request
$repoInfo = InvokeGetRequest $restApiGetRepo
$restApiGetPolicies = $restApiGetPolicies -replace "{repoId}", $repoInfo.id

ListRemovableBranches
