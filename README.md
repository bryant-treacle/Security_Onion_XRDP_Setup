# Security_Onion_XRDP_Setup

This script will configure XRDP on Security Onion 16.04.X running in offline (air gapped) networks.  

The script is currently configured to use XRDP's high crypto setting (128it RC4).  If your organization requires FIPS compliance you can change the settings in the /etc/xrdp/xrdp.ini file.

Note:  If you are creating a new user using this script, the first time you attempt to connect using that account the connection will fail. To fix this you can log into the server with that account or attempt to RDP a second time.  


