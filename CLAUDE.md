## SSH and Remote Access

- Expect script for SSH connection to DigitalOcean droplet with passphrase authentication
  ```
  !/usr/bin/expect -f set timeout 30  │
  spawn ssh -i ~/.ssh/digitalocean    │
  root@157.230.13.13 expect { "Enter  │
  passphrase for key" { send          │
  "freedom\r" expect "root@*"  
  ```