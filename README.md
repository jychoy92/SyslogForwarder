# SyslogForwarder
## Topology and Rational
Syslog Forwarder Proxy Server is meant for collecting logs from those network and system appliances that cannot install filebeat on their own, and the logs collected will then forward to Log Central.
The common appliances that cannot installed filebeat included vCenter, Synology NAS, Switch, Firewall, ESXi and ...

## SysLog Forwarder Proxy Server Installation
You can install the SysLogForwarder Proxy using the BASH script by running the following command in the Ubuntu TACACS+ Server:
```
wget https://github.com/jychoy92/SyslogForwarder/raw/main/install.sh -O install.sh; bash install.sh
```
This script will prompt you for the required variables listed in the Required Variable Settings section.

### Variables
|Variable|Description|Required|
|-------------|-------------|-------------|
|region_letters|Region Alpha-2 Code in small letter|Region code that not listed below please refer to https://www.iban.com/country-codes|Yes|
|logstach_server1|Remote Log Central LogStash IP 1|Yes|
|logstach_server2|Remote Log Central LogStash IP 2|No|
|ip_wanfirewall1|WAN Firewall 1 IP. FortiGate, PalaAlto and etc.|No|
|ip_wanfirewall2|WAN Firewall 2 IP. FortiGate, PalaAlto and etc.|No|
|ip_corefirewall1|Server Farm Core Firewall 1 IP. ASA and etc.|No|
|ip_corefirewall2|Server Farm Core Firewall 1 IP. ASA and etc.|No|
|ip_wlc1|WLC 1 IP|No|
|ip_wlc2|WLC 2 IP|No|
|ip_switches|Switches IP Range|No|
|ip_synology|Synology NAS IP|No|
|ip_vcenter|vCenter IP|No|

## Configuration Files Involve during the Installation
|Servive|Purpose|Path|
|-------------|-------------|-------------|
|rsyslog|to configure the logs receptor and reception path. Log collection is use ruleset method configure here and sort to specific folder  in /data/var/log|/etc/rsyslog.conf|
|-|to configure log rotation that capture by rsyslog in rsyslog receptor|/etc/logrotate.d/sys_log|
|filebeat|to configure filebeat to forward received logs to remote logstash|/etc/filebeat/filebeat.yml|

## Syslog Forwarder Proxy Troubleshooting
### Control Syslog Forwarder Proxy required services
```
### rsyslog service
sudo systemctl status rsyslog
sudo systemctl start rsyslog
sudo systemctl stop rsyslog
sudo systemctl restart rsyslog

### FileBeat Service
sudo systemctl status filebeat
sudo systemctl start filebeat
sudo systemctl stop filebeat
sudo systemctl restart filebeat
```

### Verify FileBeat Config is configured correctly
```
filebeat test config
filebeat test output
```

## References
* [How to Setup Central Logging Server with Rsyslog in Linux](https://www.tecmint.com/install-rsyslog-centralized-logging-in-centos-ubuntu/#:~:text=Once%20rsyslog%20installed%2C%20you%20need,status%20with%20the%20systemctl%20command.&text=The%20main%20rsyslog%20configuration%20file%20is%20located%20at%20%2Fetc%2Frsyslog)
* [Filebeat Log Shipper](https://logz.io/blog/filebeat-tutorial/#filebeatmodules)

