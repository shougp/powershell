    $Datafolder = "C:\Audit\OS_" + $env:COMPUTERNAME
    New-Item -Path "C:\Audit"  -ItemType directory -Force
# E1
    NET USER ADMINISTRATOR | Out-File ($Datafolder + "_E1_USRADM.DAT")
# E2
    NET USER GUEST | Out-File ($Datafolder + "_E2_USRGST.DAT")
# E3
    NET USERS | Out-File ($Datafolder + "_E3_USERS.DAT")
# E4 - NET USER for each user
    $myusers = get-wmiobject -class "Win32_UserAccount" -namespace "root\CIMV2" -filter "LocalAccount = True"

    for($i=0; $i -lt $myusers.Count; $i++)
    {
         [System.Management.ManagementObject] $myuser = $myusers[$i]
         NET USER $myuser.name | Out-File ($Datafolder + "_E4_" + $myuser.name + ".DAT")
    }
# E5
    NET USERS /DOMAIN | Out-File ($Datafolder + "_E5_DOMAINUSERS.DAT")
# E6
    NET LOCALGROUP | Out-File ($Datafolder + "_E6_LOCALGRP.DAT")
# E7 missing - NET LOCALGROUP for each group        
    $Groups = get-wmiobject -class "Win32_Group" -namespace "root\CIMV2" -filter "LocalAccount = True"
    
    for($i=0; $i -lt $Groups.Count; $i++)
    {
         [System.Management.ManagementObject] $Mygroup = $Groups[$i]
         NET LOCALGROUP $Mygroup.name | Out-File ($Datafolder + "_E7_" + $Mygroup.name + ".DAT")
    }

# E8
    NET GROUP /DOMAIN | Out-File ($Datafolder + "_E8_DOMAINGRP.DAT")
# E9 - run on domain controller only
    ##NET GROUP | Out-File ($Datafolder + "_E9_GROUP.DAT")
# E10 missing - NET GROUP for all global domain groups

# E11
    NET SHARE | Out-File ($Datafolder + "_E11_SHAREINF.DAT")
# E12
    NET USE | Out-File ($Datafolder + "_E12_USEINF.DAT")