function Get-LastLoggedOnUser
{
    [CmdletBinding()]
    param([Parameter(
        Mandatory=$true,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true
        )]
        [string]$ComputerName = 'None'
        )

    Begin{
        $nonUsers = @('ProxySSIS','Public')
    }

    Process{
        try {
            if (Test-netconnection -ComputerName $ComputerName -InformationLevel Quiet -WarningAction SilentlyContinue) {
                $loggedOnUsers = Get-ChildItem \\$ComputerName\c$\Users -Directory | Sort-Object LastWriteTime -Descending
        
                $loggedOnUsers | Foreach-Object {if($nonUsers -NotContains $_.Name){$_.Name}} | Select-Object -First 1
            }

            else {
                "$ComputerName is not pingable"
            }
        }
        catch {
            $_
        }
    }

    End{}
}

