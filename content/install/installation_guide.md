安裝指南
=======


> 2017.08.10



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


* [啟用 SSH](#啟用-ssh)
* [最小化安裝](#最小化安裝)
* [參考](#參考)



## 啟用 SSH


似乎未安裝圖形介面以前的命令行操作都相當不人性，
且筆者又是以虛擬機工作，
實在無法接受 文字太小、無法複製貼上、無法顯示中文 等問題，
於是乎 Cygwin 加 [SSH](/appendix/bilingual.html#安全殼)
已經是我必備的工具。


```sh
# 允許使用空密碼的 root 登入
echo -e "PermitRootLogin yes\nPermitEmptyPasswords yes" >> /etc/ssh/sshd_config

# 重啟程式
systemctl restart sshd.socket
```


查看狀態：

```sh
# 檢查 "Local Address:Port" 位置上是否有 ":::22" 啟用 22 埠
ss -tnlp

ifconfig   # 查看網路位置
```


或者以程式執行：

```sh
wget https://bwaycer.github.io/archlinux.booklet/mmrepo/installGuide/sshLogin.sh
sh ./sshLogin.sh
```



## 最小化安裝


下述命令也可以透過下列程式執行：

```sh
wget https://bwaycer.github.io/archlinux.booklet/mmrepo/installGuide/isoSmall.sh
sh ./isoSmall.sh
```



### 磁碟劃分與配置：


請見 [磁碟分區](./disk_partition.md) 。



### 選擇映射站：


```sh
vim /etc/pacman.d/mirrorlist
```



### 安裝基本程式包：


可以依需求增加程式包，
程式包也可以在進入「真正的」根管理員後繼續安裝。

```sh
pacstrap /mnt base
```



### 建立文件系統列表：


`/etc/fstab` 紀錄磁碟記錄區的文件系統與掛載位置。

```sh
genfstab -U /mnt >> /mnt/etc/fstab
```

更多資訊見： [fstab - ArchWiki](https://wiki.archlinux.org/index.php/Fstab) 。



### 切換根目錄


在此之前的所有操作都是指向 `/mnt`，
是因為目前的位置是在映像檔裡， 我們用 `/mnt` 模擬完成安裝後的根目錄，
現在要切換進以 `/mnt` 作為根目錄的另一個空間，
在這的操作也等同完成安裝後的情況。

```sh
arch-chroot /mnt
```


___注意！ 接下來的兩個步驟 建立開機映像、安裝開機程式 皆是在 `chroot` 的環境下。___



### 建立開機映像


用於機器剛啟動時加載 Linux 核心的運行環境，
見 [mkinitcpio - ArchWiki](https://wiki.archlinux.org/index.php/Mkinitcpio_(简体中文%29)
說明。

```sh
mkinitcpio -p linux
```



### 安裝開機程式


```sh
pacman -S grub-bios

grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```


關於 [GRUB](/appendix/bilingual.md#偉大的開機加載程式) 可見：
  [Category:Boot loaders - ArchWiki](https://wiki.archlinux.org/index.php/Category:Boot_loaders)
  、
  [GRUB - ArchWiki](https://wiki.archlinux.org/index.php/GRUB_(简体中文%29)
  。



### 恭喜你


接下來你只需要：

  1. 離開 `chroot`： `exit`
  2. 卸載 `/mnt`： `umount -R /mnt`
  3. 重啟機器（似乎可以免拔映像檔）： `reboot`



## 參考


* Ilcli123 網友
* [Installation guide - ArchWiki](https://wiki.archlinux.org/index.php/Installation_guide_(正體中文%29)

