VMware 虛擬機
=======


> 2017.09.27

<br>

> [VMware Workstation Player 虛擬程式官方下載](https://www.vmware.com/products/player/playerpro-evaluation.html)



## 頁籤


* [硬碟大小](#硬碟大小)
* [設定文件](#設定文件)
* [使用 UEFI](#使用-uefi)
* [快照](#快照)
* [虛擬機環境](#虛擬機環境)
* [參考](#參考)



## 硬碟大小


如果選用切分虛擬硬碟 split virtual disk，
建議以一單位 7.9 GB 計算，
這樣可以讓切分的檔案趨近 512 KB 的最大值。
（筆者經驗， 無任何根據）



## 設定文件


VMware 的設定文件為 `.vmx` 文件， 以下為筆者嘗試過的：


 參數            | 說明
:----            |:----
scsi0:0.fileName | 虛擬硬碟設定文件名稱。 （預設： `name.vmdk`）
displayName      | 虛擬機識別名稱。 （預設： `name`）
nvram            | 虛擬韌體檔案名稱。 （預設： `name.nvram`）



## 使用 UEFI


於設定文件 `.vmx` 中寫入 `firmware` 參數如下：


```
.encoding = "Big5"
firmware = "efi"      <-- 增加此行
```



## 快照


對 `.vmx` 設定文件、`.nvram` 韌體資料和所有 `.vmdk` 硬碟資料 三類檔案複製備份。



## 虛擬機環境


筆者使用 **git** 為虛擬機快照， 將 VMware 的檔案存放於
[GitLab: BwayCer/gitVirtualMachine.vmware](https://gitlab.com/BwayCer/gitVirtualMachine.vmware)
。

**感謝 [GitLab](https://gitlab.com/) 沒有單一檔案大小及總容量限制。 開心 ^^**

> 虛擬機檔案除了設定文件外都是二進位檔案，
> 二進位檔案對 Git 並不友善， 一小點變動都需要重新收錄，
> 雖然已採用切分虛擬硬碟的方式，
> 卻未感到有莫大的改善。（難道是學固態硬碟的分散的寫入方式嗎 XD）
>
> 不過意外地發現 Git 的壓縮能力，
> 把 1.21 GB 壓縮成 684 MB，
> 在壓縮虛擬機檔案上完全勝過 7zip 和 zip。



## 參考


* [VMWare Player with UEFI - Gulivert's Blog](http://gulivert.ch/vmware-player-with-uefi-bios/)
* [VMware文件辨别 - 杰迪武士的日志 - 网易博客](http://lijiwei19850620.blog.163.com/blog/static/97841538201111903625705/)

