VMware 虛擬機
=======


> 2018.01.15

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
單顆磁區大小最大為 4064 MB，
但並沒有說容量越大越好， 或越小越好，



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

> 註： 視窗作業系統建議可以加 `efi.legacyBoot.enabled = "TRUE"`，
> 筆者認為這對功能完整性有幫助， 但不清楚有什麼實質幫助。 XD



## 快照


對 `.vmx` 設定文件、`.nvram` 韌體資料和所有 `.vmdk` 硬碟資料 三類檔案複製備份。



## 虛擬機環境


過去筆者使用 **git** 為虛擬機快照，
並將它放於沒有單一檔案大小及總容量限制的 [GitLab](https://gitlab.com/) ；
而現在筆者只保留虛擬機文件作為備份之用，
顯而易見的就是大大節省空間容量。

使用 **git** 雖然能快速建立或是選擇返回某個系統狀態，
但現在面對問題筆者已經有信心可以從容的去處裡它，
還有筆者做了個更進階的 [GitHub BwayCer/ditto.vm](https://github.com/BwayCer/ditto.vm)
來處理建立虛擬機環境這苦差事。


> 註： 虛擬機檔案除了設定文件外都是二進位檔案，
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

