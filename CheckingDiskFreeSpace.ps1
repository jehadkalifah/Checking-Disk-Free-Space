$HostFile = $null
$ExportCsvFile = $null
$HostnameCount = $null
$ImportHostnames = $null
$Hostnames = @()
$WhileCounter = 0
$ExportToCsv = $null

Write-Host ("Enter a CSV file path to add required Hostnames: ") -ForegroundColor Green -NoNewline 
$HostFile = Read-Host

Write-Host ("Enter a CSV output file path to export the result: ") -ForegroundColor Green -NoNewline 
$ExportCsvFile = Read-Host

$HostnameCount = (Import-Csv -Path $HostFile | Measure-Object).Count
$ImportHostnames = Import-Csv -Path $HostFile
$ImportHostnames |   
ForEach-Object {
  $Hostnames += $_."System Name"
}

While ($WhileCounter -lt $HostnameCount){
 $ExportToCsv += @(Invoke-Command -ComputerName $Hostnames[$WhileCounter] -ScriptBlock {Get-PSDrive | ?{$_.Name -like "c"} | Select-Object -Property Name,@{Name="Used GB";Expression={[math]::round($_.used/1GB, 2)}},@{Name="Free GB";Expression={[math]::round($_.free/1GB, 2)}}})
 
 $WhileCounter++
}

$ExportToCsv | Sort-Object -Descending -Property "Free GB" | Export-Csv $ExportCsvFile