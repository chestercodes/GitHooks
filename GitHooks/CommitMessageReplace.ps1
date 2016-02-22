param([string] $commitFile=$null)

cd C:\Dev\

function com
{
    param([string]$commitFile)

    $messageFileContent = Get-Content ($commitFile)

    $jiraItemRegex = "^feature\/[A-Za-z0-9]+(\-|_)\d+"
    $currentBranch = git rev-parse --abbrev-ref HEAD
    
    # Only do things if is a feature branch
    if($currentBranch -match $jiraItemRegex)
    {
        $jiraItem = $Matches[0].Replace("feature/", "")
        $isOneLine = $messageFileContent -is [String]
        
        # Check isn't merge commit
        if($isOneLine){ 
            $firstLine = $messageFileContent 
        } else { 
            $firstLine = $messageFileContent[0] 
        }
        
        if($firstLine.StartsWith("Merge"))
        {
            return
        }

        # Make new message first line
        if($firstLine.StartsWith($jiraItem))
        {
            $msg = $firstLine
        }else {
            $msg = "$jiraItem`: $firstLine"
        }
        
        # Add first line to message
        if($isOneLine)
        {
            $newCommitMessage = $msg
        }
        else
        {
            $messageFileContent[0] = $msg
            $newCommitMessage = $messageFileContent
        }

        # Write to file.
        "Set-Content $commitFile $newCommitMessage"
    }
    else
    {
        "Branch '$currentBranch' doesn't match JIRA item regex"
    }
}

com ".git\COMMIT_EDITMSG"