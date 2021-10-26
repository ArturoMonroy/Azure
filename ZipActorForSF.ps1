# Edit C# project and add the next Attribute in "PostBuild" (Build Events)
#   Condition="$(ConfigurationName) == Debug"
# Then add the Powershell call
#  Powershell -file $(SolutionDir)MyC#ActorProjectDir\ZipActorForSF.ps1 $(SolutionDir)

$SolutionDir = $args[0]
$RuleActor = $SolutionDir + "\MyServiceFabricProjectDir\"
$MyServiceFabricActor= "MyC#ActorProjectDir"

Write-Host "====Create package for Service fabric===="
dotnet msbuild "$RuleActor\MyRuleActorProject.sfproj" /t:Package /p:Configuration=Release /p:platform="x64";

Write-Host "====Move pkg dir and rename it===="
Move-Item $RuleActor\pkg\Release $RuleActor\$MyServiceFabricActor;

Write-Host "====Delete previous zip file===="
Remove-Item $RuleActor\$MyServiceFabricActor.zip;

Write-Host "====Zip the whole content===="
Compress-Archive $RuleActor\$MyServiceFabricActor\* $RuleActor\$MyServiceFabricActor.zip;

Write-Host "====Cleaning===="
Remove-Item $RuleActor\$MyServiceFabricActor -Recurse;