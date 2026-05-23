# Windows 11 Compatibility Checker
# Run PowerShell as Administrator

Write-Host "==============================="
Write-Host " Windows 11 Compatibility Check "
Write-Host "==============================="
Write-Host ""

# ----- TPM CHECK -----
Write-Host "Checking TPM..."

try {
    $tpm = Get-Tpm

    if ($tpm.TpmPresent) {
        Write-Host "TPM Present: YES"

        if ($tpm.SpecVersion -match "2.0") {
            Write-Host "TPM Version: 2.0 (PASS)"
        }
        else {
            Write-Host "TPM Version: NOT 2.0 (FAIL)"
        }

        Write-Host "TPM Ready: $($tpm.TpmReady)"
    }
    else {
        Write-Host "TPM Present: NO (FAIL)"
    }
}
catch {
    Write-Host "Unable to retrieve TPM information."
}

Write-Host ""

# ----- SECURE BOOT CHECK -----
Write-Host "Checking Secure Boot..."

try {
    $secureBoot = Confirm-SecureBootUEFI

    if ($secureBoot -eq $true) {
        Write-Host "Secure Boot: ENABLED (PASS)"
    }
    else {
        Write-Host "Secure Boot: DISABLED (FAIL)"
    }
}
catch {
    Write-Host "Secure Boot: Not Supported or Legacy BIOS detected (FAIL)"
}

Write-Host ""

# ----- RAM CHECK -----
Write-Host "Checking RAM..."

$ramGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)

Write-Host "Installed RAM: $ramGB GB"

if ($ramGB -ge 4) {
    Write-Host "RAM Requirement: PASS"
}
else {
    Write-Host "RAM Requirement: FAIL"
}

Write-Host ""

# ----- STORAGE CHECK -----
Write-Host "Checking Storage..."

$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$freeGB = [math]::Round($disk.Size / 1GB, 2)

Write-Host "Drive Size: $freeGB GB"

if ($freeGB -ge 64) {
    Write-Host "Storage Requirement: PASS"
}
else {
    Write-Host "Storage Requirement: FAIL"
}

Write-Host ""

# ----- CPU CHECK -----
Write-Host "Checking CPU..."

$cpu = Get-CimInstance Win32_Processor

Write-Host "Processor: $($cpu.Name)"
Write-Host "Cores: $($cpu.NumberOfCores)"
Write-Host "Clock Speed: $($cpu.MaxClockSpeed) MHz"

if ($cpu.NumberOfCores -ge 2 -and $cpu.MaxClockSpeed -ge 1000) {
    Write-Host "CPU Basic Requirement: PASS"
}
else {
    Write-Host "CPU Basic Requirement: FAIL"
}

Write-Host ""

# ----- BOOT MODE CHECK -----
Write-Host "Checking BIOS Mode..."

try {
    $secureBoot = Confirm-SecureBootUEFI
    Write-Host "Boot Mode: UEFI (PASS)"
}
catch {
    Write-Host "Boot Mode: Legacy BIOS (FAIL)"
}

Write-Host ""

# ----- FINAL MESSAGE -----
Write-Host "==============================="
Write-Host " Compatibility Check Complete "
Write-Host "==============================="