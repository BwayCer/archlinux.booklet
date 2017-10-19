ppp 程式包
=======


> 2017.11.04



## 頁籤


* [簡介](#簡介)
* [撥號設定](#撥號設定)
* [撥號連線](#撥號連線)
* [故障排除](#故障排除)
  * [預設路由](#預設路由)
* [參考](#參考)



## 簡介


```
pacman -S ppp
```

`ppp` 程式包是用於處理 PPPoE 撥號連線的工具，
但其連線配置及管理推薦使用
[`netctl`](https://wiki.archlinux.org/index.php/netctl)
工具替代。


> 註： 無須下載 `rp-pppoe` 程式包。
> 另外關於使用到 `ip` 命令的部分，
> 較習慣 `ifconfig` 或 `route` 的可以安裝 `net-tools` 程式包。



## 撥號設定


**編寫 `/etc/ppp/peers/your_provider`：**

```
plugin rp-pppoe.so
# rp_pppoe_ac 'your ac name'
# rp_pppoe_service 'your service name'

# network interface
eth0
# login name
name "***@ip.hinet.net"
usepeerdns
persist
# Uncomment this if you want to enable dial on demand
#demand
#idle 180
defaultroute
hide-password
noauth
```

  * `ac name`： 選填， 全名為 Access Concentrator，
    筆者猜測的理解為如同域名解析伺服器一樣作為交換固定 IP 的伺服器。
    更多資訊可見
    [簡述 PPPoE 協議 - 百度知道](https://zhidao.baidu.com/question/1960534899790224060.html)
    、
    [何謂 PPPOE 的 Access Concentrator | Techwalla.com](https://www.techwalla.com/articles/what-is-the-pppoe-access-concentrator-on-my-computer)
    。
  * `service name`： 選填， 無相關資訊。
  * `eth0`： 網路介面名稱， 由 `ip addr` 查看。
  * `***@ip.hinet.net`： 撥號帳戶， `@ip.hinet.net` 為登入 Hinet 固定 IP 的用戶名稱。

<br>


**編寫 `/etc/ppp/pap-secrets` 和 `/etc/ppp/chap-secrets`：**

```
# Secrets for authentication using PAP/CHAP
# client        server  secret                  IP addresses
"***@ip.hinet.net" * "Hinet 密碼"
```



## 撥號連線


**清除已配置的預設路由：**

```
ip route del default
```


**撥號連線與關閉：**

```
cd /etc/ppp/peers/
pon your_provider    # 連線
poff your_provider   # 關閉
```

```
ln -s /etc/ppp/peers/your_provider /etc/ppp/peers/provider
pon
poff
```

> 註： 重新連上浮動 IP 的網路命令：
> ```
> poff
> systemctl restart dhcpcd.service
> ```

<br>

> 註： 成功連線後的狀態資訊請見
> [固定網路協定位址 # pppd 資訊](/content/command_and_operation/static_ip.html#pppd-資訊)
> 。




## 故障排除


**查看關於連線的系統日誌：**

```
journalctl -b --no-pager | grep pppd
```



### 預設路由


如果在啟動 `pppd` 之前已經有配置預設路由， 該預設路由會被保留，
在 `journalctl` 日誌裡會出現如下訊息：

```
pppd[nnnn]: not replacing existing default route via xxx.xxx.xxx.xxx
```

而這 xxx.xxx.xxx.xxx 並不是 `pppd` 通過的正確路由，
這能以 `ip route` 去修改它：

```
$ ip addr show ppp0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:78:6d:ca brd ff:ff:ff:ff:ff:ff
    inet 192.168.***.***/24 brd 192.168.1.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::68ab:3868:bb3e:a14c/64 scope link
       valid_lft forever preferred_lft forever
3: ppp0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1492 qdisc fq_codel state UNKNOWN group default qlen 3
    link/ppp
    inet 114.***.***.*** peer 168.95.98.254/32 scope global ppp0
       valid_lft forever preferred_lft forever
```

查看 `ip addr` 資訊知道需要通過 **`eth0` 網路介面** 及 **`168.95.98.254` 閘道器 gateway**。

```
ip route del default
ip route add default via 168.95.98.254 dev eth0
```


另外也能自動配置， 方法如下：


```
$ vim /etc/ppp/ip-pre-up
#!/bin/sh
#
# This script is run by pppd when there's a successful ppp connection.
#

# Execute all scripts in /etc/ppp/ip-up.d/
for ipup_pre in /etc/ppp/ip-pre-up.d/*.sh; do
  if [ -x $ipup_pre ]; then
    # Parameters: interface-name tty-device speed local-IP-address remote-IP-address ipparam
    $ipup_pre "$@"
  fi
done
```

```
$ vim /etc/ppp/ip-pre-up.d/10-route-del-default.sh
#!/bin/sh

/usr/bin/ip route del default
```

```
$ chmod 755 /etc/ppp/ip-pre-up /etc/ppp/ip-pre-up/10-route-del-default.sh
```



## 參考


* [ppp - ArchWiki](https://wiki.archlinux.org/index.php/Ppp)
* [鳥哥的 Linux 私房菜 -- 第五章、 Linux 常用網路指令 # ip](http://linux.vbird.org/linux_server/0140networkcommand.php#ip_cmd)

