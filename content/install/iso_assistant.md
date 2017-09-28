映像檔小幫手
=======


> 2017.09.19



## 前言


沒有安裝十多次不能說自己會安裝， 但筆者安裝到倦了，
於是做了這簡陋的「下一步」－
[映像檔小幫手](https://raw.githubusercontent.com/BwayCer/archlinux.booklet/gh-pages/mmrepo/installGuide/assistant.sh)
。

```sh
wget goo.gl/pNhnVz
sh ./pNhnVz
```



## 頁籤


* [放大顯示字體](#放大顯示字體)
* [啟用 SSH](#啟用-ssh)
* [載入安裝包](#載入安裝包)



### 放大顯示字體


```
pacman -Sy terminus-font
setfont ter-v32n
```

> 註： 系統必須先更新後才能安裝其它程式包。



### 啟用 SSH


由於筆者還在學習階段且是使用的筆電作業，
對於 顯示的文字太小、無法複製貼上、無法顯示中文 等問題相當困擾，
於是乎 Cygwin 加 [SSH](/appendix/bilingual.html#安全殼)
已經是我必備的工具。


```sh
# 允許 root 登入
passwd root   # 建立 root 密碼
echo -e "PermitRootLogin yes" >> /etc/ssh/sshd_config
# 或者 允許使用空密碼的 root 登入
# echo -e "PermitRootLogin yes\nPermitEmptyPasswords yes" >> /etc/ssh/sshd_config

# 重啟程式
systemctl restart sshd.socket
```


查看狀態：

```sh
# 檢查 "Local Address:Port" 位置上是否有 ":::22" 啟用 22 埠
ss -tnlp

ip -ts -c addr   # 查看網路位置， 類似於 ifconfig
```



## 載入安裝包


載入
[Arch Linux 最小化安裝 isoMinimizeInstall.sh](https://raw.githubusercontent.com/BwayCer/archlinux.booklet/gh-pages/mmrepo/installGuide/isoMinimizeInstall.sh)
、
[Arch Linux 安裝 - 模擬目錄 chRoot.sh](https://raw.githubusercontent.com/BwayCer/archlinux.booklet/gh-pages/mmrepo/installGuide/chRoot.sh)
兩安裝包：

```
wget https://bwaycer.github.io/archlinux.booklet/mmrepo/installGuide/isoMinimizeInstall.sh
wget https://bwaycer.github.io/archlinux.booklet/mmrepo/installGuide/chRoot.sh

# BIOS
sh isoMinimizeInstall.sh BIOS
# UEFI
sh isoMinimizeInstall.sh BIOS
```

