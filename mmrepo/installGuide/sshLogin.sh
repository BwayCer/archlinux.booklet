#!/bin/bash
# 啟用 SSH 登入


echo -e "PermitRootLogin yes\nPermitEmptyPasswords yes" >> /etc/ssh/sshd_config

systemctl restart sshd.socket

ifconfig

ss -tnlp
echo -e "\n\e[33mcheck if \"Local Address:Port\" have \":::22\" to allow ssh access.\e[0m"

