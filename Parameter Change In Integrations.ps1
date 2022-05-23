cd Informatica/Explore/ERP_Projects/JDE_ProjectCodes
        
    
$configFilesxml = Get-ChildItem . *.xml -rec
foreach ($file in $configFilesxml)
{
$xmlFile = Get-Content $file.Name 
$xmlFile |% { $_ -replace ([regex]::Escape("$env:IWFSFilePath")), "$env:FWFSFilePath" } | % { $_.Replace("$env:IGetErrorInfo1", "$env:FGetErrorInfo1") } | % { $_.Replace("$env:IGetErrorInfo2", "$env:FgetErrorInfo2") } | % { $_.Replace("$env:ISecureAgentGroup", "$env:FSecureAgent") } |% { $_.Replace("$env:IHostName" , "$env:FHostName") }|% { $_.Replace("$env:ILogServiceConnection", "$env:FLogServiceConnection") } |% { $_.Replace("$env:ISecureAgent", "$env:FSecureAgent") }|Set-Content $file.Name 
} 


$assetname = Get-ChildItem
if( $assetname.Name -eq "PF-JDE-FindPlanVersion-ProjPlanningResources.PROCESS.xml" )
{
$file = Get-Content .\PF-JDE-FindPlanVersion-ProjPlanningResources.PROCESS.xml
$file | % { $_.Replace("$env:FSecureAgent", "$env:FSecureAgentGroup") } | Set-Content .\PF-JDE-FindPlanVersion-ProjPlanningResources.PROCESS.xml
}

$assetname = Get-ChildItem
if( $assetname.Name -eq "C-JDE-FindPlanVersionId.AI_CONNECTION.xml" )
{
$file = Get-Content .\C-JDE-FindPlanVersionId.AI_CONNECTION.xml
$file | % { $_.Replace("$env:FSecureAgent", "$env:FSecureAgentGroup") } | Set-Content .\C-JDE-FindPlanVersionId.AI_CONNECTION.xml
}

$configFilesmtt = Get-ChildItem . *.MTT.zip
foreach ($file in $configFilesmtt)
{
Expand-Archive -LiteralPath $file.Name -DestinationPath $file.BaseName
Remove-Item -LiteralPath $file.Name
cd $file.BaseName
$jsonfile = Get-Content .\mtTask.json
$jsonfile | % { $_ -replace ([regex]::Escape("$env:IMTParameterFileDir")), "$env:FMTParameterFileDir" } |% { $_.Replace("$env:IProjectName", "$env:FProjectName") }|Set-Content .\mtTask.json
cd ..
$sourcefoldername = $file.BaseName
$destinationfoldername = $file.FullName
Compress-Archive -Path $sourcefoldername\* -DestinationPath $destinationfoldername -CompressionLevel NoCompression
Remove-Item -LiteralPath $file.BaseName -Force -Confirm:$false -Recurse
}