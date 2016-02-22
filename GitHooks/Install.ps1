# This assumes that the Install file is in a folder called GitHooks at the root of the repo
# It won't work if this isn't the case.

function BackupFileIfExists($file)
{
    if((Test-Path $file)) {
        $dateSuffix = (Get-Date).ToString("s").Replace(":","")
        $backupFile = "$file.backup.$dateSuffix"
        "copying file $file to $backupFile for backup"
        cp "$file" $backupFile
    }
}

$installFile = (Get-Item -Path ($MyInvocation.MyCommand.Path))
$gitHooksDir = $installFile.Directory
$gitHooksDirFullName = $installFile.Directory.FullName
Write-Host "GitHooks folder is at $gitHooksDirFullName"
$repoDir = $gitHooksDir.Parent.FullName
$commitMsgFile = "$repoDir\.git\hooks\commit-msg"
Write-Host "commit-msg file is '$commitMsgFile'"

BackupFileIfExists $commitMsgFile

# Was tempted to generate this file but git bash is super picky about encoding and stuff
#  so just copy across
$commitsMsgTemplate = "$gitHooksDirFullName\commit-msg"
cp $commitsMsgTemplate $commitMsgFile
