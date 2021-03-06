function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Product
    )

    Return @{
        Result = [string]$(& "$env:ProgramFiles\Microsoft\Web Platform Installer\WebPiCMD-x64.exe" /List /ListOption:Installed | Select-String -Pattern $Product)
    }
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Product,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [System.String]
        $OfflineXMLPath
    )

    if($OfflineXMLPath -ne $Null) {
        Write-Verbose "Installing $Product from Offline Path $OfflineXMLPath"
        & "$env:ProgramFiles\Microsoft\Web Platform Installer\WebPiCMD-x64.exe" /Install /Products:$Product /XML:$OfflineXMLPath /AcceptEula
    }
    else {
        Write-Verbose "Installing $Product from Internet Repository"
        & "$env:ProgramFiles\Microsoft\Web Platform Installer\WebPiCMD-x64.exe" /Install /Products:$Product /AcceptEula
    }
}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Product,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [System.String]
        $OfflineXMLPath
    )

    if(& "$env:ProgramFiles\Microsoft\Web Platform Installer\WebPiCMD-x64.exe" /List /ListOption:Installed | Select-String -Pattern $Product) {
        Write-Verbose "$Product Installed"
        Return $True
    }
    else {
        Write-Verbose "$Product Not Installed"
        Return $False
    }
}


Export-ModuleMember -Function *-TargetResource

