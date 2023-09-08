$Mal_Path = "C:\Users\TestFire\Documents\malware2"
$Executables = @(".exe",".bat",".vbs",".com",".jar",".hta")
$LogStamp = Get-Date -Format "MM-dd-yyyy_HH-mm"
$Log_File = "$PSScriptRoot\Mal-Logs_$LogStamp.txt"

Function Confirm-Requirements {
    param(
        [String]$Log
    )
    $mods = Get-InstalledModule
    $module_installed = $false
    foreach($modu in $mods){
        if($modu.Name -eq "7Zip4Powershell"){
            Write-Output "7Zip Module already installed"
            "7Zip Module already installed" | Out-File -FilePath $Log -Append
            $module_installed = $true
            Break
        }
    }
    if(!$module_installed){
        Install-Module -Name 7Zip4Powershell
    }
}

Function Set-ExtractedMalware{
    param(
        [String]$MainFolder,
        [String]$Log
    )
    $Mal_Folders = Get-ChildItem -Path $MainFolder
    foreach ($folder in $Mal_Folders) {
        # Fetching zip folder to extract and password needed to extract
        $zip = Get-ChildItem -Path "$MainFolder\$($folder.Name)" | Where-Object{$_.Name -like "*.zip"}
        $pass_file = Get-ChildItem -Path "$MainFolder\$($folder.Name)" | Where-Object{$_.Name -like "*.pass"}
        $pass = Get-Content -Path $pass_file.FullName
        $pass = $pass.Trim()
        # Checking to see if malware has already been extracted. (Extracted folder is name after malware)
        $extracted = Test-Path -Path "$($folder.FullName)\$($folder.Name)"
        if($extracted){
            Write-Output "$($folder.Name) Malware Already Extracted. Continuing to next folder."
            "$($folder.Name) Malware Already Extracted. Continuing to next folder." | Out-File -FilePath $Log -Append
        }else{
            Write-Output "Extracting $($folder.Name) malware."
            "Extracting $($folder.Name) malware." | Out-File -FilePath $Log -Append
            Expand-7Zip -ArchiveFileName $zip.FullName -TargetPath "$MainFolder\$($folder.Name)\$($folder.Name)" -Password $pass
            Start-Sleep -Seconds 2
        }
    }
}

Function Start-Malware{
    param(
        [String]$MainFolder,
        [String]$Log
    )
    $Mal_Folders = Get-ChildItem -Path $MainFolder
    $total_files_to_run = 0
    $malware_ran = 0
    foreach($folder in $Mal_Folders){
        $temp_mal_folder = "$MainFolder\$($folder.Name)\$($folder.Name)"
        $extracted_mal = Test-Path -Path $temp_mal_folder
        # making sure files extracted successfully before trying to read files to prevent errors
        if($extracted_mal){
            $temp_mal_files = Get-ChildItem -Path $temp_mal_folder
            # I'll clean this block up later. Looping over extracted files and looking for malware executables
            #  or scripts to run.
            foreach ($file in $temp_mal_files) {
                Write-Output "$temp_mal_folder\$file"
                switch -Wildcard ($file.Name) {
                    "*$($Executables[0])" {
                        try{
                            Start-Process $file.FullName -ErrorAction Stop
                            Write-Warning "$($file.Name) Malware Ran!"
                            "$($file.Name) Malware Ran!" | Out-File -FilePath $Log -Append
                            $malware_ran += 1
                        }catch{
                            Write-Output "$($file.Name) Malware Stopped."
                            "$($file.Name) Malware Stopped." | Out-File -FilePath $Log -Append
                        }
                        $total_files_to_run += 1
                    }
                    "*$($Executables[1])" {
                        try{
                            Start-Process $file.FullName -ErrorAction Stop
                            Write-Warning "$($file.Name) Malware Ran!"
                            "$($file.Name) Malware Ran!" | Out-File -FilePath $Log -Append
                            $malware_ran += 1
                        }catch{
                            Write-Output "$($file.Name) Malware Stopped."
                            "$($file.Name) Malware Stopped." | Out-File -FilePath $Log -Append
                        }
                        $total_files_to_run += 1
                    }
                    "*$($Executables[2])" {
                        try{
                            Start-Process $file.FullName -ErrorAction Stop
                            Write-Warning "$($file.Name) Malware Ran!"
                            "$($file.Name) Malware Ran!" | Out-File -FilePath $Log -Append
                            $malware_ran += 1
                        }catch{
                            Write-Output "$($file.Name) Malware Stopped."
                            "$($file.Name) Malware Stopped." | Out-File -FilePath $Log -Append
                        }
                        $total_files_to_run += 1
                    }
                    "*$($Executables[3])" {
                        try{
                            Start-Process $file.FullName -ErrorAction Stop
                            Write-Warning "$($file.Name) Malware Ran!"
                            "$($file.Name) Malware Ran!" | Out-File -FilePath $Log -Append
                            $malware_ran += 1
                        }catch{
                            Write-Output "$($file.Name) Malware Stopped."
                            "$($file.Name) Malware Stopped." | Out-File -FilePath $Log -Append
                        }
                        $total_files_to_run += 1
                    }
                    "*$($Executables[4])" {
                        try{
                            Start-Process $file.FullName -ErrorAction Stop
                            Write-Warning "$($file.Name) Malware Ran!"
                            "$($file.Name) Malware Ran!" | Out-File -FilePath $Log -Append
                            $malware_ran += 1
                        }catch{
                            Write-Output "$($file.Name) Malware Stopped."
                            "$($file.Name) Malware Stopped." | Out-File -FilePath $Log -Append
                        }
                        $total_files_to_run += 1
                    }
                    "*$($Executables[5])" {
                        try{
                            Start-Process $file.FullName -ErrorAction Stop
                            Write-Warning "$($file.Name) Malware Ran!"
                            "$($file.Name) Malware Ran!" | Out-File -FilePath $Log -Append
                            $malware_ran += 1
                        }catch{
                            Write-Output "$($file.Name) Malware Stopped."
                            "$($file.Name) Malware Stopped." | Out-File -FilePath $Log -Append
                        }
                        $total_files_to_run += 1
                    }
                    Default {
                        Write-Output "Unable to run $($file.Name)"
                        "Unable to run $($file.Name)" | Out-File -FilePath $Log -Append
                    }
                }
                Start-Sleep -Seconds 5
                # Displaying current results at the end of each loop
                Write-Output "Total files attempted to run: $total_files_to_run"
                Write-Output "Total malware files executed: $malware_ran"
                "Total files attempted to run: $total_files_to_run" | Out-File -FilePath $Log -Append
                "Total malware files executed: $malware_ran" | Out-File -FilePath $Log -Append
            }
        }
    }
    # Outputing complete results and logging to file
    Write-Output "Total files attempted to run: $total_files_to_run"
    Write-Output "Total malware files executed: $malware_ran"
    "Total files attempted to run: $total_files_to_run" | Out-File -FilePath $Log -Append
    "Total malware files executed: $malware_ran" | Out-File -FilePath $Log -Append
}

Confirm-Requirements -Log $Log_File
Set-ExtractedMalware -MainFolder $Mal_Path -Log $Log_File
Start-Malware -MainFolder $Mal_Path -Log $Log_File