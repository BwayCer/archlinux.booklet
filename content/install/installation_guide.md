安裝指南 BIOS
=======


> 2017.08.10



## 前言


如果系統環境為基本輸入輸出系統 [BIOS](/appendix/bilingual.md#基本輸入輸出系統)
請參考此篇。

這是筆者最初接觸的安裝方法，
但現在改為統一可擴展韌體介面 [UEFI](/appendix/bilingual.md#統一可擴展韌體介面)
的環境，
所以將部分重點筆記移至
[安裝指南 UEFI](content/install/installation_guide_uefi.md)
的文章中。



## 頁籤


* [映像檔小幫手](#映像檔小幫手)
* [最小化安裝](#最小化安裝)
* [參考](#參考)



## 映像檔小幫手


> 可以藉由筆者自製的
> [映像檔小幫手](https://raw.githubusercontent.com/BwayCer/archlinux.booklet/gh-pages/mmrepo/installGuide/assistant.sh)
> 來完成安裝作業：
>
> ```sh
> wget goo.gl/pNhnVz -O assistant.sh
> sh ./assistant.sh
> ```



## 最小化安裝


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
  3. 重啟機器（似乎可以免拔映像檔）： `systemctl reboot`



## 參考


* Ilcli123 網友
* [Installation guide - ArchWiki](https://wiki.archlinux.org/index.php/Installation_guide_(正體中文%29)

