param([string] $repoRootDir)

function BackupFileIfExists($file)
{
    if((Test-Path $file)) {
        $dateSuffix = (Get-Date).ToString("s").Replace(":","")
        $backupFile = "$file.backup.$dateSuffix"
        "copying file $file to $backupFile for backup"
        cp "$file" $backupFile
    }
}

$repoRootDir = "C:\Dev\GitHooks"

$commitMsgFile = "$repoRootDir\.git\hooks\commit-msg"
Write-Host "Commit-msg file is at $commitMsgFile"

$gitHooksDir = (Get-Item -Path ($MyInvocation.MyCommand.Path)).Directory.FullName
Write-Host "GitHooks folder is at $gitHooksDir"

BackupFileIfExists $commitMsgFile

$commitReplaceScriptFile = "$gitHooksDir\CommitMessageReplace.ps1"

# Was tempted to generate this file but git bash is super picky about encoding and stuff
#  so just copy across
$commitsMsgTemplate = "$gitHooksDir\commit-msg"
cp $commitsMsgTemplate $commitMsgFile
