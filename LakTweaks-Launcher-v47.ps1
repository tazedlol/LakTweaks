
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
    "Id": "pro_fse_gamedvr",
    "Title": "Pro FSE + GameDVR Off",
    "Description": "Disables capture overhead while keeping the correct exclusive fullscreen/FSE-compatible values. Replaces the old conflicting GameDVR tweak.",
    "Command": ":: === Pro FSE + GameDVR Off ===\nreg add \"HKCU\\System\\GameConfigStore\" /v \"GameDVR_Enabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\System\\GameConfigStore\" /v \"GameDVR_FSEBehaviorMode\" /t REG_DWORD /d 2 /f >nul 2>&1\nreg add \"HKCU\\System\\GameConfigStore\" /v \"GameDVR_FSEBehavior\" /t REG_DWORD /d 2 /f >nul 2>&1\nreg add \"HKCU\\System\\GameConfigStore\" /v \"GameDVR_DSEBehavior\" /t REG_DWORD /d 2 /f >nul 2>&1\nreg add \"HKCU\\System\\GameConfigStore\" /v \"GameDVR_DXGIHonorFSEWindowsCompatible\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKCU\\System\\GameConfigStore\" /v \"GameDVR_HonorUserFSEBehaviorMode\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKCU\\System\\GameConfigStore\" /v \"GameDVR_EFSEFeatureFlags\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\GameDVR\" /v \"AppCaptureEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\GameDVR\" /v \"AudioCaptureEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\GameDVR\" /v \"CursorCaptureEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\GameDVR\" /v \"MicrophoneCaptureEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\Software\\Microsoft\\GameBar\" /v \"AllowAutoGameMode\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\Software\\Microsoft\\GameBar\" /v \"AutoGameModeEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\Software\\Microsoft\\GameBar\" /v \"ShowStartupPanel\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\SOFTWARE\\Policies\\Microsoft\\Windows\\GameDVR\" /v \"AllowGameDVR\" /t REG_DWORD /d 0 /f >nul 2>&1\ntaskkill /f /im GameBar.exe >nul 2>&1\ntaskkill /f /im GameBarFTServer.exe >nul 2>&1\necho [OK] GameDVR/GameBar disabled with correct FSE values"
  },
  {
    "CategoryId": "fortnite",
    "Category": "FORTNITE FPS / PERFORMANCE",
    "Id": "pro_mmcss_scheduler",
    "Title": "Competitive MMCSS Scheduler",
    "Description": "Keeps the proven multimedia/game scheduling keys without random memory or CSRSS hacks.",
    "Command": ":: === Competitive MMCSS Scheduler ===\nreg add \"HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile\" /v \"NetworkThrottlingIndex\" /t REG_DWORD /d 4294967295 /f >nul 2>&1\nreg add \"HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile\" /v \"SystemResponsiveness\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile\\Tasks\\Games\" /v \"Affinity\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile\\Tasks\\Games\" /v \"Background Only\" /t REG_SZ /d \"False\" /f >nul 2>&1\nreg add \"HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile\\Tasks\\Games\" /v \"Clock Rate\" /t REG_DWORD /d 10000 /f >nul 2>&1\nreg add \"HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile\\Tasks\\Games\" /v \"GPU Priority\" /t REG_DWORD /d 8 /f >nul 2>&1\nreg add \"HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile\\Tasks\\Games\" /v \"Priority\" /t REG_DWORD /d 6 /f >nul 2>&1\nreg add \"HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile\\Tasks\\Games\" /v \"Scheduling Category\" /t REG_SZ /d \"High\" /f >nul 2>&1\nreg add \"HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile\\Tasks\\Games\" /v \"SFIO Priority\" /t REG_SZ /d \"High\" /f >nul 2>&1\necho [OK] Competitive MMCSS scheduler applied"
  },
  {
    "CategoryId": "fortnite",
    "Category": "FORTNITE FPS / PERFORMANCE",
    "Id": "win32priority_26_clean",
    "Title": "Win32 Priority Separation 26",
    "Description": "Sets foreground scheduling to 26, avoiding the old conflicting priority values.",
    "Command": ":: === Win32 Priority Separation 26 ===\nreg add \"HKLM\\SYSTEM\\CurrentControlSet\\Control\\PriorityControl\" /v \"Win32PrioritySeparation\" /t REG_DWORD /d 26 /f >nul 2>&1\necho [OK] Win32PrioritySeparation set to 26"
  },
  {
    "CategoryId": "fortnite",
    "Category": "FORTNITE FPS / PERFORMANCE",
    "Id": "directx_swap_upgrade",
    "Title": "DirectX Swap Effect Upgrade",
    "Description": "Enables the DirectX swap-effect upgrade flag used by OneClick-style performance configs.",
    "Command": ":: === DirectX Swap Effect Upgrade ===\nreg add \"HKCU\\Software\\Microsoft\\DirectX\\UserGpuPreferences\" /v \"DirectXUserGlobalSettings\" /t REG_SZ /d \"SwapEffectUpgradeEnable=1;\" /f >nul 2>&1\necho [OK] DirectX swap effect upgrade enabled"
  },
  {
    "CategoryId": "fortnite",
    "Category": "FORTNITE FPS / PERFORMANCE",
    "Id": "fortnite_stable_gpu_timeout",
    "Title": "Stable GPU Timeout Values",
    "Description": "Sets GPU TDR values to 60 seconds in one clean owner tweak. No duplicate TDR writes elsewhere.",
    "Command": ":: === Stable GPU Timeout Values ===\nreg add \"HKLM\\SYSTEM\\CurrentControlSet\\Control\\GraphicsDrivers\" /v \"TdrDelay\" /t REG_DWORD /d 60 /f >nul 2>&1\nreg add \"HKLM\\SYSTEM\\CurrentControlSet\\Control\\GraphicsDrivers\" /v \"TdrDdiDelay\" /t REG_DWORD /d 60 /f >nul 2>&1\necho [OK] Stable GPU timeout values set"
  },
  {
    "CategoryId": "fortnite",
    "Category": "FORTNITE FPS / PERFORMANCE",
    "Id": "fortnite_settings_note",
    "Title": "Fortnite Settings Reminder",
    "Description": "Shows the in-game settings that must be set manually. Reflex is an in-game option, not a fake registry tweak.",
    "Command": ":: === Fortnite Manual Settings Reminder ===\necho [INFO] In Fortnite, set NVIDIA Reflex to ON.\necho [INFO] Use Fullscreen / desired render mode and rebuild shader cache after fresh OS installs.\necho [OK] Manual Fortnite settings reminder complete"
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
    "Description": "Stops Windows Update-related services and blocks auto-install.",
    "Command": ":: === Disable Windows Update Services ===\nfor %%S in (wuauserv UsoSvc WaaSMedicSvc DoSvc BITS) do (\n    sc stop %%S >nul 2>&1\n    sc config %%S start= disabled >nul 2>&1\n)\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\WindowsUpdate\" /v \"DoNotConnectToWindowsUpdateInternetLocations\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\WindowsUpdate\" /v \"ExcludeWUDriversInQualityUpdate\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\WindowsUpdate\\\\AU\" /v \"NoAutoUpdate\" /t REG_DWORD /d 1 /f >nul 2>&1\necho [OK] Windows Update services disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "search_svc",
    "Title": "Disable Windows Search",
    "Description": "Turns off the Search indexing service and kills related processes.",
    "Command": ":: === Disable Windows Search ===\nsc stop WSearch >nul 2>&1\nsc config WSearch start= disabled >nul 2>&1\ntaskkill /f /im SearchHost.exe >nul 2>&1\ntaskkill /f /im SearchApp.exe >nul 2>&1\ntaskkill /f /im SearchIndexer.exe >nul 2>&1\necho [OK] Windows Search disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "sysmain",
    "Title": "Disable SysMain / Superfetch",
    "Description": "Disables SysMain which causes background disk thrashing.",
    "Command": ":: === Disable SysMain ===\nsc stop SysMain >nul 2>&1\nsc config SysMain start= disabled >nul 2>&1\necho [OK] SysMain disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "xbox_gaming",
    "Title": "Disable Xbox / Gaming Services",
    "Description": "Disables Xbox Game Bar services and Microsoft Gaming Services.",
    "Command": ":: === Disable Xbox and Gaming Services ===\nfor %%S in (XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc BcastDVRUserService GamingServices GamingServicesNet) do (\n    sc stop %%S >nul 2>&1\n    sc config %%S start= disabled >nul 2>&1\n)\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\GamingServices\" /v \"Start\" /t REG_DWORD /d 4 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\GamingServicesNet\" /v \"Start\" /t REG_DWORD /d 4 /f >nul 2>&1\necho [OK] Xbox and Gaming services disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "defender_svc",
    "Title": "Disable Windows Defender",
    "Description": "Disables Defender services and real-time protection.",
    "Command": ":: === Disable Windows Defender ===\nsc stop WinDefend >nul 2>&1\nsc config WinDefend start= disabled >nul 2>&1\nsc stop SecurityHealthService >nul 2>&1\nsc config SecurityHealthService start= disabled >nul 2>&1\nsc stop WdNisSvc >nul 2>&1\nsc config WdNisSvc start= disabled >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows Defender\\\\Real-Time Protection\" /v \"DisableRealtimeMonitoring\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows Defender\\\\Features\" /v \"TamperProtection\" /t REG_DWORD /d 0 /f >nul 2>&1\necho [OK] Windows Defender disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "print_svc",
    "Title": "Disable Print Spooler",
    "Description": "Turns off print spooler services.",
    "Command": ":: === Disable Print Spooler ===\nsc stop Spooler >nul 2>&1\nsc config Spooler start= disabled >nul 2>&1\nsc stop PrintNotify >nul 2>&1\nsc config PrintNotify start= disabled >nul 2>&1\nsc config PrintScanBrokerService start= disabled >nul 2>&1\nsc config PrintDeviceConfigurationService start= disabled >nul 2>&1\necho [OK] Print spooler disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "bluetooth_svc",
    "Title": "Disable Bluetooth Services",
    "Description": "Turns off Bluetooth services if unused.",
    "Command": ":: === Disable Bluetooth Services ===\nfor %%S in (bthserv BluetoothUserService BTAGService BthAvctpSvc) do (\n    sc stop %%S >nul 2>&1\n    sc config %%S start= disabled >nul 2>&1\n)\necho [OK] Bluetooth services disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "wer_svc",
    "Title": "Disable Windows Error Reporting",
    "Description": "Stops crash reporting and background error collection.",
    "Command": ":: === Disable Windows Error Reporting ===\nsc stop WerSvc >nul 2>&1\nsc config WerSvc start= disabled >nul 2>&1\nsc config wercplsupport start= disabled >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows\\\\Windows Error Reporting\" /v \"Disabled\" /t REG_DWORD /d 1 /f >nul 2>&1\necho [OK] Windows Error Reporting disabled"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "oneclick_services_pack1",
    "Title": "OneClick Service Debloat Pack 1 (A-D)",
    "Description": "Disables background services A through D from OneClick V8.4: AarSvc, ADPSvc, AJRouter, ALG, AppMgmt, AppReadiness, AssignedAccessManagerSvc, autotimesvc, AxInstSV, BcastDVRUserService, BDESVC, BITS, CaptureService, cbdhsvc, CDPUserSvc, CDPSvc, CertPropSvc, cloudidsvc, COMSysApp, ConsentUxUserSvc, CscService, dcsvc, DeviceAssociationService, DeviceInstall, DiagTrack, diagsvc, DisplayEnhancementService, DmEnrollmentSvc, dmwappushservice, dot3svc, DPS, DsmSvc, DsSvc, DusmSvc.",
    "Command": ":: === OneClick Services Pack 1 (A-D) ===\nfor %%S in (AarSvc ADPSvc AJRouter ALG AppMgmt AppReadiness AssignedAccessManagerSvc autotimesvc AxInstSV BcastDVRUserService BDESVC BITS CaptureService cbdhsvc CDPUserSvc CDPSvc CertPropSvc cloudidsvc COMSysApp ConsentUxUserSvc CscService dcsvc DeviceAssociationService DeviceInstall DevicePickerUserSvc DevicesFlowUserSvc DevQueryBroker diagnosticshub.standardcollector.service DiagTrack diagsvc DisplayEnhancementService DmEnrollmentSvc dmwappushservice dot3svc DPS DsmSvc DsSvc DusmSvc) do (\n    sc stop %%S >nul 2>&1\n    sc config %%S start= disabled >nul 2>&1\n)\necho [OK] OneClick services pack 1 A-D applied"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "oneclick_services_pack2",
    "Title": "OneClick Service Debloat Pack 2 (E-L)",
    "Description": "Disables background services E through L from OneClick V8.4: Eaphost, edgeupdate, edgeupdatem, EFS, EventLog, fdPHost, FDResPub, fhsvc, FontCache, FrameServer, FrameServerMonitor, GameInputSvc, GraphicsPerfSvc, hidserv, HvHost, icssvc, IKEEXT, InstallService, InventorySvc, IpxlatCfgSvc, KtmRm, LanmanServer, LanmanWorkstation, lfsvc, LicenseManager, lltdsvc, lmhosts, LxpSvc.",
    "Command": ":: === OneClick Services Pack 2 (E-L) ===\nfor %%S in (Eaphost edgeupdate edgeupdatem EFS fdPHost FDResPub fhsvc FontCache FrameServer FrameServerMonitor GameInputSvc GraphicsPerfSvc hidserv HvHost icssvc IKEEXT InstallService InventorySvc IpxlatCfgSvc KtmRm LanmanServer LanmanWorkstation lfsvc LicenseManager lltdsvc lmhosts LxpSvc) do (\n    sc stop %%S >nul 2>&1\n    sc config %%S start= disabled >nul 2>&1\n)\necho [OK] OneClick services pack 2 E-L applied"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "oneclick_services_pack3",
    "Title": "OneClick Service Debloat Pack 3 (M-R)",
    "Description": "Disables background services M through R from OneClick V8.4: MapsBroker, MessagingService, MSDTC, MSiSCSI, NaturalAuthentication, NcaSvc, NcbService, NcdAutoSetup, Netlogon, Netman, NetSetupSvc, NetTcpPortSharing, NlaSvc, OneSyncSvc, p2pimsvc, p2psvc, P9RdrService, PcaSvc, PeerDistSvc, PenService, PerfHost, PhoneSvc, PimIndexMaintenanceSvc, pla, PNRPAutoReg, PNRPsvc, PolicyAgent, PushToInstall, QWAVE, RasAuto, RasMan, RemoteAccess, RemoteRegistry, RetailDemo, RmSvc.",
    "Command": ":: === OneClick Services Pack 3 (M-R) ===\nfor %%S in (MapsBroker MessagingService MSDTC MSiSCSI NaturalAuthentication NcaSvc NcbService NcdAutoSetup Netlogon Netman NetSetupSvc NetTcpPortSharing NlaSvc OneSyncSvc p2pimsvc p2psvc P9RdrService PcaSvc PeerDistSvc PenService PerfHost PhoneSvc PimIndexMaintenanceSvc pla PNRPAutoReg PNRPsvc PolicyAgent PushToInstall QWAVE RasAuto RasMan RemoteAccess RemoteRegistry RetailDemo RmSvc) do (\n    sc stop %%S >nul 2>&1\n    sc config %%S start= disabled >nul 2>&1\n)\necho [OK] OneClick services pack 3 M-R applied"
  },
  {
    "CategoryId": "services",
    "Category": "WINDOWS SERVICES",
    "Id": "oneclick_services_pack4",
    "Title": "OneClick Service Debloat Pack 4 (S-Z)",
    "Description": "Disables background services S through Z from OneClick V8.4: SamSs, SCardSvr, SCPolicySvc, SDRSVC, seclogon, SENS, Sense, SensorDataService, SensorService, SensrSvc, SEMgrSvc, SessionEnv, SharedAccess, ShellHWDetection, Spooler, SysMain, TabletInputService, TDPIPE, TrkWks, UevAgentService, upnphost, VaultSvc, W32Time, WalletService, WbioSrvc, Wcmsvc, WdiServiceHost, WebClient, webthreatdefusersvc, webthreatdefsvc, Wecsvc, WerSvc, WFDSConMgrSvc, WiaRpc, WinRM, wisvc, WlanSvc, WManSvc, WMPNetworkSvc, WpnUserService, WpnService, WSearch, WwanSvc.",
    "Command": ":: === OneClick Services Pack 4 (S-Z) ===\nfor %%S in (SamSs SCardSvr SCPolicySvc SDRSVC seclogon SENS Sense SensorDataService SensorService SensrSvc SEMgrSvc SessionEnv SharedAccess ShellHWDetection SysMain TabletInputService TrkWks UevAgentService upnphost VaultSvc W32Time WalletService WbioSrvc Wcmsvc WdiServiceHost WdiSystemHost WebClient webthreatdefusersvc webthreatdefsvc Wecsvc WEPHOSTSVC wercplsupport WerSvc WFDSConMgrSvc WiaRpc WinRM wisvc WlanSvc wlidsvc WManSvc wmiApSrv WMPNetworkSvc workfolderssvc WpcMonSvc WPDBusEnum WpnUserService WpnService WSearch WwanSvc XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc) do (\n    sc stop %%S >nul 2>&1\n    sc config %%S start= disabled >nul 2>&1\n)\necho [OK] OneClick services pack 4 S-Z applied"
  },
  {
    "CategoryId": "services",
    "Id": "chris_titus_winutil_services",
    "Title": "Chris Titus Winutil Service Profile",
    "Description": "Applies the Winutil-style service profile: disables selected telemetry/remote services and sets supported services to manual.",
    "Command": ":: === Chris Titus Winutil Service Profile ===\nfor %%S in (CscService DiagTrack RemoteAccess RemoteRegistry SharedAccess ssh-agent) do (\n    sc stop %%S >nul 2>&1\n    sc config %%S start= disabled >nul 2>&1\n)\nfor %%S in (MapsBroker StorSvc TermService TroubleshootingSvc seclogon) do (\n    sc config %%S start= demand >nul 2>&1\n)\nreg add \"HKLM\\SYSTEM\\CurrentControlSet\\Control\" /v \"SvcHostSplitThresholdInKB\" /t REG_DWORD /d 3670016 /f >nul 2>&1\necho [OK] Chris Titus/Winutil service profile applied"
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
    "Id": "hibernate_off",
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
    "Command": ":: === Explorer Policy Cleanup ===\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\Explorer\" /v \"NoLowDiskSpaceChecks\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\Explorer\" /v \"LinkResolveIgnoreLinkInfo\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\Explorer\" /v \"NoResolveSearch\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\Explorer\" /v \"NoResolveTrack\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\Explorer\" /v \"NoInstrumentation\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\Explorer\" /v \"NoInstrumentation\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Explorer\" /v \"Max Cached Icons\" /t REG_SZ /d \"4096\" /f >nul 2>&1\necho [OK] Explorer policies set"
  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "visualfxbest",
    "Title": "Visual Effects: Best Performance",
    "Description": "Reduces animations and visual effects for a lighter desktop.",
    "Command": ":: === Visual Effects Best Performance ===\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Explorer\\\\VisualEffects\" /v \"VisualFXSetting\" /t REG_DWORD /d 2 /f >nul 2>&1\nreg add \"HKCU\\\\Control Panel\\\\Desktop\" /v \"UserPreferencesMask\" /t REG_BINARY /d 9012038010000000 /f >nul 2>&1\nreg add \"HKCU\\\\Control Panel\\\\Desktop\" /v \"DragFullWindows\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg add \"HKCU\\\\Control Panel\\\\Desktop\\\\WindowMetrics\" /v \"MinAnimate\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Explorer\\\\Advanced\" /v \"TaskbarAnimations\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Explorer\\\\Advanced\" /v \"ListviewAlphaSelect\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Explorer\\\\Advanced\" /v \"ListviewShadow\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Themes\\\\Personalize\" /v \"EnableTransparency\" /t REG_DWORD /d 0 /f >nul 2>&1\necho [OK] Visual effects set to best performance"
  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "maint_off",
    "Title": "Disable Auto Maintenance",
    "Description": "Stops automatic maintenance and driver background work.",
    "Command": ":: === Disable Auto Maintenance ===\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Schedule\\\\Maintenance\" /v \"MaintenanceDisabled\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\DriverSearching\" /v \"SearchOrderConfig\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Device Installer\" /v \"DisableCoInstallers\" /t REG_DWORD /d 1 /f >nul 2>&1\necho [OK] Auto maintenance disabled"
  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "svc_host_split",
    "Title": "SvcHost Split Threshold",
    "Description": "On 8GB+ RAM, splits svchost so each service runs isolated \u2014 prevents one service stalling another.",
    "Command": ":: === SvcHost Split Threshold ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\" /v \"SvcHostSplitThresholdInKB\" /t REG_DWORD /d 4194304 /f >nul 2>&1\necho [OK] SvcHost split threshold set to 4GB"
  },
  {
    "CategoryId": "registry",
    "Category": "REGISTRY TWEAKS",
    "Id": "oneclick_regpack",
    "Title": "OneClick Registry Pack",
    "Description": "Applies OneClick V8.4 registry tweaks: disable IPv6, Delivery Optimization, WiFi Sense, Active Probing, Content Delivery Manager, VBS/HVCI, and storage sense.",
    "Command": ":: === OneClick Registry Pack ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip6\\\\Parameters\" /v \"DisabledComponents\" /t REG_DWORD /d 255 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\DeliveryOptimization\\\\Config\" /v \"DODownloadMode\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\DeliveryOptimization\" /v \"DODownloadMode\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\Software\\\\Microsoft\\\\PolicyManager\\\\default\\\\WiFi\\\\AllowWiFiHotSpotReporting\" /v \"Value\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\Software\\\\Microsoft\\\\PolicyManager\\\\default\\\\WiFi\\\\AllowAutoConnectToWiFiSenseHotspots\" /v \"Value\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\NetworkConnectivityStatusIndicator\" /v \"NoActiveProbe\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\System\\\\CurrentControlSet\\\\Services\\\\NlaSvc\\\\Parameters\\\\Internet\" /v \"EnableActiveProbing\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\\\SOFTWARE\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\ContentDeliveryManager\" /v \"ContentDeliveryAllowed\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\\\SOFTWARE\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\ContentDeliveryManager\" /v \"SilentInstalledAppsEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\\\SOFTWARE\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\ContentDeliveryManager\" /v \"SystemPaneSuggestionsEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\StorageSense\\\\Parameters\\\\StoragePolicy\" /v \"01\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\CloudContent\" /v \"DisableWindowsConsumerFeatures\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\AdvertisingInfo\" /v \"DisabledByGroupPolicy\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\FileSystem\" /v \"LongPathsEnabled\" /t REG_DWORD /d 1 /f >nul 2>&1\necho [OK] OneClick registry pack applied"
  },
  {
    "CategoryId": "gpu",
    "Category": "GPU / NVIDIA",
    "Id": "dxgkrnl",
    "Title": "DXGKrnl Thread Priority",
    "Description": "Raises DXGKrnl thread priority.",
    "Command": ":: === DXGKrnl Priority ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\DXGKrnl\\\\Parameters\" /v \"ThreadPriority\" /t REG_DWORD /d 15 /f >nul 2>&1\necho [OK] DXGKrnl thread priority set"
  },
  {
    "CategoryId": "gpu",
    "Category": "GPU / NVIDIA",
    "Id": "usbpriority",
    "Title": "USB Controller Priority",
    "Description": "Raises USB controller thread priorities.",
    "Command": ":: === USB Controller Thread Priority ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\USBHUB3\\\\Parameters\" /v \"ThreadPriority\" /t REG_DWORD /d 15 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\USBXHCI\\\\Parameters\" /v \"ThreadPriority\" /t REG_DWORD /d 15 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\USB\" /v \"DisableSelectiveSuspend\" /t REG_DWORD /d 1 /f >nul 2>&1\necho [OK] USB controller thread priority and suspend set"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK",
    "Id": "tcpack",
    "Title": "TCP/IP Tweaks",
    "Description": "Disables TCP auto-tuning, ECN, and timestamps. Applies per-adapter TcpAckFrequency.",
    "Command": ":: === TCP/IP Tweaks ===\nnetsh int tcp set global autotuninglevel=disabled >nul 2>&1\nnetsh int tcp set global ecncapability=disabled >nul 2>&1\nnetsh int tcp set global timestamps=disabled >nul 2>&1\nnetsh int tcp set heuristics disabled >nul 2>&1\nnetsh int tcp set supplemental template=Internet congestionprovider=ctcp >nul 2>&1\nfor /f \"tokens=*\" %%i in ('reg query \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters\\\\Interfaces\" ^| findstr /i \"HKEY_LOCAL_MACHINE\"') do (\n    reg add \"%%i\" /v \"TcpAckFrequency\" /t REG_DWORD /d 1 /f >nul 2>&1\n    reg add \"%%i\" /v \"TCPNoDelay\" /t REG_DWORD /d 1 /f >nul 2>&1\n    reg add \"%%i\" /v \"TcpDelAckTicks\" /t REG_DWORD /d 0 /f >nul 2>&1\n)\necho [OK] TCP/IP optimized"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK",
    "Id": "nagle_off",
    "Title": "Disable Nagle Algorithm (System-Wide)",
    "Description": "Disables Nagle buffering globally \u2014 packets sent immediately, cutting TCP send latency.",
    "Command": ":: === Disable Nagle Algorithm System-Wide ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters\" /v \"TcpNoDelay\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters\" /v \"TcpAckFrequency\" /t REG_DWORD /d 1 /f >nul 2>&1\nfor /f \"tokens=*\" %%i in ('reg query \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters\\\\Interfaces\" ^| findstr /i \"HKEY_LOCAL_MACHINE\"') do (\n    reg add \"%%i\" /v \"TcpNoDelay\" /t REG_DWORD /d 1 /f >nul 2>&1\n    reg add \"%%i\" /v \"TcpAckFrequency\" /t REG_DWORD /d 1 /f >nul 2>&1\n    reg add \"%%i\" /v \"TcpDelAckTicks\" /t REG_DWORD /d 0 /f >nul 2>&1\n)\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\MSMQ\\\\Parameters\" /v \"TCPNoDelay\" /t REG_DWORD /d 1 /f >nul 2>&1\necho [OK] Nagle algorithm disabled system-wide"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK",
    "Id": "tcpparams",
    "Title": "TCP Parameters Deep Tweaks",
    "Description": "DelayedAck, congestion, window size, and advanced TCP parameters.",
    "Command": ":: === TCP Parameters Deep Tweaks ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters\" /v \"DelayedAckFrequency\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters\" /v \"DelayedAckTicks\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters\" /v \"CongestionAlgorithm\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters\" /v \"FastCopyReceiveThreshold\" /t REG_DWORD /d 16384 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters\" /v \"FastSendDatagramThreshold\" /t REG_DWORD /d 16384 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters\" /v \"TcpWindowSize\" /t REG_DWORD /d 65534 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters\" /v \"MaxUserPort\" /t REG_DWORD /d 65534 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters\" /v \"TcpTimedWaitDelay\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters\" /v \"DefaultTTL\" /t REG_DWORD /d 200 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters\" /v \"EnableICMPRedirect\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters\" /v \"EnableDca\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters\" /v \"SackOpts\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters\" /v \"Tcp1323Opts\" /t REG_DWORD /d 3 /f >nul 2>&1\necho [OK] TCP parameters deep tweaks applied"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK",
    "Id": "afdparams",
    "Title": "AFD Socket Buffer Tweaks",
    "Description": "Sets AFD send/receive window sizes and socket performance flags for lower latency.",
    "Command": ":: === AFD Socket Buffer Tweaks ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\AFD\\\\Parameters\" /v \"DefaultReceiveWindow\" /t REG_DWORD /d 16384 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\AFD\\\\Parameters\" /v \"DefaultSendWindow\" /t REG_DWORD /d 16384 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\AFD\\\\Parameters\" /v \"FastCopyReceiveThreshold\" /t REG_DWORD /d 16384 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\AFD\\\\Parameters\" /v \"FastSendDatagramThreshold\" /t REG_DWORD /d 16384 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\AFD\\\\Parameters\" /v \"DynamicSendBufferDisable\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\AFD\\\\Parameters\" /v \"IgnorePushBitOnReceives\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\AFD\\\\Parameters\" /v \"NonBlockingSendSpecialBuffering\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\AFD\\\\Parameters\" /v \"DisableRawSecurity\" /t REG_DWORD /d 1 /f >nul 2>&1\necho [OK] AFD socket buffer tweaks applied"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK",
    "Id": "dnspriority",
    "Title": "DNS / NetBT Service Priority",
    "Description": "Sets Tcpip ServiceProvider priority order for fastest resolution.",
    "Command": ":: === DNS / NetBT Priority ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\ServiceProvider\" /v \"LocalPriority\" /t REG_DWORD /d 4 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\ServiceProvider\" /v \"HostsPriority\" /t REG_DWORD /d 5 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\ServiceProvider\" /v \"DnsPriority\" /t REG_DWORD /d 6 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\ServiceProvider\" /v \"NetbtPriority\" /t REG_DWORD /d 7 /f >nul 2>&1\necho [OK] DNS/NetBT service priority set"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK",
    "Id": "ndu",
    "Title": "Disable NDU",
    "Description": "Disables Network Data Usage tracking service.",
    "Command": ":: === Disable NDU ===\nreg add \"HKLM\\\\SYSTEM\\\\ControlSet001\\\\Services\\\\Ndu\" /v \"Start\" /t REG_DWORD /d 4 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Ndu\" /v \"Start\" /t REG_DWORD /d 4 /f >nul 2>&1\necho [OK] NDU disabled"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK",
    "Id": "netbt",
    "Title": "Disable NetBT",
    "Description": "Disables NetBIOS over TCP/IP.",
    "Command": ":: === Disable NetBT ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\NetBT\" /v \"Start\" /t REG_DWORD /d 4 /f >nul 2>&1\necho [OK] NetBT disabled"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK",
    "Id": "irpstack",
    "Title": "IRP Stack / MMCSS Network",
    "Description": "Applies IRP stack size and MMCSS NoLazyMode.",
    "Command": ":: === IRP Stack / MMCSS Network Tweak ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\LanmanServer\\\\Parameters\" /v \"IRPStackSize\" /t REG_DWORD /d 20 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Multimedia\\\\SystemProfile\" /v \"NoLazyMode\" /t REG_DWORD /d 1 /f >nul 2>&1\necho [OK] IRP stack and MMCSS network set"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK",
    "Id": "qos0",
    "Title": "QoS Reserved Bandwidth 0%",
    "Description": "Sets NonBestEffortLimit to 0 so no bandwidth is reserved.",
    "Command": ":: === QoS Reserved Bandwidth 0% ===\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\Psched\" /v \"NonBestEffortLimit\" /t REG_DWORD /d 0 /f >nul 2>&1\necho [OK] QoS reserved bandwidth set to 0%"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK",
    "Id": "nicpowersave",
    "Title": "Disable NIC Power Saving",
    "Description": "Disables common network-adapter power saving values that can add latency.",
    "Command": ":: === Disable NIC Power Saving ===\nfor /f \"tokens=*\" %%K in ('reg query \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Class\\\\{4d36e972-e325-11ce-bfc1-08002be10318}\" ^| findstr /i \"\\\\000\"') do (\n    reg add \"%%K\" /v \"*EEE\" /t REG_SZ /d \"0\" /f >nul 2>&1\n    reg add \"%%K\" /v \"*WakeOnMagicPacket\" /t REG_SZ /d \"0\" /f >nul 2>&1\n    reg add \"%%K\" /v \"*WakeOnPattern\" /t REG_SZ /d \"0\" /f >nul 2>&1\n    reg add \"%%K\" /v \"PnPCapabilities\" /t REG_DWORD /d 24 /f >nul 2>&1\n)\necho [OK] NIC power saving disabled where supported"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK",
    "Id": "rss_disable",
    "Title": "Disable RSS / Receive Side Scaling",
    "Description": "Disables RSS which can add latency on low-core-count systems.",
    "Command": ":: === Disable RSS ===\nnetsh int tcp set global rss=disabled >nul 2>&1\necho [OK] RSS disabled"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK",
    "Id": "chimney_off",
    "Title": "Disable TCP Chimney Offload",
    "Description": "Disables hardware TCP offload \u2014 often causes latency spikes on modern NICs.",
    "Command": ":: === Disable TCP Chimney Offload ===\nnetsh int tcp set global chimney=disabled >nul 2>&1\necho [OK] TCP chimney offload disabled"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK",
    "Id": "nic_interrupt_moderation_off",
    "Title": "Disable NIC Interrupt Moderation",
    "Description": "Attempts to disable interrupt moderation on supported network adapters to reduce packet/input latency.",
    "Command": ":: === Disable NIC Interrupt Moderation ===\npowershell -NoProfile -ExecutionPolicy Bypass -Command \"Get-NetAdapter -Physical -ErrorAction SilentlyContinue | ForEach-Object { $n=$_.Name; Get-NetAdapterAdvancedProperty -Name $n -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match 'Interrupt Moderation' -or $_.RegistryKeyword -match 'InterruptModeration' } | ForEach-Object { try { Set-NetAdapterAdvancedProperty -Name $n -RegistryKeyword $_.RegistryKeyword -RegistryValue 0 -NoRestart -ErrorAction SilentlyContinue } catch {} } }\"\necho [OK] NIC interrupt moderation disabled where supported"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK",
    "Id": "nic_green_eee_off",
    "Title": "Disable Green Ethernet / EEE",
    "Description": "Turns off common NIC energy-saving features that can add latency or cause link-state delay.",
    "Command": ":: === Disable Green Ethernet / Energy Efficient Ethernet ===\npowershell -NoProfile -ExecutionPolicy Bypass -Command \"Get-NetAdapter -Physical -ErrorAction SilentlyContinue | ForEach-Object { $n=$_.Name; Get-NetAdapterAdvancedProperty -Name $n -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match 'Energy Efficient|Green Ethernet|Power Saving|Ultra Low Power|EEE' -or $_.RegistryKeyword -match 'EEE|Green|PowerSaving|ULP|ReduceSpeed' } | ForEach-Object { try { Set-NetAdapterAdvancedProperty -Name $n -RegistryKeyword $_.RegistryKeyword -RegistryValue 0 -NoRestart -ErrorAction SilentlyContinue } catch {} } }\"\necho [OK] Green Ethernet / EEE disabled where supported"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK",
    "Id": "tcp_rss_rsc_latency",
    "Title": "RSS On / RSC Off Latency Profile",
    "Description": "Enables RSS for multi-core network processing and disables RSC where supported for a lower-latency gaming profile.",
    "Command": ":: === RSS On / RSC Off Latency Profile ===\nnetsh int tcp set global rss=enabled >nul 2>&1\nnetsh int tcp set global rsc=disabled >nul 2>&1\npowershell -NoProfile -ExecutionPolicy Bypass -Command \"Get-NetAdapter -Physical -ErrorAction SilentlyContinue | ForEach-Object { try { Enable-NetAdapterRss -Name $_.Name -ErrorAction SilentlyContinue } catch {}; try { Disable-NetAdapterRsc -Name $_.Name -ErrorAction SilentlyContinue } catch {} }\"\necho [OK] RSS enabled and RSC disabled where supported"
  },
  {
    "CategoryId": "network",
    "Category": "NETWORK",
    "Id": "dns_cache_flush_reset",
    "Title": "DNS Cache Flush / Winsock Refresh",
    "Description": "Flushes DNS and refreshes Winsock/IP state after network tweaks so adapter changes apply cleanly.",
    "Command": ":: === DNS Cache Flush / Winsock Refresh ===\nipconfig /flushdns >nul 2>&1\nnetsh winsock reset >nul 2>&1\nnetsh int ip reset >nul 2>&1\necho [OK] DNS flushed and Winsock/IP reset queued; reboot recommended"
  },
  {
    "CategoryId": "input",
    "Category": "INPUT / MOUSE",
    "Id": "pointer_precision_off",
    "Title": "Disable Pointer Precision (EPP Off)",
    "Description": "Removes Enhance Pointer Precision entirely \u2014 mandatory for raw aim accuracy.",
    "Command": ":: === Disable Pointer Precision ===\nreg add \"HKCU\\\\Control Panel\\\\Mouse\" /v \"MouseSpeed\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg add \"HKCU\\\\Control Panel\\\\Mouse\" /v \"MouseThreshold1\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg add \"HKCU\\\\Control Panel\\\\Mouse\" /v \"MouseThreshold2\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg add \"HKCU\\\\Control Panel\\\\Mouse\" /v \"MouseSensitivity\" /t REG_SZ /d \"10\" /f >nul 2>&1\nreg add \"HKU\\\\.DEFAULT\\\\Control Panel\\\\Mouse\" /v \"MouseSpeed\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg add \"HKU\\\\.DEFAULT\\\\Control Panel\\\\Mouse\" /v \"MouseThreshold1\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg add \"HKU\\\\.DEFAULT\\\\Control Panel\\\\Mouse\" /v \"MouseThreshold2\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg delete \"HKCU\\\\Control Panel\\\\Mouse\" /v \"SmoothMouseXCurve\" /f >nul 2>&1\nreg delete \"HKCU\\\\Control Panel\\\\Mouse\" /v \"SmoothMouseYCurve\" /f >nul 2>&1\necho [OK] EPP/pointer precision fully disabled"
  },
  {
    "CategoryId": "input",
    "Category": "INPUT / MOUSE",
    "Id": "mousepriority",
    "Title": "Mouse / Keyboard Driver Priority",
    "Description": "Raises keyboard and mouse class driver thread priorities.",
    "Command": ":: === Mouse and Keyboard Driver Priority ===\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\mouclass\\\\Parameters\" /v \"ThreadPriority\" /t REG_DWORD /d 31 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\kbdclass\\\\Parameters\" /v \"ThreadPriority\" /t REG_DWORD /d 31 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\mouclass\\\\Parameters\" /v \"MouseDataQueueSize\" /t REG_DWORD /d 20 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\kbdclass\\\\Parameters\" /v \"KeyboardDataQueueSize\" /t REG_DWORD /d 20 /f >nul 2>&1\necho [OK] Mouse/keyboard driver priority set to 31"
  },
  {
    "CategoryId": "input",
    "Category": "INPUT / MOUSE",
    "Id": "directinputacceloff",
    "Title": "DirectInput8 Latency Fix",
    "Description": "Forces DirectInput acceleration off and fixes DInput8 buffer/polling for lowest input latency.",
    "Command": ":: === DirectInput8 Latency Fix ===\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\DirectInput\" /v \"DisableAcceleration\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\DirectInput\" /v \"MouseWheelRouting\" /t REG_DWORD /d 2 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\WOW6432Node\\\\Microsoft\\\\DirectInput\" /v \"DisableAcceleration\" /t REG_DWORD /d 1 /f >nul 2>&1\necho [OK] DirectInput8 latency fix applied"
  },
  {
    "CategoryId": "input",
    "Category": "INPUT / MOUSE",
    "Id": "kbdrepeat",
    "Title": "Keyboard Repeat Response",
    "Description": "Sets fast keyboard repeat speed and lowest repeat delay for snappier key response.",
    "Command": ":: === Keyboard Repeat Response ===\nreg add \"HKCU\\\\Control Panel\\\\Keyboard\" /v \"KeyboardDelay\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg add \"HKCU\\\\Control Panel\\\\Keyboard\" /v \"KeyboardSpeed\" /t REG_SZ /d \"31\" /f >nul 2>&1\nreg add \"HKU\\\\.DEFAULT\\\\Control Panel\\\\Keyboard\" /v \"KeyboardDelay\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg add \"HKU\\\\.DEFAULT\\\\Control Panel\\\\Keyboard\" /v \"KeyboardSpeed\" /t REG_SZ /d \"31\" /f >nul 2>&1\necho [OK] Keyboard repeat tuned"
  },
  {
    "CategoryId": "input",
    "Category": "INPUT / MOUSE",
    "Id": "accessibilityoff",
    "Title": "Disable Accessibility Shortcut Keys",
    "Description": "Turns off StickyKeys, ToggleKeys, and FilterKeys hotkey popups that interrupt gameplay.",
    "Command": ":: === Disable Accessibility Shortcut Keys ===\nreg add \"HKCU\\\\Control Panel\\\\Accessibility\\\\StickyKeys\" /v \"Flags\" /t REG_SZ /d \"506\" /f >nul 2>&1\nreg add \"HKCU\\\\Control Panel\\\\Accessibility\\\\ToggleKeys\" /v \"Flags\" /t REG_SZ /d \"58\" /f >nul 2>&1\nreg add \"HKCU\\\\Control Panel\\\\Accessibility\\\\Keyboard Response\" /v \"Flags\" /t REG_SZ /d \"122\" /f >nul 2>&1\necho [OK] Accessibility shortcut keys disabled"
  },
  {
    "CategoryId": "input",
    "Category": "INPUT / MOUSE",
    "Id": "hidusbpowersaveoff",
    "Title": "Disable HID / USB Input Power Saving",
    "Description": "Disables all idle and suspend flags for HID and USB device parameters to keep mice and keyboards fully awake.",
    "Command": ":: === Disable HID / USB Input Power Saving ===\nfor /f \"tokens=*\" %%u in ('reg query \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Enum\\\\USB\" /s ^| findstr /i /c:\"\\\\Device Parameters\"') do (\n    reg add \"%%u\" /v \"AllowIdleIrpInD3\" /t REG_DWORD /d 0 /f >nul 2>&1\n    reg add \"%%u\" /v \"SelectiveSuspendEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\n    reg add \"%%u\" /v \"D3ColdSupported\" /t REG_DWORD /d 0 /f >nul 2>&1\n    reg add \"%%u\" /v \"EnhancedPowerManagementEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\n    reg add \"%%u\" /v \"DeviceSelectiveSuspended\" /t REG_DWORD /d 0 /f >nul 2>&1\n    reg add \"%%u\" /v \"DeviceIdleEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\n    reg add \"%%u\" /v \"EnableIdlePowerManagement\" /t REG_DWORD /d 0 /f >nul 2>&1\n    reg add \"%%u\\\\WDF\" /v \"IdleInWorkingState\" /t REG_DWORD /d 0 /f >nul 2>&1\n)\nfor /f \"tokens=*\" %%u in ('reg query \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Enum\\\\HID\" /s ^| findstr /i /c:\"\\\\Device Parameters\"') do (\n    reg add \"%%u\" /v \"AllowIdleIrpInD3\" /t REG_DWORD /d 0 /f >nul 2>&1\n    reg add \"%%u\" /v \"SelectiveSuspendEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\n    reg add \"%%u\" /v \"D3ColdSupported\" /t REG_DWORD /d 0 /f >nul 2>&1\n    reg add \"%%u\" /v \"EnhancedPowerManagementEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\n    reg add \"%%u\" /v \"DeviceSelectiveSuspended\" /t REG_DWORD /d 0 /f >nul 2>&1\n    reg add \"%%u\" /v \"DeviceIdleEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\n    reg add \"%%u\" /v \"EnableIdlePowerManagement\" /t REG_DWORD /d 0 /f >nul 2>&1\n    reg add \"%%u\\\\WDF\" /v \"IdleInWorkingState\" /t REG_DWORD /d 0 /f >nul 2>&1\n)\necho [OK] HID and USB input power saving disabled"
  },
  {
    "CategoryId": "input",
    "Category": "INPUT / MOUSE",
    "Id": "usb_poll_rate",
    "Title": "USB Polling Rate Boost",
    "Description": "Sets USB controller transfer periods to minimum to boost mouse polling rate responsiveness.",
    "Command": ":: === USB Polling Rate Boost ===\nfor /f \"tokens=*\" %%K in ('reg query \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Class\\\\{36fc9e60-c465-11cf-8056-444553540000}\" ^| findstr /i \"\\\\000\"') do (\n    reg add \"%%K\" /v \"TransferPeriod\" /t REG_DWORD /d 1 /f >nul 2>&1\n    reg add \"%%K\" /v \"IgnoreHWSerNum\" /t REG_DWORD /d 1 /f >nul 2>&1\n)\necho [OK] USB polling rate boost applied"
  },
  {
    "CategoryId": "privacy",
    "Category": "PRIVACY",
    "Id": "teldata",
    "Title": "Disable Telemetry Collection",
    "Description": "Disables Windows telemetry collection policies.",
    "Command": ":: === Disable Telemetry Data Collection ===\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\DataCollection\" /v \"AllowTelemetry\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\DataCollection\" /v \"AllowTelemetry\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\DataCollection\" /v \"DoNotShowFeedbackNotifications\" /t REG_DWORD /d 1 /f >nul 2>&1\necho [OK] Telemetry data collection disabled"
  },
  {
    "CategoryId": "privacy",
    "Category": "PRIVACY",
    "Id": "schedtasks",
    "Title": "Disable Telemetry Tasks",
    "Description": "Disables telemetry-related scheduled tasks.",
    "Command": ":: === Disable Telemetry Scheduled Tasks ===\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\Application Experience\\\\Microsoft Compatibility Appraiser\" /Disable >nul 2>&1\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\Application Experience\\\\StartupAppTask\" /Disable >nul 2>&1\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\Customer Experience Improvement Program\\\\Consolidator\" /Disable >nul 2>&1\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\Customer Experience Improvement Program\\\\UsbCeip\" /Disable >nul 2>&1\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\DiskDiagnostic\\\\Microsoft-Windows-DiskDiagnosticDataCollector\" /Disable >nul 2>&1\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\Windows Error Reporting\\\\QueueReporting\" /Disable >nul 2>&1\nschtasks /Change /TN \"\\\\Microsoft\\\\Windows\\\\Feedback\\\\Siuf\\\\DmClient\" /Disable >nul 2>&1\necho [OK] Telemetry scheduled tasks disabled"
  },
  {
    "CategoryId": "privacy",
    "Category": "PRIVACY",
    "Id": "activity_location",
    "Title": "Disable Activity History / Location",
    "Description": "Turns off activity history, location access, and sensor permissions.",
    "Command": ":: === Disable Activity History and Location ===\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\System\" /v \"EnableActivityFeed\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\System\" /v \"PublishUserActivities\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\System\" /v \"UploadUserActivities\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\CapabilityAccessManager\\\\ConsentStore\\\\location\" /v \"Value\" /t REG_SZ /d \"Deny\" /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\lfsvc\\\\Service\\\\Configuration\" /v \"Status\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\Maps\" /v \"AutoUpdateEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\\\SOFTWARE\\\\Microsoft\\\\Siuf\\\\Rules\" /v \"NumberOfSIUFInPeriod\" /t REG_DWORD /d 0 /f >nul 2>&1\necho [OK] Activity history and location tracking disabled"
  },
  {
    "CategoryId": "debloat",
    "Category": "PROCESS DEBLOAT",
    "Id": "killjunk",
    "Title": "Kill Junk Processes",
    "Description": "Kills common background apps, launchers, and overlay processes.",
    "Command": ":: === Kill Junk Processes ===\nfor %%P in (brave.exe chrome.exe msedge.exe Discord.exe EpicGamesLauncher.exe EpicWebHelper.exe Steam.exe steamwebhelper.exe OneDrive.exe Spotify.exe Teams.exe ms-teams.exe AdobeIPCBroker.exe CCXProcess.exe GameBar.exe GameBarFTServer.exe backgroundTaskHost.exe CompPkgSrv.exe SgrmBroker.exe Widgets.exe Copilot.exe PhoneExperienceHost.exe) do (\n    taskkill /f /im %%P >nul 2>&1\n)\necho [OK] Junk processes killed"
  },
  {
    "CategoryId": "debloat",
    "Category": "PROCESS DEBLOAT",
    "Id": "killui",
    "Title": "Kill UI Bloat Processes",
    "Description": "Kills extra UI helper processes and telemetry runners.",
    "Command": ":: === Kill UI Bloat ===\ntaskkill /f /im TextInputHost.exe >nul 2>&1\ntaskkill /f /im ctfmon.exe >nul 2>&1\ntaskkill /f /im msedgewebview2.exe >nul 2>&1\ntaskkill /f /im RuntimeBroker.exe >nul 2>&1\ntaskkill /f /im ShellExperienceHost.exe >nul 2>&1\ntaskkill /f /im StartMenuExperienceHost.exe >nul 2>&1\ntaskkill /f /im MicrosoftEdgeUpdate.exe >nul 2>&1\ntaskkill /f /im YourPhone.exe >nul 2>&1\ntaskkill /f /im SearchApp.exe >nul 2>&1\ntaskkill /f /im SearchHost.exe >nul 2>&1\necho [OK] UI bloat processes killed"
  },
  {
    "CategoryId": "debloat",
    "Category": "PROCESS DEBLOAT",
    "Id": "scheduled_tasks_kill",
    "Title": "Kill Bloat Scheduled Tasks",
    "Description": "Disables all known bloat Windows scheduled tasks that fire during gameplay.",
    "Command": ":: === Kill Bloat Scheduled Tasks ===\nfor %%T in (\"Microsoft\\\\Windows\\\\Application Experience\\\\Microsoft Compatibility Appraiser\" \"Microsoft\\\\Windows\\\\Application Experience\\\\StartupAppTask\" \"Microsoft\\\\Windows\\\\Customer Experience Improvement Program\\\\Consolidator\" \"Microsoft\\\\Windows\\\\Customer Experience Improvement Program\\\\UsbCeip\" \"Microsoft\\\\Windows\\\\Autochk\\\\Proxy\" \"Microsoft\\\\Windows\\\\DiskDiagnostic\\\\Microsoft-Windows-DiskDiagnosticDataCollector\" \"Microsoft\\\\Windows\\\\Windows Error Reporting\\\\QueueReporting\" \"Microsoft\\\\Windows\\\\Feedback\\\\Siuf\\\\DmClient\" \"Microsoft\\\\Windows\\\\Feedback\\\\Siuf\\\\DmClientOnScenarioDownload\") do (\n    schtasks /Change /TN \"%%~T\" /Disable >nul 2>&1\n)\necho [OK] Bloat scheduled tasks disabled"
  },
  {
    "CategoryId": "debloat",
    "Category": "PROCESS DEBLOAT",
    "Id": "startup_clean",
    "Title": "Clean Startup / OneDrive / Cortana",
    "Description": "Removes startup entries for OneDrive, Discord, Spotify. Disables Cortana and Bing search.",
    "Command": ":: === Clean Startup / OneDrive / Cortana ===\nreg delete \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Run\" /v \"OneDrive\" /f >nul 2>&1\nreg delete \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Run\" /v \"Discord\" /f >nul 2>&1\nreg delete \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Run\" /v \"Spotify\" /f >nul 2>&1\nreg delete \"HKLM\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Run\" /v \"SecurityHealth\" /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\Windows Search\" /v \"AllowCortana\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Search\" /v \"BingSearchEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\\\SOFTWARE\\\\Policies\\\\Microsoft\\\\Windows\\\\OneDrive\" /v \"DisableFileSyncNGSC\" /t REG_DWORD /d 1 /f >nul 2>&1\ntaskkill /f /im OneDrive.exe >nul 2>&1\necho [OK] Startup entries cleaned and OneDrive/Cortana disabled"
  },
  {
    "CategoryId": "debloat",
    "Id": "oneclick_process_pack",
    "Title": "OneClick Process Debloat Pack",
    "Description": "Kills common background processes from OneClick-style debloat without touching core Windows login/network services.",
    "Command": ":: === OneClick Process Debloat Pack ===\nfor %%P in (OneDrive.exe Teams.exe ms-teams.exe SkypeApp.exe XboxPcApp.exe GameBar.exe GameBarFTServer.exe Widgets.exe SearchHost.exe SearchApp.exe Copilot.exe PhoneExperienceHost.exe Microsoft.Photos.exe YourPhone.exe SecHealthUI.exe) do (\n    taskkill /f /im %%P >nul 2>&1\n)\necho [OK] OneClick process debloat pack applied"
  },
  {
    "CategoryId": "power",
    "Category": "POWER PLAN",
    "Id": "cpumaxmin",
    "Title": "CPU Min/Max 100% + Turbo Always On",
    "Description": "Forces CPU to 100% min/max and enables aggressive turbo boost mode.",
    "Command": ":: === CPU Min/Max State 100% + Turbo ===\npowercfg /setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100 >nul 2>&1\npowercfg /setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100 >nul 2>&1\npowercfg /setacvalueindex scheme_current sub_processor PERFBOOSTMODE 2 >nul 2>&1\npowercfg /setacvalueindex scheme_current sub_processor PERFBOOSTPOL 100 >nul 2>&1\npowercfg /setdcvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100 >nul 2>&1\npowercfg /setdcvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100 >nul 2>&1\npowercfg /setactive scheme_current >nul 2>&1\necho [OK] CPU min/max set to 100% with turbo always on"
  },
  {
    "CategoryId": "power",
    "Category": "POWER PLAN",
    "Id": "usbpower",
    "Title": "USB Power Always On",
    "Description": "Disables USB selective suspend in active plan \u2014 mice and keyboards never lose power.",
    "Command": ":: === USB Power Always On ===\npowercfg /setacvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0 >nul 2>&1\npowercfg /setdcvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0 >nul 2>&1\npowercfg /setacvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1\npowercfg /setdcvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1\nreg add \"HKLM\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\USB\" /v \"DisableSelectiveSuspend\" /t REG_DWORD /d 1 /f >nul 2>&1\npowercfg /setactive scheme_current >nul 2>&1\necho [OK] USB power always on"
  },
  {
    "CategoryId": "power",
    "Category": "POWER PLAN",
    "Id": "pcielinkoff",
    "Title": "PCIe Link State Off",
    "Description": "Disables PCIe Link State Power Management \u2014 prevents GPU from downclocking.",
    "Command": ":: === PCIe Link State Off ===\npowercfg /setacvalueindex scheme_current SUB_PCIEXPRESS ASPM 0 >nul 2>&1\npowercfg /setdcvalueindex scheme_current SUB_PCIEXPRESS ASPM 0 >nul 2>&1\npowercfg /setactive scheme_current >nul 2>&1\necho [OK] PCIe Link State Power Management disabled"
  },
  {
    "CategoryId": "power",
    "Category": "POWER PLAN",
    "Id": "sleepfeaturesoff",
    "Title": "Disable Hybrid Sleep / Wake Timers / Away Mode",
    "Description": "Turns off hybrid sleep, wake timers, and away mode on AC and DC power.",
    "Command": ":: === Disable Hybrid Sleep and Wake Timers ===\npowercfg /setacvalueindex scheme_current SUB_SLEEP HYBRIDSLEEP 0 >nul 2>&1\npowercfg /setdcvalueindex scheme_current SUB_SLEEP HYBRIDSLEEP 0 >nul 2>&1\npowercfg /setacvalueindex scheme_current SUB_SLEEP RTCWAKE 0 >nul 2>&1\npowercfg /setdcvalueindex scheme_current SUB_SLEEP RTCWAKE 0 >nul 2>&1\npowercfg /setacvalueindex scheme_current SUB_SLEEP AWAYMODE 0 >nul 2>&1\npowercfg /setdcvalueindex scheme_current SUB_SLEEP AWAYMODE 0 >nul 2>&1\npowercfg /change standby-timeout-ac 0 >nul 2>&1\npowercfg /change standby-timeout-dc 0 >nul 2>&1\npowercfg /change hibernate-timeout-ac 0 >nul 2>&1\npowercfg /change hibernate-timeout-dc 0 >nul 2>&1\npowercfg /change monitor-timeout-ac 0 >nul 2>&1\npowercfg /change monitor-timeout-dc 0 >nul 2>&1\npowercfg /setactive scheme_current >nul 2>&1\necho [OK] Hybrid sleep wake timers and away mode disabled"
  },
  {
    "CategoryId": "power",
    "Category": "POWER PLAN",
    "Id": "storagediskpoweroff",
    "Title": "Disable Disk / Storage Power Saving",
    "Description": "Sets disk idle timeout to never and disables storage power-down behavior.",
    "Command": ":: === Disable Disk and Storage Power Saving ===\npowercfg /change disk-timeout-ac 0 >nul 2>&1\npowercfg /change disk-timeout-dc 0 >nul 2>&1\npowercfg /setactive scheme_current >nul 2>&1\necho [OK] Disk and storage power saving disabled"
  },
  {
    "CategoryId": "power",
    "Category": "POWER PLAN",
    "Id": "procidleoff",
    "Title": "Disable Processor Idle Switching",
    "Description": "Reduces aggressive processor idle state switching on the active plan.",
    "Command": ":: === Disable Processor Idle ===\npowercfg /setacvalueindex scheme_current sub_processor IDLEDISABLE 1 >nul 2>&1\npowercfg /setdcvalueindex scheme_current sub_processor IDLEDISABLE 1 >nul 2>&1\npowercfg /setactive scheme_current >nul 2>&1\necho [OK] Processor idle disable applied"
  },
  {
    "CategoryId": "extreme",
    "Category": "EXTREME OS STRIP (UNSTABLE)",
    "Id": "extreme_service_strip",
    "Title": "Extreme Service Strip",
    "Description": "Aggressively disables non-core background services for a minimal gaming OS feel. This can break convenience features.",
    "Command": ":: === Extreme Service Strip ===\nfor %%S in (DiagTrack dmwappushservice WerSvc Wecsvc XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc BcastDVRUserService CaptureService MapsBroker MessagingService OneSyncSvc CDPSvc CDPUserSvc WpnService WpnUserService PushToInstall RetailDemo Fax lfsvc WalletService SysMain WSearch RemoteRegistry WinRM FontCache FrameServer GraphicsPerfSvc PrintNotify PrintScanBrokerService Spooler BluetoothUserService bthserv BTAGService BthAvctpSvc) do (\n    sc stop %%S >nul 2>&1\n    sc config %%S start= disabled >nul 2>&1\n)\necho [OK] Extreme service strip applied"
  },
  {
    "CategoryId": "extreme",
    "Category": "EXTREME MODE",
    "Id": "extreme_oneclick_full_services",
    "Title": "EXTREME OneClick Full Service Strip",
    "Description": "Disables the full OneClick-style service list you provided, including core services. Lab-only and expected to break Windows features.",
    "Command": ":: === EXTREME OneClick Full Service Strip ===\n:: Lab-only. Disables the full OneClick-style service list requested.\nsc stop WSearch >nul 2>&1\nsc config WSearch start= disabled >nul 2>&1\nsc stop SysMain >nul 2>&1\nsc config SysMain start= disabled >nul 2>&1\nsc stop Spooler >nul 2>&1\nsc config Spooler start= disabled >nul 2>&1\nsc stop PrintNotify >nul 2>&1\nsc config PrintNotify start= disabled >nul 2>&1\nsc stop WinDefend >nul 2>&1\nsc config WinDefend start= disabled >nul 2>&1\nsc stop SecurityHealthService >nul 2>&1\nsc config SecurityHealthService start= disabled >nul 2>&1\nsc stop WdNisSvc >nul 2>&1\nsc config WdNisSvc start= disabled >nul 2>&1\nsc stop ucpd >nul 2>&1\nsc config ucpd start= disabled >nul 2>&1\nsc stop TrustedInstaller >nul 2>&1\nsc config TrustedInstaller start= disabled >nul 2>&1\nsc stop VSS >nul 2>&1\nsc config VSS start= demand >nul 2>&1\nsc stop swprv >nul 2>&1\nsc config swprv start= demand >nul 2>&1\nsc stop AarSvc >nul 2>&1\nsc config AarSvc start= disabled >nul 2>&1\nsc stop ADPSvc >nul 2>&1\nsc config ADPSvc start= disabled >nul 2>&1\nsc stop AJRouter >nul 2>&1\nsc config AJRouter start= disabled >nul 2>&1\nsc stop ALG >nul 2>&1\nsc config ALG start= disabled >nul 2>&1\nsc stop AppMgmt >nul 2>&1\nsc config AppMgmt start= disabled >nul 2>&1\nsc stop AppInfo >nul 2>&1\nsc config AppInfo start= demand >nul 2>&1\nsc stop AppReadiness >nul 2>&1\nsc config AppReadiness start= disabled >nul 2>&1\nsc stop AssignedAccessManagerSvc >nul 2>&1\nsc config AssignedAccessManagerSvc start= disabled >nul 2>&1\nsc stop autotimesvc >nul 2>&1\nsc config autotimesvc start= disabled >nul 2>&1\nsc stop AxInstSV >nul 2>&1\nsc config AxInstSV start= disabled >nul 2>&1\nsc stop BcastDVRUserService >nul 2>&1\nsc config BcastDVRUserService start= disabled >nul 2>&1\nsc stop BDESVC >nul 2>&1\nsc config BDESVC start= disabled >nul 2>&1\nsc stop BITS >nul 2>&1\nsc config BITS start= disabled >nul 2>&1\nsc stop BluetoothUserService >nul 2>&1\nsc config BluetoothUserService start= disabled >nul 2>&1\nsc stop BTAGService >nul 2>&1\nsc config BTAGService start= disabled >nul 2>&1\nsc stop BthAvctpSvc >nul 2>&1\nsc config BthAvctpSvc start= disabled >nul 2>&1\nsc stop bthserv >nul 2>&1\nsc config bthserv start= disabled >nul 2>&1\nsc stop CaptureService >nul 2>&1\nsc config CaptureService start= disabled >nul 2>&1\nsc stop cbdhsvc >nul 2>&1\nsc config cbdhsvc start= disabled >nul 2>&1\nsc stop CDPUserSvc >nul 2>&1\nsc config CDPUserSvc start= disabled >nul 2>&1\nsc stop CDPSvc >nul 2>&1\nsc config CDPSvc start= disabled >nul 2>&1\nsc stop CertPropSvc >nul 2>&1\nsc config CertPropSvc start= disabled >nul 2>&1\nsc stop CloudBackupRestoreSvc >nul 2>&1\nsc config CloudBackupRestoreSvc start= disabled >nul 2>&1\nsc stop cloudidsvc >nul 2>&1\nsc config cloudidsvc start= disabled >nul 2>&1\nsc stop COMSysApp >nul 2>&1\nsc config COMSysApp start= disabled >nul 2>&1\nsc stop ConsentUxUserSvc >nul 2>&1\nsc config ConsentUxUserSvc start= disabled >nul 2>&1\nsc stop CscService >nul 2>&1\nsc config CscService start= disabled >nul 2>&1\nsc stop dcsvc >nul 2>&1\nsc config dcsvc start= disabled >nul 2>&1\nsc stop defragsvc >nul 2>&1\nsc config defragsvc start= demand >nul 2>&1\nsc stop DeviceAssociationService >nul 2>&1\nsc config DeviceAssociationService start= disabled >nul 2>&1\nsc stop DeviceInstall >nul 2>&1\nsc config DeviceInstall start= disabled >nul 2>&1\nsc stop DevicePickerUserSvc >nul 2>&1\nsc config DevicePickerUserSvc start= disabled >nul 2>&1\nsc stop DevicesFlowUserSvc >nul 2>&1\nsc config DevicesFlowUserSvc start= disabled >nul 2>&1\nsc stop DevQueryBroker >nul 2>&1\nsc config DevQueryBroker start= disabled >nul 2>&1\nsc stop diagnosticshub.standardcollector.service >nul 2>&1\nsc config diagnosticshub.standardcollector.service start= disabled >nul 2>&1\nsc stop DiagTrack >nul 2>&1\nsc config DiagTrack start= disabled >nul 2>&1\nsc stop diagsvc >nul 2>&1\nsc config diagsvc start= disabled >nul 2>&1\nsc stop DispBrokerDesktopSvc >nul 2>&1\nsc config DispBrokerDesktopSvc start= auto >nul 2>&1\nsc stop DisplayEnhancementService >nul 2>&1\nsc config DisplayEnhancementService start= disabled >nul 2>&1\nsc stop DmEnrollmentSvc >nul 2>&1\nsc config DmEnrollmentSvc start= disabled >nul 2>&1\nsc stop dmwappushservice >nul 2>&1\nsc config dmwappushservice start= disabled >nul 2>&1\nsc stop dot3svc >nul 2>&1\nsc config dot3svc start= disabled >nul 2>&1\nsc stop DPS >nul 2>&1\nsc config DPS start= disabled >nul 2>&1\nsc stop DsmSvc >nul 2>&1\nsc config DsmSvc start= disabled >nul 2>&1\nsc stop DsSvc >nul 2>&1\nsc config DsSvc start= disabled >nul 2>&1\nsc stop DusmSvc >nul 2>&1\nsc config DusmSvc start= disabled >nul 2>&1\nsc stop Eaphost >nul 2>&1\nsc config Eaphost start= disabled >nul 2>&1\nsc stop edgeupdate >nul 2>&1\nsc config edgeupdate start= disabled >nul 2>&1\nsc stop edgeupdatem >nul 2>&1\nsc config edgeupdatem start= disabled >nul 2>&1\nsc stop EFS >nul 2>&1\nsc config EFS start= disabled >nul 2>&1\nsc stop EventLog >nul 2>&1\nsc config EventLog start= disabled >nul 2>&1\nsc stop EventSystem >nul 2>&1\nsc config EventSystem start= demand >nul 2>&1\nsc stop fdPHost >nul 2>&1\nsc config fdPHost start= disabled >nul 2>&1\nsc stop FDResPub >nul 2>&1\nsc config FDResPub start= disabled >nul 2>&1\nsc stop fhsvc >nul 2>&1\nsc config fhsvc start= disabled >nul 2>&1\nsc stop FontCache >nul 2>&1\nsc config FontCache start= disabled >nul 2>&1\nsc stop FrameServer >nul 2>&1\nsc config FrameServer start= disabled >nul 2>&1\nsc stop FrameServerMonitor >nul 2>&1\nsc config FrameServerMonitor start= disabled >nul 2>&1\nsc stop GameInputSvc >nul 2>&1\nsc config GameInputSvc start= disabled >nul 2>&1\nsc stop GraphicsPerfSvc >nul 2>&1\nsc config GraphicsPerfSvc start= disabled >nul 2>&1\nsc stop hpatchmon >nul 2>&1\nsc config hpatchmon start= disabled >nul 2>&1\nsc stop hidserv >nul 2>&1\nsc config hidserv start= disabled >nul 2>&1\nsc stop HvHost >nul 2>&1\nsc config HvHost start= disabled >nul 2>&1\nsc stop icssvc >nul 2>&1\nsc config icssvc start= disabled >nul 2>&1\nsc stop IKEEXT >nul 2>&1\nsc config IKEEXT start= disabled >nul 2>&1\nsc stop InstallService >nul 2>&1\nsc config InstallService start= disabled >nul 2>&1\nsc stop InventorySvc >nul 2>&1\nsc config InventorySvc start= disabled >nul 2>&1\nsc stop IpxlatCfgSvc >nul 2>&1\nsc config IpxlatCfgSvc start= disabled >nul 2>&1\nsc stop KtmRm >nul 2>&1\nsc config KtmRm start= disabled >nul 2>&1\nsc stop LanmanServer >nul 2>&1\nsc config LanmanServer start= disabled >nul 2>&1\nsc stop LanmanWorkstation >nul 2>&1\nsc config LanmanWorkstation start= disabled >nul 2>&1\nsc stop lfsvc >nul 2>&1\nsc config lfsvc start= disabled >nul 2>&1\nsc stop LocalKdc >nul 2>&1\nsc config LocalKdc start= disabled >nul 2>&1\nsc stop LicenseManager >nul 2>&1\nsc config LicenseManager start= disabled >nul 2>&1\nsc stop lltdsvc >nul 2>&1\nsc config lltdsvc start= disabled >nul 2>&1\nsc stop lmhosts >nul 2>&1\nsc config lmhosts start= disabled >nul 2>&1\nsc stop LxpSvc >nul 2>&1\nsc config LxpSvc start= disabled >nul 2>&1\nsc stop MapsBroker >nul 2>&1\nsc config MapsBroker start= disabled >nul 2>&1\nsc stop McpManagementService >nul 2>&1\nsc config McpManagementService start= disabled >nul 2>&1\nsc stop McmSvc >nul 2>&1\nsc config McmSvc start= disabled >nul 2>&1\nsc stop MessagingService >nul 2>&1\nsc config MessagingService start= disabled >nul 2>&1\nsc stop midisrv >nul 2>&1\nsc config midisrv start= disabled >nul 2>&1\nsc stop MSDTC >nul 2>&1\nsc config MSDTC start= disabled >nul 2>&1\nsc stop MSiSCSI >nul 2>&1\nsc config MSiSCSI start= disabled >nul 2>&1\nsc stop NaturalAuthentication >nul 2>&1\nsc config NaturalAuthentication start= disabled >nul 2>&1\nsc stop NcaSvc >nul 2>&1\nsc config NcaSvc start= disabled >nul 2>&1\nsc stop NcbService >nul 2>&1\nsc config NcbService start= disabled >nul 2>&1\nsc stop NcdAutoSetup >nul 2>&1\nsc config NcdAutoSetup start= disabled >nul 2>&1\nsc stop Netlogon >nul 2>&1\nsc config Netlogon start= disabled >nul 2>&1\nsc stop Netman >nul 2>&1\nsc config Netman start= disabled >nul 2>&1\nsc stop NetSetupSvc >nul 2>&1\nsc config NetSetupSvc start= disabled >nul 2>&1\nsc stop NetTcpPortSharing >nul 2>&1\nsc config NetTcpPortSharing start= disabled >nul 2>&1\nsc stop NlaSvc >nul 2>&1\nsc config NlaSvc start= disabled >nul 2>&1\nsc stop NPSMSvc >nul 2>&1\nsc config NPSMSvc start= disabled >nul 2>&1\nsc stop OneSyncSvc >nul 2>&1\nsc config OneSyncSvc start= disabled >nul 2>&1\nsc stop p2pimsvc >nul 2>&1\nsc config p2pimsvc start= disabled >nul 2>&1\nsc stop p2psvc >nul 2>&1\nsc config p2psvc start= disabled >nul 2>&1\nsc stop P9RdrService >nul 2>&1\nsc config P9RdrService start= disabled >nul 2>&1\nsc stop UevAgentService >nul 2>&1\nsc config UevAgentService start= disabled >nul 2>&1\nsc stop uhssvc >nul 2>&1\nsc config uhssvc start= disabled >nul 2>&1\nsc stop UmRdpService >nul 2>&1\nsc config UmRdpService start= disabled >nul 2>&1\nsc stop UnistoreSvc >nul 2>&1\nsc config UnistoreSvc start= disabled >nul 2>&1\nsc stop upnphost >nul 2>&1\nsc config upnphost start= disabled >nul 2>&1\nsc stop UserDataSvc >nul 2>&1\nsc config UserDataSvc start= disabled >nul 2>&1\nsc stop VacSvc >nul 2>&1\nsc config VacSvc start= disabled >nul 2>&1\nsc stop VaultSvc >nul 2>&1\nsc config VaultSvc start= disabled >nul 2>&1\nsc stop vds >nul 2>&1\nsc config vds start= disabled >nul 2>&1\nsc stop vmicguestinterface >nul 2>&1\nsc config vmicguestinterface start= disabled >nul 2>&1\nsc stop vmicheartbeat >nul 2>&1\nsc config vmicheartbeat start= disabled >nul 2>&1\nsc stop vmickvpexchange >nul 2>&1\nsc config vmickvpexchange start= disabled >nul 2>&1\nsc stop vmicrdv >nul 2>&1\nsc config vmicrdv start= disabled >nul 2>&1\nsc stop vmicshutdown >nul 2>&1\nsc config vmicshutdown start= disabled >nul 2>&1\nsc stop vmictimesync >nul 2>&1\nsc config vmictimesync start= disabled >nul 2>&1\nsc stop vmicvmsession >nul 2>&1\nsc config vmicvmsession start= disabled >nul 2>&1\nsc stop vmicvss >nul 2>&1\nsc config vmicvss start= disabled >nul 2>&1\nsc stop W32Time >nul 2>&1\nsc config W32Time start= disabled >nul 2>&1\nsc stop WalletService >nul 2>&1\nsc config WalletService start= disabled >nul 2>&1\nsc stop WarpJITSvc >nul 2>&1\nsc config WarpJITSvc start= disabled >nul 2>&1\nsc stop wbengine >nul 2>&1\nsc config wbengine start= disabled >nul 2>&1\nsc stop WbioSrvc >nul 2>&1\nsc config WbioSrvc start= disabled >nul 2>&1\nsc stop Wcmsvc >nul 2>&1\nsc config Wcmsvc start= disabled >nul 2>&1\nsc stop wcncsvc >nul 2>&1\nsc config wcncsvc start= disabled >nul 2>&1\nsc stop WdiServiceHost >nul 2>&1\nsc config WdiServiceHost start= disabled >nul 2>&1\nsc stop WdiSystemHost >nul 2>&1\nsc config WdiSystemHost start= disabled >nul 2>&1\nsc stop WebClient >nul 2>&1\nsc config WebClient start= disabled >nul 2>&1\nsc stop webthreatdefusersvc >nul 2>&1\nsc config webthreatdefusersvc start= disabled >nul 2>&1\nsc stop webthreatdefsvc >nul 2>&1\nsc config webthreatdefsvc start= disabled >nul 2>&1\nsc stop Wecsvc >nul 2>&1\nsc config Wecsvc start= disabled >nul 2>&1\nsc stop WEPHOSTSVC >nul 2>&1\nsc config WEPHOSTSVC start= disabled >nul 2>&1\nsc stop wercplsupport >nul 2>&1\nsc config wercplsupport start= disabled >nul 2>&1\nsc stop WerSvc >nul 2>&1\nsc config WerSvc start= disabled >nul 2>&1\nsc stop WFDSConMgrSvc >nul 2>&1\nsc config WFDSConMgrSvc start= disabled >nul 2>&1\nsc stop whesvc >nul 2>&1\nsc config whesvc start= disabled >nul 2>&1\nsc stop WiaRpc >nul 2>&1\nsc config WiaRpc start= disabled >nul 2>&1\nsc stop WinRM >nul 2>&1\nsc config WinRM start= disabled >nul 2>&1\nsc stop wisvc >nul 2>&1\nsc config wisvc start= disabled >nul 2>&1\nsc stop WlanSvc >nul 2>&1\nsc config WlanSvc start= disabled >nul 2>&1\nsc stop wlidsvc >nul 2>&1\nsc config wlidsvc start= disabled >nul 2>&1\nsc stop wlpasvc >nul 2>&1\nsc config wlpasvc start= disabled >nul 2>&1\nsc stop WManSvc >nul 2>&1\nsc config WManSvc start= disabled >nul 2>&1\nsc stop wmiApSrv >nul 2>&1\nsc config wmiApSrv start= disabled >nul 2>&1\nsc stop WMPNetworkSvc >nul 2>&1\nsc config WMPNetworkSvc start= disabled >nul 2>&1\nsc stop workfolderssvc >nul 2>&1\nsc config workfolderssvc start= disabled >nul 2>&1\nsc stop WpcMonSvc >nul 2>&1\nsc config WpcMonSvc start= disabled >nul 2>&1\nsc stop WPDBusEnum >nul 2>&1\nsc config WPDBusEnum start= disabled >nul 2>&1\nsc stop WpnUserService >nul 2>&1\nsc config WpnUserService start= disabled >nul 2>&1\nsc stop WpnService >nul 2>&1\nsc config WpnService start= disabled >nul 2>&1\nsc stop wuqisvc >nul 2>&1\nsc config wuqisvc start= disabled >nul 2>&1\nsc stop WSAIFabricSvc >nul 2>&1\nsc config WSAIFabricSvc start= disabled >nul 2>&1\nsc stop WwanSvc >nul 2>&1\nsc config WwanSvc start= disabled >nul 2>&1\nsc stop XblAuthManager >nul 2>&1\nsc config XblAuthManager start= disabled >nul 2>&1\nsc stop XblGameSave >nul 2>&1\nsc config XblGameSave start= disabled >nul 2>&1\nsc stop XboxGipSvc >nul 2>&1\nsc config XboxGipSvc start= disabled >nul 2>&1\nsc stop XboxNetApiSvc >nul 2>&1\nsc config XboxNetApiSvc start= disabled >nul 2>&1\nsc stop jhi_service >nul 2>&1\nsc config jhi_service start= disabled >nul 2>&1\nsc stop WMIRegistrationService >nul 2>&1\nsc config WMIRegistrationService start= disabled >nul 2>&1\nsc stop ipfsvc >nul 2>&1\nsc config ipfsvc start= disabled >nul 2>&1\nsc stop igccservice >nul 2>&1\nsc config igccservice start= disabled >nul 2>&1\nsc stop cplspcon >nul 2>&1\nsc config cplspcon start= disabled >nul 2>&1\nsc stop esifsvc >nul 2>&1\nsc config esifsvc start= disabled >nul 2>&1\nsc stop LMS >nul 2>&1\nsc config LMS start= disabled >nul 2>&1\nsc stop ibtsiva >nul 2>&1\nsc config ibtsiva start= disabled >nul 2>&1\nsc stop cphs >nul 2>&1\nsc config cphs start= disabled >nul 2>&1\nsc stop DSAService >nul 2>&1\nsc config DSAService start= disabled >nul 2>&1\nsc stop DSAUpdateService >nul 2>&1\nsc config DSAUpdateService start= disabled >nul 2>&1\nsc stop RstMwService >nul 2>&1\nsc config RstMwService start= disabled >nul 2>&1\nsc stop SystemUsageReportSvc_QUEENCREEK >nul 2>&1\nsc config SystemUsageReportSvc_QUEENCREEK start= disabled >nul 2>&1\nsc stop iaStorAfsService >nul 2>&1\nsc config iaStorAfsService start= disabled >nul 2>&1\nsc stop NVDisplay.ContainerLocalSystem >nul 2>&1\nsc config NVDisplay.ContainerLocalSystem start= disabled >nul 2>&1\nsc stop NvContainerLocalSystem >nul 2>&1\nsc config NvContainerLocalSystem start= disabled >nul 2>&1\nsc stop FvSVC >nul 2>&1\nsc config FvSVC start= disabled >nul 2>&1\nsc stop RzActionSvc >nul 2>&1\nsc config RzActionSvc start= disabled >nul 2>&1\nsc stop CortexLauncherService >nul 2>&1\nsc config CortexLauncherService start= disabled >nul 2>&1\nsc stop HapticService >nul 2>&1\nsc config HapticService start= disabled >nul 2>&1\nsc stop logi_lamparray_service >nul 2>&1\nsc config logi_lamparray_service start= disabled >nul 2>&1\nsc stop LGHUBUpdaterService >nul 2>&1\nsc config LGHUBUpdaterService start= disabled >nul 2>&1\nsc stop PcaSvc >nul 2>&1\nsc config PcaSvc start= disabled >nul 2>&1\nsc stop PeerDistSvc >nul 2>&1\nsc config PeerDistSvc start= disabled >nul 2>&1\nsc stop PenService >nul 2>&1\nsc config PenService start= disabled >nul 2>&1\nsc stop perceptionsimulation >nul 2>&1\nsc config perceptionsimulation start= disabled >nul 2>&1\nsc stop PerfHost >nul 2>&1\nsc config PerfHost start= disabled >nul 2>&1\nsc stop PhoneSvc >nul 2>&1\nsc config PhoneSvc start= disabled >nul 2>&1\nsc stop PimIndexMaintenanceSvc >nul 2>&1\nsc config PimIndexMaintenanceSvc start= disabled >nul 2>&1\nsc stop pla >nul 2>&1\nsc config pla start= disabled >nul 2>&1\nsc stop PNRPAutoReg >nul 2>&1\nsc config PNRPAutoReg start= disabled >nul 2>&1\nsc stop PNRPsvc >nul 2>&1\nsc config PNRPsvc start= disabled >nul 2>&1\nsc stop PolicyAgent >nul 2>&1\nsc config PolicyAgent start= disabled >nul 2>&1\nsc stop PrintDeviceConfigurationService >nul 2>&1\nsc config PrintDeviceConfigurationService start= disabled >nul 2>&1\nsc stop PrintScanBrokerService >nul 2>&1\nsc config PrintScanBrokerService start= disabled >nul 2>&1\nsc stop PushToInstall >nul 2>&1\nsc config PushToInstall start= disabled >nul 2>&1\nsc stop QWAVE >nul 2>&1\nsc config QWAVE start= disabled >nul 2>&1\nsc stop RasAuto >nul 2>&1\nsc config RasAuto start= disabled >nul 2>&1\nsc stop RasMan >nul 2>&1\nsc config RasMan start= disabled >nul 2>&1\nsc stop refsdedupsvc >nul 2>&1\nsc config refsdedupsvc start= disabled >nul 2>&1\nsc stop RemoteAccess >nul 2>&1\nsc config RemoteAccess start= disabled >nul 2>&1\nsc stop RemoteRegistry >nul 2>&1\nsc config RemoteRegistry start= disabled >nul 2>&1\nsc stop RetailDemo >nul 2>&1\nsc config RetailDemo start= disabled >nul 2>&1\nsc stop RmSvc >nul 2>&1\nsc config RmSvc start= disabled >nul 2>&1\nsc stop RpcLocator >nul 2>&1\nsc config RpcLocator start= disabled >nul 2>&1\nsc stop SamSs >nul 2>&1\nsc config SamSs start= disabled >nul 2>&1\nsc stop SCardSvr >nul 2>&1\nsc config SCardSvr start= disabled >nul 2>&1\nsc stop ScDeviceEnum >nul 2>&1\nsc config ScDeviceEnum start= disabled >nul 2>&1\nsc stop SCPolicySvc >nul 2>&1\nsc config SCPolicySvc start= disabled >nul 2>&1\nsc stop SDRSVC >nul 2>&1\nsc config SDRSVC start= disabled >nul 2>&1\nsc stop seclogon >nul 2>&1\nsc config seclogon start= disabled >nul 2>&1\nsc stop SENS >nul 2>&1\nsc config SENS start= disabled >nul 2>&1\nsc stop Sense >nul 2>&1\nsc config Sense start= disabled >nul 2>&1\nsc stop SensorDataService >nul 2>&1\nsc config SensorDataService start= disabled >nul 2>&1\nsc stop SensorService >nul 2>&1\nsc config SensorService start= disabled >nul 2>&1\nsc stop SensrSvc >nul 2>&1\nsc config SensrSvc start= disabled >nul 2>&1\nsc stop SEMgrSvc >nul 2>&1\nsc config SEMgrSvc start= disabled >nul 2>&1\nsc stop SessionEnv >nul 2>&1\nsc config SessionEnv start= disabled >nul 2>&1\nsc stop SharedAccess >nul 2>&1\nsc config SharedAccess start= disabled >nul 2>&1\nsc stop SharedRealitySvc >nul 2>&1\nsc config SharedRealitySvc start= disabled >nul 2>&1\nsc stop ShellHWDetection >nul 2>&1\nsc config ShellHWDetection start= disabled >nul 2>&1\necho [OK] Extreme OneClick full service strip applied"
  },
  {
    "CategoryId": "extreme",
    "Category": "EXTREME OS STRIP (UNSTABLE)",
    "Id": "extreme_process_kill",
    "Title": "Extreme Process Kill",
    "Description": "Kills extra background UI/cloud/store/gamebar processes. They may restart after reboot unless startup entries are also removed.",
    "Command": ":: === Extreme Process Kill ===\nfor %%P in (OneDrive.exe Teams.exe ms-teams.exe SkypeApp.exe XboxPcApp.exe GameBar.exe GameBarFTServer.exe Widgets.exe SearchHost.exe SearchApp.exe Copilot.exe PhoneExperienceHost.exe msedgewebview2.exe RuntimeBroker.exe TextInputHost.exe Microsoft.Photos.exe YourPhone.exe SecHealthUI.exe) do (\n    taskkill /f /im %%P >nul 2>&1\n)\necho [OK] Extreme process kill complete"
  },
  {
    "CategoryId": "extreme",
    "Category": "EXTREME OS STRIP (UNSTABLE)",
    "Id": "extreme_power_strip",
    "Title": "Extreme Power Strip",
    "Description": "Disables sleep, hibernate, disk timeout, PCIe link power saving, USB suspend, and pins CPU min/max on AC power.",
    "Command": ":: === Extreme Power Strip ===\npowercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1\nfor /f \"tokens=4\" %%G in ('powercfg -list ^| findstr /i \"Ultimate\"') do powercfg -setactive %%G >nul 2>&1\npowercfg -change standby-timeout-ac 0 >nul 2>&1\npowercfg -change monitor-timeout-ac 0 >nul 2>&1\npowercfg -change disk-timeout-ac 0 >nul 2>&1\npowercfg -hibernate off >nul 2>&1\npowercfg /setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100 >nul 2>&1\npowercfg /setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100 >nul 2>&1\npowercfg /setacvalueindex scheme_current SUB_PCIEXPRESS ASPM 0 >nul 2>&1\npowercfg /setacvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0 >nul 2>&1\npowercfg /setactive scheme_current >nul 2>&1\necho [OK] Extreme power strip applied"
  },
  {
    "CategoryId": "extreme",
    "Category": "EXTREME OS STRIP (UNSTABLE)",
    "Id": "extreme_input_lock",
    "Title": "Extreme Input Lock",
    "Description": "Mouse acceleration off, 10/20 Windows sensitivity, curve removal, and keyboard repeat/accessibility popup cleanup.",
    "Command": ":: === Extreme Input Lock ===\nreg add \"HKCU\\Control Panel\\Mouse\" /v \"MouseSpeed\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg add \"HKCU\\Control Panel\\Mouse\" /v \"MouseThreshold1\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg add \"HKCU\\Control Panel\\Mouse\" /v \"MouseThreshold2\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg add \"HKCU\\Control Panel\\Mouse\" /v \"MouseSensitivity\" /t REG_SZ /d \"10\" /f >nul 2>&1\nreg delete \"HKCU\\Control Panel\\Mouse\" /v \"SmoothMouseXCurve\" /f >nul 2>&1\nreg delete \"HKCU\\Control Panel\\Mouse\" /v \"SmoothMouseYCurve\" /f >nul 2>&1\nreg add \"HKCU\\Control Panel\\Keyboard\" /v \"KeyboardDelay\" /t REG_SZ /d \"0\" /f >nul 2>&1\nreg add \"HKCU\\Control Panel\\Keyboard\" /v \"KeyboardSpeed\" /t REG_SZ /d \"31\" /f >nul 2>&1\nreg add \"HKCU\\Control Panel\\Accessibility\\StickyKeys\" /v \"Flags\" /t REG_SZ /d \"506\" /f >nul 2>&1\nreg add \"HKCU\\Control Panel\\Accessibility\\Keyboard Response\" /v \"Flags\" /t REG_SZ /d \"122\" /f >nul 2>&1\nreg add \"HKCU\\Control Panel\\Accessibility\\ToggleKeys\" /v \"Flags\" /t REG_SZ /d \"58\" /f >nul 2>&1\necho [OK] Extreme input lock applied"
  },
  {
    "CategoryId": "extreme",
    "Category": "EXTREME OS STRIP (UNSTABLE)",
    "Id": "extreme_privacy_content_off",
    "Title": "Extreme Privacy / Content Strip",
    "Description": "Disables consumer content, tailored experiences, feedback, suggestions, feeds, widgets, and advertising ID.",
    "Command": ":: === Extreme Privacy / Content Strip ===\nreg add \"HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager\" /v \"ContentDeliveryAllowed\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager\" /v \"OemPreInstalledAppsEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager\" /v \"PreInstalledAppsEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager\" /v \"SilentInstalledAppsEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager\" /v \"SystemPaneSuggestionsEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\PushNotifications\" /v \"ToastEnabled\" /t REG_DWORD /d 0 /f >nul 2>&1\nreg add \"HKLM\\SOFTWARE\\Policies\\Microsoft\\Windows\\CloudContent\" /v \"DisableWindowsConsumerFeatures\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKLM\\SOFTWARE\\Policies\\Microsoft\\Windows\\AdvertisingInfo\" /v \"DisabledByGroupPolicy\" /t REG_DWORD /d 1 /f >nul 2>&1\nreg add \"HKCU\\SOFTWARE\\Policies\\Microsoft\\Windows\\Explorer\" /v \"DisableNotificationCenter\" /t REG_DWORD /d 1 /f >nul 2>&1\necho [OK] Extreme privacy/content strip applied"
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
$script:LastFailedTweaks = @()
$script:LogHistory = New-Object System.Collections.Generic.List[string]
$script:FastApplyMode = $true
$script:MaxLogLines = 220
$script:CachedWindowsBuild = $null
$script:CpuCounter = $null
$script:RamCounter = $null
$script:NetMode = "Unknown"

function Get-ColorBrush([string]$hex) { [Windows.Media.BrushConverter]::new().ConvertFromString($hex) }
function Get-ArgbBrush([string]$hex, [double]$opacity) {
    $c = [Windows.Media.ColorConverter]::ConvertFromString($hex)
    [Windows.Media.SolidColorBrush]::new([Windows.Media.Color]::FromArgb([byte]([Math]::Round(255 * $opacity)),$c.R,$c.G,$c.B))
}

function Normalize-HexColor([string]$value) {
    if ([string]::IsNullOrWhiteSpace($value)) { throw 'Empty color value.' }
    $hex = $value.Trim()
    if ($hex -notmatch '^#') { $hex = '#' + $hex }
    if ($hex -match '^#([0-9a-fA-F]{3})$') {
        $m = $Matches[1]
        return ('#{0}{0}{1}{1}{2}{2}' -f $m[0],$m[1],$m[2]).ToUpper()
    }
    if ($hex -match '^#([0-9a-fA-F]{6})$') { return ('#' + $Matches[1]).ToUpper() }
    throw 'Use a hex color like #F00 or #FF0000.'
}

function Show-AccentHexDialog([string]$currentColor) {
    [xml]$dialogXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Accent Color"
        Width="420" Height="210"
        ResizeMode="NoResize"
        WindowStartupLocation="CenterOwner"
        Background="#08131a"
        Foreground="#e8f7ff"
        FontFamily="Segoe UI">
  <Window.Resources>
    <Style TargetType="Button">
      <Setter Property="Background" Value="#0a131c"/>
      <Setter Property="Foreground" Value="#ffffff"/>
      <Setter Property="BorderBrush" Value="#1a3440"/>
      <Setter Property="BorderThickness" Value="1.2"/>
      <Setter Property="FontSize" Value="12"/>
      <Setter Property="MinHeight" Value="54"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border CornerRadius="10" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" RecognizesAccessKey="True"/>
            </Border>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style TargetType="ListBoxItem">
      <Setter Property="MinHeight" Value="72"/>
      <Setter Property="FontSize" Value="13"/>
      <Setter Property="FontWeight" Value="Bold"/>
      <Setter Property="HorizontalContentAlignment" Value="Center"/>
      <Setter Property="VerticalContentAlignment" Value="Center"/>
    </Style>
  </Window.Resources>
  <Grid Margin="16">
    <Grid.RowDefinitions>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="*"/>
      <RowDefinition Height="Auto"/>
    </Grid.RowDefinitions>
    <TextBlock Text="Enter any hex accent color" FontSize="16" FontWeight="SemiBold"/>
    <TextBlock Grid.Row="1" Margin="0,8,0,12" Text="#RGB or #RRGGBB  e.g.  #F00   #00FFE7   #7C3AED" Foreground="#7ca7a2"/>
    <DockPanel Grid.Row="2" LastChildFill="True">
      <Border x:Name="PreviewBox" Width="44" Height="44" CornerRadius="6" BorderBrush="White" BorderThickness="1" Margin="0,0,12,0"/>
      <TextBox x:Name="ColorInput" VerticalContentAlignment="Center" FontSize="16" Padding="10,8" Background="#101820" Foreground="White" BorderBrush="#335c6d"/>
    </DockPanel>
    <StackPanel Grid.Row="3" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,16,0,0">
      <Button x:Name="CancelBtn" Content="Cancel" Width="90" Margin="0,0,10,0"/>
      <Button x:Name="ApplyBtn" Content="Apply" Width="90"/>
    </StackPanel>
  </Grid>
</Window>
"@
    $reader = [System.Xml.XmlNodeReader]::new($dialogXaml)
    $dialog = [Windows.Markup.XamlReader]::Load($reader)
    $colorInput = $dialog.FindName('ColorInput')
    $previewBox = $dialog.FindName('PreviewBox')
    $cancelBtn = $dialog.FindName('CancelBtn')
    $applyBtn = $dialog.FindName('ApplyBtn')
    $colorInput.Text = $currentColor
    $script:AccentDialogResult = $null
    $updatePreview = {
        try {
            $normalized = Normalize-HexColor $colorInput.Text
            $previewBox.Background = Get-ColorBrush $normalized
            $colorInput.BorderBrush = Get-ColorBrush '#2ed573'
        } catch {
            $previewBox.Background = Get-ColorBrush '#101820'
            $colorInput.BorderBrush = Get-ColorBrush '#ff4757'
        }
    }
    & $updatePreview
    $colorInput.Add_TextChanged($updatePreview)
    $cancelBtn.Add_Click({ $dialog.DialogResult = $false; $dialog.Close() })
    $applyBtn.Add_Click({
        try {
            $script:AccentDialogResult = Normalize-HexColor $colorInput.Text
            $dialog.DialogResult = $true
            $dialog.Close()
        } catch {
            [System.Windows.MessageBox]::Show('Use a valid hex color like #F00 or #FF0000.','LakTweaks','OK','Warning') | Out-Null
        }
    })
    $dialog.Owner = $Window
    $null = $dialog.ShowDialog()
    return $script:AccentDialogResult
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
    if (-not (Test-Path $script:SettingsPath)) { return }
    try {
        $obj = Get-Content -Path $script:SettingsPath -Raw | ConvertFrom-Json
        if ($obj.Accent)              { $script:CurrentAccent = [string]$obj.Accent }
        if ($null -ne $obj.BgOpacity) { $script:CurrentBgOpacity = [double]$obj.BgOpacity }
        if ($null -ne $obj.Glow)      { $script:CurrentGlow = [double]$obj.Glow }
        if ($null -ne $obj.Compact)   { $script:CurrentCompact = [bool]$obj.Compact }
        if ($null -ne $obj.Clean)     { $script:CurrentClean = [bool]$obj.Clean }
        if ($null -ne $obj.Scanlines) { $script:CurrentScanlines = [double]$obj.Scanlines }
        if ($null -ne $obj.Grid)      { $script:CurrentGrid = [double]$obj.Grid }
    } catch {}
}

function Save-AppliedTweaks {
    $script:AppliedTweaks | Sort-Object -Unique | ConvertTo-Json -Depth 2 | Set-Content -Path $script:AppliedTweaksPath -Encoding UTF8
}
function Load-AppliedTweaks {
    if (-not (Test-Path $script:AppliedTweaksPath)) { $script:AppliedTweaks = @(); return }
    try {
        $raw = Get-Content -Path $script:AppliedTweaksPath -Raw
        if ([string]::IsNullOrWhiteSpace($raw)) { $script:AppliedTweaks = @(); return }
        $loaded = $raw | ConvertFrom-Json
        if ($loaded -is [System.Array]) { $script:AppliedTweaks = @($loaded | ForEach-Object { [string]$_ }) }
        elseif ($null -ne $loaded) { $script:AppliedTweaks = @([string]$loaded) }
        else { $script:AppliedTweaks = @() }
    } catch { $script:AppliedTweaks = @() }
}
function Test-TweakApplied([string]$id) { return $script:AppliedTweaks -contains $id }
function Mark-TweaksApplied([object[]]$selected) {
    foreach($item in $selected) {
        if (-not ($script:AppliedTweaks -contains $item.Id)) { $script:AppliedTweaks += [string]$item.Id }
    }
    Save-AppliedTweaks
}


function Write-Log {
    param([string]$Message, [string]$Level='INFO')
    $time = Get-Date -Format 'HH:mm:ss'
    $line = "[$time][$Level] $Message"
    try { [void]$script:LogHistory.Add($line) } catch {}
    try { while ($script:LogHistory.Count -gt $script:MaxLogLines) { $script:LogHistory.RemoveAt(0) } } catch {}
    if ($null -ne $LogBox) {
        if ($script:FastApplyMode) {
            $LogBox.Text = ($script:LogHistory -join "`r`n")
            $LogBox.ScrollToEnd()
        } else {
            $LogBox.AppendText("`r`n" + $line)
            $LogBox.ScrollToEnd()
        }
    }
}

function Select-Preset([string]$Mode) {
    Clear-TweakSelections
    $selectedIds = @()

    switch ($Mode) {
        'Safe' {
            $safeCats = @('privacy','debloat','registry')
            $selectedIds = @($script:Catalog | Where-Object {
                $safeCats -contains $_.CategoryId -and $_.Id -notmatch 'defender|wupdate|trusted|extreme|strip'
            } | Select-Object -ExpandProperty Id)
            Write-Log 'Safe preset selected: privacy, cleanup, light registry responsiveness.' 'PRESET'
        }
        'Competitive' {
            $compCats = @('fortnite','network','input','power','gpu')
            $selectedIds = @($script:Catalog | Where-Object {
                $compCats -contains $_.CategoryId -and $_.Id -notmatch 'spectre|tdr|cstates|deep|strip'
            } | Select-Object -ExpandProperty Id)
            Write-Log 'Competitive preset selected: gaming, network, input, power, and GPU latency stack.' 'PRESET'
        }
        'Extreme' {
            $selectedIds = @($script:Catalog | Where-Object {
                $_.CategoryId -eq 'extreme' -or ($_.CategoryId -eq 'services' -and $_.Id -notmatch 'defender')
            } | Select-Object -ExpandProperty Id)
            Write-Log 'Extreme preset selected. Expect broken Windows features; this is lab/dev mode.' 'WARN'
        }
    }

    foreach($id in $selectedIds) { Select-TweakById $id }
    Update-SelectedCount
}

function Test-TweakConflicts([object[]]$selected) {
    $warnings = New-Object System.Collections.Generic.List[string]
    $ids = @($selected | Select-Object -ExpandProperty Id)

    if ($selected | Where-Object { $_.CategoryId -eq 'extreme' }) {
        [void]$warnings.Add('Extreme Mode selected: this can disable networking, Windows Update, printing, Bluetooth, security, and core Windows features.')
    }
    if ($ids -contains 'gpu_tdr_off') {
        [void]$warnings.Add('GPU TDR changes require reboot and can hide driver crash symptoms. Use only if you understand the tradeoff.')
    }
    if ($ids -contains 'timer_bcdedit' -or $ids -contains 'cpu_cstates_off') {
        [void]$warnings.Add('BCD/timer tweaks require reboot. If frametimes get worse, restore defaults before testing again.')
    }
    if ($ids -contains 'extreme_oneclick_full_service_strip') {
        [void]$warnings.Add('Full OneClick service strip includes core service disables and should be tested only on a disposable install.')
    }
    return ,$warnings.ToArray()
}

function New-LakRestorePoint {
    try {
        Write-Log 'Creating restore point: LakTweaks v36 Before Apply...' 'INFO'
        Checkpoint-Computer -Description 'LakTweaks v36 Before Apply' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction Stop
        Write-Log 'Restore point created successfully.' 'OK'
        [System.Windows.MessageBox]::Show('Restore point created successfully.', 'LakTweaks', 'OK', 'Information') | Out-Null
    } catch {
        Write-Log ('Restore point failed: ' + $_.Exception.Message) 'WARN'
        [System.Windows.MessageBox]::Show('Restore point failed: ' + $_.Exception.Message, 'LakTweaks', 'OK', 'Warning') | Out-Null
    }
}



function Get-LakHardwareSummary {
    $cpu = 'Unknown CPU'; $gpu = 'Unknown GPU'; $os = 'Windows'; $ram = 'RAM Unknown'
    try { $cpu = (Get-CimInstance Win32_Processor | Select-Object -First 1 -ExpandProperty Name).Trim() } catch {}
    try { $gpu = (Get-CimInstance Win32_VideoController | Where-Object { $_.Name -notmatch 'Basic Display|Remote' } | Select-Object -First 1 -ExpandProperty Name).Trim() } catch {}
    try {
        $osObj = Get-CimInstance Win32_OperatingSystem
        $os = ($osObj.Caption + ' ' + $osObj.BuildNumber)
        $script:CachedWindowsBuild = $osObj.BuildNumber
        $ram = [math]::Round(($osObj.TotalVisibleMemorySize/1MB),1).ToString() + ' GB RAM'
    } catch {}
    try {
        $up = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq 'Up' } | Select-Object -First 1
        if ($up) { $script:NetMode = if ($up.Name -match 'wi-?fi|wireless|wlan' -or $up.InterfaceDescription -match 'wi-?fi|wireless|wlan') { 'WiFi' } else { 'Ethernet' } }
    } catch {}
    return [pscustomobject]@{ CPU=$cpu; GPU=$gpu; OS=$os; RAM=$ram; Network=$script:NetMode }
}

function Initialize-FastPerformanceCounters {
    try { $script:CpuCounter = [System.Diagnostics.PerformanceCounter]::new('Processor','% Processor Time','_Total'); [void]$script:CpuCounter.NextValue() } catch { $script:CpuCounter = $null }
    try { $script:RamCounter = [System.Diagnostics.PerformanceCounter]::new('Memory','% Committed Bytes In Use'); [void]$script:RamCounter.NextValue() } catch { $script:RamCounter = $null }
}

function Update-PerformancePanel {
    try {
        if ($null -ne $WindowsValueText -and $script:CachedWindowsBuild) { $WindowsValueText.Text = [string]$script:CachedWindowsBuild }
        if ($null -ne $AdminValueText) { $AdminValueText.Text = if (Test-Admin) { 'Elevated' } else { 'Limited' } }
        if ($null -ne $LastUpdatedText) { $LastUpdatedText.Text = (Get-Date -Format 'M/d/yyyy  hh:mm:ss tt') }
        if ($null -ne $CpuValueText) {
            $cpuText = $null
            if ($script:CpuCounter) { try { $cpuText = ([math]::Round($script:CpuCounter.NextValue(),0).ToString() + '%') } catch {} }
            if (-not $cpuText) {
                try {
                    $cpuLoad = (Get-CimInstance Win32_Processor -ErrorAction Stop | Measure-Object -Property LoadPercentage -Average).Average
                    if ($null -ne $cpuLoad) { $cpuText = ([math]::Round([double]$cpuLoad,0).ToString() + '%') }
                } catch {}
            }
            if ($cpuText) { $CpuValueText.Text = $cpuText } else { $CpuValueText.Text = '0%' }
        }
        if ($null -ne $RamValueText) {
            $ramText = $null
            if ($script:RamCounter) { try { $ramText = ([math]::Round($script:RamCounter.NextValue(),0).ToString() + '%') } catch {} }
            if (-not $ramText) {
                try {
                    $osMem = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
                    $used = [double]($osMem.TotalVisibleMemorySize - $osMem.FreePhysicalMemory)
                    $pct = ($used / [double]$osMem.TotalVisibleMemorySize) * 100
                    $ramText = ([math]::Round($pct,0).ToString() + '%')
                } catch {}
            }
            if ($ramText) { $RamValueText.Text = $ramText } else { $RamValueText.Text = '0%' }
        }
    } catch {}
}

function Select-SmartNetworkPreset {
    Clear-TweakSelections
    $net = 'Unknown'
    try {
        $up = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq 'Up' } | Select-Object -First 1
        if ($up) { $net = if ($up.Name -match 'wi-?fi|wireless|wlan' -or $up.InterfaceDescription -match 'wi-?fi|wireless|wlan') { 'WiFi' } else { 'Ethernet' } }
    } catch {}
    $base = @('tcpack','ndu','netbt','qos_bandwidth_zero','dns_winsock_refresh')
    if ($net -eq 'Ethernet') { $base += @('nic_interrupt_moderation_off','green_ethernet_off','rss_on_rsc_off') }
    foreach($id in $base) { Select-TweakById $id }
    Update-SelectedCount
    Write-Log ('Smart Network Mode queued ' + $base.Count + ' tweak(s). Adapter type: ' + $net) 'PRESET'
}

function Enable-LakLowTimerMode {
    try {
        if (-not ('WinMM.NativeMethods' -as [type])) {
            Add-Type -Namespace WinMM -Name NativeMethods -MemberDefinition '[DllImport("winmm.dll")] public static extern uint timeBeginPeriod(uint uMilliseconds); [DllImport("winmm.dll")] public static extern uint timeEndPeriod(uint uMilliseconds);' | Out-Null
        }
        [void][WinMM.NativeMethods]::timeBeginPeriod(1)
        $script:LowTimerActive = $true
        Write-Log 'Low timer request enabled while LakTweaks is open.' 'OK'
    } catch { Write-Log ('Low timer request failed: ' + $_.Exception.Message) 'WARN' }
}

function Backup-LakQuickRegistry {
    try {
        $dir = Join-Path $env:APPDATA 'LakTweaks\Backups'
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
        $paths = @(
            @{Hive='HKCU\System\GameConfigStore'; File='GameConfigStore'},
            @{Hive='HKCU\Control Panel\Mouse'; File='Mouse'},
            @{Hive='HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile'; File='SystemProfile'},
            @{Hive='HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl'; File='PriorityControl'},
            @{Hive='HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers'; File='GraphicsDrivers'}
        )
        foreach($p in $paths) {
            $out = Join-Path $dir ($p.File + '_' + $stamp + '.reg')
            cmd.exe /c ('reg export "' + $p.Hive + '" "' + $out + '" /y') | Out-Null
        }
        Write-Log ('Quick registry backup saved to ' + $dir) 'OK'
    } catch { Write-Log ('Quick registry backup failed: ' + $_.Exception.Message) 'WARN' }
}


function Backup-LakFullRegistry {
    try {
        $dir = Join-Path $env:APPDATA 'LakTweaks\FullBackup'
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        $hklm = Join-Path $dir 'HKLM_FULL_BACKUP.reg'
        $hkcu = Join-Path $dir 'HKCU_FULL_BACKUP.reg'
        Write-Log 'Creating full registry backup. This can take a minute...' 'INFO'
        cmd.exe /c ('reg export HKLM "' + $hklm + '" /y') | Out-Null
        cmd.exe /c ('reg export HKCU "' + $hkcu + '" /y') | Out-Null
        Write-Log ('Full registry backup saved to ' + $dir) 'OK'
        [System.Windows.MessageBox]::Show('Full registry backup saved to:`n' + $dir, 'LakTweaks v36 ULTIMATE', 'OK', 'Information') | Out-Null
    } catch { Write-Log ('Full backup failed: ' + $_.Exception.Message) 'FAIL' }
}

function Restore-LakFullRegistry {
    try {
        $dir = Join-Path $env:APPDATA 'LakTweaks\FullBackup'
        $hklm = Join-Path $dir 'HKLM_FULL_BACKUP.reg'
        $hkcu = Join-Path $dir 'HKCU_FULL_BACKUP.reg'
        if (-not (Test-Path $hklm) -or -not (Test-Path $hkcu)) {
            [System.Windows.MessageBox]::Show('No full backup found. Click FULL BACKUP first.', 'LakTweaks', 'OK', 'Warning') | Out-Null
            return
        }
        $r = [System.Windows.MessageBox]::Show('Restore the saved full registry backup now? You should reboot after restoring.', 'LakTweaks v36 ULTIMATE', 'YesNo', 'Warning')
        if ($r -ne 'Yes') { return }
        Write-Log 'Restoring full registry backup...' 'WARN'
        cmd.exe /c ('reg import "' + $hklm + '"') | Out-Null
        cmd.exe /c ('reg import "' + $hkcu + '"') | Out-Null
        Write-Log 'Full registry backup restored. Reboot recommended.' 'OK'
    } catch { Write-Log ('Restore failed: ' + $_.Exception.Message) 'FAIL' }
}

function Clean-LakRamLite {
    try {
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
        [System.GC]::Collect()
        Write-Log 'Light RAM cleanup completed for this PowerShell session.' 'OK'
    } catch { Write-Log ('RAM cleanup failed: ' + $_.Exception.Message) 'WARN' }
}

function Verify-TweakPostApply([object]$item) {
    try {
        switch ($item.Id) {
            'win32pri_26' { return ((Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl' -Name 'Win32PrioritySeparation' -ErrorAction SilentlyContinue).Win32PrioritySeparation -eq 26) }
            'gamedvr_disable' { return ((Get-ItemProperty 'HKCU:\System\GameConfigStore' -Name 'GameDVR_Enabled' -ErrorAction SilentlyContinue).GameDVR_Enabled -eq 0) }
            'hags_enable' { return ((Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers' -Name 'HwSchMode' -ErrorAction SilentlyContinue).HwSchMode -eq 2) }
            'mouseaccel' { return ((Get-ItemProperty 'HKCU:\Control Panel\Mouse' -Name 'MouseSpeed' -ErrorAction SilentlyContinue).MouseSpeed -eq '0') }
            'mouse_1to1_sens' { return ((Get-ItemProperty 'HKCU:\Control Panel\Mouse' -Name 'MouseSensitivity' -ErrorAction SilentlyContinue).MouseSensitivity -eq '10') }
            default { return $null }
        }
    } catch { return $false }
}

function Select-SmartOptimizePreset {
    Clear-TweakSelections
    $hw = Get-LakHardwareSummary
    Write-Log ('Smart Optimize detected: ' + $hw.OS + ' | ' + $hw.CPU + ' | ' + $hw.GPU + ' | ' + $hw.RAM) 'INFO'
    $ids = @($script:Catalog | Where-Object {
        ($_.CategoryId -in @('network','input','power','gpu','privacy','registry','debloat')) -and
        ($_.Id -notmatch 'extreme|strip|defender|wupdate|tdr|spectre|cstates|trusted|eventlog|samss')
    } | Select-Object -ExpandProperty Id)
    if ($hw.GPU -notmatch 'NVIDIA') { $ids = @($ids | Where-Object { $_ -notmatch 'nvidia|msi_latency' }) }
    foreach($id in $ids) { Select-TweakById $id }
    Update-SelectedCount
    Write-Log ('Smart Optimize queued ' + $ids.Count + ' safer competitive tweaks. Review, then Apply Selected.') 'PRESET'
}

function Export-Bat([object[]]$selected, [string]$path) {
    $now = Get-Date -Format 'yyyy-MM-dd HH:mm'
    $lines = @('@echo off','title LAK TWEAKS ELITE','color 0A','setlocal EnableExtensions EnableDelayedExpansion','','net session >nul 2>&1','if %errorlevel% neq 0 (','    echo ERROR: Run as Administrator!','    pause','    exit /b',')','','echo ============================================','echo   LAK TWEAKS ELITE  -  Generated: ' + $now,'echo   Tweaks selected: ' + $selected.Count,'echo ============================================','')
    foreach($group in ($selected | Group-Object Category)) {
        $lines += ':: ===================================================='
        $lines += ':: ' + $group.Name
        $lines += ':: ===================================================='
        foreach($item in $group.Group) { $lines += $item.Command.TrimEnd(); $lines += '' }
    }
    $lines += 'echo.'; $lines += 'echo ============================================'
    $lines += 'echo   ALL TWEAKS APPLIED - REBOOT FOR FULL EFFECT'
    $lines += 'echo ============================================'; $lines += 'pause'
    [IO.File]::WriteAllText($path, ($lines -join [Environment]::NewLine), [Text.UTF8Encoding]::new($false))
}

function Invoke-TweakCommands([object[]]$selected) {
    $succeeded = @()
    $failed    = @()
    $script:LastFailedTweaks = @()

    foreach($item in $selected) {
        $tempBat = Join-Path $env:TEMP ("LakTweaks_" + $item.Id + "_" + [guid]::NewGuid().ToString('N') + ".bat")
        $tempLog = Join-Path $env:TEMP ("LakTweaks_" + $item.Id + "_" + [guid]::NewGuid().ToString('N') + ".log")
        try {
            Write-Log ("Applying: " + $item.Title) 'RUN'
            $batContent = @(
                '@echo off',
                'setlocal EnableExtensions EnableDelayedExpansion',
                'echo [LAKTWEAKS] Starting: ' + $item.Title,
                $item.Command,
                'set "LAK_EXIT=%ERRORLEVEL%"',
                'echo [LAKTWEAKS] Finished: ' + $item.Title + ' ExitCode=%LAK_EXIT%',
                'exit /b %LAK_EXIT%'
            ) -join [Environment]::NewLine

            [System.IO.File]::WriteAllText($tempBat, $batContent, [System.Text.UTF8Encoding]::new($false))
            $arg = '/c "' + $tempBat + '" > "' + $tempLog + '" 2>&1'
            $proc = Start-Process -FilePath 'cmd.exe' -ArgumentList $arg -Wait -PassThru -WindowStyle Hidden

            $output = ''
            if ($proc.ExitCode -ne 0 -and (Test-Path $tempLog)) { $output = Get-Content -Path $tempLog -Raw -ErrorAction SilentlyContinue }

            if ($proc.ExitCode -eq 0) {
                $verify = Verify-TweakPostApply $item
                $succeeded += $item
                if ($null -eq $verify) {
                    Write-Log ($item.Title + ' applied successfully. Verification: not required.') 'OK'
                } elseif ($verify) {
                    Write-Log ($item.Title + ' applied successfully. Verification passed.') 'OK'
                } else {
                    Write-Log ($item.Title + ' applied, but verification could not confirm the expected value.') 'WARN'
                }
            } else {
                $failed += [pscustomobject]@{ Item=$item; ExitCode=$proc.ExitCode; Output=$output }
                $script:LastFailedTweaks += $item
                Write-Log ($item.Title + ' failed. ExitCode=' + $proc.ExitCode) 'FAIL'
            }
        } catch {
            $failed += [pscustomobject]@{ Item=$item; ExitCode=-1; Output=$_.Exception.Message }
            $script:LastFailedTweaks += $item
            Write-Log ($item.Title + ' exception: ' + $_.Exception.Message) 'FAIL'
        } finally {
            if (Test-Path $tempBat) { Remove-Item -Path $tempBat -Force -ErrorAction SilentlyContinue }
            if (Test-Path $tempLog) { Remove-Item -Path $tempLog -Force -ErrorAction SilentlyContinue }
        }
    }

    return [pscustomobject]@{
        Succeeded = @($succeeded)
        Failed    = @($failed)
    }
}

Load-UiSettings
Load-AppliedTweaks

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="LakTweaks v47 CLEAN FIT"
        Height="900" Width="1720"
        MinHeight="760" MinWidth="1200"
        WindowStartupLocation="CenterScreen"
        ResizeMode="CanResizeWithGrip"
        Background="#050a0f"
        Foreground="#c8f5f0"
        FontFamily="Segoe UI">
  <Grid>
    <Grid.Resources>
      <Style TargetType="Button">
        <Setter Property="Foreground" Value="#ffffff"/>
        <Setter Property="Background" Value="#07131c"/>
        <Setter Property="BorderBrush" Value="#17313d"/>
        <Setter Property="BorderThickness" Value="1.4"/>
        <Setter Property="Cursor" Value="Hand"/>
        <Setter Property="SnapsToDevicePixels" Value="True"/>
        <Setter Property="Template">
          <Setter.Value>
            <ControlTemplate TargetType="Button">
              <Border x:Name="BtnBorder" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="10">
                <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" RecognizesAccessKey="True"/>
              </Border>
              <ControlTemplate.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                  <Setter TargetName="BtnBorder" Property="BorderBrush" Value="#00ffe7"/>
                  <Setter TargetName="BtnBorder" Property="Background" Value="#0d1e29"/>
                </Trigger>
                <Trigger Property="IsPressed" Value="True">
                  <Setter TargetName="BtnBorder" Property="Background" Value="#102b37"/>
                </Trigger>
                <Trigger Property="IsEnabled" Value="False">
                  <Setter Property="Opacity" Value="0.45"/>
                </Trigger>
              </ControlTemplate.Triggers>
            </ControlTemplate>
          </Setter.Value>
        </Setter>
      </Style>
    </Grid.Resources>
    <Grid.ColumnDefinitions>
      <ColumnDefinition Width="205"/>
      <ColumnDefinition Width="*"/>
    </Grid.ColumnDefinitions>
    <Grid.RowDefinitions>
      <RowDefinition Height="104"/>
      <RowDefinition Height="*"/>
      <RowDefinition Height="74"/>
    </Grid.RowDefinitions>

    <Border Grid.Row="0" Grid.Column="0" Background="#050a0f" BorderBrush="#142b35" BorderThickness="0,0,1,1">
      <Grid VerticalAlignment="Center" HorizontalAlignment="Center" Width="36" Height="36">
        <Border CornerRadius="10" Background="#07131c" BorderBrush="#00ffe7" BorderThickness="1.1" Opacity="0.95"/>
        <TextBlock Text="L" FontSize="18" FontWeight="Black" Foreground="#00ffe7" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="-6,-1,0,0"/>
        <TextBlock Text="T" FontSize="15" FontWeight="Black" Foreground="#ffffff" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="8,6,0,0"/>
      </Grid>
    </Border>

    <Border x:Name="HeaderBorder" Grid.Row="0" Grid.Column="1" Background="#060b12" BorderThickness="0,0,0,1">
      <Grid Margin="22,0,22,0">
        <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
        <StackPanel Orientation="Vertical" VerticalAlignment="Center">
          <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
            <TextBlock x:Name="LogoText" Text="LAKTWEAKS" FontSize="28" FontWeight="Black" Foreground="#ffffff"/>
            <TextBlock Text=" v45" FontSize="25" FontWeight="Black" Foreground="#00ffe7" Margin="14,0,0,0"/>
            <Border CornerRadius="8" Padding="13,4" Margin="14,4,0,0" Background="#1d1236" BorderBrush="#784dff" BorderThickness="1.2">
              <TextBlock Text="ULTIMATE" FontSize="15" FontWeight="Black" Foreground="#b98cff"/>
            </Border>
          </StackPanel>
          <TextBlock Text="ULTIMATE WINDOWS OPTIMIZER" FontSize="13" Foreground="#7fa5a6" FontWeight="SemiBold" Margin="2,10,0,0"/>
        </StackPanel>

        <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center">
          <Border CornerRadius="14" Padding="14,8" Margin="0,0,10,0" Background="#09131d" BorderBrush="#17313d" BorderThickness="1.2">
            <StackPanel Orientation="Horizontal"><TextBlock Text="▦" Foreground="#00a2ff" FontSize="24" Margin="0,0,10,0" VerticalAlignment="Center"/><StackPanel><TextBlock Text="Windows 11 Pro" Foreground="#ffffff" FontSize="12" FontWeight="Bold"/><TextBlock x:Name="WindowsValueText" Text="Detecting" Foreground="#00ffe7" FontSize="11" FontWeight="SemiBold"/></StackPanel></StackPanel>
          </Border>
          <Border CornerRadius="14" Padding="14,8" Margin="0,0,10,0" Background="#09131d" BorderBrush="#17313d" BorderThickness="1.2">
            <StackPanel Orientation="Horizontal"><TextBlock Text="▣" Foreground="#00ffe7" FontSize="22" Margin="0,0,10,0" VerticalAlignment="Center"/><StackPanel><TextBlock Text="CPU" Foreground="#ffffff" FontSize="12" FontWeight="Bold"/><TextBlock x:Name="CpuValueText" Text="0%" Foreground="#00ffe7" FontSize="11" FontWeight="SemiBold"/></StackPanel></StackPanel>
          </Border>
          <Border CornerRadius="14" Padding="14,8" Margin="0,0,10,0" Background="#09131d" BorderBrush="#17313d" BorderThickness="1.2">
            <StackPanel Orientation="Horizontal"><TextBlock Text="▤" Foreground="#00ffe7" FontSize="22" Margin="0,0,10,0" VerticalAlignment="Center"/><StackPanel><TextBlock Text="RAM" Foreground="#ffffff" FontSize="12" FontWeight="Bold"/><TextBlock x:Name="RamValueText" Text="0%" Foreground="#00ffe7" FontSize="11" FontWeight="SemiBold"/></StackPanel></StackPanel>
          </Border>
          <Border CornerRadius="14" Padding="14,8" Background="#09131d" BorderBrush="#17313d" BorderThickness="1.2">
            <StackPanel Orientation="Horizontal"><TextBlock Text="♙" Foreground="#00ffe7" FontSize="23" Margin="0,0,10,0" VerticalAlignment="Center"/><StackPanel><TextBlock Text="Administrator" Foreground="#ffffff" FontSize="12" FontWeight="Bold"/><TextBlock x:Name="AdminValueText" Text="Checking" Foreground="#2ed573" FontSize="11" FontWeight="SemiBold"/></StackPanel></StackPanel>
          </Border>
        </StackPanel>
      </Grid>
    </Border>

    <Border x:Name="SidebarBorder" Grid.Row="1" Grid.RowSpan="2" Grid.Column="0" BorderBrush="#142b35" BorderThickness="0,0,1,0" Background="#050a0f">
      <ListBox x:Name="SidebarList" BorderThickness="0" Background="Transparent" Foreground="#c8f5f0" Margin="12,14,10,10" HorizontalContentAlignment="Stretch" ScrollViewer.HorizontalScrollBarVisibility="Disabled"/>
    </Border>

    <Grid x:Name="MainContentGrid" Grid.Row="1" Grid.Column="1" Margin="16,16,16,14">
      <Grid.RowDefinitions><RowDefinition x:Name="HomeRowDef" Height="210"/><RowDefinition x:Name="ContentRowDef" Height="*"/></Grid.RowDefinitions>

      <Border x:Name="HomeDashboardBorder" Grid.Row="0" CornerRadius="16" Background="#071018" BorderBrush="#183542" BorderThickness="1.2" Padding="14,10">
        <Grid>
          <Grid.RowDefinitions>
            <RowDefinition Height="68"/>
            <RowDefinition Height="6"/>
            <RowDefinition Height="58"/>
            <RowDefinition Height="6"/>
            <RowDefinition Height="46"/>
          </Grid.RowDefinitions>

          <!-- ROW 1: 9 equal preset/utility buttons -->
          <UniformGrid Grid.Row="0" Rows="1" Columns="9" HorizontalAlignment="Stretch">
            <Button x:Name="SafePresetBtn"    Margin="4,0" Height="60" FontSize="10" FontWeight="Bold" Background="#07131c" Foreground="#ffffff"/>
            <Button x:Name="CompPresetBtn"    Margin="4,0" Height="60" FontSize="10" FontWeight="Bold" Background="#07131c" Foreground="#ffffff"/>
            <Button x:Name="ExtremePresetBtn" Margin="4,0" Height="60" FontSize="10" FontWeight="Bold" Background="#07131c" Foreground="#ffffff"/>
            <Button x:Name="SelectAllBtn"     Margin="4,0" Height="60" FontSize="10" FontWeight="Bold" Background="#07131c" Foreground="#ffffff"/>
            <Button x:Name="ResetAllBtn"      Margin="4,0" Height="60" FontSize="10" FontWeight="Bold" Background="#07131c" Foreground="#ffffff"/>
            <Button x:Name="ExportBatBtn"     Margin="4,0" Height="60" FontSize="10" FontWeight="Bold" Background="#07131c" Foreground="#ffffff"/>
            <Button x:Name="RestorePointBtn"  Margin="4,0" Height="60" FontSize="10" FontWeight="Bold" Background="#07131c" Foreground="#ffffff"/>
            <Button x:Name="RetryFailedBtn"   Margin="4,0" Height="60" FontSize="10" FontWeight="Bold" Background="#07131c" Foreground="#ffffff"/>
            <Button x:Name="ClearLogBtn"      Margin="4,0" Height="60" FontSize="10" FontWeight="Bold" Background="#07131c" Foreground="#ffffff"/>
          </UniformGrid>

          <!-- ROW 2: 7 equal action buttons -->
          <UniformGrid Grid.Row="2" Rows="1" Columns="8" HorizontalAlignment="Stretch">
            <Button x:Name="OptimizeBtn"      Margin="4,0" Height="50" FontSize="10" FontWeight="Bold" Background="#07131c" Foreground="#ffffff"/>
            <Button x:Name="LowTimerBtn"      Margin="4,0" Height="50" FontSize="10" FontWeight="Bold" Background="#07131c" Foreground="#ffffff"/>
            <Button x:Name="SmartNetBtn"      Margin="4,0" Height="50" FontSize="10" FontWeight="Bold" Background="#07131c" Foreground="#ffffff"/>
            <Button x:Name="FullBackupBtn"    Margin="4,0" Height="50" FontSize="10" FontWeight="Bold" Background="#07131c" Foreground="#ffffff"/>
            <Button x:Name="RestoreBackupBtn" Margin="4,0" Height="50" FontSize="10" FontWeight="Bold" Background="#07131c" Foreground="#ffffff"/>
            <Button x:Name="RamCleanBtn"      Margin="4,0" Height="50" FontSize="10" FontWeight="Bold" Background="#07131c" Foreground="#ffffff"/>
            <Button x:Name="ApplyBtn"         Margin="4,0" Height="50" FontSize="10" FontWeight="Black" Background="#071f14" Foreground="#00ffe7"/>
            <StackPanel VerticalAlignment="Center" HorizontalAlignment="Center">
              <TextBlock Text="SELECTED" FontSize="10" Foreground="#bcecff" FontWeight="Bold" HorizontalAlignment="Center"/>
              <TextBlock x:Name="SelectedCountText" Text="0" FontSize="30" FontWeight="Black" Foreground="#ffaa2b" HorizontalAlignment="Center"/>
            </StackPanel>
          </UniformGrid>

          <!-- LOG ROW -->
          <Border Grid.Row="4" CornerRadius="10" BorderThickness="1" BorderBrush="#163847" Background="#03080d" Padding="10,4">
            <Grid>
              <Grid.ColumnDefinitions><ColumnDefinition Width="28"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
              <TextBlock Text="✓" FontSize="18" FontWeight="Black" Foreground="#00ffe7" VerticalAlignment="Center" HorizontalAlignment="Center"/>
              <TextBox x:Name="LogBox" Grid.Column="1" IsReadOnly="True" TextWrapping="NoWrap" AcceptsReturn="False" VerticalScrollBarVisibility="Disabled" HorizontalScrollBarVisibility="Disabled" Background="Transparent" Foreground="#00ffe7" BorderThickness="0" FontFamily="Consolas" FontSize="11" FontWeight="Bold" Padding="0,2,8,0" Text="LakTweaks v47 ready. Pick a preset or select tweaks manually."/>
            </Grid>
          </Border>
        </Grid>
      </Border>

      <Border Grid.Row="1" CornerRadius="16" Background="#050b10" BorderBrush="#142b35" BorderThickness="1.2" Margin="0,14,0,0" Padding="18,14">
        <Grid>
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/></Grid.RowDefinitions>
          <StackPanel Margin="0,0,0,12"><TextBlock x:Name="SectionTitle" FontSize="24" FontWeight="Black" Foreground="#00ffe7"/><TextBlock x:Name="SectionDesc" FontSize="12" Foreground="#5a8a85" TextWrapping="Wrap" Margin="0,3,0,0"/></StackPanel>
          <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled"><WrapPanel x:Name="CardPanel" ItemWidth="374"/></ScrollViewer>
        </Grid>
      </Border>
    </Grid>

    <Border x:Name="FooterBorder" Grid.Row="2" Grid.Column="1" Margin="16,0,16,12" CornerRadius="14" Background="#071018" BorderBrush="#00a7c8" BorderThickness="1.1">
      <Grid Margin="22,0">
        <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="*"/><ColumnDefinition Width="*"/><ColumnDefinition Width="140"/></Grid.ColumnDefinitions>
        <StackPanel Orientation="Horizontal" VerticalAlignment="Center" HorizontalAlignment="Center"><TextBlock Text="🛡" FontSize="21" Foreground="#2ed573" Margin="0,0,10,0"/><TextBlock Text="SYSTEM OPTIMIZED" Foreground="#ffffff" FontSize="13" FontWeight="Bold"/></StackPanel>
        <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center" HorizontalAlignment="Center"><TextBlock Text="⚡" FontSize="22" Foreground="#ffaa2b" Margin="0,0,10,0"/><TextBlock Text="POWER MODE: " Foreground="#ffffff" FontSize="13" FontWeight="Bold"/><TextBlock Text="ULTIMATE PERFORMANCE" Foreground="#b54cff" FontSize="13" FontWeight="Bold"/></StackPanel>
        <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center" HorizontalAlignment="Center"><TextBlock Text="◷" FontSize="22" Foreground="#ffffff" Margin="0,0,10,0"/><TextBlock Text="LAST UPDATED: " Foreground="#ffffff" FontSize="13" FontWeight="Bold"/><TextBlock x:Name="LastUpdatedText" Text="--" Foreground="#00ffe7" FontSize="13" FontWeight="Bold"/></StackPanel>
        <Border Grid.Column="3" CornerRadius="10" BorderBrush="#00a7c8" BorderThickness="1" Padding="16,7" HorizontalAlignment="Center" VerticalAlignment="Center"><TextBlock Text="v45.0.0" Foreground="#00ffe7" FontSize="13" FontWeight="Black"/></Border>
      </Grid>
    </Border>

    <StackPanel Visibility="Collapsed"><Button x:Name="ThemeCyan" Tag="#00ffe7"/><Button x:Name="ThemePink" Tag="#ff3cac"/><Button x:Name="ThemeGold" Tag="#f9c74f"/><Button x:Name="ThemePurple" Tag="#784dff"/><Button x:Name="ThemeRed" Tag="#ff4757"/><Button x:Name="ThemeGreen" Tag="#2ed573"/><Button x:Name="ThemeBlue" Tag="#21d4fd"/></StackPanel>
  </Grid>
</Window>
"@


$reader = [System.Xml.XmlNodeReader]::new($xaml)
$Window = [Windows.Markup.XamlReader]::Load($reader)
$find = { param($n) $Window.FindName($n) }

$SidebarList        = & $find 'SidebarList'
$CardPanel          = & $find 'CardPanel'
$SectionTitle       = & $find 'SectionTitle'
$SectionDesc        = & $find 'SectionDesc'
$SelectedCountText  = & $find 'SelectedCountText'
$LogoText           = & $find 'LogoText'
$HeaderBorder       = & $find 'HeaderBorder'
$SidebarBorder      = & $find 'SidebarBorder'
$FooterBorder       = & $find 'FooterBorder'
$LogBox             = & $find 'LogBox'
$WindowsValueText   = & $find 'WindowsValueText'
$CpuValueText       = & $find 'CpuValueText'
$RamValueText       = & $find 'RamValueText'
$AdminValueText     = & $find 'AdminValueText'
$LastUpdatedText    = & $find 'LastUpdatedText'
$HomeDashboardBorder = & $find 'HomeDashboardBorder'
$HomeRowDef          = & $find 'HomeRowDef'

function Set-UltraActionButton {
    param([Windows.Controls.Button]$Button,[string]$Icon,[string]$Label,[string]$Color='#00ffe7',[bool]$Wide=$false)
    if ($null -eq $Button) { return }
    $Button.Background = Get-ArgbBrush '#07131c' 0.96
    $Button.BorderBrush = Get-ArgbBrush '#28424f' 0.95
    $Button.Foreground = [Windows.Media.Brushes]::White
    # Width/Height handled by UniformGrid — don't override
    $stack = [Windows.Controls.StackPanel]::new()
    $stack.Orientation = 'Vertical'
    $stack.HorizontalAlignment = 'Center'; $stack.VerticalAlignment = 'Center'
    $iconBlock = [Windows.Controls.TextBlock]::new()
    $iconBlock.Text = $Icon
    $iconBlock.FontFamily = [Windows.Media.FontFamily]::new('Segoe MDL2 Assets')
    $iconBlock.FontSize = 18
    $iconBlock.Foreground = Get-ColorBrush $Color
    $iconBlock.HorizontalAlignment = 'Center'; $iconBlock.VerticalAlignment = 'Center'
    $iconBlock.Margin = '0,0,0,4'
    $textBlock = [Windows.Controls.TextBlock]::new()
    $textBlock.Text = $Label
    $textBlock.FontSize = 9
    $textBlock.FontWeight = 'Black'
    $textBlock.Foreground = if ($Label -eq 'APPLY SELECTED') { Get-ColorBrush '#00ffe7' } else { [Windows.Media.Brushes]::White }
    $textBlock.HorizontalAlignment = 'Center'; $textBlock.TextAlignment = 'Center'; $textBlock.TextWrapping = 'Wrap'
    $stack.Children.Add($iconBlock) | Out-Null; $stack.Children.Add($textBlock) | Out-Null
    $Button.Content = $stack
}
function Apply-UltraActionButtons {
    Set-UltraActionButton (& $find 'SafePresetBtn')    ([string][char]0xE72E) 'SAFE PRESET' '#2ed573'
    Set-UltraActionButton (& $find 'CompPresetBtn')    ([string][char]0xE7B7) 'COMPETITIVE' '#0078ff'
    Set-UltraActionButton (& $find 'ExtremePresetBtn') ([string][char]0xE7BA) 'EXTREME MODE' '#ff2d2d'
    Set-UltraActionButton (& $find 'SelectAllBtn')     ([string][char]0xE8B3) 'SELECT ALL' '#b54cff'
    Set-UltraActionButton (& $find 'ResetAllBtn')      ([string][char]0xE777) 'RESET ALL' '#ffaa2b'
    Set-UltraActionButton (& $find 'ExportBatBtn')     ([string][char]0xE8A5) 'EXPORT BAT' '#0078ff'
    Set-UltraActionButton (& $find 'RestorePointBtn')  ([string][char]0xE72E) 'RESTORE POINT' '#2ed573'
    Set-UltraActionButton (& $find 'RetryFailedBtn')   ([string][char]0xE72C) 'RETRY FAILED' '#0078ff'
    Set-UltraActionButton (& $find 'ClearLogBtn')      ([string][char]0xE74D) 'CLEAR LOG' '#ff3cac'
    Set-UltraActionButton (& $find 'OptimizeBtn')      ([string][char]0xE945) 'OPTIMIZE MY PC' '#ffaa2b'
    Set-UltraActionButton (& $find 'LowTimerBtn')      ([string][char]0xE916) 'LOW TIMER' '#00ffe7' $true
    Set-UltraActionButton (& $find 'SmartNetBtn')      ([string][char]0xE774) 'SMART NETWORK' '#0078ff' $true
    Set-UltraActionButton (& $find 'FullBackupBtn')    ([string][char]0xE8E5) 'FULL BACKUP' '#ffaa2b' $true
    Set-UltraActionButton (& $find 'RestoreBackupBtn') ([string][char]0xE777) 'RESTORE BACKUP' '#2ed573' $true
    Set-UltraActionButton (& $find 'RamCleanBtn')      ([string][char]0xE950) 'RAM CLEAN' '#b54cff' $true
    Set-UltraActionButton (& $find 'ApplyBtn')         ([string][char]0xE768) 'APPLY SELECTED' '#00ffe7' $true
}

$script:CheckboxMap  = @{}
$script:SectionOrder = @(
    [pscustomobject]@{ Key='home';     Title='Home';             Icon=[char]0xE80F; IconColor='#00ffe7'; Desc='Dashboard: presets, backups, timer, smart network, logs, selected count, and optimizer status.' },
    [pscustomobject]@{ Key='fortnite'; Title='Fortnite FPS';     Icon=[char]0xE7FC; IconColor='#00a2ff'; Desc='Rebuilt Pro Core: FSE-safe GameDVR off, MMCSS scheduler, Win32PrioritySeparation 26, DirectX swap effect, and clean TDR ownership.' },
    [pscustomobject]@{ Key='services'; Title='Windows Services'; Icon=[char]0xE713; IconColor='#b98cff'; Desc='Disable unnecessary background services — telemetry, update, Xbox, Defender, and more.' },
    [pscustomobject]@{ Key='registry'; Title='Registry Tweaks';  Icon=[char]0xE90F; IconColor='#ffaa2b'; Desc='Registry changes for responsiveness, Explorer behavior, animations, and background activity.' },
    [pscustomobject]@{ Key='gpu';      Title='GPU / NVIDIA';     Icon=[char]0xE7F4; IconColor='#784dff'; Desc='GPU, NVIDIA, DirectX, USB priority, and PCIe latency settings.' },
    [pscustomobject]@{ Key='network';  Title='Network';          Icon=[char]0xE774; IconColor='#00a2ff'; Desc='TCP/IP, AFD buffers, DNS priority, NDU, QoS, and per-adapter ping tweaks.' },
    [pscustomobject]@{ Key='input';    Title='Input / Mouse';    Icon=[char]0xE962; IconColor='#ffffff'; Desc='Mouse acceleration, buffer, raw input, and keyboard/mouse priority settings.' },
    [pscustomobject]@{ Key='privacy';  Title='Privacy';          Icon=[char]0xE72E; IconColor='#00ffe7'; Desc='Telemetry, CEIP, widgets, activity history, and privacy-focused settings.' },
    [pscustomobject]@{ Key='debloat';  Title='Process Debloat';  Icon=[char]0xE74D; IconColor='#ff3cac'; Desc='Background process cleanup and startup entry removal.' },
    [pscustomobject]@{ Key='power';    Title='Power Plan';       Icon=[char]0xE945; IconColor='#ffaa2b'; Desc='Ultimate Performance, CPU states, PCIe link, sleep, and USB power settings.' },
    [pscustomobject]@{ Key='extreme';  Title='Extreme Mode';     Icon=[char]0xE7BA; IconColor='#ff4757'; Desc='Lab-only strip: OneClick full service disabling, process cleanup, power strip, input lock, and content cleanup. Expect broken Windows features.' },
    [pscustomobject]@{ Key='ui';       Title='UI Settings';      Icon=[char]0xE713; IconColor='#2ed573'; Desc='Customize the appearance of LakTweaks. Changes apply live.' }
)
function Update-SelectedCount {
    $count = 0
    foreach($entry in $script:CheckboxMap.Values) {
        if ($entry.CheckBox.IsEnabled -and $entry.CheckBox.IsChecked) { $count++ }
    }
    $SelectedCountText.Text = [string]$count
}

function Apply-Theme {
    $accent     = Get-ColorBrush $script:CurrentAccent
    $glowAlpha  = [Math]::Min(0.80, 0.12 + ($script:CurrentGlow * 0.60))
    $dimAlpha   = [Math]::Min(0.18, 0.04 + ($script:CurrentGlow * 0.12))
    $accentBorder = Get-ArgbBrush $script:CurrentAccent $glowAlpha
    $panelBg    = [Math]::Min(1.0, [Math]::Max(0.45, $script:CurrentBgOpacity))

    $Window.Background          = Get-ArgbBrush '#050a0f' 1.0
    $HeaderBorder.Background    = Get-ArgbBrush '#080f16' $panelBg
    $SidebarBorder.Background   = Get-ArgbBrush '#060d14' $panelBg
    $FooterBorder.Background    = Get-ArgbBrush '#080f16' $panelBg
    $HeaderBorder.BorderBrush   = $accentBorder
    $SidebarBorder.BorderBrush  = $accentBorder
    $FooterBorder.BorderBrush   = $accentBorder
    $LogoText.Foreground        = $accent
    $SectionTitle.Foreground    = $accent
    $SelectedCountText.Foreground = $accent

    $themeButtons = 'ThemeCyan','ThemePink','ThemeGold','ThemePurple','ThemeRed','ThemeGreen','ThemeBlue'
    foreach($btn in $themeButtons) {
        $b = & $find $btn
        if ($null -eq $b) { continue }
        $b.Background   = Get-ColorBrush $b.Tag
        $b.BorderBrush  = if ($b.Tag -eq $script:CurrentAccent) { [Windows.Media.Brushes]::White } else { Get-ArgbBrush '#ffffff' 0.10 }
        $b.BorderThickness = '2'
    }

    foreach($item in $SidebarList.Items) {
        $item.Background  = Get-ArgbBrush $script:CurrentAccent (0.03 + ($script:CurrentGrid * 0.08))
        $item.BorderBrush = Get-ArgbBrush $script:CurrentAccent (0.08 + ($script:CurrentGlow * 0.18))
    }
}

function Set-TweakVisualState([string]$id) {
    if (-not $script:CheckboxMap.ContainsKey($id)) { return }
    $entry = $script:CheckboxMap[$id]
    if (Test-TweakApplied $id) {
        $entry.CheckBox.IsChecked  = $false
        $entry.CheckBox.IsEnabled  = $false
        $entry.CheckBox.Content    = 'Already Applied'
        $entry.CheckBox.Foreground = Get-ColorBrush '#2ed573'
        $entry.Status.Text         = 'ENABLED'
        $entry.Status.Foreground   = Get-ColorBrush '#2ed573'
        $entry.Card.BorderBrush    = Get-ArgbBrush '#2ed573' 0.50
        $entry.Card.Background     = Get-ArgbBrush '#2ed573' 0.07
    } else {
        $entry.CheckBox.IsEnabled  = $true
        $entry.CheckBox.Content    = 'Enable'
        $entry.CheckBox.Foreground = Get-ColorBrush $script:CurrentAccent
        $entry.Status.Text         = 'NOT APPLIED'
        $entry.Status.Foreground   = Get-ColorBrush '#5a8a85'
        $entry.Card.BorderBrush    = Get-ArgbBrush $script:CurrentAccent (0.14 + ($script:CurrentGlow * 0.22))
        $entry.Card.Background     = if ($script:CurrentClean) { Get-ArgbBrush '#0e171d' 0.92 } else { Get-ArgbBrush $script:CurrentAccent (0.03 + ($script:CurrentBgOpacity * 0.07)) }
    }
}

function New-Card([object]$item) {
    $cardW = if ($script:CurrentCompact) { 340 } else { 368 }

    $outer = [Windows.Controls.Border]::new()
    $outer.Width            = $cardW
    $outer.MinHeight        = if ($script:CurrentCompact) { 208 } else { 236 }
    $outer.Margin           = '0,0,20,20'
    $outer.Padding          = if ($script:CurrentCompact) { '16,14' } else { '20,18' }
    $outer.CornerRadius     = '14'
    $outer.Background       = if ($script:CurrentClean) { Get-ArgbBrush '#0e171d' 0.94 } else { Get-ArgbBrush $script:CurrentAccent (0.035 + ($script:CurrentBgOpacity * 0.075)) }
    $outer.BorderBrush      = Get-ArgbBrush $script:CurrentAccent (0.16 + ($script:CurrentGlow * 0.22))
    $outer.BorderThickness  = '1'
    $outer.SnapsToDevicePixels = $true

    $grid = [Windows.Controls.Grid]::new()
    [void]$grid.RowDefinitions.Add([Windows.Controls.RowDefinition]::new())
    [void]$grid.RowDefinitions.Add([Windows.Controls.RowDefinition]::new())
    [void]$grid.RowDefinitions.Add([Windows.Controls.RowDefinition]::new())
    [void]$grid.RowDefinitions.Add([Windows.Controls.RowDefinition]::new())
    $grid.RowDefinitions[0].Height = [Windows.GridLength]::Auto
    $grid.RowDefinitions[1].Height = [Windows.GridLength]::Auto
    $grid.RowDefinitions[2].Height = [Windows.GridLength]::new(1, [Windows.GridUnitType]::Star)
    $grid.RowDefinitions[3].Height = [Windows.GridLength]::Auto

    # Title
    $title = [Windows.Controls.TextBlock]::new()
    $title.Text           = $item.Title
    $title.FontSize       = if ($script:CurrentCompact) { 14 } else { 15 }
    $title.FontWeight     = 'Bold'
    $title.Foreground     = [Windows.Media.Brushes]::White
    $title.TextWrapping   = 'Wrap'
    $title.MaxWidth       = $cardW - 44
    $title.Margin         = '0,0,0,6'
    [Windows.Controls.Grid]::SetRow($title, 0)
    $grid.Children.Add($title) | Out-Null

    # Category badge
    $cat = [Windows.Controls.Border]::new()
    $cat.Margin           = '0,0,0,12'
    $cat.Padding          = '7,2'
    $cat.CornerRadius     = '4'
    $cat.Background       = Get-ArgbBrush $script:CurrentAccent 0.12
    $cat.HorizontalAlignment = 'Left'
    $catText = [Windows.Controls.TextBlock]::new()
    $catText.Text         = $item.Category
    $catText.FontSize     = 9
    $catText.FontWeight   = 'SemiBold'
    $catText.Foreground   = Get-ArgbBrush $script:CurrentAccent 1.0
    $cat.Child            = $catText
    [Windows.Controls.Grid]::SetRow($cat, 1)
    $grid.Children.Add($cat) | Out-Null

    # Description
    $desc = [Windows.Controls.TextBlock]::new()
    $desc.Text            = $item.Description
    $desc.TextWrapping    = 'Wrap'
    $desc.Foreground      = Get-ColorBrush '#6e9e9a'
    $desc.FontSize        = if ($script:CurrentCompact) { 11 } else { 12 }
    $desc.LineHeight      = if ($script:CurrentCompact) { 16 } else { 18 }
    $desc.MaxHeight       = if ($script:CurrentCompact) { 52 } else { 72 }
    $desc.TextTrimming    = 'CharacterEllipsis'
    $desc.Margin          = '0,0,0,18'
    [Windows.Controls.Grid]::SetRow($desc, 2)
    $grid.Children.Add($desc) | Out-Null

    # Bottom row
    $bottom = [Windows.Controls.Grid]::new()
    [void]$bottom.ColumnDefinitions.Add([Windows.Controls.ColumnDefinition]::new())
    [void]$bottom.ColumnDefinitions.Add([Windows.Controls.ColumnDefinition]::new())
    $bottom.ColumnDefinitions[0].Width = [Windows.GridLength]::new(1, [Windows.GridUnitType]::Star)
    $bottom.ColumnDefinitions[1].Width = [Windows.GridLength]::Auto
    $bottom.VerticalAlignment = 'Bottom'

    $cb = [Windows.Controls.CheckBox]::new()
    $cb.Content            = 'Enable'
    $cb.FontWeight         = 'SemiBold'
    $cb.Tag                = $item.Id
    $cb.VerticalAlignment  = 'Center'
    $cb.Margin             = '0,0,12,2'
    $cb.Add_Checked({ Update-SelectedCount })
    $cb.Add_Unchecked({ Update-SelectedCount })
    [Windows.Controls.Grid]::SetColumn($cb, 0)
    $bottom.Children.Add($cb) | Out-Null

    $status = [Windows.Controls.TextBlock]::new()
    $status.FontSize          = 10
    $status.FontWeight        = 'Bold'
    $status.HorizontalAlignment = 'Right'
    $status.VerticalAlignment = 'Center'
    $status.TextAlignment     = 'Right'
    $status.TextWrapping      = 'NoWrap'
    $status.Width             = 112
    $status.Margin            = '0,0,10,2'
    [Windows.Controls.Grid]::SetColumn($status, 1)
    $bottom.Children.Add($status) | Out-Null

    [Windows.Controls.Grid]::SetRow($bottom, 3)
    $grid.Children.Add($bottom) | Out-Null

    $outer.Child = $grid
    $script:CheckboxMap[$item.Id] = [pscustomobject]@{ CheckBox=$cb; Status=$status; Card=$outer }
    Set-TweakVisualState $item.Id
    return $outer
}


function New-UiWideSliderRow {
    param([string]$Label, [double]$Minimum, [double]$Maximum, [double]$Value, [string]$SettingKey)
    $border = [Windows.Controls.Border]::new()
    $border.Margin        = '0,0,0,14'
    $border.Padding       = '18,13'
    $border.CornerRadius  = '10'
    $border.Background    = Get-ArgbBrush '#07121a' ([Math]::Max(0.82, $script:CurrentBgOpacity))
    $border.BorderBrush   = Get-ArgbBrush $script:CurrentAccent (0.16 + ($script:CurrentGlow * 0.20))
    $border.BorderThickness = '1'

    $dock = [Windows.Controls.DockPanel]::new()
    $dock.LastChildFill = $true

    $valueText = [Windows.Controls.TextBlock]::new()
    $valueText.Text        = ([string]([int][Math]::Round($Value)) + '%')
    $valueText.Foreground  = Get-ColorBrush $script:CurrentAccent
    $valueText.FontWeight  = 'Bold'
    $valueText.FontSize    = 14
    $valueText.Width       = 56
    $valueText.TextAlignment = 'Right'
    [Windows.Controls.DockPanel]::SetDock($valueText, 'Right')
    $dock.Children.Add($valueText) | Out-Null

    $labelText = [Windows.Controls.TextBlock]::new()
    $labelText.Text       = $Label
    $labelText.Foreground = Get-ColorBrush '#7ca7a2'
    $labelText.Width      = 200
    $labelText.FontSize   = 13
    [Windows.Controls.DockPanel]::SetDock($labelText, 'Left')
    $dock.Children.Add($labelText) | Out-Null

    $slider = [Windows.Controls.Slider]::new()
    $slider.Minimum             = $Minimum
    $slider.Maximum             = $Maximum
    $slider.Value               = $Value
    $slider.IsMoveToPointEnabled = $true
    $slider.IsSnapToTickEnabled = $false
    $slider.Height              = 26
    $slider.Margin              = '14,0,14,0'
    $slider.Tag = [pscustomobject]@{ ValueText = $valueText; SettingKey = $SettingKey }
    $slider.Add_ValueChanged({
        param($sender, $args)
        if ($null -eq $sender -or $null -eq $sender.Tag) { return }
        $meta    = $sender.Tag
        $rounded = [int][Math]::Round($sender.Value)
        if ($meta.ValueText -is [Windows.Controls.TextBlock]) { $meta.ValueText.Text = ([string]$rounded + '%') }
        switch ([string]$meta.SettingKey) {
            'BgOpacity' { $script:CurrentBgOpacity = [math]::Round($sender.Value / 100, 2) }
            'Glow'      { $script:CurrentGlow      = [math]::Round($sender.Value / 100, 2) }
            'Grid'      { $script:CurrentGrid      = [math]::Round($sender.Value / 100, 2) }
            'Scanlines' { $script:CurrentScanlines = [math]::Round($sender.Value / 100, 2) }
        }
        Save-UiSettings
        Apply-Theme
    })
    $dock.Children.Add($slider) | Out-Null
    $border.Child = $dock
    return $border
}

function Show-UiSettings {
    $CardPanel.Children.Clear()
    $CardPanel.ItemWidth = [double]::NaN

    $container = [Windows.Controls.StackPanel]::new()
    $container.Orientation = 'Vertical'
    $container.MaxWidth    = 860
    $container.Margin      = '0,0,20,10'

    # ── THEME HINT ──
    $notice = [Windows.Controls.Border]::new()
    $notice.Margin        = '0,0,0,22'
    $notice.Padding       = '16,12'
    $notice.CornerRadius  = '10'
    $notice.Background    = Get-ArgbBrush $script:CurrentAccent 0.06
    $notice.BorderBrush   = Get-ArgbBrush $script:CurrentAccent 0.40
    $notice.BorderThickness = '1'
    $noticeText = [Windows.Controls.TextBlock]::new()
    $noticeText.Text       = '🎨  Quick theme buttons are in the header bar. Use the controls below to fine-tune every detail.'
    $noticeText.Foreground = Get-ColorBrush '#7ca7a2'
    $noticeText.TextWrapping = 'Wrap'
    $noticeText.FontSize   = 12
    $notice.Child          = $noticeText
    $container.Children.Add($notice) | Out-Null

    # ── APPEARANCE HEADER ──
    $h1 = [Windows.Controls.TextBlock]::new()
    $h1.Text       = 'APPEARANCE'
    $h1.FontSize   = 13
    $h1.FontWeight = 'Bold'
    $h1.Foreground = Get-ColorBrush $script:CurrentAccent
    $h1.Margin     = '0,0,0,14'
    $container.Children.Add($h1) | Out-Null

    # Sliders
    $container.Children.Add((New-UiWideSliderRow -Label 'Background Opacity' -Minimum 45 -Maximum 100 -Value ($script:CurrentBgOpacity*100) -SettingKey 'BgOpacity')) | Out-Null
    $container.Children.Add((New-UiWideSliderRow -Label 'Grid Brightness'    -Minimum 0  -Maximum 100 -Value ($script:CurrentGrid*100)      -SettingKey 'Grid')) | Out-Null
    $container.Children.Add((New-UiWideSliderRow -Label 'Neon Glow Intensity'-Minimum 0  -Maximum 100 -Value ($script:CurrentGlow*100)      -SettingKey 'Glow')) | Out-Null
    $container.Children.Add((New-UiWideSliderRow -Label 'Scanlines'          -Minimum 0  -Maximum 100 -Value ($script:CurrentScanlines*100)  -SettingKey 'Scanlines')) | Out-Null

    # ── ACCENT COLOR ROW ──
    $accentBorder = [Windows.Controls.Border]::new()
    $accentBorder.Margin       = '0,0,0,22'
    $accentBorder.Padding      = '18,13'
    $accentBorder.CornerRadius = '10'
    $accentBorder.Background   = Get-ArgbBrush '#07121a' ([Math]::Max(0.82, $script:CurrentBgOpacity))
    $accentBorder.BorderBrush  = Get-ArgbBrush $script:CurrentAccent (0.16 + ($script:CurrentGlow * 0.20))
    $accentBorder.BorderThickness = '1'

    $accentDock = [Windows.Controls.DockPanel]::new()
    $accentDock.LastChildFill = $true

    $accentLabel = [Windows.Controls.TextBlock]::new()
    $accentLabel.Text     = 'Accent Color'
    $accentLabel.Foreground = Get-ColorBrush '#7ca7a2'
    $accentLabel.Width    = 200
    $accentLabel.FontSize = 13
    $accentLabel.VerticalAlignment = 'Center'
    [Windows.Controls.DockPanel]::SetDock($accentLabel, 'Left')
    $accentDock.Children.Add($accentLabel) | Out-Null

    $accentPreview = [Windows.Controls.Button]::new()
    $accentPreview.Width          = 38
    $accentPreview.Height         = 28
    $accentPreview.Content        = ''
    $accentPreview.Background     = Get-ColorBrush $script:CurrentAccent
    $accentPreview.BorderBrush    = [Windows.Media.Brushes]::White
    $accentPreview.BorderThickness = '1'
    $accentPreview.Margin         = '14,0,10,0'
    $accentPreview.ToolTip        = 'Click to open color picker'
    [Windows.Controls.DockPanel]::SetDock($accentPreview, 'Left')
    $accentPreview.Add_Click({
        $picked = Show-AccentHexDialog $script:CurrentAccent
        if ($picked) {
            $script:CurrentAccent = $picked
            Save-UiSettings; Apply-Theme; Show-UiSettings
        }
    })
    $accentDock.Children.Add($accentPreview) | Out-Null

    $accentBox = [Windows.Controls.TextBox]::new()
    $accentBox.Text         = $script:CurrentAccent
    $accentBox.Background   = '#101820'
    $accentBox.Foreground   = 'White'
    $accentBox.BorderBrush  = Get-ArgbBrush $script:CurrentAccent 0.55
    $accentBox.Margin       = '0,0,10,0'
    $accentBox.Padding      = '8,6'
    $accentBox.FontSize     = 13
    $accentBox.Width        = 140
    $accentBox.VerticalContentAlignment = 'Center'
    $accentBox.ToolTip      = 'Enter any hex: #RGB or #RRGGBB'
    [Windows.Controls.DockPanel]::SetDock($accentBox, 'Left')
    $accentDock.Children.Add($accentBox) | Out-Null

    $accentApply = [Windows.Controls.Button]::new()
    $accentApply.Content    = 'Apply'
    $accentApply.Padding    = '14,7'
    $accentApply.FontWeight = 'SemiBold'
    $accentApply.VerticalAlignment = 'Center'
    [Windows.Controls.DockPanel]::SetDock($accentApply, 'Right')
    $accentApply.Add_Click({
        try {
            $script:CurrentAccent = Normalize-HexColor $accentBox.Text
            Save-UiSettings; Apply-Theme; Show-UiSettings
        } catch {
            [System.Windows.MessageBox]::Show('Use a valid hex color like #F00 or #FF0000') | Out-Null
        }
    })
    $accentDock.Children.Add($accentApply) | Out-Null
    $accentBorder.Child = $accentDock
    $container.Children.Add($accentBorder) | Out-Null

    # ── MODE TOGGLES ──
    $modeBorder = [Windows.Controls.Border]::new()
    $modeBorder.Margin       = '0,0,0,22'
    $modeBorder.Padding      = '18,14'
    $modeBorder.CornerRadius = '10'
    $modeBorder.Background   = Get-ArgbBrush '#07121a' ([Math]::Max(0.82, $script:CurrentBgOpacity))
    $modeBorder.BorderBrush  = Get-ArgbBrush $script:CurrentAccent (0.16 + ($script:CurrentGlow * 0.20))
    $modeBorder.BorderThickness = '1'
    $modeStack = [Windows.Controls.StackPanel]::new()

    $compactCb = [Windows.Controls.CheckBox]::new()
    $compactCb.Content   = 'Compact Mode  —  smaller cards'
    $compactCb.IsChecked = $script:CurrentCompact
    $compactCb.Foreground = [Windows.Media.Brushes]::White
    $compactCb.FontSize  = 13
    $compactCb.Margin    = '0,0,0,10'
    $compactCb.Add_Click({ $script:CurrentCompact = [bool]$this.IsChecked; Save-UiSettings })
    $modeStack.Children.Add($compactCb) | Out-Null

    $cleanCb = [Windows.Controls.CheckBox]::new()
    $cleanCb.Content   = 'Clean Mode  —  solid dark backgrounds instead of tinted'
    $cleanCb.IsChecked = $script:CurrentClean
    $cleanCb.Foreground = [Windows.Media.Brushes]::White
    $cleanCb.FontSize  = 13
    $cleanCb.Add_Click({ $script:CurrentClean = [bool]$this.IsChecked; Save-UiSettings })
    $modeStack.Children.Add($cleanCb) | Out-Null
    $modeBorder.Child = $modeStack
    $container.Children.Add($modeBorder) | Out-Null

    # ── RESET / RANDOMIZE ──
    $actionRow = [Windows.Controls.WrapPanel]::new()
    $actionRow.Margin = '0,0,0,22'

    $resetBtn = [Windows.Controls.Button]::new()
    $resetBtn.Content = 'Reset to Defaults'
    $resetBtn.Padding = '14,9'; $resetBtn.Margin = '0,0,12,0'
    $resetBtn.Add_Click({
        $script:CurrentAccent = '#00ffe7'
        $script:CurrentBgOpacity = 0.92; $script:CurrentGlow = 0.65
        $script:CurrentCompact = $false; $script:CurrentClean = $false
        $script:CurrentScanlines = 0.30; $script:CurrentGrid = 0.30
        Save-UiSettings; Apply-Theme; Show-UiSettings
    })
    $actionRow.Children.Add($resetBtn) | Out-Null

    $randomBtn = [Windows.Controls.Button]::new()
    $randomBtn.Content = 'Randomize'
    $randomBtn.Padding = '14,9'
    $randomBtn.Add_Click({
        $colors = '#00ffe7','#ff3cac','#f9c74f','#784dff','#ff4757','#2ed573','#21d4fd','#ff9f43'
        $script:CurrentAccent    = Get-Random $colors
        $script:CurrentBgOpacity = [math]::Round((Get-Random -Minimum 55 -Maximum 97) / 100, 2)
        $script:CurrentGlow      = [math]::Round((Get-Random -Minimum 25 -Maximum 100) / 100, 2)
        $script:CurrentGrid      = [math]::Round((Get-Random -Minimum 10 -Maximum 70) / 100, 2)
        $script:CurrentScanlines = [math]::Round((Get-Random -Minimum 0 -Maximum 55) / 100, 2)
        Save-UiSettings; Apply-Theme; Show-UiSettings
    })
    $actionRow.Children.Add($randomBtn) | Out-Null
    $container.Children.Add($actionRow) | Out-Null

    # ── ABOUT ──
    $h2 = [Windows.Controls.TextBlock]::new()
    $h2.Text = 'ABOUT'; $h2.FontSize = 13; $h2.FontWeight = 'Bold'
    $h2.Foreground = Get-ColorBrush $script:CurrentAccent; $h2.Margin = '0,0,0,12'
    $container.Children.Add($h2) | Out-Null

    $aboutBorder = [Windows.Controls.Border]::new()
    $aboutBorder.Padding = '18,14'; $aboutBorder.CornerRadius = '10'
    $aboutBorder.Background  = Get-ArgbBrush '#07121a' ([Math]::Max(0.82, $script:CurrentBgOpacity))
    $aboutBorder.BorderBrush = Get-ArgbBrush $script:CurrentAccent 0.40
    $aboutBorder.BorderThickness = '1'
    $aboutStack = [Windows.Controls.StackPanel]::new()

    $aTitle = [Windows.Controls.TextBlock]::new()
    $aTitle.Text = 'LAK TWEAKS GOD  —  Version 47'
    $aTitle.Foreground = Get-ColorBrush $script:CurrentAccent; $aTitle.FontWeight = 'Bold'; $aTitle.Margin = '0,0,0,8'
    $aboutStack.Children.Add($aTitle) | Out-Null

    $aBody = [Windows.Controls.TextBlock]::new()
    $aBody.Text = 'Built by: Lak'
    $aBody.TextWrapping = 'Wrap'; $aBody.Foreground = Get-ColorBrush '#5a8a85'; $aBody.FontSize = 11; $aBody.Margin = '0,0,0,10'
    $aboutStack.Children.Add($aBody) | Out-Null

    $aWarn = [Windows.Controls.TextBlock]::new()
    $aWarn.Text = '⚠  Always run as Administrator. Reboot after applying tweaks for full effect. Applied tweaks are tracked and shown as ENABLED.'
    $aWarn.TextWrapping = 'Wrap'; $aWarn.Foreground = Get-ColorBrush '#5a8a85'; $aWarn.FontSize = 11
    $aboutStack.Children.Add($aWarn) | Out-Null
    $aboutBorder.Child = $aboutStack
    $container.Children.Add($aboutBorder) | Out-Null

    $CardPanel.Children.Add($container) | Out-Null
}

function Set-HomeDashboardVisible([bool]$visible) {
    if ($visible) {
        $HomeDashboardBorder.Visibility = 'Visible'
        $HomeRowDef.Height = [Windows.GridLength]::new(210)
    } else {
        $HomeDashboardBorder.Visibility = 'Collapsed'
        $HomeRowDef.Height = [Windows.GridLength]::new(0)
    }
}

function Show-Section([string]$key) {
    $CardPanel.Children.Clear()
    if ($key -eq 'home') {
        Set-HomeDashboardVisible $true
        $SectionTitle.Text = ''
        $SectionDesc.Text  = ''
        $CardPanel.ItemWidth = [double]::NaN
        $script:CheckboxMap = @{}
        Update-SelectedCount
        return
    }
    Set-HomeDashboardVisible $false
    if ($key -eq 'ui') {
        $SectionTitle.Text = 'UI SETTINGS'
        $SectionDesc.Text  = 'Customize the appearance of LakTweaks. Changes apply live.'
        $CardPanel.ItemWidth = [double]::NaN
        Show-UiSettings
        Update-SelectedCount
        return
    }
    $CardPanel.ItemWidth = if ($script:CurrentCompact) { 340 } else { 368 }
    $section = $script:SectionOrder | Where-Object Key -eq $key
    $SectionTitle.Text = $section.Title
    $SectionDesc.Text  = $section.Desc
    $script:CheckboxMap = @{}
    $items = $script:Catalog | Where-Object CategoryId -eq $key
    foreach ($item in $items) { $CardPanel.Children.Add((New-Card $item)) | Out-Null }
    Update-SelectedCount
}

# Build sidebar with premium icon rows
foreach ($sec in $script:SectionOrder) {
    $item = [Windows.Controls.ListBoxItem]::new()
    $item.Tag             = $sec.Key
    $item.Padding         = '8,5'
    $item.Margin          = '0,0,0,3'
    $item.Background      = Get-ArgbBrush $script:CurrentAccent 0.04
    $item.BorderBrush     = Get-ArgbBrush $script:CurrentAccent 0.10
    $item.BorderThickness = '1'
    $item.Foreground      = 'White'
    $item.FontSize        = 11
    $item.MinHeight       = 38
    $item.HorizontalContentAlignment = 'Stretch'
    $row = [Windows.Controls.StackPanel]::new()
    $row.Orientation = 'Horizontal'; $row.HorizontalAlignment = 'Left'; $row.VerticalAlignment = 'Center'
    $ico = [Windows.Controls.TextBlock]::new()
    $ico.Text = [string]$sec.Icon
    $ico.FontFamily = [Windows.Media.FontFamily]::new('Segoe MDL2 Assets')
    $ico.FontSize = 15; $ico.Foreground = Get-ColorBrush $sec.IconColor; $ico.Width = 26; $ico.VerticalAlignment = 'Center'
    $lbl = [Windows.Controls.TextBlock]::new()
    $lbl.Text = $sec.Title; $lbl.FontSize = 11; $lbl.FontWeight = 'SemiBold'; $lbl.TextWrapping = 'NoWrap'; $lbl.TextTrimming = 'None'; $lbl.Foreground = [Windows.Media.Brushes]::White; $lbl.VerticalAlignment = 'Center'
    $row.Children.Add($ico) | Out-Null; $row.Children.Add($lbl) | Out-Null
    $item.Content = $row
    $SidebarList.Items.Add($item) | Out-Null
}

$SidebarList.Add_SelectionChanged({
    if ($SidebarList.SelectedItem) { Show-Section $SidebarList.SelectedItem.Tag }
})
$SidebarList.SelectedIndex = 0

# Theme buttons (7 now)
foreach ($btnName in 'ThemeCyan','ThemePink','ThemeGold','ThemePurple','ThemeRed','ThemeGreen','ThemeBlue') {
    $btn = & $find $btnName
    if ($null -eq $btn) { continue }
    $btn.Add_Click({
        param($sender, $args)
        $script:CurrentAccent = [string]$sender.Tag
        Save-UiSettings; Apply-Theme
        if ($SidebarList.SelectedItem -and $SidebarList.SelectedItem.Tag -eq 'ui') { Show-UiSettings }
        else { Show-Section $SidebarList.SelectedItem.Tag }
    })
}

(& $find 'SelectAllBtn').Add_Click({
    foreach ($entry in $script:CheckboxMap.Values) { if ($entry.CheckBox.IsEnabled) { $entry.CheckBox.IsChecked = $true } }
    Update-SelectedCount
})
(& $find 'ResetAllBtn').Add_Click({
    foreach ($entry in $script:CheckboxMap.Values) { if ($entry.CheckBox.IsEnabled) { $entry.CheckBox.IsChecked = $false } }
    Update-SelectedCount
})
(& $find 'ExportBatBtn').Add_Click({
    $selected = foreach ($item in $script:Catalog) {
        if ($script:CheckboxMap.ContainsKey($item.Id) -and $script:CheckboxMap[$item.Id].CheckBox.IsChecked) { $item }
    }
    if (-not $selected) { [System.Windows.MessageBox]::Show('Select at least one tweak first.') | Out-Null; return }
    $dlg = [Microsoft.Win32.SaveFileDialog]::new()
    $dlg.Filter   = 'Batch Files (*.bat)|*.bat'
    $dlg.FileName = 'LAK_TWEAKS_ELITE.bat'
    if ($dlg.ShowDialog()) {
        Export-Bat $selected $dlg.FileName
        [System.Windows.MessageBox]::Show('Saved: ' + $dlg.FileName) | Out-Null
    }
})

(& $find 'SafePresetBtn').Add_Click({ Select-Preset 'Safe' })
(& $find 'CompPresetBtn').Add_Click({ Select-Preset 'Competitive' })
(& $find 'ExtremePresetBtn').Add_Click({ Select-Preset 'Extreme' })
(& $find 'RestorePointBtn').Add_Click({ New-LakRestorePoint })
(& $find 'ClearLogBtn').Add_Click({
    if ($null -ne $LogBox) { $LogBox.Text = 'LakTweaks v46 log cleared.' }
    try { $script:LogHistory.Clear() } catch {}
})
(& $find 'RetryFailedBtn').Add_Click({
    if (-not $script:LastFailedTweaks -or $script:LastFailedTweaks.Count -eq 0) {
        [System.Windows.MessageBox]::Show('No failed tweaks to retry.', 'LakTweaks', 'OK', 'Information') | Out-Null
        return
    }
    Clear-TweakSelections
    foreach($item in $script:LastFailedTweaks) { Select-TweakById $item.Id }
    Update-SelectedCount
    Write-Log ("Retry queued for " + $script:LastFailedTweaks.Count + " failed tweak(s). Click Apply Selected.") 'INFO'
})

(& $find 'OptimizeBtn').Add_Click({ Select-SmartOptimizePreset })
(& $find 'LowTimerBtn').Add_Click({ Enable-LakLowTimerMode })
(& $find 'SmartNetBtn').Add_Click({ Select-SmartNetworkPreset })
(& $find 'FullBackupBtn').Add_Click({ Backup-LakFullRegistry })
(& $find 'RestoreBackupBtn').Add_Click({ Restore-LakFullRegistry })
(& $find 'RamCleanBtn').Add_Click({ Clean-LakRamLite })

(& $find 'ApplyBtn').Add_Click({
    Ensure-Admin
    $selected = foreach ($item in $script:Catalog) {
        if ($script:CheckboxMap.ContainsKey($item.Id) -and $script:CheckboxMap[$item.Id].CheckBox.IsChecked) { $item }
    }
    if (-not $selected) { [System.Windows.MessageBox]::Show('Select at least one tweak first.') | Out-Null; return }

    $warnings = Test-TweakConflicts $selected
    $warningText = ''
    if ($warnings -and $warnings.Count -gt 0) {
        $warningText = "`n`nWarnings:`n- " + ($warnings -join "`n- ")
        foreach($w in $warnings) { Write-Log $w 'WARN' }
    }

    $r = [System.Windows.MessageBox]::Show(
        "Apply $($selected.Count) selected tweak(s)?$warningText`n`nA restore point is recommended before applying service, BCD, or Extreme Mode tweaks.",
        'LakTweaks v36 ULTIMATE','YesNo','Warning')
    if ($r -ne 'Yes') { return }

    try {
        Backup-LakQuickRegistry
        Write-Log ("Starting apply run with " + $selected.Count + " tweak(s).") 'INFO'
        $result = Invoke-TweakCommands $selected

        if ($result.Succeeded.Count -gt 0) {
            Mark-TweaksApplied $result.Succeeded
            foreach ($item in $result.Succeeded) {
                if ($script:CheckboxMap.ContainsKey($item.Id)) { Set-TweakVisualState $item.Id }
            }
        }

        if ($result.Failed.Count -gt 0) {
            foreach($fail in $result.Failed) {
                if ($script:CheckboxMap.ContainsKey($fail.Item.Id)) { Set-TweakFailedVisualState $fail.Item.Id }
            }
        }

        Update-SelectedCount
        Write-Log ("Apply complete. Success=" + $result.Succeeded.Count + " Failed=" + $result.Failed.Count) 'INFO'

        if ($result.Failed.Count -gt 0) {
            [System.Windows.MessageBox]::Show("Applied $($result.Succeeded.Count), failed $($result.Failed.Count). Check the log panel, then use RETRY FAILED if needed.", 'LakTweaks v36 ULTIMATE', 'OK', 'Warning') | Out-Null
        } else {
            [System.Windows.MessageBox]::Show("Applied $($result.Succeeded.Count) tweak(s) successfully.`nReboot your PC for full effect.", 'LakTweaks v36 ULTIMATE', 'OK', 'Information') | Out-Null
        }
    } catch {
        Write-Log ('Apply engine error: ' + $_.Exception.Message) 'FAIL'
        [System.Windows.MessageBox]::Show('Error: ' + $_.Exception.Message, 'LakTweaks', 'OK', 'Error') | Out-Null
    }
})


Apply-UltraActionButtons
Apply-Theme
Initialize-FastPerformanceCounters
Update-PerformancePanel
$hwStart = Get-LakHardwareSummary
Write-Log ('Hardware detected: ' + $hwStart.OS + ' | ' + $hwStart.CPU + ' | ' + $hwStart.GPU + ' | ' + $hwStart.RAM + ' | Network=' + $hwStart.Network) 'INFO'
Write-Log 'v47: uniform button grid, smaller LT logo (36px), compact sidebar rows (38px min-height), full section names visible.' 'OK'
$script:PerfTimer = [Windows.Threading.DispatcherTimer]::new()
$script:PerfTimer.Interval = [TimeSpan]::FromSeconds(2)
$script:PerfTimer.Add_Tick({ Update-PerformancePanel })
$script:PerfTimer.Start()
Show-Section 'home'
Update-SelectedCount
$Window.Add_Closed({ if ($script:LowTimerActive -and ('WinMM.NativeMethods' -as [type])) { try { [void][WinMM.NativeMethods]::timeEndPeriod(1) } catch {} } })
$Window.ShowDialog() | Out-Null
