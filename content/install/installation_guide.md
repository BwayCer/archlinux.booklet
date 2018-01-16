安裝指南
=======


> 2018.01.16



## 前言


新手報到， 這是筆者第一次使用命令安裝作業系統，
少了「下一步」這小幫手可花我了許久的時間去重新認識 Linux，
但還是有不少指令是模模糊糊跟著前人們複製貼上。


最特別的就是映像檔的命令行 `root@archiso`，
這可不是最後成果的命令行喔！
`root@archiso` 這是映像檔的根管理員，
預先幫忙連上了網路， 也預載了 `wget`、`openssh` ... 等等功能。

還有喔！
`pacstrap`、`arch-chroot` 這是只有映像檔才有的命令。



## 頁籤


* [映像檔小幫手](#映像檔小幫手)
    * [放大顯示字體](#放大顯示字體)
    * [啟用 SSH](#啟用-ssh)
* [判別 UEFI 韌體](#判別-uefi-韌體)
* [最小化安裝](#最小化安裝)
  * [映像檔環境](#映像檔環境)
    * [磁碟劃分與配置](#磁碟劃分與配置)
    * [選擇映射站](#選擇映射站)
    * [安裝基本程式包](#安裝基本程式包)
    * [建立文件系統列表](#建立文件系統列表)
    * [切換根目錄](#切換根目錄)
  * [模擬目錄環境](#模擬目錄環境)
    * [建立開機映像](#建立開機映像)
    * [建立開機程式](#建立開機程式)
* [補充說明](#補充說明)
  * [建立開機映像 BIOS](#建立開機映像-bios)
* [參考](#參考)



## 映像檔小幫手


[Arch Linux 安裝導引程式](https://raw.githubusercontent.com/BwayCer/archlinux.booklet/gh-pages/mmrepo/installGuide.sh)
， 筆者自製的「下一步」腳本：

```
sh -c "`curl -L https://goo.gl/8Qrkrv`"
```



### 放大顯示字體


```
pacman -S terminus-font
setfont ter-v32n
```

> 註： 系統必須先 `pacman -Sy` 更新後才能安裝其它程式包。



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



## 判別 UEFI 韌體


```
ls /sys/firmware/efi
```

**本篇會以 UEFI 需求安裝為主， 不過有補充筆者先前安裝傳統 BIOS 的命令。**



## 最小化安裝


### 映像檔環境


#### 磁碟劃分與配置


請見 [磁碟分區](./disk_partition.md) 。

> 註： 若是 UEFI， 一定要將 `/boot` 用 'EF00` 做分區。



#### 選擇映射站


```sh
vim /etc/pacman.d/mirrorlist
```



#### 安裝基本程式包


可以依需求增加程式包，
程式包也可以在進入「真正的」根管理員後繼續安裝。

```sh
pacstrap /mnt base [Pkg2] [Pkg ...]
```



#### 建立文件系統列表


`/etc/fstab` 紀錄磁碟記錄區的文件系統與掛載位置。

```sh
genfstab -U /mnt >> /mnt/etc/fstab
```

更多資訊見：
[鳥哥的 Linux 私房菜 -- 第十九章、開機流程、模組管理與 Loader # 開機流程分析](http://linux.vbird.org/linux_basic/0510osloader.php#startup)
、
[fstab - ArchWiki](https://wiki.archlinux.org/index.php/Fstab)
。



#### 切換根目錄


在此之前的所有操作都是指向 `/mnt`，
是因為目前的位置是在映像檔裡， 我們用 `/mnt` 模擬完成安裝後的根目錄，
現在要切換進以 `/mnt` 作為根目錄的另一個空間，
在這的操作也等同完成安裝後的情況。

```sh
arch-chroot /mnt
```


接著則是在模擬目錄下繼續完成安裝手續， 請參考 [模擬目錄環境](#模擬目錄環境) 。



### 模擬目錄環境


#### 建立開機映像


用於機器剛啟動時加載 Linux 核心的運行環境，
見 [mkinitcpio - ArchWiki](https://wiki.archlinux.org/index.php/Mkinitcpio_(简体中文%29)
說明。

```sh
mkinitcpio -p linux
```



#### 建立開機程式


> 註： 若是 BIOS， 請參考 [建立開機映像 BIOS](#建立開機映像-bios)


複製 systemd-boot 二進制文件到您的 EFI 系統分區（預設為 `/boot` 目錄），
並把 systemd-boot 作為 EFI 開機管理器預設載入的 EFI 應用程式。

```
bootctl install
```


**建立開機選單：**


`/boot/loader/loader.conf`：

```
default arch
timeout 4
```


`/boot/loader/entries/arch.conf`：

```
title Archlinux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=PARTUUID=xxx rw
```

關於最後一行 `options root=PARTUUID=xxx rw`
中的 `xxx` 請查找 `blkid` 命令中 `/` 跟目錄的 `PARTUUID`。


更多資訊見： [systemd-boot - ArchWiki](https://wiki.archlinux.org/index.php/Systemd-boot) 。


#### Arch 歡迎你


你已經完成安裝了， 依下述動作重新啟動機器後你就是 Arch 的一員了。

  1. 離開 `chroot`： `exit`
  2. 卸載 `/mnt`： `umount -R /mnt`
  3. 重啟機器（似乎可以免拔映像檔）： `systemctl reboot`



## 補充說明


### 建立開機映像 BIOS


```sh
# 安裝 GRUB
pacman -S grub-bios
# 把 GRUB 安裝到磁碟上
grub-install --target=i386-pc --recheck /dev/sda
# GRUB 的配置
grub-mkconfig -o /boot/grub/grub.cfg
```


關於 [GRUB](/appendix/bilingual.md#偉大的開機加載程式) 可見：
  [Category:Boot loaders - ArchWiki](https://wiki.archlinux.org/index.php/Category:Boot_loaders)
  、
  [GRUB - ArchWiki](https://wiki.archlinux.org/index.php/GRUB_(简体中文%29)
  。



## 參考


* Ilcli123 網友
* [Installation guide - ArchWiki](https://wiki.archlinux.org/index.php/Installation_guide_(正體中文%29)
* [Archlinux install in less than 10 minutes on a UEFI system - YouTube](https://youtu.be/DfC5hgdtbWY)

