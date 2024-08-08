function Push-CIPPStandard {
    <#
    .FUNCTIONALITY
        Entrypoint
    #>
    param (
        $Item
    )

    Write-Host "Received queue item for $($Item.Tenant) and standard $($Item.Standard)."
    $Tenant = $Item.Tenant
    $Standard = $Item.Standard
    $FunctionName = 'Invoke-CIPPStandard{0}' -f $Standard
    Write-Host "We'll be running $FunctionName"
    $Rerun = Test-CIPPRerun -Type Standard -Tenant $Tenant -Settings $Settings -API $Standard
    if ($Rerun) {
        Write-Host 'Detected rerun. Exiting cleanly'
        exit 0
    } else {
        Write-Host "Rerun is set to true. We'll be running $FunctionName"
    }
    try {
        & $FunctionName -Tenant $Item.Tenant -Settings $Item.Settings -ErrorAction Stop
    } catch {
        throw $_.Exception.Message
    }
}
