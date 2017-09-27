磁碟分區
=======


> 2017.08.08



## 頁籤


* [分區對齊](#分區對齊)
* [命令](#命令)
* [格式化](#格式化)
* [筆者現況參考](#筆者現況參考)
* [參考](#參考)



## 分區對齊


磁碟是有最小的讀取單位的， 通常是 512byte 或是 4KB，
而所謂的對齊就是以最小讀取單位的倍數去劃分磁區。
這對固態硬碟來說更為重要，
固態硬碟的快閃記憶體是有讀寫次數的極限的，
超過性能便會下降甚至報廢，
正確的分區對齊可避免一些無謂的讀寫動作。


[ArchWiki](https://wiki.archlinux.org/index.php/Partitioning_(简体中文%29#.E5.88.86.E5.8C.BA.E5.B7.A5.E5.85.B7_2)
說 `fdisk`、`gdisk`、`gparted`、`parted` 等常用工具已可自動處理對齊，
但我的理解是 512B 倍數的為 512B 對齊； 4K 倍數的為 4K 對齊，
而 `fdisk` 允許設定 2049 為起始點， 不符合 512B 對齊？！
`gdisk` 允許設定分區大小為 1K， 不符合 4K 對齊？！
疑惑呀？


相關文章見：

  * [Partitioning # 分區對齊 - ArchWiki](https://wiki.archlinux.org/index.php/Partitioning_(简体中文%29#.E5.88.86.E5.8C.BA.E5.AF.B9.E9.BD.90)
  * [Advanced Format - ArchWiki](https://wiki.archlinux.org/index.php/Advanced_Format)



### 驗證是否對齊命令


```
$ parted /dev/sda
(parted) align-check optimal 1   # 1 表示 /dev/sda1 的意思
1 aligned   # 有對齊
```



## 命令


各類相關命令與其操作形式一覽：

 操作形式       | 主開機紀錄     | 全局唯一識別碼分區表
:--------       |:----------     |:--------------------
 命令           | sfdisk、parted | sfdisk、sgdisk、parted
 對話           | fdisk、parted  | fdisk、gdisk、parted
 文字類圖形介面 | cfdisk         | cfdisk、cgdisk


筆者最後選用 `fdisk` 命令， 以下為使用參考：

```
$ fdisk /dev/sda
welcome to fdisk (util-linux 2.30.1)
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

# 在此所做的更改僅只暫存在記憶體中， 直到你決定寫入它們。
# 請小心使用 write 命令。

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x9cc1856d.

Command (m for help) m

Help:

  DOS (MBR)
   a   toggle a bootable flag              # 開關可啟動識別標誌
   b   edit nested BSD disklabel
   c   toggle the dos compatibility flag

  Ge21474836480neric
   d   delete a partition                    # 刪除一個分區
   F   list free unpartitioned space
   l   list known partition types
   n   add a new partition                   # 增加一個分區
   p   print the partition table             # 打印當前分區表
   t   change a partition type
   v   verify the partition table
   i   print information about a partition

  Misc
   m   print this menu                      # 打印此幫助選單
   u   change display/entry units
   x   extra functionality (experts only)

  Script
   I   load disk layout from sfdisk script file
   O   dump disk layout to sfdisk script file

  Save & Exit
   w   write table to disk and exit   # 寫入分區表後離開
   q   quit without saving changes    # 不寫入離開

  Create a new label
   g   create a new empty GPT partition table          # 創建新的全局唯一識別碼分區表
   G   create a new empty SGI (IRIX) partition table
   o   create a new empty DOS partition table          # 創建新的 DOS 分區表（主開機紀錄）
   s   create a new empty Sun partition table

Command (m for help) n
Partition type
  p primary (0 primary, 0 extended, 4 free)       # 主要分區
  e extended (container for logical partitions)   # 延伸分區
Select (default p): p
Partition number (1-4, default 1): (Enter)                                 # /dev/sda 磁區編號
First sector (2048-67108863, default 2048): (Enter)                                 # 起始扇區
Last sector, +sectors or +size{K,M,G,T,P} (2048-67108863, default 67108863): +32G   # 結束扇區

Command (m for help) p
Disk /dev/sda: 32 GiB, 34359738368 bytes, 67108864 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos                                          # 使用 MBR 分區表
Disk identifier: 0x9cc1856d

Device    Boot Start      End  Sectors Size Id Type
/dev/sda1       2048 67108863 67106816  32G 83 Linux
```

> 註： 如果有四個以上的分區需求建議使用 GPT 分區表，
  而有關主要分區、延伸分區這學問就略過吧。


查看分區狀態：

```
$ fdisk -l
Disk /dev/sda: 8 GiB, 8589934592 bytes, 16777216 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x6a339903

Device     Boot    Start      End Sectors  Size Id Type
/dev/sda1           2048  1050623 1048576  512M 83 Linux
/dev/sda2        1050624  7342079 6291456    3G 83 Linux
/dev/sda3        7342080 14657535 7315456  3.5G 83 Linux
/dev/sda4       14657536 16777215 2119680    1G 83 Linux
```



## 格式化


格式化這步驟也是在建置該分區的文件系統。
其命令有 [`mkfs`](http://linux.vbird.org/linux_basic/0230filesystem.php#format)
、 [`mkswap`](http://linux.vbird.org/linux_basic/0230filesystem.php#swap)
兩類。

關於可用的文件系統見：
  [File systems - ArchWiki](https://wiki.archlinux.org/index.php/File_systems) 。


```
$ mkfs.ext4 /dev/sda1
mke2fs 1.43.4 (31-Jan-2017)
Creating filesystem with 131072 4k blocks and 32768 inodes
Filesystem UUID: d28375fe-0170-4b25-b40e-cf609a74a4aa
Superblock backups stored on blocks:
        32768, 908304

Allocating group tables: done
Writing inode tables: done
Creating journal (4096 blocks): done
writing superblocks and filesystem accounting information: done
```

```
$ mkswap /dev/sda4   # 格式化
Setting up swapspace version 1, size = 2 GiB (2146430976 bytes)
no label, UUID=4aaa4e3e-69e3-44a3-a91b-f023deb9e34a

$ free
Mem:         743736      142020      290772      113976      310944      377580  # 實體記憶體
Swap:             0           0           0                                      # swap 相關

$ swapon /dev/sda4   # 啟用

$ free
              total        used        free      shared  buff/cache   available
Mem:         743736      143612      289056      113976      310944      377580
Swap:       2096124           0     2096124
```

> 註： 關於 `free` 命令見：
  鳥哥的 Linux 私房菜
  [第七章、Linux 磁碟與檔案系統管理 # swap](http://linux.vbird.org/linux_basic/0230filesystem.php#swap)
  、
  [第十六章、程序管理與 SELinux 初探 # free](http://linux.vbird.org/linux_basic/0440processcontrol.php#free)
  。


查看磁碟資訊：

```
$ lsblk
NAME         MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0          7:0    0   40G  1 loop /run/archiso/sfs/airootfs
sda            8:0    0   32G  0 disk
├─sda1         8:1    0    2M  0 part /mnt/boot
├─sda2         8:2    0    1G  0 part /mnt
├─sda3         8:3    0   30G  0 part /mnt/home
└─sda4         8:3    0   30G  0 part [SWAP]
sr0           11:0    1  516M  0 rom  /run/archiso/bootmnt

$ lsblk -f
NAME   FSTYPE   LABEL       UUID                   MOUNTPOINT
loop0  squashfs
sda
|-sda1 ext4                 (略)                   /mnt/boot
|-sda2 ext4                 (略)                   /mnt
|-sda3 ext4                 (略)                   /mnt/home
|-sda4 swap                 (略)                   [SWAP]
sr0    iso9660  ARCH_201708 2017-08-01-13-16-28-00 /run/archiso/bootmnt
```



### Btrfs 文件系統


由於鳥哥在
[第三章 - 安裝 CentOS7.x](http://linux.vbird.org/linux_basic/0157installcentos7.php#centos_5)
中提到並於
[第七章 - Linux 磁碟與檔案系統管理](http://linux.vbird.org/linux_basic/0230filesystem.php#harddisk-xfs)
的檔案系統介紹中再次說明 EXT 家族會漸漸式微的原因。

這也讓我關心的查了查資料，結果發現又有新的檔案系統被發展出來了：

  * [Btrfs - ArchWiki](https://wiki.archlinux.org/index.php/Btrfs)
  * [\[問題\] Apple推出APFS那linux有其他FS可以比較嗎 - 看板 Linux - 批踢踢實業坊](https://www.ptt.cc/bbs/Linux/M.1492431791.A.D8C.html)

在 ArchWiki
[Partitioning # Btrfs](https://wiki.archlinux.org/index.php/Partitioning_(简体中文%29#Btrfs_.E5.88.86.E5.8C.BA)
中還說道這是要替代 MBR 和 GPT 分區的方案，
咦～ 分區表、文件系統？！



## 筆者現況參考


Linux 目前規劃在 VMware 虛擬機、樹莓派、備用電腦 等主機中使用。


預計劃分四個磁區：

  * `/boot`： 開機目錄。 其包含有核心檔案、開機選單與設定檔 ... 等等。
  * `/`： 根目錄。 系統一切的起始。
  * `/home`： 家目錄。 個人資料的所在。
  * `swap`： 記憶體置換空間。 以硬碟空間代替記憶體使用。

而舊有烏班圖的現況：
`/boot` 目錄占 471MB；
不含 `/home` 的 `/` 目錄占 7GB 的使用量。
所以應該會是以下規劃：

 磁區記錄區 | 掛載  | 檔案系統 | 大小
:---------- |:----  | --------:| ----:
 /dev/sda1  | /boot |     ext4 | 384MB
 /dev/sda2  | /     |     ext4 |  10GB
 /dev/sda3  | /home |     ext4 |   ---
 /dev/sda4  |       |     swap |   2GB


> 註：
  [ArchWiki](https://wiki.archlinux.org/index.php/Partitioning_(简体中文%29#.E5.88.86.E5.8C.BA.E5.BA.94.E8.AF.A5.E8.AE.BE.E7.BD.AE.E5.A4.9A.E5.A4.A7.EF.BC.9F)
  說 `/boot` 目錄實際需求只有 100 MB。


> 註：
  當硬體支援 UEFI 時 `/boot` 文件系統請使用 `FAT32 (vfat)`。
  相關文章可見：
  [File systems # Create a file system - ArchWiki](https://wiki.archlinux.org/index.php/File_systems#Create_a_file_system)
  [\[SOLVED\] EFI on ext4 ?](http://www.linuxquestions.org/questions/linux-hardware-18/efi-on-ext4-4175510688/)
  。



## 參考

* [Partitioning - ArchWiki](https://wiki.archlinux.org/index.php/Partitioning)
* [鳥哥的 Linux 私房菜 -- 第七章、Linux 磁碟與檔案系統管理 # 磁碟分割： gdisk/fdisk](http://linux.vbird.org/linux_basic/0230filesystem.php#f.disk)
* [4K對齊 - 維基百科](https://zh.wikipedia.org/wiki/4K对齐)
* [鳥哥的 Linux 私房菜 -- 第七章、Linux 磁碟與檔案系統管理 # 磁碟格式化(建置檔案系統)](http://linux.vbird.org/linux_basic/0230filesystem.php#format)
* [鳥哥的 Linux 私房菜 -- 第七章、Linux 磁碟與檔案系統管理 # swap](http://linux.vbird.org/linux_basic/0230filesystem.php#swap)
* [鳥哥的 Linux 私房菜 -- 第三章、安裝 CentOS7.x # 練習配置](http://linux.vbird.org/linux_basic/0157installcentos7.php#design)
* [鳥哥的 Linux 私房菜 -- 第五章、Linux 的檔案權限與目錄配置 # 根目錄](http://linux.vbird.org/linux_basic/0210filepermission.php#dir_fhs_root)

