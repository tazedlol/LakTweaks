
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
    "Command": ":: === Activate Ultimate Performance Power Plan ===\npowercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1\nfor /f \"tokens=4\" %%G in ('powercfg -list ^| findstr /i \"Ultimate\"') do (\n    powercfg -setactive %%G >nul 2>&1\n)\necho [OK] Ultimate Performance power plan activated"
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
    foreach($item in $selected) {
        $cmd = "@echo off`r`n" + $item.Command + "`r`nexit /b %errorlevel%"
        cmd.exe /c $cmd | Out-Null
    }
}
Load-UiSettings
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
function Update-SelectedCount { $SelectedCountText.Text = [string](($script:CheckboxMap.Values | Where-Object IsChecked).Count) }
function Apply-Theme {
    $accent = Get-ColorBrush $script:CurrentAccent; $accentLite = Get-ArgbBrush $script:CurrentAccent 0.18
    $HeaderBorder.BorderBrush = $accentLite; $SidebarBorder.BorderBrush = $accentLite; $FooterBorder.BorderBrush = $accentLite; $LogoText.Foreground = $accent; $SectionTitle.Foreground = $accent; $SelectedCountText.Foreground = $accent
    foreach($btn in 'ThemeCyan','ThemePink','ThemeGold','ThemePurple','ThemeRed') { $b = & $find $btn; $b.Background = Get-ColorBrush $b.Tag; $b.BorderBrush = if ($b.Tag -eq $script:CurrentAccent) { [Windows.Media.Brushes]::White } else { Get-ArgbBrush '#ffffff' 0.0 }; $b.BorderThickness = '2' }
}
function New-Card([object]$item) {
    $outer = [Windows.Controls.Border]::new(); $outer.Width = if($script:CurrentCompact) {300} else {320}; $outer.Margin='0,0,14,14'; $outer.Padding=if($script:CurrentCompact){'12'}else{'16'}; $outer.CornerRadius='12'; $outer.Background=if($script:CurrentClean){Get-ArgbBrush '#0e171d' 0.95}else{Get-ArgbBrush $script:CurrentAccent 0.06}; $outer.BorderBrush=Get-ArgbBrush $script:CurrentAccent 0.26; $outer.BorderThickness='1'
    $stack=[Windows.Controls.StackPanel]::new()
    $title=[Windows.Controls.TextBlock]::new(); $title.Text=$item.Title; $title.FontSize=15; $title.FontWeight='Bold'; $title.Foreground=[Windows.Media.Brushes]::White; $stack.Children.Add($title)|Out-Null
    $cat=[Windows.Controls.TextBlock]::new(); $cat.Text=$item.Category; $cat.FontSize=10; $cat.Foreground=Get-ArgbBrush $script:CurrentAccent 0.9; $cat.Margin='0,4,0,8'; $stack.Children.Add($cat)|Out-Null
    $desc=[Windows.Controls.TextBlock]::new(); $desc.Text=$item.Description; $desc.TextWrapping='Wrap'; $desc.Foreground=Get-ColorBrush '#7ca7a2'; $desc.FontSize=if($script:CurrentCompact){11}else{12}; $desc.Margin='0,0,0,12'; $stack.Children.Add($desc)|Out-Null
    $cb=[Windows.Controls.CheckBox]::new(); $cb.Content='Enable'; $cb.Foreground=Get-ColorBrush $script:CurrentAccent; $cb.FontWeight='SemiBold'; $cb.Tag=$item.Id; $cb.Add_Checked({ Update-SelectedCount }); $cb.Add_Unchecked({ Update-SelectedCount }); $script:CheckboxMap[$item.Id]=$cb; $stack.Children.Add($cb)|Out-Null
    $outer.Child = $stack; return $outer
}
function Show-UiSettings {
    $CardPanel.Children.Clear()
    $left=[Windows.Controls.Border]::new(); $left.Width=520; $left.Margin='0,0,14,14'; $left.Padding='16'; $left.CornerRadius='12'; $left.Background=Get-ArgbBrush $script:CurrentAccent 0.06; $left.BorderBrush=Get-ArgbBrush $script:CurrentAccent 0.26; $left.BorderThickness='1'
    $stack=[Windows.Controls.StackPanel]::new()
    $h=[Windows.Controls.TextBlock]::new(); $h.Text='Theme Presets'; $h.FontSize=18; $h.FontWeight='Bold'; $h.Foreground=Get-ColorBrush $script:CurrentAccent; $stack.Children.Add($h)|Out-Null
    $d=[Windows.Controls.TextBlock]::new(); $d.Text='Live styling controls inspired by your HTML tool: accent, opacity, glow, scanlines, grid, compact mode, and clean mode.'; $d.TextWrapping='Wrap'; $d.Foreground=Get-ColorBrush '#7ca7a2'; $d.Margin='0,4,0,12'; $stack.Children.Add($d)|Out-Null
    $presetPanel=[Windows.Controls.WrapPanel]::new(); $presetPanel.Margin='0,0,0,10'
    foreach($preset in @(@{Name='Cyan Core';Hex='#00ffe7'},@{Name='Pink Surge';Hex='#ff3cac'},@{Name='Gold Rush';Hex='#f9c74f'},@{Name='Purple Voltage';Hex='#784dff'},@{Name='Red Strike';Hex='#ff4757'})) { $b=[Windows.Controls.Button]::new(); $b.Content=$preset.Name; $b.Margin='0,0,8,8'; $b.Padding='12,10'; $b.Background=Get-ArgbBrush $preset.Hex 0.18; $b.BorderBrush=Get-ArgbBrush $preset.Hex 0.55; $b.Foreground='White'; $b.Tag=$preset.Hex; $b.Add_Click({ $script:CurrentAccent = $this.Tag; Apply-Theme; Show-UiSettings; Save-UiSettings }); $presetPanel.Children.Add($b)|Out-Null }
    $stack.Children.Add($presetPanel)|Out-Null
    function Add-SliderRow($parent,$label,$min,$max,$val,$onChanged) { $sp=[Windows.Controls.StackPanel]::new(); $sp.Margin='0,4,0,10'; $tb=[Windows.Controls.TextBlock]::new(); $tb.Text=$label; $tb.Foreground='White'; $sp.Children.Add($tb)|Out-Null; $sl=[Windows.Controls.Slider]::new(); $sl.Minimum=$min; $sl.Maximum=$max; $sl.Value=$val; $sl.Margin='0,4,0,0'; $sl.Add_ValueChanged($onChanged); $sp.Children.Add($sl)|Out-Null; $parent.Children.Add($sp)|Out-Null }
    Add-SliderRow $stack 'Background Opacity' 45 100 ($script:CurrentBgOpacity*100) {
        $script:CurrentBgOpacity = [math]::Round($this.Value/100,2)
        Save-UiSettings
        Show-UiSettings
    }
    Add-SliderRow $stack 'Glow Strength' 0 100 ($script:CurrentGlow*100) {
        $script:CurrentGlow = [math]::Round($this.Value/100,2)
        Save-UiSettings
        Show-UiSettings
    }
    Add-SliderRow $stack 'Grid Strength' 0 100 ($script:CurrentGrid*100) {
        $script:CurrentGrid = [math]::Round($this.Value/100,2)
        Save-UiSettings
        Show-UiSettings
    }
    Add-SliderRow $stack 'Scanlines' 0 100 ($script:CurrentScanlines*100) {
        $script:CurrentScanlines = [math]::Round($this.Value/100,2)
        Save-UiSettings
        Show-UiSettings
    }
    $accentBox=[Windows.Controls.TextBox]::new(); $accentBox.Text=$script:CurrentAccent; $accentBox.Margin='0,6,0,0'; $accentBox.Background='#101820'; $accentBox.Foreground='White'; $accentBox.BorderBrush=Get-ArgbBrush $script:CurrentAccent 0.55; $stack.Children.Add($accentBox)|Out-Null
    $accentApply=[Windows.Controls.Button]::new(); $accentApply.Content='Apply Accent'; $accentApply.Margin='0,8,0,0'; $accentApply.Padding='10,8'; $accentApply.Add_Click({ try { [void](Get-ColorBrush $accentBox.Text); $script:CurrentAccent = $accentBox.Text; Apply-Theme; Show-UiSettings; Save-UiSettings } catch { [System.Windows.MessageBox]::Show('Use a valid hex color like #00ffe7') | Out-Null } }); $stack.Children.Add($accentApply)|Out-Null
    $compactCb=[Windows.Controls.CheckBox]::new(); $compactCb.Content='Compact Mode'; $compactCb.IsChecked=$script:CurrentCompact; $compactCb.Margin='0,8,0,6'; $compactCb.Foreground='White'; $compactCb.Add_Click({
        $script:CurrentCompact = [bool]$this.IsChecked
        Save-UiSettings
        if($SidebarList.SelectedItem -and $SidebarList.SelectedItem.Tag -eq 'ui'){ Show-UiSettings }
        elseif($SidebarList.SelectedItem){ Show-Section $SidebarList.SelectedItem.Tag }
    }); $stack.Children.Add($compactCb)|Out-Null
    $cleanCb=[Windows.Controls.CheckBox]::new(); $cleanCb.Content='Clean Mode'; $cleanCb.IsChecked=$script:CurrentClean; $cleanCb.Margin='0,0,0,8'; $cleanCb.Foreground='White'; $cleanCb.Add_Click({
        $script:CurrentClean = [bool]$this.IsChecked
        Save-UiSettings
        if($SidebarList.SelectedItem -and $SidebarList.SelectedItem.Tag -eq 'ui'){ Show-UiSettings }
        elseif($SidebarList.SelectedItem){ Show-Section $SidebarList.SelectedItem.Tag }
    }); $stack.Children.Add($cleanCb)|Out-Null
    $row=[Windows.Controls.WrapPanel]::new(); $row.Margin='0,12,0,0'
    $reset=[Windows.Controls.Button]::new(); $reset.Content='Reset UI'; $reset.Padding='12,8'; $reset.Margin='0,0,8,0'; $reset.Add_Click({ $script:CurrentAccent='#00ffe7'; $script:CurrentBgOpacity=0.92; $script:CurrentGlow=0.65; $script:CurrentCompact=$false; $script:CurrentClean=$false; $script:CurrentScanlines=0.30; $script:CurrentGrid=0.30; Save-UiSettings; Apply-Theme; Show-UiSettings }); $row.Children.Add($reset)|Out-Null
    $random=[Windows.Controls.Button]::new(); $random.Content='Randomize'; $random.Padding='12,8'; $random.Add_Click({ $colors='#00ffe7','#ff3cac','#f9c74f','#784dff','#ff4757','#21d4fd'; $script:CurrentAccent=Get-Random $colors; $script:CurrentBgOpacity=[math]::Round((Get-Random -Minimum 55 -Maximum 97)/100,2); $script:CurrentGlow=[math]::Round((Get-Random -Minimum 25 -Maximum 100)/100,2); $script:CurrentGrid=[math]::Round((Get-Random -Minimum 10 -Maximum 70)/100,2); $script:CurrentScanlines=[math]::Round((Get-Random -Minimum 0 -Maximum 60)/100,2); Save-UiSettings; Apply-Theme; Show-UiSettings }); $row.Children.Add($random)|Out-Null
    $stack.Children.Add($row)|Out-Null; $left.Child=$stack
    $right=[Windows.Controls.Border]::new(); $right.Width=520; $right.Margin='0,0,14,14'; $right.Padding='16'; $right.CornerRadius='12'; $right.Background=Get-ArgbBrush '#0e171d' 0.95; $right.BorderBrush=Get-ArgbBrush $script:CurrentAccent 0.26; $right.BorderThickness='1'
    $rstack=[Windows.Controls.StackPanel]::new(); $rh=[Windows.Controls.TextBlock]::new(); $rh.Text='Live Preview'; $rh.FontSize=18; $rh.FontWeight='Bold'; $rh.Foreground=Get-ColorBrush $script:CurrentAccent; $rstack.Children.Add($rh)|Out-Null
    $rd=[Windows.Controls.TextBlock]::new(); $rd.Text='A quick preview of the shell style. The tweak sections stay the same, but this page controls the full look and feel.'; $rd.TextWrapping='Wrap'; $rd.Foreground=Get-ColorBrush '#7ca7a2'; $rd.Margin='0,4,0,12'; $rstack.Children.Add($rd)|Out-Null
    $preview=[Windows.Controls.Border]::new(); $preview.Height=320; $preview.CornerRadius='12'; $preview.Background=Get-ArgbBrush '#071017' $script:CurrentBgOpacity; $preview.BorderBrush=Get-ArgbBrush $script:CurrentAccent 0.35; $preview.BorderThickness='1'; $preview.Padding='14'
    $pv=[Windows.Controls.StackPanel]::new(); $p1=[Windows.Controls.TextBlock]::new(); $p1.Text='LAKTWEAKS PREVIEW'; $p1.Foreground=Get-ColorBrush $script:CurrentAccent; $p1.FontSize=20; $p1.FontWeight='Bold'; $pv.Children.Add($p1)|Out-Null; $p2=[Windows.Controls.TextBlock]::new(); $p2.Text='Elite PC Optimizer'; $p2.Foreground='White'; $p2.Margin='0,10,0,8'; $p2.FontSize=16; $pv.Children.Add($p2)|Out-Null
    $pc=[Windows.Controls.Border]::new(); $pc.Margin='0,10,0,0'; $pc.Padding='12'; $pc.Background=if($script:CurrentClean){Get-ArgbBrush '#111a21' 0.95}else{Get-ArgbBrush $script:CurrentAccent 0.10}; $pc.BorderBrush=Get-ArgbBrush $script:CurrentAccent 0.28; $pc.BorderThickness='1'; $pc.CornerRadius='10'
    $pcs=[Windows.Controls.StackPanel]::new(); $pct=[Windows.Controls.TextBlock]::new(); $pct.Text='Fortnite FPS Boost'; $pct.Foreground='White'; $pct.FontWeight='Bold'; $pcs.Children.Add($pct)|Out-Null; $pcd=[Windows.Controls.TextBlock]::new(); $pcd.Text='Neon accents, glass cards, and responsive controls stay synced with your chosen UI settings.'; $pcd.TextWrapping='Wrap'; $pcd.Margin='0,8,0,0'; $pcd.Foreground=Get-ColorBrush '#7ca7a2'; $pcs.Children.Add($pcd)|Out-Null; $pc.Child=$pcs; $pv.Children.Add($pc)|Out-Null; $preview.Child=$pv; $rstack.Children.Add($preview)|Out-Null; $right.Child=$rstack
    $CardPanel.Children.Add($left)|Out-Null; $CardPanel.Children.Add($right)|Out-Null
}
function Show-Section([string]$key) {
    $CardPanel.Children.Clear(); $section = $script:SectionOrder | Where-Object Key -eq $key; $SectionTitle.Text=$section.Title; $SectionDesc.Text=$section.Desc
    if ($key -eq 'ui') { Show-UiSettings; return }
    $items = $script:Catalog | Where-Object CategoryId -eq $key
    foreach($item in $items) { $CardPanel.Children.Add((New-Card $item)) | Out-Null }
    Update-SelectedCount
}
foreach($sec in $script:SectionOrder) { $item=[Windows.Controls.ListBoxItem]::new(); $item.Content=$sec.Title; $item.Tag=$sec.Key; $item.Padding='12,10'; $item.Margin='0,0,0,6'; $item.Background=Get-ArgbBrush $script:CurrentAccent 0.04; $item.BorderBrush=Get-ArgbBrush $script:CurrentAccent 0.10; $item.BorderThickness='1'; $item.Foreground='White'; $SidebarList.Items.Add($item)|Out-Null }
$SidebarList.Add_SelectionChanged({ if ($SidebarList.SelectedItem) { Show-Section $SidebarList.SelectedItem.Tag } })
$SidebarList.SelectedIndex = 0
foreach($btnName in 'ThemeCyan','ThemePink','ThemeGold','ThemePurple','ThemeRed') { (& $find $btnName).Add_Click({ $script:CurrentAccent = $this.Tag; Save-UiSettings; Apply-Theme; if($SidebarList.SelectedItem -and $SidebarList.SelectedItem.Tag -eq 'ui'){Show-UiSettings}else{Show-Section $SidebarList.SelectedItem.Tag} }) }
(& $find 'SelectAllBtn').Add_Click({ foreach($cb in $script:CheckboxMap.Values) { $cb.IsChecked = $true }; Update-SelectedCount })
(& $find 'ResetAllBtn').Add_Click({ foreach($cb in $script:CheckboxMap.Values) { $cb.IsChecked = $false }; Update-SelectedCount })
(& $find 'ExportBatBtn').Add_Click({ $selected = foreach($item in $script:Catalog) { if($script:CheckboxMap.ContainsKey($item.Id) -and $script:CheckboxMap[$item.Id].IsChecked) { $item } }; if(-not $selected) { [System.Windows.MessageBox]::Show('Select at least one tweak first.') | Out-Null; return }; $dlg = [Microsoft.Win32.SaveFileDialog]::new(); $dlg.Filter = 'Batch Files (*.bat)|*.bat'; $dlg.FileName = 'LAK_TWEAKS_ELITE.bat'; if($dlg.ShowDialog()) { Export-Bat $selected $dlg.FileName; [System.Windows.MessageBox]::Show('Saved BAT file to ' + $dlg.FileName) | Out-Null } })
(& $find 'ApplyBtn').Add_Click({ Ensure-Admin; $selected = foreach($item in $script:Catalog) { if($script:CheckboxMap.ContainsKey($item.Id) -and $script:CheckboxMap[$item.Id].IsChecked) { $item } }; if(-not $selected) { [System.Windows.MessageBox]::Show('Select at least one tweak first.') | Out-Null; return }; $r = [System.Windows.MessageBox]::Show("Apply $($selected.Count) selected tweaks now? Some are aggressive and may disable services, widgets, or security features.",'LakTweaks','YesNo','Warning'); if($r -ne 'Yes') { return }; try { Invoke-TweakCommands $selected; [System.Windows.MessageBox]::Show('Finished applying selected tweaks. Reboot your PC for full effect.') | Out-Null } catch { [System.Windows.MessageBox]::Show('A tweak hit an error: ' + $_.Exception.Message) | Out-Null } })
Apply-Theme
Show-Section 'fortnite'
Update-SelectedCount
$Window.ShowDialog() | Out-Null
