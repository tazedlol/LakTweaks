
Add-Type -AssemblyName PresentationCore,PresentationFramework,WindowsBase,System.Xaml
$ErrorActionPreference = 'Stop'
function Test-Admin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p = [Security.Principal.WindowsPrincipal]::new($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
function Ensure-Admin {
    if (Test-Admin) { return }

    $msg = 'Run PowerShell as Administrator, then launch LakTweaks again.'
    [System.Windows.MessageBox]::Show($msg, 'LakTweaks', 'OK', 'Warning') | Out-Null
    throw 'Administrator privileges are required to apply tweaks.'
}
$script:Catalog = @'
[
  {
    "CategoryId": "fortnite",
    "Category": "FORTNITE FPS / PERFORMANCE",
    "Id": "hwsched",
    "Title": "Hardware GPU Scheduling",
    "Description": "Enables HAGS to reduce CPU overhead in games.",
    "Command": ":: === Hardware GPU Scheduling (HAGS) ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\GraphicsDrivers\" /v \"HwSchMode\" /t REG_DWORD /d 2 /f >nul 2>&1\necho [OK] Hardware GPU Scheduling enabled"
  },
  {
    "CategoryId": "fortnite",
    "Category": "FORTNITE FPS / PERFORMANCE",
    "Id": "gamepriority",
    "Title": "Game CPU Priority",
    "Description": "Sets Multimedia SystemProfile game priorities for better responsiveness.",
    "Command": ":: === Game CPU/GPU Priority (Multimedia SystemProfile) ===\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Multimedia\\\\SystemProfile\" /v \"NetworkThrottlingIndex\" /t REG_DWORD /d 4294967295 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Multimedia\\\\SystemProfile\" /v \"SystemResponsiveness\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Multimedia\\\\SystemProfile\\\\Tasks\\\\Games\" /v \"Affinity\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Multimedia\\\\SystemProfile\\\\Tasks\\\\Games\" /v \"Background Only\" /t REG_SZ /d \"False\" /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Multimedia\\\\SystemProfile\\\\Tasks\\\\Games\" /v \"Clock Rate\" /t REG_DWORD /d 10000 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Multimedia\\\\SystemProfile\\\\Tasks\\\\Games\" /v \"GPU Priority\" /t REG_DWORD /d 8 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Multimedia\\\\SystemProfile\\\\Tasks\\\\Games\" /v \"Priority\" /t REG_DWORD /d 6 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Multimedia\\\\SystemProfile\\\\Tasks\\\\Games\" /v \"Scheduling Category\" /t REG_SZ /d \"High\" /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Multimedia\\\\SystemProfile\\\\Tasks\\\\Games\" /v \"SFIO Priority\" /t REG_SZ /d \"High\" /f >nul 2>&1\necho [OK] Game CPU/GPU priority set"
  },
  {
    "CategoryId": "fortnite",
    "Category": "FORTNITE FPS / PERFORMANCE",
    "Id": "gamedvr",
    "Title": "Disable GameDVR / GameBar",
    "Description": "Turns off Game Bar and capture overhead.",
    "Command": ":: === Disable GameDVR / GameBar / Capture ===\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\GameBar\" /v \"UseNexusForGameBarEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\GameBar\" /v \"ShowStartupPanel\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\GameBar\" /v \"AutoGameModeEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\GameBar\" /v \"AllowAutoGameMode\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\\\System\\\\GameConfigStore\" /v \"GameDVR_Enabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\\\System\\\\GameConfigStore\" /v \"GameDVR_FSEBehaviorMode\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\\\System\\\\GameConfigStore\" /v \"GameDVR_FSEBehavior\" /t REG_DWORD /d 2 /f >nul 2>&1\nreg add \"HKCU\\\\System\\\\GameConfigStore\" /v \"GameDVR_HonorUserFSEBehaviorMode\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\\\System\\\\GameConfigStore\" /v \"GameDVR_DXGIHonorFSEWindowsCompatible\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\\\System\\\\GameConfigStore\" /v \"GameDVR_EFSEFeatureFlags\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\GameDVR\" /v \"AppCaptureEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\GameDVR\" /v \"AllowGameDVR\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\PolicyManager\\\\default\\\\ApplicationManagement\\\\AllowGameDVR\" /v \"value\" /t REG_SZ /d \"00000000\" /f >nul 2>&1\ntaskkill /f /im GameBar.exe >nul 2>&1\ntaskkill /f /im GameBarFTServer.exe >nul 2>&1\necho [OK] GameDVR/GameBar disabled"
  },
  {
    "CategoryId": "fortnite",
    "Category": "FORTNITE FPS / PERFORMANCE",
    "Id": "powerthrottle",
    "Title": "Disable Power Throttling",
    "Description": "Keeps game workloads from being power-throttled.",
    "Command": ":: === Disable Power Throttling ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Power\\\\PowerThrottling\" /v \"PowerThrottlingOff\" /t REG_DWORD /d 1 /f >nul 2>&1\necho [OK] Power throttling disabled"
  },
  {
    "CategoryId": "fortnite",
    "Category": "FORTNITE FPS / PERFORMANCE",
    "Id": "netthrottle",
    "Title": "Disable Network Throttling",
    "Description": "Removes MMCSS network throttling limits.",
    "Command": ":: === Disable Network Throttling ===\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Multimedia\\\\SystemProfile\" /v \"NetworkThrottlingIndex\" /t REG_DWORD /d 4294967295 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Multimedia\\\\SystemProfile\" /v \"SystemResponsiveness\" /t REG_DWORD /d 0 /f >nul 2>&1\necho [OK] Network throttling disabled"
  },
  {
    "CategoryId": "fortnite",
    "Category": "FORTNITE FPS / PERFORMANCE",
    "Id": "hyperv",
    "Title": "Disable Hyper-V / Dynamic Tick",
    "Description": "Disables extra virtualization and timing overhead.",
    "Command": ":: === Disable Hyper-V / Dynamic Tick / TSC ===\nbcdedit /set disabledynamictick yes >nul 2>&1\nbcdedit /set hypervisorlaunchtype off >nul 2>&1\necho [OK] Hyper-V and dynamic tick disabled"
  },
  {
    "CategoryId": "fortnite",
    "Category": "FORTNITE FPS / PERFORMANCE",
    "Id": "prefetch",
    "Title": "Disable Prefetch / Superfetch",
    "Description": "Reduces background disk reads on SSD systems.",
    "Command": ":: === Disable Prefetch / Superfetch ===\nreg add \"HKLM\\\\SYSTEM\\\\ControlSet001\\\\Control\\\\Session Manager\\\\Memory Management\\\\PrefetchParameters\" /v \"EnablePrefetcher\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\\\\PrefetchParameters\" /v \"EnablePrefetcher\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\\\\PrefetchParameters\" /v \"EnableSuperfetch\" /t REG_DWORD /d 0 /f >nul 2>&1\necho [OK] Prefetch/Superfetch disabled"
  },
  {
    "CategoryId": "fortnite",
    "Category": "FORTNITE FPS / PERFORMANCE",
    "Id": "memopt",
    "Title": "Memory Manager Optimization",
    "Description": "Applies memory manager tweaks aimed at gaming performance.",
    "Command": ":: === Memory Manager Optimization ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\" /v \"ClearPageFileAtShutdown\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\" /v \"DisablePagingExecutive\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\" /v \"LargeSystemCache\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\" /v \"NonPagedPoolQuota\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\" /v \"NonPagedPoolSize\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\" /v \"SessionViewSize\" /t REG_DWORD /d 192 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\" /v \"SystemPages\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\" /v \"SecondLevelDataCache\" /t REG_DWORD /d 3072 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\" /v \"SessionPoolSize\" /t REG_DWORD /d 192 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\" /v \"PagedPoolSize\" /t REG_DWORD /d 192 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\" /v \"PagedPoolQuota\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\" /v \"PhysicalAddressExtension\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\" /v \"IoPageLockLimit\" /t REG_DWORD /d 1048576 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\" /v \"PoolUsageMaximum\" /t REG_DWORD /d 96 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\" /v \"FeatureSettingsOverride\" /t REG_DWORD /d 3 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\" /v \"FeatureSettingsOverrideMask\" /t REG_DWORD /d 3 /f >nul 2>&1\necho [OK] Memory manager optimized"
  },
  {
    "CategoryId": "fortnite",
    "Category": "FORTNITE FPS / PERFORMANCE",
    "Id": "win32pri",
    "Title": "Win32 Priority Separation",
    "Description": "Boosts foreground app scheduling.",
    "Command": ":: === Win32 Priority Separation ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\PriorityControl\" /v \"Win32PrioritySeparation\" /t REG_DWORD /d 38 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\PriorityControl\" /v \"ConvertibleSlateMode\" /t REG_DWORD /d 0 /f >nul 2>&1\necho [OK] Win32 priority separation set to 38"
  },
  {
    "CategoryId": "fortnite",
    "Category": "FORTNITE FPS / PERFORMANCE",
    "Id": "tscsync",
    "Title": "TSC Sync",
    "Description": "Sets enhanced TSC sync policy.",
    "Command": ":: === TSC Sync Policy ===\nbcdedit /set tscsyncpolicy Enhanced >nul 2>&1\necho [OK] TSC sync policy set to Enhanced"
  },
  {
    "CategoryId": "fortnite",
    "Category": "FORTNITE FPS / PERFORMANCE",
    "Id": "msimode",
    "Title": "MSI Mode for GPU",
    "Description": "Enables MSI interrupt mode for supported GPUs.",
    "Command": ":: === MSI Mode for GPU (Flipz Elite Tuning inspired) ===\n:: Enables Message Signaled Interrupts on GPU for lower latency\nfor /f \"tokens=*\" %%i in ('wmic path win32_videocontroller get pnpdeviceid ^| findstr /i \"PCI\\\\VEN\"') do (\n    reg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Enum\\\\%%i\\\\Device Parameters\\\\Interrupt Management\\\\MessageSignaledInterruptProperties\" /v \"MSISupported\" /t REG_DWORD /d 1 /f >nul 2>&1\n    reg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Enum\\\\%%i\\\\Device Parameters\\\\Interrupt Management\\\\Affinity Policy\" /v \"DevicePolicy\" /t REG_DWORD /d 4 /f >nul 2>&1\n    reg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Enum\\\\%%i\\\\Device Parameters\\\\Interrupt Management\\\\Affinity Policy\" /v \"AssignmentSetOverride\" /t REG_BINARY /d 01 /f >nul 2>&1\n)\necho [OK] GPU MSI Mode enabled"
  },
  {
    "CategoryId": "fortnite",
    "Category": "FORTNITE FPS / PERFORMANCE",
    "Id": "cpupark",
    "Title": "Disable CPU Core Parking",
    "Description": "Keeps CPU cores awake during gameplay.",
    "Command": ":: === Disable CPU Core Parking ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Power\\\\PowerSettings\\\\54533251-82be-4824-96c1-47b60b740d00\\\\0cc5b647-c1df-4637-891a-dec35c318583\" /v \"ValueMax\" /t REG_DWORD /d 0 /f >nul 2>&1\npowercfg /setacvalueindex scheme_current 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 0 >nul 2>&1\npowercfg /setdcvalueindex scheme_current 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 0 >nul 2>&1\npowercfg /setactive scheme_current >nul 2>&1\necho [OK] CPU core parking disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "telemetry",
    "Title": "Disable Telemetry Services",
    "Description": "Stops telemetry-related services and background collection.",
    "Command": ":: === Disable Telemetry Services ===\nfor %%S in (DiagTrack dmwappushservice diagnosticshub.standardcollector.service SensorDataService SensrSvc SensorService) do (\n    sc stop %%S >nul 2>&1\n    sc config %%S start= disabled >nul 2>&1\n)\necho [OK] Telemetry services disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "wupdate",
    "Title": "Disable Windows Update",
    "Description": "Stops Windows Update-related services.",
    "Command": ":: === Disable Windows Update Services ===\nfor %%S in (wuauserv UsoSvc WaaSMedicSvc DoSvc BITS) do (\n    sc stop %%S >nul 2>&1\n    sc config %%S start= disabled >nul 2>&1\n)\necho [OK] Windows Update services disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "search",
    "Title": "Disable Windows Search",
    "Description": "Turns off the Search service and related processes.",
    "Command": ":: === Disable Windows Search ===\nsc stop WSearch >nul 2>&1\nsc config WSearch start= disabled >nul 2>&1\ntaskkill /f /im SearchHost.exe >nul 2>&1\ntaskkill /f /im SearchApp.exe >nul 2>&1\ntaskkill /f /im SearchIndexer.exe >nul 2>&1\ntaskkill /f /im SearchProtocolHost.exe >nul 2>&1\ntaskkill /f /im SearchFilterHost.exe >nul 2>&1\necho [OK] Windows Search disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "sysmain",
    "Title": "Disable SysMain",
    "Description": "Disables SysMain / Superfetch.",
    "Command": ":: === Disable SysMain ===\nsc stop SysMain >nul 2>&1\nsc config SysMain start= disabled >nul 2>&1\necho [OK] SysMain disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "xbox",
    "Title": "Disable Xbox Services",
    "Description": "Disables Xbox and Game Bar support services.",
    "Command": ":: === Disable Xbox Services ===\nfor %%S in (XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc BcastDVRUserService) do (\n    sc stop %%S >nul 2>&1\n    sc config %%S start= disabled >nul 2>&1\n)\necho [OK] Xbox services disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "print",
    "Title": "Disable Print Spooler",
    "Description": "Turns off printer services if you do not need them.",
    "Command": ":: === Disable Print Spooler ===\nsc stop Spooler >nul 2>&1\nsc config Spooler start= disabled >nul 2>&1\nsc stop PrintNotify >nul 2>&1\nsc config PrintNotify start= disabled >nul 2>&1\necho [OK] Print spooler disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "bluetooth",
    "Title": "Disable Bluetooth Services",
    "Description": "Turns off Bluetooth services if unused.",
    "Command": ":: === Disable Bluetooth Services ===\nfor %%S in (bthserv BluetoothUserService BTAGService BthAvctpSvc) do (\n    sc stop %%S >nul 2>&1\n    sc config %%S start= disabled >nul 2>&1\n)\necho [OK] Bluetooth services disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "defender",
    "Title": "Disable Windows Defender",
    "Description": "Disables Defender-related services and checks.",
    "Command": ":: === Disable Windows Defender (GAMING MODE) ===\n:: WARNING: Only on dedicated gaming rigs with other AV or trusted environment\nsc stop WinDefend >nul 2>&1\nsc config WinDefend start= disabled >nul 2>&1\nsc stop SecurityHealthService >nul 2>&1\nsc config SecurityHealthService start= disabled >nul 2>&1\nsc stop WdNisSvc >nul 2>&1\nsc config WdNisSvc start= disabled >nul 2>&1\necho [OK] Windows Defender disabled"
  },

  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "diagstack",
    "Title": "Disable Diagnostic Stack Services",
    "Description": "Disables Diagnostic Execution, Policy, Service Host, and System Host services for a leaner background footprint.",
    "Command": ":: === Disable Diagnostic Stack Services ===
for %%S in (DiagSvc DPS WdiServiceHost WdiSystemHost) do (
    sc stop %%S >nul 2>&1
    sc config %%S start= disabled >nul 2>&1
)
echo [OK] Diagnostic stack services disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "filehistory",
    "Title": "Disable File History Service",
    "Description": "Disables the File History service if you do not use Windows File History backups.",
    "Command": ":: === Disable File History ===
sc stop fhsvc >nul 2>&1
sc config fhsvc start= disabled >nul 2>&1
echo [OK] File History service disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "autotimezone",
    "Title": "Disable Auto Time Zone Updater",
    "Description": "Disables automatic time zone detection if you do not need Windows to switch zones automatically.",
    "Command": ":: === Disable Auto Time Zone Updater ===
sc stop tzautoupdate >nul 2>&1
sc config tzautoupdate start= disabled >nul 2>&1
echo [OK] Auto Time Zone Updater disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "branchcache",
    "Title": "Disable BranchCache",
    "Description": "Disables the enterprise BranchCache service on home or gaming systems.",
    "Command": ":: === Disable BranchCache ===
sc stop PeerDistSvc >nul 2>&1
sc config PeerDistSvc start= disabled >nul 2>&1
echo [OK] BranchCache disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "sensorstack",
    "Title": "Disable Sensor Services",
    "Description": "Disables sensor-related services on desktops that do not use auto-brightness, motion, or orientation sensors.",
    "Command": ":: === Disable Sensor Services ===
for %%S in (SensorDataService SensorMonitoringService SensorService SensrSvc) do (
    sc stop %%S >nul 2>&1
    sc config %%S start= disabled >nul 2>&1
)
echo [OK] Sensor services disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "devicediscovery",
    "Title": "Disable Device Discovery Services",
    "Description": "Disables SSDP, UPnP, and Function Discovery publication services if you do not use local-network device discovery.",
    "Command": ":: === Disable Device Discovery Services ===
for %%S in (SSDPSRV upnphost FDResPub fdPHost) do (
    sc stop %%S >nul 2>&1
    sc config %%S start= disabled >nul 2>&1
)
echo [OK] Device discovery services disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "peernetwork",
    "Title": "Disable Peer Networking Services",
    "Description": "Disables legacy peer networking services that are usually unnecessary on gaming PCs.",
    "Command": ":: === Disable Peer Networking Services ===
for %%S in (p2pimsvc p2psvc PNRPsvc PNRPAutoReg) do (
    sc stop %%S >nul 2>&1
    sc config %%S start= disabled >nul 2>&1
)
echo [OK] Peer networking services disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "linklayer",
    "Title": "Disable Link-Layer Discovery",
    "Description": "Disables Link-Layer Topology Discovery Mapper and Responder services.",
    "Command": ":: === Disable Link-Layer Discovery ===
for %%S in (lltdsvc rspndr) do (
    sc stop %%S >nul 2>&1
    sc config %%S start= disabled >nul 2>&1
)
echo [OK] Link-layer discovery services disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "biometric",
    "Title": "Disable Biometric Service",
    "Description": "Disables Windows Biometric Service if you do not use fingerprint or facial sign-in.",
    "Command": ":: === Disable Windows Biometric Service ===
sc stop WbioSrvc >nul 2>&1
sc config WbioSrvc start= disabled >nul 2>&1
echo [OK] Windows Biometric Service disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "mobilehotspot",
    "Title": "Disable Mobile Hotspot Service",
    "Description": "Disables the Windows Mobile Hotspot service if you never share your connection from this PC.",
    "Command": ":: === Disable Mobile Hotspot Service ===
sc stop icssvc >nul 2>&1
sc config icssvc start= disabled >nul 2>&1
echo [OK] Mobile Hotspot service disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "windowsbackup",
    "Title": "Disable Windows Backup Service",
    "Description": "Disables the Windows Backup service if you do not use built-in backup jobs.",
    "Command": ":: === Disable Windows Backup Service ===
sc stop SDRSVC >nul 2>&1
sc config SDRSVC start= disabled >nul 2>&1
echo [OK] Windows Backup service disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "wallet",
    "Title": "Disable Wallet Service",
    "Description": "Disables WalletService on systems that do not use Microsoft Wallet features.",
    "Command": ":: === Disable Wallet Service ===
sc stop WalletService >nul 2>&1
sc config WalletService start= disabled >nul 2>&1
echo [OK] Wallet Service disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "webclient",
    "Title": "Disable WebClient",
    "Description": "Disables WebClient if you do not use WebDAV shares.",
    "Command": ":: === Disable WebClient ===
sc stop WebClient >nul 2>&1
sc config WebClient start= disabled >nul 2>&1
echo [OK] WebClient disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "mapbrokerhard",
    "Title": "Disable Downloaded Maps Service",
    "Description": "Disables MapsBroker completely as an aggressive option, beyond the Winutil manual setting.",
    "Command": ":: === Disable Downloaded Maps Service ===
sc stop MapsBroker >nul 2>&1
sc config MapsBroker start= disabled >nul 2>&1
echo [OK] Downloaded Maps service disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "aggressivepack",
    "Title": "Lak Aggressive Services Pack",
    "Description": "Applies a larger aggressive set of non-essential services based on your current setup pattern plus Winutil-style cleanup. Use carefully.",
    "Command": ":: === Lak Aggressive Services Pack ===
for %%S in (DiagTrack dmwappushservice diagnosticshub.standardcollector.service DiagSvc DPS WdiServiceHost WdiSystemHost WSearch SysMain BITS DoSvc RemoteRegistry RemoteAccess SharedAccess ssh-agent tzautoupdate fhsvc PeerDistSvc SensorDataService SensorMonitoringService SensorService SensrSvc SSDPSRV upnphost FDResPub fdPHost p2pimsvc p2psvc PNRPsvc PNRPAutoReg lltdsvc WalletService WebClient WbioSrvc icssvc SDRSVC MapsBroker XboxGipSvc XboxNetApiSvc XblAuthManager XblGameSave BcastDVRUserService) do (
    sc stop %%S >nul 2>&1
    sc config %%S start= disabled >nul 2>&1
)
echo [OK] Lak aggressive services pack applied"

  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "uispeed",
    "Title": "UI Speed",
    "Description": "Reduces menu and shutdown delays.",
    "Command": ":: === UI Speed Tweaks ===\nreg add \"HKCU\\\\Control Panel\\\\Desktop\" /v \"AutoEndTasks\" /t REG_SZ /d \"1\" /f >nul 2>&1\nreg add \"HKCU\\\\Control Panel\\\\Desktop\" /v \"HungAppTimeout\" /t REG_SZ /d \"1000\" /f >nul 2>&1\nreg add \"HKCU\\\\Control Panel\\\\Desktop\" /v \"MenuShowDelay\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg add \"HKCU\\\\Control Panel\\\\Desktop\" /v \"WaitToKillAppTimeout\" /t REG_SZ /d \"2000\" /f >nul 2>&1\nreg add \"HKCU\\\\Control Panel\\\\Desktop\" /v \"LowLevelHooksTimeout\" /t REG_SZ /d \"1000\" /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\" /v \"WaitToKillServiceTimeout\" /t REG_SZ /d \"2000\" /f >nul 2>&1\necho [OK] UI speed tweaks applied"
  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "startupdelay",
    "Title": "Remove Startup Delay",
    "Description": "Removes Explorer startup delay.",
    "Command": ":: === Remove Explorer Startup Delay ===\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Explorer\\\\Serialize\" /v \"Startupdelayinmsec\" /t REG_DWORD /d 0 /f >nul 2>&1\necho [OK] Startup delay removed"
  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "bgapps",
    "Title": "Disable Background Apps",
    "Description": "Disables background UWP apps.",
    "Command": ":: === Disable Background Apps ===\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\BackgroundAccessApplications\" /v \"GlobalUserDisabled\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Search\" /v \"BackgroundAppGlobalToggle\" /t REG_DWORD /d 0 /f >nul 2>&1\necho [OK] Background apps disabled"
  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "maintenance",
    "Title": "Disable Auto Maintenance",
    "Description": "Stops automatic maintenance and extra background work.",
    "Command": ":: === Disable Auto Maintenance / Driver Search ===\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Schedule\\\\Maintenance\" /v \"MaintenanceDisabled\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\DriverSearching\" /v \"SearchOrderConfig\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\WindowsUpdate\" /v \"ExcludeWUDriversInQualityUpdate\" /t REG_DWORD /d 1 /f >nul 2>&1\necho [OK] Auto maintenance disabled"
  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "hibernate",
    "Title": "Disable Hibernate / Fast Boot",
    "Description": "Turns off hibernation and fast startup.",
    "Command": ":: === Disable Hibernate / Fast Boot ===\nreg add \"HKLM\\\\SYSTEM\\\\ControlSet001\\\\Control\\\\Power\" /v \"HibernateEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Power\" /v \"HibernateEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Power\" /v \"HiberbootEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\npowercfg /h off >nul 2>&1\necho [OK] Hibernate and fast boot disabled"
  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "explorerclean",
    "Title": "Explorer Policies",
    "Description": "Disables certain Explorer background helpers.",
    "Command": ":: === Explorer Policy Cleanup ===\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\Explorer\" /v \"NoLowDiskSpaceChecks\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\Explorer\" /v \"LinkResolveIgnoreLinkInfo\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\Explorer\" /v \"NoResolveSearch\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\Explorer\" /v \"NoResolveTrack\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\Explorer\" /v \"NoInternetOpenWith\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\Explorer\" /v \"NoInstrumentation\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\Explorer\" /v \"NoInstrumentation\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Explorer\" /v \"Max Cached Icons\" /t REG_SZ /d \"4096\" /f >nul 2>&1\necho [OK] Explorer policies set"
  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "iconfix",
    "Title": "Restore Old Right-Click Menu",
    "Description": "Restores classic Windows 10 style context menu.",
    "Command": ":: === Restore Old Right-Click Menu (Win11) ===\nreg add \"HKCU\\\\Software\\\\Classes\\\\CLSID\\\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\\\\InprocServer32\" /ve /t REG_SZ /d \"\" /f >nul 2>&1\necho [OK] Old right-click context menu restored"
  },
  {
    "CategoryId": "gpu",
    "Category": "GPU / NVIDIA (Lumin + MSI Util)",
    "Id": "nvidiathread",
    "Title": "NVIDIA Driver Thread Priority",
    "Description": "Raises NVIDIA driver thread priority.",
    "Command": ":: === NVIDIA Driver Thread Priority (Lak + Lumin Nvidia) ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\nvlddmkm\\\\Parameters\" /v \"ThreadPriority\" /t REG_DWORD /d 31 /f >nul 2>&1\necho [OK] NVIDIA thread priority set to 31"
  },
  {
    "CategoryId": "gpu",
    "Category": "GPU / NVIDIA (Lumin + MSI Util)",
    "Id": "nvidiafts",
    "Title": "NVIDIA EnableRID61684",
    "Description": "Sets NVIDIA latency-related registry flag.",
    "Command": ":: === NVIDIA FTS Flag ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\nvlddmkm\\\\FTS\" /v \"EnableRID61684\" /t REG_DWORD /d 1 /f >nul 2>&1\necho [OK] NVIDIA FTS EnableRID61684 enabled"
  },
  {
    "CategoryId": "gpu",
    "Category": "GPU / NVIDIA (Lumin + MSI Util)",
    "Id": "dxgkrnl",
    "Title": "DXGKrnl Thread Priority",
    "Description": "Raises DXGKrnl thread priority.",
    "Command": ":: === DXGKrnl Priority ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\DXGKrnl\\\\Parameters\" /v \"ThreadPriority\" /t REG_DWORD /d 15 /f >nul 2>&1\necho [OK] DXGKrnl thread priority set"
  },
  {
    "CategoryId": "gpu",
    "Category": "GPU / NVIDIA (Lumin + MSI Util)",
    "Id": "pcilatency",
    "Title": "PCIe Latency Optimization",
    "Description": "Applies PCI latency-related settings.",
    "Command": ":: === PCIe Latency (MSI Util / Flipz inspired) ===\n:: Set GPU interrupt latency to IOAPIC mode where possible\nfor /f \"tokens=*\" %%i in ('wmic path win32_videocontroller get pnpdeviceid ^| findstr /i \"PCI\\\\VEN\"') do (\n    reg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Enum\\\\%%i\\\\Device Parameters\\\\Interrupt Management\\\\MessageSignaledInterruptProperties\" /v \"MessageNumberLimit\" /t REG_DWORD /d 1 /f >nul 2>&1\n)\necho [OK] PCIe latency optimized"
  },
  {
    "CategoryId": "gpu",
    "Category": "GPU / NVIDIA (Lumin + MSI Util)",
    "Id": "usbpriority",
    "Title": "USB Controller Priority",
    "Description": "Raises USB controller-related priorities.",
    "Command": ":: === USB Controller Thread Priority ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\USBHUB3\\\\Parameters\" /v \"ThreadPriority\" /t REG_DWORD /d 15 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\USBXHCI\\\\Parameters\" /v \"ThreadPriority\" /t REG_DWORD /d 15 /f >nul 2>&1\necho [OK] USB controller thread priority set"
  },
  {
    "CategoryId": "gpu",
    "Category": "GPU / NVIDIA (Lumin + MSI Util)",
    "Id": "usbsuspend",
    "Title": "Disable USB Selective Suspend",
    "Description": "Prevents USB devices from sleeping.",
    "Command": ":: === Disable USB Selective Suspend ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\USB\" /v \"DisableSelectiveSuspend\" /t REG_DWORD /d 1 /f >nul 2>&1\necho [OK] USB selective suspend disabled"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK (Chris Titus Tech)",
    "Id": "tcpack",
    "Title": "TCP/IP Tweaks",
    "Description": "Applies gaming-focused TCP/IP settings.",
    "Command": ":: === TCP/IP Tweaks (Chris Titus Tech) ===\n:: Disable TCP auto-tuning\nnetsh int tcp set global autotuninglevel=disabled >nul 2>&1\nnetsh int tcp set global ecncapability=disabled >nul 2>&1\nnetsh int tcp set global timestamps=disabled >nul 2>&1\nnetsh int tcp set heuristics disabled >nul 2>&1\n:: Enable RSC, Chimney\nnetsh int tcp set supplemental template=Internet congestionprovider=ctcp >nul 2>&1\n:: TcpAckFrequency + TCPNoDelay for each adapter\nfor /f \"tokens=3*\" %%a in ('reg query \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters\\\\Interfaces\" /k /f \"\" ^| findstr /i \"HKEY\"') do (\n    reg add \"%%a\" /v \"TcpAckFrequency\" /t REG_DWORD /d 1 /f >nul 2>&1\n    reg add \"%%a\" /v \"TCPNoDelay\" /t REG_DWORD /d 1 /f >nul 2>&1\n    reg add \"%%a\" /v \"TcpDelAckTicks\" /t REG_DWORD /d 0 /f >nul 2>&1\n)\necho [OK] TCP/IP optimized"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK (Chris Titus Tech)",
    "Id": "ndu",
    "Title": "Disable NDU",
    "Description": "Disables Network Data Usage tracking.",
    "Command": ":: === Disable NDU (Network Data Usage monitor) ===\nreg add \"HKLM\\\\SYSTEM\\\\ControlSet001\\\\Services\\\\Ndu\" /v \"Start\" /t REG_DWORD /d 4 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Ndu\" /v \"Start\" /t REG_DWORD /d 4 /f >nul 2>&1\necho [OK] NDU disabled"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK (Chris Titus Tech)",
    "Id": "netbt",
    "Title": "Disable NetBT",
    "Description": "Disables NetBIOS over TCP/IP.",
    "Command": ":: === Disable NetBT ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\NetBT\" /v \"Start\" /t REG_DWORD /d 4 /f >nul 2>&1\necho [OK] NetBT disabled"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK (Chris Titus Tech)",
    "Id": "irpstack",
    "Title": "IRP Stack / MMCSS Network",
    "Description": "Applies IRP/MMCSS network settings.",
    "Command": ":: === IRP Stack / MMCSS Network Tweak ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\LanmanServer\\\\Parameters\" /v \"IRPStackSize\" /t REG_DWORD /d 20 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Multimedia\\\\SystemProfile\" /v \"NoLazyMode\" /t REG_DWORD /d 1 /f >nul 2>&1\necho [OK] IRP stack and MMCSS network set"
  },
  {
    "CategoryId": "input",
    "Category": "INPUT / MOUSE",
    "Id": "mouseaccel",
    "Title": "Disable Mouse Acceleration",
    "Description": "Turns off Enhance Pointer Precision behavior.",
    "Command": ":: === Disable Mouse Acceleration ===\nreg add \"HKCU\\\\Control Panel\\\\Mouse\" /v \"MouseSpeed\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg add \"HKCU\\\\Control Panel\\\\Mouse\" /v \"MouseThreshold1\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg add \"HKCU\\\\Control Panel\\\\Mouse\" /v \"MouseThreshold2\" /t REG_SZ /d \"0\" /f >nul 2>&1\necho [OK] Mouse acceleration disabled"
  },
  {
    "CategoryId": "input",
    "Category": "INPUT / MOUSE",
    "Id": "mousepriority",
    "Title": "Mouse / Keyboard Driver Priority",
    "Description": "Raises keyboard and mouse class priorities.",
    "Command": ":: === Mouse & Keyboard Driver Priority ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\mouclass\\\\Parameters\" /v \"ThreadPriority\" /t REG_DWORD /d 31 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\kbdclass\\\\Parameters\" /v \"ThreadPriority\" /t REG_DWORD /d 31 /f >nul 2>&1\necho [OK] Mouse/keyboard driver priority set to 31"
  },
  {
    "CategoryId": "input",
    "Category": "INPUT / MOUSE",
    "Id": "mousebuffer",
    "Title": "Mouse / Keyboard Queue Size",
    "Description": "Sets queue size tuning values.",
    "Command": ":: === Mouse & Keyboard Queue Size ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\mouclass\\\\Parameters\" /v \"MouseDataQueueSize\" /t REG_DWORD /d 20 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\kbdclass\\\\Parameters\" /v \"KeyboardDataQueueSize\" /t REG_DWORD /d 20 /f >nul 2>&1\necho [OK] Mouse/keyboard queue size set"
  },
  {
    "CategoryId": "input",
    "Category": "INPUT / MOUSE",
    "Id": "rawmouse",
    "Title": "Raw Mouse Input Curve",
    "Description": "Sets flat smooth mouse curves.",
    "Command": ":: === Raw Mouse Input (SmoothCurve flat) ===\nreg add \"HKCU\\\\Control Panel\\\\Mouse\" /v \"SmoothMouseXCurve\" /t REG_BINARY /d \"0000000000000000C0CC0C000000000080991900000000004066260000000000003333000000000000000000\" /f >nul 2>&1\nreg add \"HKCU\\\\Control Panel\\\\Mouse\" /v \"SmoothMouseYCurve\" /t REG_BINARY /d \"000000000000000000003800000000000000700000000000000038000000000000003800000000000000E000000000000000\" /f >nul 2>&1\necho [OK] Raw mouse input curves set"
  },

  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "consumerfeatures",
    "Title": "Disable Consumer Features",
    "Description": "Turns off Microsoft consumer experiences and suggested apps.",
    "Command": ":: === Disable Consumer Features ===
reg add "HKLM\\SOFTWARE\\Policies\\Microsoft\\Windows\\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f >nul 2>&1
echo [OK] Consumer features disabled"
  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "bingstartoff",
    "Title": "Disable Bing Search in Start Menu",
    "Description": "Turns off online Bing-backed search suggestions in the Start menu.",
    "Command": ":: === Disable Bing Search in Start Menu ===
reg add "HKCU\\Software\\Policies\\Microsoft\\Windows\\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Bing search in Start menu disabled"
  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "locationsenseoff",
    "Title": "Disable Location Tracking",
    "Description": "Turns off Windows location tracking policies.",
    "Command": ":: === Disable Location Tracking ===
reg add "HKLM\\SOFTWARE\\Policies\\Microsoft\\Windows\\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\CapabilityAccessManager\\ConsentStore\\location" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
echo [OK] Location tracking disabled"
  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "storagesenseoff",
    "Title": "Disable Storage Sense",
    "Description": "Turns off Storage Sense automatic cleanup behavior.",
    "Command": ":: === Disable Storage Sense ===
reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\StorageSense\\Parameters\\StoragePolicy" /v "01" /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Storage Sense disabled"
  }

  {
    "CategoryId": "privacy",
    "Category": "PRIVACY (O&O ShutUp10 style)",
    "Id": "teldata",
    "Title": "Disable Telemetry Collection",
    "Description": "Disables Windows telemetry collection policies.",
    "Command": ":: === Disable Telemetry Data Collection ===\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\DataCollection\" /v \"AllowTelemetry\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\DataCollection\" /v \"AllowTelemetry\" /t REG_DWORD /d 0 /f >nul 2>&1\necho [OK] Telemetry data collection disabled"
  },
  {
    "CategoryId": "privacy",
    "Category": "PRIVACY (O&O ShutUp10 style)",
    "Id": "ceip",
    "Title": "Disable CEIP / SQM",
    "Description": "Disables CEIP and SQM tasks/settings.",
    "Command": ":: === Disable CEIP / SQM ===\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\SQMClient\\\\Windows\" /v \"CEIPEnable\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\HandwritingErrorReports\" /v \"PreventHandwritingErrorReports\" /t REG_DWORD /d 1 /f >nul 2>&1\necho [OK] CEIP/SQM disabled"
  },
  {
    "CategoryId": "privacy",
    "Category": "PRIVACY (O&O ShutUp10 style)",
    "Id": "appcompat",
    "Title": "Disable App Compatibility Telemetry",
    "Description": "Disables application compatibility telemetry.",
    "Command": ":: === Disable App Compatibility Telemetry ===\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\AppCompat\" /v \"AITEnable\" /t REG_DWORD /d 0 /f >nul 2>&1\necho [OK] App compatibility telemetry disabled"
  },
  {
    "CategoryId": "privacy",
    "Category": "PRIVACY (O&O ShutUp10 style)",
    "Id": "schedtasks",
    "Title": "Disable Telemetry Tasks",
    "Description": "Disables telemetry-related scheduled tasks.",
    "Command": ":: === Disable Telemetry Scheduled Tasks ===\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\Application Experience\\\\Microsoft Compatibility Appraiser\" /Disable >nul 2>&1\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\Application Experience\\\\PcaPatchDbTask\" /Disable >nul 2>&1\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\Application Experience\\\\StartupAppTask\" /Disable >nul 2>&1\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\Customer Experience Improvement Program\\\\Consolidator\" /Disable >nul 2>&1\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\Customer Experience Improvement Program\\\\UsbCeip\" /Disable >nul 2>&1\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\DiskDiagnostic\\\\Microsoft-Windows-DiskDiagnosticDataCollector\" /Disable >nul 2>&1\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\Power Efficiency Diagnostics\\\\AnalyzeSystem\" /Disable >nul 2>&1\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\Windows Error Reporting\\\\QueueReporting\" /Disable >nul 2>&1\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\Feedback\\\\Siuf\\\\DmClient\" /Disable >nul 2>&1\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\Feedback\\\\Siuf\\\\DmClientOnScenarioDownload\" /Disable >nul 2>&1\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\PushToInstall\\\\LoginCheck\" /Disable >nul 2>&1\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\PushToInstall\\\\Registration\" /Disable >nul 2>&1\necho [OK] Telemetry scheduled tasks disabled"
  },
  {
    "CategoryId": "privacy",
    "Category": "PRIVACY (O&O ShutUp10 style)",
    "Id": "newsinterests",
    "Title": "Disable News / Widgets",
    "Description": "Turns off widgets and news surfaces.",
    "Command": ":: === Disable News, Interests, Widgets ===\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\Dsh\" /v \"AllowNewsAndInterests\" /t REG_DWORD /d 0 /f >nul 2>&1\ntaskkill /f /im Widgets.exe >nul 2>&1\necho [OK] News and Interests/Widgets disabled"
  },
  {
    "CategoryId": "debloat",
    "Category": "PROCESS DEBLOAT (Lumin)",
    "Id": "killjunk",
    "Title": "Kill Junk Processes",
    "Description": "Kills common background apps and launchers.",
    "Command": ":: === Kill Junk Processes (LuminDebloater inspired) ===\nfor %%P in (brave.exe chrome.exe msedge.exe Discord.exe EpicGamesLauncher.exe EpicWebHelper.exe Steam.exe steamwebhelper.exe OneDrive.exe Spotify.exe Teams.exe ms-teams.exe AdobeIPCBroker.exe CCXProcess.exe GameBar.exe GameBarFTServer.exe) do (\n    taskkill /f /im %%P >nul 2>&1\n)\necho [OK] Junk processes killed"
  },
  {
    "CategoryId": "debloat",
    "Category": "PROCESS DEBLOAT (Lumin)",
    "Id": "killui",
    "Title": "Kill UI Bloat",
    "Description": "Kills extra UI helper processes.",
    "Command": ":: === Kill UI Bloat (LuminFree inspired) ===\ntaskkill /f /im TextInputHost.exe >nul 2>&1\ntaskkill /f /im ctfmon.exe >nul 2>&1\ntaskkill /f /im msedgewebview2.exe >nul 2>&1\ntaskkill /f /im Widgets.exe >nul 2>&1\ntaskkill /f /im Copilot.exe >nul 2>&1\ntaskkill /f /im PhoneExperienceHost.exe >nul 2>&1\ntaskkill /f /im RuntimeBroker.exe >nul 2>&1\ntaskkill /f /im ShellExperienceHost.exe >nul 2>&1\ntaskkill /f /im StartMenuExperienceHost.exe >nul 2>&1\necho [OK] UI bloat processes killed"
  },
  {
    "CategoryId": "debloat",
    "Category": "PROCESS DEBLOAT (Lumin)",
    "Id": "removestartup",
    "Title": "Clean Startup Entries",
    "Description": "Removes common startup entries.",
    "Command": ":: === Remove Startup Entries ===\nreg delete \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Run\" /v \"OneDrive\" /f >nul 2>&1\nreg delete \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Run\" /v \"Discord\" /f >nul 2>&1\nreg delete \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Run\" /v \"Spotify\" /f >nul 2>&1\nreg delete \"HKLM\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Run\" /v \"SecurityHealth\" /f >nul 2>&1\nreg delete \"HKLM\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Run\" /v \"OneDrive\" /f >nul 2>&1\necho [OK] Startup entries cleaned"
  },
  {
    "CategoryId": "power",
    "Category": "POWER PLAN",
    "Id": "ultperf",
    "Title": "Ultimate Performance Plan",
    "Description": "Enables and activates Ultimate Performance.",
    "Command": ":: === Activate Ultimate Performance Power Plan ===\nset \"UPGUID=\"\nfor /f \"tokens=4\" %%G in ('powercfg -list ^| findstr /i \"Ultimate Performance\"') do if not defined UPGUID set \"UPGUID=%%G\"\nif not defined UPGUID (\n    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1\n    for /f \"tokens=4\" %%G in ('powercfg -list ^| findstr /i \"Ultimate Performance\"') do if not defined UPGUID set \"UPGUID=%%G\"\n)\nif defined UPGUID (\n    powercfg -setactive !UPGUID! >nul 2>&1\n    echo [OK] Ultimate Performance power plan activated\n) else (\n    echo [WARN] Could not activate Ultimate Performance power plan\n)"
  },
  {
    "CategoryId": "power",
    "Category": "POWER PLAN",
    "Id": "cpumaxmin",
    "Title": "CPU Min/Max 100%",
    "Description": "Sets CPU minimum and maximum states to 100%.",
    "Command": ":: === CPU Min/Max State 100% ===\npowercfg /setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100 >nul 2>&1\npowercfg /setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100 >nul 2>&1\npowercfg /setactive scheme_current >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Power\\\\PowerSettings\\\\54533251-82be-4824-96c1-47b60b740d00\\\\4b92d758-5a24-4851-a470-815d78aee119\\\\DefaultPowerSchemeValues\\\\381b4222-f694-41f0-9685-ff5bb260df2e\" /v \"ACSettingIndex\" /t REG_DWORD /d 100 /f >nul 2>&1\necho [OK] CPU min/max set to 100%"
  },
  {
    "CategoryId": "power",
    "Category": "POWER PLAN",
    "Id": "usbpower",
    "Title": "USB Power Always On",
    "Description": "Disables USB selective suspend in active plan.",
    "Command": ":: === USB Power Always On ===\nreg add \"HKLM\\SYSTEM\\CurrentControlSet\\Control\\Power\\PowerSettings\\2a737441-1930-4402-8d77-b2bebba308a3\\d4e98f31-5ffe-4ce1-be31-1b38b384c009\\DefaultPowerSchemeValues\\381b4222-f694-41f0-9685-ff5bb260df2e\" /v \"ACSettingIndex\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\SYSTEM\\CurrentControlSet\\Control\\Power\\PowerSettings\\2a737441-1930-4402-8d77-b2bebba308a3\\d4e98f31-5ffe-4ce1-be31-1b38b384c009\\DefaultPowerSchemeValues\\381b4222-f694-41f0-9685-ff5bb260df2e\" /v \"DCSettingIndex\" /t REG_DWORD /d 0 /f >nul 2>&1\npowercfg /setacvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0 >nul 2>&1\npowercfg /setactive scheme_current >nul 2>&1\necho [OK] USB power always on"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "wer",
    "Title": "Disable Windows Error Reporting",
    "Description": "Stops crash reporting service and reduces background reporting tasks.",
    "Command": ":: === Disable Windows Error Reporting ===\nsc stop WerSvc >nul 2>&1\nsc config WerSvc start= disabled >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows\\\\Windows Error Reporting\" /v \"Disabled\" /t REG_DWORD /d 1 /f >nul 2>&1\necho [OK] Windows Error Reporting disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "remotereg",
    "Title": "Disable Remote Registry",
    "Description": "Turns off Remote Registry if you do not manage this PC remotely.",
    "Command": ":: === Disable Remote Registry ===\nsc stop RemoteRegistry >nul 2>&1\nsc config RemoteRegistry start= disabled >nul 2>&1\necho [OK] Remote Registry disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "maps",
    "Title": "Disable Maps Services",
    "Description": "Stops offline maps services that most gaming PCs do not need.",
    "Command": ":: === Disable Maps Services ===\nsc stop MapsBroker >nul 2>&1\nsc config MapsBroker start= disabled >nul 2>&1\nsc stop lfsvc >nul 2>&1\nsc config lfsvc start= disabled >nul 2>&1\necho [OK] Maps and location services disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "faxsvc",
    "Title": "Disable Fax Service",
    "Description": "Disables legacy fax service on systems that do not use it.",
    "Command": ":: === Disable Fax Service ===\nsc stop Fax >nul 2>&1\nsc config Fax start= disabled >nul 2>&1\necho [OK] Fax service disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "retaildemo",
    "Title": "Disable Retail Demo Service",
    "Description": "Disables retail demo mode service found on some Windows installs.",
    "Command": ":: === Disable Retail Demo Service ===\nsc stop RetailDemo >nul 2>&1\nsc config RetailDemo start= disabled >nul 2>&1\necho [OK] Retail demo service disabled"

  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "cttservices",
    "Title": "Chris Titus Services Profile",
    "Description": "Applies the current Winutil services profile: some services go Manual, others Disabled, matching the official service list where documented.",
    "Command": ":: === Chris Titus Services Profile ===
sc stop CscService >nul 2>&1
sc config CscService start= disabled >nul 2>&1
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc config MapsBroker start= demand >nul 2>&1
sc stop RemoteAccess >nul 2>&1
sc config RemoteAccess start= disabled >nul 2>&1
sc stop RemoteRegistry >nul 2>&1
sc config RemoteRegistry start= disabled >nul 2>&1
sc config StorSvc start= demand >nul 2>&1
sc stop SharedAccess >nul 2>&1
sc config SharedAccess start= disabled >nul 2>&1
sc config TermService start= demand >nul 2>&1
sc config TroubleshootingSvc start= demand >nul 2>&1
sc config seclogon start= demand >nul 2>&1
sc stop ssh-agent >nul 2>&1
sc config ssh-agent start= disabled >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "$Memory=(Get-CimInstance Win32_PhysicalMemory | Measure-Object Capacity -Sum).Sum / 1KB; Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name 'SvcHostSplitThresholdInKB' -Value $Memory" >nul 2>&1
echo [OK] Chris Titus services profile applied"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "offlinefiles",
    "Title": "Disable Offline Files",
    "Description": "Disables CscService, which Winutil also sets to Disabled in its services profile.",
    "Command": ":: === Disable Offline Files ===
sc stop CscService >nul 2>&1
sc config CscService start= disabled >nul 2>&1
echo [OK] Offline Files service disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "remoteaccess",
    "Title": "Disable Remote Access",
    "Description": "Disables the RemoteAccess service if you do not use VPN/dial-up style remote networking.",
    "Command": ":: === Disable Remote Access ===
sc stop RemoteAccess >nul 2>&1
sc config RemoteAccess start= disabled >nul 2>&1
echo [OK] Remote Access service disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "ics",
    "Title": "Disable Internet Connection Sharing",
    "Description": "Disables SharedAccess, which Winutil also sets to Disabled in its services profile.",
    "Command": ":: === Disable Internet Connection Sharing ===
sc stop SharedAccess >nul 2>&1
sc config SharedAccess start= disabled >nul 2>&1
echo [OK] Internet Connection Sharing disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "sshagent",
    "Title": "Disable OpenSSH Authentication Agent",
    "Description": "Disables ssh-agent if you do not use SSH keys on this PC.",
    "Command": ":: === Disable OpenSSH Authentication Agent ===
sc stop ssh-agent >nul 2>&1
sc config ssh-agent start= disabled >nul 2>&1
echo [OK] OpenSSH Authentication Agent disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "onesync",
    "Title": "Disable OneSync / Messaging Sync",
    "Description": "Disables the OneSync service family used for Mail, Contacts, and Calendar syncing on consumer installs.",
    "Command": ":: === Disable OneSync / Unistack Sync Services ===
for /f "tokens=1*" %%S in ('sc query state^= all ^| findstr /i "OneSyncSvc UnistoreSvc UserDataSvc PimIndexMaintenanceSvc CDPUserSvc"') do (
    sc stop %%S >nul 2>&1
    sc config %%S start= disabled >nul 2>&1
)
echo [OK] OneSync-style sync services disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "xbliveextras",
    "Title": "Disable Xbox Accessory Services",
    "Description": "Disables extra Xbox-related services beyond the main Xbox service toggle.",
    "Command": ":: === Disable Additional Xbox Services ===
for %%S in (GamingServices GamingServicesNet) do (
    sc stop %%S >nul 2>&1
    sc config %%S start= disabled >nul 2>&1
)
echo [OK] Additional Xbox services disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "deliveryopt",
    "Title": "Disable Delivery Optimization",
    "Description": "Stops DoSvc peer-to-peer update delivery service for a leaner background footprint.",
    "Command": ":: === Disable Delivery Optimization ===
sc stop DoSvc >nul 2>&1
sc config DoSvc start= disabled >nul 2>&1
echo [OK] Delivery Optimization disabled"
  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "visualfxbest",
    "Title": "Visual Effects: Best Performance",
    "Description": "Reduces animations and visual effects for a lighter desktop shell.",
    "Command": ":: === Visual Effects Best Performance ===\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Explorer\\\\VisualEffects\" /v \"VisualFXSetting\" /t REG_DWORD /d 2 /f >nul 2>&1\nreg add \"HKCU\\\\Control Panel\\\\Desktop\" /v \"UserPreferencesMask\" /t REG_BINARY /d 9012038010000000 /f >nul 2>&1\necho [OK] Visual effects set to best performance"
  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "transparencyoff",
    "Title": "Disable Transparency Effects",
    "Description": "Turns off transparency to reduce shell overhead.",
    "Command": ":: === Disable Transparency Effects ===\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Themes\\\\Personalize\" /v \"EnableTransparency\" /t REG_DWORD /d 0 /f >nul 2>&1\necho [OK] Transparency effects disabled"
  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "animoff",
    "Title": "Disable Window Animations",
    "Description": "Turns off common UI animations for snappier desktop response.",
    "Command": ":: === Disable Window Animations ===\nreg add \"HKCU\\\\Control Panel\\\\Desktop\\\\WindowMetrics\" /v \"MinAnimate\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Explorer\\\\Advanced\" /v \"TaskbarAnimations\" /t REG_DWORD /d 0 /f >nul 2>&1\necho [OK] Window animations disabled"
  },
  {
    "CategoryId": "privacy",
    "Category": "PRIVACY (O&O ShutUp10 style)",
    "Id": "activityhistory",
    "Title": "Disable Activity History",
    "Description": "Turns off activity history collection and publishing.",
    "Command": ":: === Disable Activity History ===\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\System\" /v \"EnableActivityFeed\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\System\" /v \"PublishUserActivities\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\System\" /v \"UploadUserActivities\" /t REG_DWORD /d 0 /f >nul 2>&1\necho [OK] Activity history disabled"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK (Chris Titus Tech)",
    "Id": "qos0",
    "Title": "QoS Reserved Bandwidth 0%",
    "Description": "Sets NonBestEffortLimit to 0 using a common gaming-network tweak.",
    "Command": ":: === QoS Reserved Bandwidth 0% ===\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\Psched\" /v \"NonBestEffortLimit\" /t REG_DWORD /d 0 /f >nul 2>&1\necho [OK] QoS reserved bandwidth set to 0%"
  },
  {
    "CategoryId": "power",
    "Category": "POWER PLAN",
    "Id": "pcielinkoff",
    "Title": "PCIe Link State Off",
    "Description": "Disables PCIe Link State Power Management on the active plan.",
    "Command": ":: === PCIe Link State Off ===\npowercfg /setacvalueindex scheme_current SUB_PCIEXPRESS ASPM 0 >nul 2>&1\npowercfg /setdcvalueindex scheme_current SUB_PCIEXPRESS ASPM 0 >nul 2>&1\npowercfg /setactive scheme_current >nul 2>&1\necho [OK] PCIe Link State Power Management disabled"
  },
  {
    "CategoryId": "power",
    "Category": "POWER PLAN",
    "Id": "sleepoff",
    "Title": "Disable Sleep / Hibernate Timers",
    "Description": "Keeps the active power plan from sleeping the PC during use.",
    "Command": ":: === Disable Sleep / Hibernate Timers ===\npowercfg /change standby-timeout-ac 0 >nul 2>&1\npowercfg /change hibernate-timeout-ac 0 >nul 2>&1\npowercfg /change monitor-timeout-ac 0 >nul 2>&1\necho [OK] Sleep and hibernate timers disabled on AC"
  },
  {
    "CategoryId": "power",
    "Category": "POWER PLAN",
    "Id": "procidleoff",
    "Title": "Disable Processor Idle Demote / Promote",
    "Description": "Reduces aggressive processor idle state switching on the active plan.",
    "Command": ":: === Disable Processor Idle Demote/Promote ===\npowercfg /setacvalueindex scheme_current sub_processor IDLEDISABLE 1 >nul 2>&1\npowercfg /setactive scheme_current >nul 2>&1\necho [OK] Processor idle disable applied"

  ,
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "consumerfeaturesoff",
    "Title": "Disable Consumer Features",
    "Description": "Turns off Windows consumer-content suggestions and silent app installs.",
    "Command": ":: === Disable Consumer Features ===\nreg add \"HKLM\\SOFTWARE\\Policies\\Microsoft\\Windows\\CloudContent\" /v \"DisableWindowsConsumerFeatures\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager\" /v \"ContentDeliveryAllowed\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager\" /v \"OemPreInstalledAppsEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager\" /v \"PreInstalledAppsEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager\" /v \"SilentInstalledAppsEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\necho [OK] Consumer features disabled"
  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "notifoff",
    "Title": "Disable Toast Notifications",
    "Description": "Disables Notification Center to reduce background UI interruptions.",
    "Command": ":: === Disable Toast Notifications ===\nreg add \"HKCU\\Software\\Policies\\Microsoft\\Windows\\Explorer\" /v \"DisableNotificationCenter\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\PushNotifications\" /v \"ToastEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\necho [OK] Toast notifications disabled"
  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "folderdiscoveryoff",
    "Title": "Disable Folder Discovery",
    "Description": "Stops Explorer from auto-detecting folder templates.",
    "Command": ":: === Disable Explorer Folder Discovery ===\nreg add \"HKCU\\Software\\Classes\\Local Settings\\Software\\Microsoft\\Windows\\Shell\\Bags\\AllFolders\\Shell\" /v \"FolderType\" /t REG_SZ /d \"NotSpecified\" /f >nul 2>&1\necho [OK] Folder discovery disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "deliveryopt",
    "Title": "Disable Delivery Optimization",
    "Description": "Stops update peer upload traffic and the DoSvc service.",
    "Command": ":: === Disable Delivery Optimization ===\nreg add \"HKLM\\SOFTWARE\\Policies\\Microsoft\\Windows\\DeliveryOptimization\" /v \"DODownloadMode\" /t REG_DWORD /d 0 /f >nul 2>&1\nsc stop DoSvc >nul 2>&1\nsc config DoSvc start= disabled >nul 2>&1\necho [OK] Delivery Optimization disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "mapsupdates",
    "Title": "Disable Downloaded Maps Updates",
    "Description": "Turns off automatic offline maps updates and the Maps Broker service.",
    "Command": ":: === Disable Downloaded Maps Updates ===\nreg add \"HKLM\\SYSTEM\\Maps\" /v \"AutoUpdateEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nsc stop MapsBroker >nul 2>&1\nsc config MapsBroker start= disabled >nul 2>&1\necho [OK] Downloaded Maps updates disabled"
  },
  {
    "CategoryId": "debloat",
    "Category": "PROCESS DEBLOAT (Lumin)",
    "Id": "killbackgroundhost",
    "Title": "Kill Background Task Host",
    "Description": "Stops backgroundTaskHost and other low-value shell helpers for the current session.",
    "Command": ":: === Kill Background Task Host ===\ntaskkill /f /im backgroundTaskHost.exe >nul 2>&1\ntaskkill /f /im Widgets.exe >nul 2>&1\ntaskkill /f /im SearchHost.exe >nul 2>&1\necho [OK] Background host processes killed"
  },
  {
    "CategoryId": "power",
    "Category": "POWER PLAN",
    "Id": "perfsliderbest",
    "Title": "Best Performance AC Settings",
    "Description": "Applies performance-oriented processor settings on AC power.",
    "Command": ":: === Best Performance AC Settings ===\npowercfg /setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100 >nul 2>&1\npowercfg /setacvalueindex scheme_current sub_processor PERFBOOSTMODE 1 >nul 2>&1\npowercfg /setactive scheme_current >nul 2>&1\necho [OK] Best performance AC settings applied"
  }
]
'@ | ConvertFrom-Json
$script:SettingsDir = Join-Path $env:APPDATA 'LakTweaks'
$script:SettingsPath = Join-Path $script:SettingsDir 'ui-settings.json'
if (-not (Test-Path $script:SettingsDir)) {
    New-Item -ItemType Directory -Force -Path $script:SettingsDir | Out-Null
}
$script:CurrentAccent = '#00ffe7'
$script:CurrentBgOpacity = 0.92
$script:CurrentGlow = 0.65
$script:CurrentCompact = $false
$script:CurrentClean = $false
$script:CurrentScanlines = 0.30
$script:CurrentGrid = 0.30
$script:AppliedTweaksPath = Join-Path $script:SettingsDir 'applied-tweaks.json'
$script:AppliedTweaks = @()
function Get-ColorBrush([string]$hex) { [Windows.Media.BrushConverter]::new().ConvertFromString($hex) }
function Get-ArgbBrush([string]$hex, [double]$opacity) {
    $c = [Windows.Media.ColorConverter]::ConvertFromString($hex)
    [Windows.Media.SolidColorBrush]::new([Windows.Media.Color]::FromArgb([byte]([Math]::Round(255 * $opacity)),$c.R,$c.G,$c.B))
}
function Save-UiSettings {
    $settings = [ordered]@{
        Accent    = $script:CurrentAccent
        BgOpacity = $script:CurrentBgOpacity
        Glow      = $script:CurrentGlow
        Compact   = $script:CurrentCompact
        Clean     = $script:CurrentClean
        Scanlines = $script:CurrentScanlines
        Grid      = $script:CurrentGrid
    }

    $settings | ConvertTo-Json -Depth 3 | Set-Content -Path $script:SettingsPath -Encoding UTF8
}
function Load-UiSettings {
    if (-not (Test-Path $script:SettingsPath)) {
        return
    }

    try {
        $obj = Get-Content -Path $script:SettingsPath -Raw | ConvertFrom-Json
        if ($obj.Accent)              { $script:CurrentAccent = [string]$obj.Accent }
        if ($null -ne $obj.BgOpacity) { $script:CurrentBgOpacity = [double]$obj.BgOpacity }
        if ($null -ne $obj.Glow)      { $script:CurrentGlow = [double]$obj.Glow }
        if ($null -ne $obj.Compact)   { $script:CurrentCompact = [bool]$obj.Compact }
        if ($null -ne $obj.Clean)     { $script:CurrentClean = [bool]$obj.Clean }
        if ($null -ne $obj.Scanlines) { $script:CurrentScanlines = [double]$obj.Scanlines }
        if ($null -ne $obj.Grid)      { $script:CurrentGrid = [double]$obj.Grid }
    }
    catch {
    }
}

function Save-AppliedTweaks {
    $script:AppliedTweaks | Sort-Object -Unique | ConvertTo-Json -Depth 2 | Set-Content -Path $script:AppliedTweaksPath -Encoding UTF8
}
function Load-AppliedTweaks {
    if (-not (Test-Path $script:AppliedTweaksPath)) {
        $script:AppliedTweaks = @()
        return
    }
    try {
        $raw = Get-Content -Path $script:AppliedTweaksPath -Raw
        if ([string]::IsNullOrWhiteSpace($raw)) {
            $script:AppliedTweaks = @()
            return
        }
        $loaded = $raw | ConvertFrom-Json
        if ($loaded -is [System.Array]) {
            $script:AppliedTweaks = @($loaded | ForEach-Object { [string]$_ })
        } elseif ($null -ne $loaded) {
            $script:AppliedTweaks = @([string]$loaded)
        } else {
            $script:AppliedTweaks = @()
        }
    } catch {
        $script:AppliedTweaks = @()
    }
}
function Test-TweakApplied([string]$id) {
    return $script:AppliedTweaks -contains $id
}
function Mark-TweaksApplied([object[]]$selected) {
    foreach($item in $selected) {
        if (-not ($script:AppliedTweaks -contains $item.Id)) {
            $script:AppliedTweaks += [string]$item.Id
        }
    }
    Save-AppliedTweaks
}

function Export-Bat([object[]]$selected, [string]$path) {
    $now = Get-Date -Format 'yyyy-MM-dd HH:mm'
    $lines = @('@echo off','title Lak Tweaks Elite - PowerShell Edition','color 0A','setlocal EnableExtensions EnableDelayedExpansion','','net session >nul 2>&1','if %errorlevel% neq 0 (','    echo ============================================','    echo  ERROR: Run this script as Administrator!','    echo ============================================','    pause','    exit /b',')','','echo ============================================','echo   LAK TWEAKS ELITE - POWERSHELL EDITION','echo   Generated: ' + $now,'echo   Tweaks selected: ' + $selected.Count,'echo ============================================','')
    foreach($group in ($selected | Group-Object Category)) {
        $lines += ':: ===================================================='
        $lines += ':: ' + $group.Name
        $lines += ':: ===================================================='
        foreach($item in $group.Group) { $lines += $item.Command.TrimEnd(); $lines += '' }
    }
    $lines += 'echo.'; $lines += 'echo ============================================'; $lines += 'echo   ALL TWEAKS APPLIED SUCCESSFULLY!'; $lines += 'echo   REBOOT YOUR PC FOR FULL EFFECT.'; $lines += 'echo ============================================'; $lines += 'pause'
    [IO.File]::WriteAllText($path, ($lines -join [Environment]::NewLine), [Text.UTF8Encoding]::new($false))
}
function Invoke-TweakCommands([object[]]$selected) {
    $succeeded = @()

    foreach($item in $selected) {
        $tempBat = Join-Path $env:TEMP ("LakTweaks_" + $item.Id + "_" + [guid]::NewGuid().ToString('N') + ".bat")
        try {
            $batContent = @(
                '@echo off'
                'setlocal EnableExtensions EnableDelayedExpansion'
                $item.Command
                'exit /b %errorlevel%'
            ) -join [Environment]::NewLine

            [System.IO.File]::WriteAllText($tempBat, $batContent, [System.Text.UTF8Encoding]::new($false))

            $proc = Start-Process -FilePath 'cmd.exe' -ArgumentList '/c', ('"' + $tempBat + '"') -Wait -PassThru -WindowStyle Hidden

            if ($proc.ExitCode -eq 0) {
                $succeeded += $item
            }
            else {
                throw ("Tweak failed: " + $item.Title + " (ExitCode " + $proc.ExitCode + ")")
            }
        }
        finally {
            if (Test-Path $tempBat) {
                Remove-Item -Path $tempBat -Force -ErrorAction SilentlyContinue
            }
        }
    }

    return ,$succeeded
}
Load-UiSettings
Load-AppliedTweaks
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="LakTweaks PowerShell Tool" Height="920" Width="1500" MinHeight="760" MinWidth="1180" WindowStartupLocation="CenterScreen" ResizeMode="CanResizeWithGrip" Background="#050a0f" Foreground="#c8f5f0" FontFamily="Segoe UI">
  <Grid>
    <Grid.RowDefinitions><RowDefinition Height="64"/><RowDefinition Height="*"/><RowDefinition Height="72"/></Grid.RowDefinitions>
    <Border x:Name="HeaderBorder" Grid.Row="0" Background="#0a1218" BorderBrush="#224444" BorderThickness="0,0,0,1">
      <Grid Margin="18,0"><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
        <StackPanel Orientation="Vertical" VerticalAlignment="Center"><TextBlock x:Name="LogoText" Text="LAKTWEAKS" FontSize="24" FontWeight="Bold"/><TextBlock Text="PowerShell Desktop Tuning Tool" FontSize="11" Foreground="#7ca7a2"/></StackPanel>
        <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center"><Ellipse Width="8" Height="8" Fill="#2ed573" Margin="0,0,8,0"/><TextBlock Text="READY" Foreground="#2ed573" VerticalAlignment="Center" Margin="0,0,18,0"/><StackPanel Orientation="Horizontal"><Button x:Name="ThemeCyan" Tag="#00ffe7" Width="22" Height="22" Margin="2"/><Button x:Name="ThemePink" Tag="#ff3cac" Width="22" Height="22" Margin="2"/><Button x:Name="ThemeGold" Tag="#f9c74f" Width="22" Height="22" Margin="2"/><Button x:Name="ThemePurple" Tag="#784dff" Width="22" Height="22" Margin="2"/><Button x:Name="ThemeRed" Tag="#ff4757" Width="22" Height="22" Margin="2"/></StackPanel></StackPanel>
      </Grid>
    </Border>
    <Grid Grid.Row="1"><Grid.ColumnDefinitions><ColumnDefinition Width="280"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
      <Border x:Name="SidebarBorder" Grid.Column="0" Background="#091016" BorderBrush="#224444" BorderThickness="0,0,1,0"><StackPanel Margin="12"><TextBlock Text="SECTIONS" Margin="8,8,8,10" FontSize="11" Foreground="#7ca7a2"/><ListBox x:Name="SidebarList" BorderThickness="0" Background="Transparent" Foreground="#c8f5f0"/></StackPanel></Border>
      <Grid Grid.Column="1" Margin="18"><Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/></Grid.RowDefinitions><StackPanel Margin="0,0,0,14"><TextBlock x:Name="SectionTitle" FontSize="24" FontWeight="Bold"/><TextBlock x:Name="SectionDesc" FontSize="13" Foreground="#7ca7a2" TextWrapping="Wrap"/></StackPanel><ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto"><WrapPanel x:Name="CardPanel" ItemWidth="320"/></ScrollViewer></Grid>
    </Grid>
    <Border x:Name="FooterBorder" Grid.Row="2" Background="#0a1218" BorderBrush="#224444" BorderThickness="0,1,0,0"><Grid Margin="18,10"><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions><StackPanel Orientation="Horizontal" VerticalAlignment="Center"><Button x:Name="SelectAllBtn" Content="SELECT ALL" Padding="16,10" Margin="0,0,10,0"/><Button x:Name="ResetAllBtn" Content="RESET ALL" Padding="16,10" Margin="0,0,10,0"/><Button x:Name="ExportBatBtn" Content="EXPORT BAT" Padding="16,10" Margin="0,0,10,0"/><Button x:Name="ApplyBtn" Content="APPLY SELECTED" Padding="18,10"/></StackPanel><StackPanel Grid.Column="1" VerticalAlignment="Center"><TextBlock Text="TWEAKS SELECTED" FontSize="11" Foreground="#7ca7a2" HorizontalAlignment="Right"/><TextBlock x:Name="SelectedCountText" Text="0" FontSize="20" FontWeight="Bold" HorizontalAlignment="Right"/></StackPanel></Grid></Border>
  </Grid>
</Window>
"@
$reader = [System.Xml.XmlNodeReader]::new($xaml)
$Window = [Windows.Markup.XamlReader]::Load($reader)
$find = { param($n) $Window.FindName($n) }
$SidebarList = & $find 'SidebarList'; $CardPanel = & $find 'CardPanel'; $SectionTitle = & $find 'SectionTitle'; $SectionDesc = & $find 'SectionDesc'; $SelectedCountText = & $find 'SelectedCountText'; $LogoText = & $find 'LogoText'; $HeaderBorder = & $find 'HeaderBorder'; $SidebarBorder = & $find 'SidebarBorder'; $FooterBorder = & $find 'FooterBorder'
$script:CheckboxMap = @{}
$script:SectionOrder = @(
    [pscustomobject]@{ Key='fortnite'; Title='Fortnite FPS'; Desc='Maximum FPS, minimum input lag. Uses the same tweak sections from your original LakTweaks HTML.' },
    [pscustomobject]@{ Key='services'; Title='Windows Services'; Desc='Disable unnecessary background services. These are the same categories from your tool.' },
    [pscustomobject]@{ Key='registry'; Title='Registry Tweaks'; Desc='Registry changes for responsiveness, Explorer behavior, and background activity.' },
    [pscustomobject]@{ Key='gpu'; Title='GPU / NVIDIA'; Desc='GPU, NVIDIA, DirectX, USB priority, and latency-related settings.' },
    [pscustomobject]@{ Key='network'; Title='Network'; Desc='Gaming-focused TCP/IP, NDU, NetBT, and network responsiveness settings.' },
    [pscustomobject]@{ Key='input'; Title='Input / Mouse'; Desc='Mouse acceleration, buffer, raw input, and keyboard/mouse priority settings.' },
    [pscustomobject]@{ Key='privacy'; Title='Privacy'; Desc='Telemetry, CEIP, widgets, and related privacy-focused settings.' },
    [pscustomobject]@{ Key='debloat'; Title='Process Debloat'; Desc='Common background process cleanup and startup entry removal.' },
    [pscustomobject]@{ Key='power'; Title='Power Plan'; Desc='Ultimate Performance, CPU power state, and USB power settings.' },
    [pscustomobject]@{ Key='ui'; Title='UI Settings'; Desc='Theme presets, accent color, background opacity, glow, compact mode, clean mode, scanlines, and grid strength.' }
)

function Update-SelectedCount {
    $count = 0
    foreach($entry in $script:CheckboxMap.Values) {
        if ($entry.CheckBox.IsEnabled -and $entry.CheckBox.IsChecked) { $count++ }
    }
    $SelectedCountText.Text = [string]$count
}
function Apply-Theme {
    $accent = Get-ColorBrush $script:CurrentAccent
    $borderOpacity = [Math]::Min(0.75, 0.10 + ($script:CurrentGlow * 0.55))
    $accentLite = Get-ArgbBrush $script:CurrentAccent $borderOpacity
    $panelOpacity = [Math]::Min(1.0, [Math]::Max(0.40, $script:CurrentBgOpacity))

    $Window.Background = Get-ArgbBrush '#050a0f' 1.0
    $HeaderBorder.Background = Get-ArgbBrush '#0a1218' $panelOpacity
    $SidebarBorder.Background = Get-ArgbBrush '#091016' $panelOpacity
    $FooterBorder.Background = Get-ArgbBrush '#0a1218' $panelOpacity
    $HeaderBorder.Opacity = [Math]::Min(1.0, 0.88 + ($script:CurrentScanlines * 0.12))
    $SidebarBorder.Opacity = [Math]::Min(1.0, 0.88 + ($script:CurrentScanlines * 0.12))
    $FooterBorder.Opacity = [Math]::Min(1.0, 0.88 + ($script:CurrentScanlines * 0.12))

    $HeaderBorder.BorderBrush = $accentLite
    $SidebarBorder.BorderBrush = $accentLite
    $FooterBorder.BorderBrush = $accentLite
    $LogoText.Foreground = $accent
    $SectionTitle.Foreground = $accent
    $SelectedCountText.Foreground = $accent

    foreach($btn in 'ThemeCyan','ThemePink','ThemeGold','ThemePurple','ThemeRed') {
        $b = & $find $btn
        $b.Background = Get-ColorBrush $b.Tag
        $b.BorderBrush = if ($b.Tag -eq $script:CurrentAccent) { [Windows.Media.Brushes]::White } else { Get-ArgbBrush '#ffffff' 0.12 }
        $b.BorderThickness = '2'
    }

    foreach($item in $SidebarList.Items) {
        $item.Background = Get-ArgbBrush $script:CurrentAccent (0.02 + ($script:CurrentGrid * 0.10))
        $item.BorderBrush = Get-ArgbBrush $script:CurrentAccent (0.06 + ($script:CurrentGlow * 0.22))
    }
}
function Set-TweakVisualState([string]$id) {
    if (-not $script:CheckboxMap.ContainsKey($id)) { return }
    $entry = $script:CheckboxMap[$id]
    if (Test-TweakApplied $id) {
        $entry.CheckBox.IsChecked = $false
        $entry.CheckBox.IsEnabled = $false
        $entry.CheckBox.Content = 'Already Applied'
        $entry.CheckBox.Foreground = Get-ColorBrush '#2ed573'
        $entry.Status.Text = 'ENABLED'
        $entry.Status.Foreground = Get-ColorBrush '#2ed573'
        $entry.Card.BorderBrush = Get-ArgbBrush '#2ed573' 0.45
        $entry.Card.Background = if($script:CurrentClean){Get-ArgbBrush '#102017' 0.95}else{Get-ArgbBrush '#2ed573' 0.08}
    } else {
        $entry.CheckBox.IsEnabled = $true
        $entry.CheckBox.Content = 'Enable'
        $entry.CheckBox.Foreground = Get-ColorBrush $script:CurrentAccent
        $entry.Status.Text = 'NOT APPLIED'
        $entry.Status.Foreground = Get-ColorBrush '#7ca7a2'
        $entry.Card.BorderBrush = Get-ArgbBrush $script:CurrentAccent (0.12 + ($script:CurrentGlow * 0.22))
        $entry.Card.Background = if($script:CurrentClean){Get-ArgbBrush '#0e171d' ([Math]::Max(0.78,$script:CurrentBgOpacity))}else{Get-ArgbBrush $script:CurrentAccent (0.03 + ($script:CurrentBgOpacity * 0.08))}
    }
}
function New-Card([object]$item) {
    $outer = [Windows.Controls.Border]::new()
    $outer.Width = if($script:CurrentCompact) {300} else {320}
    $outer.Margin = '0,0,14,14'
    $outer.Padding = if($script:CurrentCompact){'12'}else{'16'}
    $outer.CornerRadius = '12'
    $outer.Background = if($script:CurrentClean){Get-ArgbBrush '#0e171d' ([Math]::Max(0.78,$script:CurrentBgOpacity))}else{Get-ArgbBrush $script:CurrentAccent (0.03 + ($script:CurrentBgOpacity * 0.08))}
    $outer.BorderBrush = Get-ArgbBrush $script:CurrentAccent (0.12 + ($script:CurrentGlow * 0.22))
    $outer.BorderThickness = '1'

    $stack=[Windows.Controls.StackPanel]::new()
    $title=[Windows.Controls.TextBlock]::new(); $title.Text=$item.Title; $title.FontSize=15; $title.FontWeight='Bold'; $title.Foreground=[Windows.Media.Brushes]::White; $stack.Children.Add($title)|Out-Null
    $cat=[Windows.Controls.TextBlock]::new(); $cat.Text=$item.Category; $cat.FontSize=10; $cat.Foreground=Get-ArgbBrush $script:CurrentAccent 0.9; $cat.Margin='0,4,0,8'; $stack.Children.Add($cat)|Out-Null
    $desc=[Windows.Controls.TextBlock]::new(); $desc.Text=$item.Description; $desc.TextWrapping='Wrap'; $desc.Foreground=Get-ColorBrush '#7ca7a2'; $desc.FontSize=if($script:CurrentCompact){11}else{12}; $desc.Margin='0,0,0,12'; $stack.Children.Add($desc)|Out-Null

    $status=[Windows.Controls.TextBlock]::new(); $status.FontSize=10; $status.FontWeight='Bold'; $status.Margin='0,0,0,8'; $stack.Children.Add($status)|Out-Null
    $cb=[Windows.Controls.CheckBox]::new(); $cb.Content='Enable'; $cb.Foreground=Get-ColorBrush $script:CurrentAccent; $cb.FontWeight='SemiBold'; $cb.Tag=$item.Id
    $cb.Add_Checked({ Update-SelectedCount })
    $cb.Add_Unchecked({ Update-SelectedCount })
    $stack.Children.Add($cb)|Out-Null

    $outer.Child = $stack
    $script:CheckboxMap[$item.Id] = [pscustomobject]@{ CheckBox=$cb; Status=$status; Card=$outer }
    Set-TweakVisualState $item.Id
    return $outer
}

function New-UiSliderRow {
    param(
        [Parameter(Mandatory=$true)]$Parent,
        [Parameter(Mandatory=$true)][string]$Label,
        [Parameter(Mandatory=$true)][double]$Minimum,
        [Parameter(Mandatory=$true)][double]$Maximum,
        [Parameter(Mandatory=$true)][double]$Value,
        [Parameter(Mandatory=$true)][string]$SettingKey
    )

    $sp = [Windows.Controls.StackPanel]::new()
    $sp.Margin = '0,6,0,12'

    $row = [Windows.Controls.DockPanel]::new()
    $tb = [Windows.Controls.TextBlock]::new()
    $tb.Text = $Label
    $tb.Foreground = [Windows.Media.Brushes]::White
    $tb.FontWeight = 'SemiBold'
    [Windows.Controls.DockPanel]::SetDock($tb,'Left')
    $row.Children.Add($tb) | Out-Null

    $valText = [Windows.Controls.TextBlock]::new()
    $valText.Text = [string][int][Math]::Round($Value)
    $valText.Foreground = Get-ColorBrush $script:CurrentAccent
    [Windows.Controls.DockPanel]::SetDock($valText,'Right')
    $row.Children.Add($valText) | Out-Null
    $sp.Children.Add($row) | Out-Null

    $sl = [Windows.Controls.Slider]::new()
    $sl.Minimum = $Minimum
    $sl.Maximum = $Maximum
    $sl.Value = $Value
    $sl.TickFrequency = 1
    $sl.IsMoveToPointEnabled = $true
    $sl.IsSnapToTickEnabled = $false
    $sl.Margin = '0,6,0,0'
    $sl.Height = 24
    $sl.Width = 420
    $sl.Tag = [pscustomobject]@{ ValueText = $valText; SettingKey = $SettingKey }
    $sl.Add_ValueChanged({
        param($sender,$args)
        if ($null -eq $sender) { return }

        $meta = $sender.Tag
        if ($null -eq $meta) { return }

        $rounded = [int][Math]::Round($sender.Value)
        if ($meta.ValueText -is [Windows.Controls.TextBlock]) {
            $meta.ValueText.Text = [string]$rounded
        }

        switch ([string]$meta.SettingKey) {
            'BgOpacity' { $script:CurrentBgOpacity = [math]::Round($sender.Value / 100, 2) }
            'Glow'      { $script:CurrentGlow      = [math]::Round($sender.Value / 100, 2) }
            'Grid'      { $script:CurrentGrid      = [math]::Round($sender.Value / 100, 2) }
            'Scanlines' { $script:CurrentScanlines = [math]::Round($sender.Value / 100, 2) }
        }

        Save-UiSettings
        Apply-Theme
    })
    $sp.Children.Add($sl) | Out-Null
    $Parent.Children.Add($sp) | Out-Null
    return $sl
}
function Show-UiSettings {
    $CardPanel.Children.Clear()
    $CardPanel.ItemWidth = [double]::NaN

    $left=[Windows.Controls.Border]::new()
    $left.Width=460
    $left.Margin='0,0,18,14'
    $left.Padding='18'
    $left.CornerRadius='12'
    $left.Background=Get-ArgbBrush $script:CurrentAccent (0.04 + ($script:CurrentBgOpacity * 0.06))
    $left.BorderBrush=Get-ArgbBrush $script:CurrentAccent (0.20 + ($script:CurrentGlow * 0.20))
    $left.BorderThickness='1'

    $stack=[Windows.Controls.StackPanel]::new()
    $h=[Windows.Controls.TextBlock]::new(); $h.Text='Theme Presets'; $h.FontSize=20; $h.FontWeight='Bold'; $h.Foreground=Get-ColorBrush $script:CurrentAccent; $stack.Children.Add($h)|Out-Null
    $d=[Windows.Controls.TextBlock]::new(); $d.Text='Tune the whole app look here. Presets, sliders, accent color, compact mode, and clean mode are all here.'; $d.TextWrapping='Wrap'; $d.Foreground=Get-ColorBrush '#7ca7a2'; $d.Margin='0,6,0,14'; $stack.Children.Add($d)|Out-Null

    $presetPanel=[Windows.Controls.WrapPanel]::new(); $presetPanel.Margin='0,0,0,12'
    foreach($preset in @(@{Name='Cyan Core';Hex='#00ffe7'},@{Name='Pink Surge';Hex='#ff3cac'},@{Name='Gold Rush';Hex='#f9c74f'},@{Name='Purple Voltage';Hex='#784dff'},@{Name='Red Strike';Hex='#ff4757'})) {
        $b=[Windows.Controls.Button]::new()
        $b.Content=$preset.Name
        $b.Margin='0,0,8,8'
        $b.Padding='10,10'
        $b.MinWidth=100
        $b.Background=Get-ArgbBrush $preset.Hex 0.18
        $b.BorderBrush=Get-ArgbBrush $preset.Hex 0.55
        $b.Foreground='White'
        $b.Tag=$preset.Hex
        $b.Add_Click({
            param($sender,$args)
            $script:CurrentAccent = [string]$sender.Tag
            Save-UiSettings
            Apply-Theme
            Show-UiSettings
        })
        $presetPanel.Children.Add($b)|Out-Null
    }
    $stack.Children.Add($presetPanel)|Out-Null

    $null = New-UiSliderRow -Parent $stack -Label 'Background Opacity' -Minimum 45 -Maximum 100 -Value ($script:CurrentBgOpacity*100) -SettingKey 'BgOpacity'
    $null = New-UiSliderRow -Parent $stack -Label 'Glow Strength' -Minimum 0 -Maximum 100 -Value ($script:CurrentGlow*100) -SettingKey 'Glow'
    $null = New-UiSliderRow -Parent $stack -Label 'Grid Strength' -Minimum 0 -Maximum 100 -Value ($script:CurrentGrid*100) -SettingKey 'Grid'
    $null = New-UiSliderRow -Parent $stack -Label 'Scanlines' -Minimum 0 -Maximum 100 -Value ($script:CurrentScanlines*100) -SettingKey 'Scanlines'

    $accentBox=[Windows.Controls.TextBox]::new(); $accentBox.Text=$script:CurrentAccent; $accentBox.Margin='0,6,0,0'; $accentBox.Background='#101820'; $accentBox.Foreground='White'; $accentBox.BorderBrush=Get-ArgbBrush $script:CurrentAccent 0.55; $accentBox.Width=420; $stack.Children.Add($accentBox)|Out-Null
    $accentApply=[Windows.Controls.Button]::new(); $accentApply.Content='Apply Accent'; $accentApply.Margin='0,8,0,0'; $accentApply.Padding='10,8'; $accentApply.Width=420; $accentApply.Add_Click({ try { [void](Get-ColorBrush $accentBox.Text); $script:CurrentAccent = $accentBox.Text; Save-UiSettings; Apply-Theme; Show-UiSettings } catch { [System.Windows.MessageBox]::Show('Use a valid hex color like #00ffe7') | Out-Null } }); $stack.Children.Add($accentApply)|Out-Null

    $compactCb=[Windows.Controls.CheckBox]::new(); $compactCb.Content='Compact Mode'; $compactCb.IsChecked=$script:CurrentCompact; $compactCb.Margin='0,10,0,6'; $compactCb.Foreground='White'; $compactCb.Add_Click({ param($sender,$args) $script:CurrentCompact = [bool]$sender.IsChecked; Save-UiSettings; Show-UiSettings }); $stack.Children.Add($compactCb)|Out-Null
    $cleanCb=[Windows.Controls.CheckBox]::new(); $cleanCb.Content='Clean Mode'; $cleanCb.IsChecked=$script:CurrentClean; $cleanCb.Margin='0,0,0,10'; $cleanCb.Foreground='White'; $cleanCb.Add_Click({ param($sender,$args) $script:CurrentClean = [bool]$sender.IsChecked; Save-UiSettings; Show-UiSettings }); $stack.Children.Add($cleanCb)|Out-Null

    $row=[Windows.Controls.WrapPanel]::new(); $row.Margin='0,12,0,0'
    $reset=[Windows.Controls.Button]::new(); $reset.Content='Reset UI'; $reset.Padding='12,8'; $reset.Margin='0,0,8,0'; $reset.Add_Click({ $script:CurrentAccent='#00ffe7'; $script:CurrentBgOpacity=0.92; $script:CurrentGlow=0.65; $script:CurrentCompact=$false; $script:CurrentClean=$false; $script:CurrentScanlines=0.30; $script:CurrentGrid=0.30; Save-UiSettings; Apply-Theme; Show-UiSettings }); $row.Children.Add($reset)|Out-Null
    $random=[Windows.Controls.Button]::new(); $random.Content='Randomize'; $random.Padding='12,8'; $random.Add_Click({ $colors='#00ffe7','#ff3cac','#f9c74f','#784dff','#ff4757','#21d4fd'; $script:CurrentAccent=Get-Random $colors; $script:CurrentBgOpacity=[math]::Round((Get-Random -Minimum 55 -Maximum 97)/100,2); $script:CurrentGlow=[math]::Round((Get-Random -Minimum 25 -Maximum 100)/100,2); $script:CurrentGrid=[math]::Round((Get-Random -Minimum 10 -Maximum 70)/100,2); $script:CurrentScanlines=[math]::Round((Get-Random -Minimum 0 -Maximum 60)/100,2); Save-UiSettings; Apply-Theme; Show-UiSettings }); $row.Children.Add($random)|Out-Null
    $stack.Children.Add($row)|Out-Null
    $left.Child=$stack

    $right=[Windows.Controls.Border]::new()
    $right.Width=460
    $right.Margin='0,0,14,14'
    $right.Padding='18'
    $right.CornerRadius='12'
    $right.Background=Get-ArgbBrush '#0e171d' ([Math]::Max(0.78,$script:CurrentBgOpacity))
    $right.BorderBrush=Get-ArgbBrush $script:CurrentAccent (0.20 + ($script:CurrentGlow * 0.20))
    $right.BorderThickness='1'

    $rstack=[Windows.Controls.StackPanel]::new()
    $rh=[Windows.Controls.TextBlock]::new(); $rh.Text='Live Preview'; $rh.FontSize=20; $rh.FontWeight='Bold'; $rh.Foreground=Get-ColorBrush $script:CurrentAccent; $rstack.Children.Add($rh)|Out-Null
    $rd=[Windows.Controls.TextBlock]::new(); $rd.Text='A quick preview of the shell style. The tweak sections stay the same, but this page controls the full look and feel.'; $rd.TextWrapping='Wrap'; $rd.Foreground=Get-ColorBrush '#7ca7a2'; $rd.Margin='0,6,0,14'; $rstack.Children.Add($rd)|Out-Null

    $preview=[Windows.Controls.Border]::new(); $preview.Height=360; $preview.CornerRadius='12'; $preview.Background=Get-ArgbBrush '#071017' $script:CurrentBgOpacity; $preview.BorderBrush=Get-ArgbBrush $script:CurrentAccent (0.16 + ($script:CurrentGlow * 0.30)); $preview.BorderThickness='1'; $preview.Padding='16'
    $pv=[Windows.Controls.StackPanel]::new()
    $p1=[Windows.Controls.TextBlock]::new(); $p1.Text='LAKTWEAKS PREVIEW'; $p1.Foreground=Get-ColorBrush $script:CurrentAccent; $p1.FontSize=20; $p1.FontWeight='Bold'; $pv.Children.Add($p1)|Out-Null
    $p2=[Windows.Controls.TextBlock]::new(); $p2.Text='Elite PC Optimizer'; $p2.Foreground='White'; $p2.Margin='0,10,0,8'; $p2.FontSize=16; $pv.Children.Add($p2)|Out-Null
    $pc=[Windows.Controls.Border]::new(); $pc.Margin='0,12,0,0'; $pc.Padding=if($script:CurrentCompact){'10'}else{'14'}; $pc.Background=if($script:CurrentClean){Get-ArgbBrush '#111a21' 0.95}else{Get-ArgbBrush $script:CurrentAccent (0.05 + $script:CurrentGrid * 0.10)}; $pc.BorderBrush=Get-ArgbBrush $script:CurrentAccent (0.14 + ($script:CurrentGlow * 0.25)); $pc.BorderThickness='1'; $pc.CornerRadius='10'
    $pcs=[Windows.Controls.StackPanel]::new(); $pct=[Windows.Controls.TextBlock]::new(); $pct.Text='Fortnite FPS Boost'; $pct.Foreground='White'; $pct.FontWeight='Bold'; $pcs.Children.Add($pct)|Out-Null; $pcd=[Windows.Controls.TextBlock]::new(); $pcd.Text='Neon accents, glass cards, and responsive controls stay synced with your chosen UI settings.'; $pcd.TextWrapping='Wrap'; $pcd.Margin='0,8,0,0'; $pcd.Foreground=Get-ColorBrush '#7ca7a2'; $pcs.Children.Add($pcd)|Out-Null; $pc.Child=$pcs; $pv.Children.Add($pc)|Out-Null
    $preview.Child=$pv; $rstack.Children.Add($preview)|Out-Null
    $right.Child=$rstack

    $CardPanel.Children.Add($left)|Out-Null
    $CardPanel.Children.Add($right)|Out-Null
}
function Show-Section([string]$key) {
    $CardPanel.Children.Clear()
    if ($key -eq 'ui') {
        $SectionTitle.Text='UI Settings'
        $SectionDesc.Text='Theme presets, accent color, background opacity, glow, compact mode, clean mode, scanlines, and grid strength.'
        Show-UiSettings
        Update-SelectedCount
        return
    }
    $CardPanel.ItemWidth = if($script:CurrentCompact){300}else{320}
    $section = $script:SectionOrder | Where-Object Key -eq $key
    $SectionTitle.Text=$section.Title
    $SectionDesc.Text=$section.Desc
    $script:CheckboxMap = @{}
    $items = $script:Catalog | Where-Object CategoryId -eq $key
    foreach($item in $items) { $CardPanel.Children.Add((New-Card $item)) | Out-Null }
    Update-SelectedCount
}
foreach($sec in $script:SectionOrder) {
    $item=[Windows.Controls.ListBoxItem]::new(); $item.Content=$sec.Title; $item.Tag=$sec.Key; $item.Padding='12,10'; $item.Margin='0,0,0,6'; $item.Background=Get-ArgbBrush $script:CurrentAccent 0.04; $item.BorderBrush=Get-ArgbBrush $script:CurrentAccent 0.10; $item.BorderThickness='1'; $item.Foreground='White'; $SidebarList.Items.Add($item)|Out-Null
}
$SidebarList.Add_SelectionChanged({ if ($SidebarList.SelectedItem) { Show-Section $SidebarList.SelectedItem.Tag } })
$SidebarList.SelectedIndex = 0
foreach($btnName in 'ThemeCyan','ThemePink','ThemeGold','ThemePurple','ThemeRed') {
    (& $find $btnName).Add_Click({
        param($sender,$args)
        $script:CurrentAccent = [string]$sender.Tag
        Save-UiSettings
        Apply-Theme
        if($SidebarList.SelectedItem -and $SidebarList.SelectedItem.Tag -eq 'ui'){Show-UiSettings}else{Show-Section $SidebarList.SelectedItem.Tag}
    })
}
(& $find 'SelectAllBtn').Add_Click({ foreach($entry in $script:CheckboxMap.Values) { if($entry.CheckBox.IsEnabled){ $entry.CheckBox.IsChecked = $true } }; Update-SelectedCount })
(& $find 'ResetAllBtn').Add_Click({ foreach($entry in $script:CheckboxMap.Values) { if($entry.CheckBox.IsEnabled){ $entry.CheckBox.IsChecked = $false } }; Update-SelectedCount })
(& $find 'ExportBatBtn').Add_Click({
    $selected = foreach($item in $script:Catalog) {
        if($script:CheckboxMap.ContainsKey($item.Id) -and $script:CheckboxMap[$item.Id].CheckBox.IsChecked) { $item }
    }
    if(-not $selected) { [System.Windows.MessageBox]::Show('Select at least one tweak first.') | Out-Null; return }
    $dlg = [Microsoft.Win32.SaveFileDialog]::new(); $dlg.Filter = 'Batch Files (*.bat)|*.bat'; $dlg.FileName = 'LAK_TWEAKS_ELITE.bat'
    if($dlg.ShowDialog()) { Export-Bat $selected $dlg.FileName; [System.Windows.MessageBox]::Show('Saved BAT file to ' + $dlg.FileName) | Out-Null }
})
(& $find 'ApplyBtn').Add_Click({
    Ensure-Admin
    $selected = foreach($item in $script:Catalog) {
        if($script:CheckboxMap.ContainsKey($item.Id) -and $script:CheckboxMap[$item.Id].CheckBox.IsChecked) { $item }
    }
    if(-not $selected) { [System.Windows.MessageBox]::Show('Select at least one tweak first.') | Out-Null; return }
    $r = [System.Windows.MessageBox]::Show("Apply $($selected.Count) selected tweaks now? Some are aggressive and may disable services, widgets, or security features.",'LakTweaks','YesNo','Warning')
    if($r -ne 'Yes') { return }
    try {
        $appliedNow = Invoke-TweakCommands $selected
        if(-not $appliedNow -or $appliedNow.Count -eq 0) {
            throw 'No tweaks were applied.'
        }
        Mark-TweaksApplied $appliedNow
        foreach($item in $appliedNow) {
            if($script:CheckboxMap.ContainsKey($item.Id)) { Set-TweakVisualState $item.Id }
        }
        Update-SelectedCount
        [System.Windows.MessageBox]::Show(('Finished applying ' + $appliedNow.Count + ' tweak(s). Reboot your PC for full effect.')) | Out-Null
    } catch {
        [System.Windows.MessageBox]::Show('A tweak hit an error: ' + $_.Exception.Message) | Out-Null
    }
})
Apply-Theme
Show-Section 'fortnite'
Update-SelectedCount
$Window.ShowDialog() | Out-Null
