UEFI、MBR、GPT 區別
=======


> 2017.08.07



## 頁籤


* [基本輸入輸出系統](#基本輸入輸出系統)
  * [UEFI 的好處](#UEFI的好處)
* [磁碟分區表](#磁碟分區表)
* [參考](#參考)



## 基本輸入輸出系統


基本輸入輸出系統 [BIOS](/appendix/bilingual.md#基本輸入輸出系統)
是連接硬體與軟體間的韌體，
也是開機時第一個啟動的軟體。


在英特爾 [Intel](/appendix/bilingual.md#英特爾) 處理器進入 32 位元的時代，
卻因為相容性的關係仍需為 BIOS 保留 16 位元的執行方式，
且這十多年未曾改變的 BIOS 缺乏統一標準，
各廠商間見招拆招、疊床架屋，
也就吹生了統一可擴展韌體介面 [UEFI](/appendix/bilingual.md#統一可擴展韌體介面) 。


___※
  T客邦說道以 C 語言寫的 UEFI BIOS 體積增大，
  連帶使儲存 BIOS 的 [EEPROM](/appendix/bilingual.md#電子抹除式可複寫唯讀記憶體)
  晶片需要擴增，
  而關於晶片就是英特爾擅長的範圍。___



### UEFI 的好處


> 原文： [UEFI 韌體 - 微軟開發者網路](https://msdn.microsoft.com/zh-tw/library/hh824898.aspx)


* 較快的開機和繼續時間。
* 能夠使用安全性功能， 例如： 進行安全開機、使用原廠加密的磁碟機。
* 能夠更輕易地支援大型硬碟 (超過 2 TB) 和具備四個以上磁碟分割的磁碟機。
  （這部分與 GPT 有關係。）
* 與舊版 BIOS 的相容性。
  有一些 UEFI 型電腦包含相容性支援模組 (CSM)，
  可以模擬舊版 BIOS， 為使用者提供更多彈性和相容性。
* 支援多點傳送部署，
  讓電腦製造商能夠廣播可透過多部電腦接收的電腦映像，
  而不會讓網路或映像伺服器爆滿。
* 支援 UEFI 韌體驅動程式、應用程式及 Option ROM。



## 磁碟分區表


磁碟分區表包含開機管理程式與[磁碟分區](/appendix/bilingual.md#磁碟分區)資訊兩部分，
目前有 主開機紀錄 [MBR](/appendix/bilingual.md#主開機紀錄)
、 全局唯一識別碼分區表 [GPT](/appendix/bilingual.md#全局唯一識別碼分區表)
兩種標準。

GPT 相容於 MBR， 為 UEFI 所採用的分區表，
其優點為能支援超過 2.2 TB 的硬碟和有 128 個磁碟分區。


 項目     | 主開機紀錄     | 全局唯一識別碼分區表
:----     |:----------:    |:--------------------:
 佔位空間 | 512 位元組 * 1 | 512 位元組 * ( 34 + 33 )
 分區數量 | 4              | 128


___※
  在使用 主開機紀錄 時需去在意的 主要分區、延伸分區、邏輯分區
  的概念在使用多分區數量的
  全局唯一識別碼分區表 時應該會愈來愈少會被用到。___


更詳細資料可見：

  * [鳥哥的 Linux 私房菜 -- 第二章、主機規劃與磁碟分割 # MSDOS(MBR) 與 GPT 磁碟分割表(partition table)](http://linux.vbird.org/linux_basic/0130designlinux.php#partition_table)
  * [GUID磁碟分割表 - 維基百科](https://zh.wikipedia.org/wiki/GUID磁碟分割表)
  * [大容量硬碟、UEFI 系統進階玩法：GPT / MBR 分割表格式無損輕鬆互轉 | T客邦](https://www.techbang.com/posts/14126)



## 參考


* [即將換掉傳統 BIOS 的 UEFI，你懂了嗎？（二） | T客邦](https://www.techbang.com/posts/4359)
* [統一可延伸韌體介面 - 維基百科](https://zh.wikipedia.org/wiki/統一可延伸韌體介面)
* [鳥哥的 Linux 私房菜 -- 第二章、主機規劃與磁碟分割 # 開機流程中的 BIOS 與 UEFI 開機檢測程式](http://linux.vbird.org/linux_basic/0130designlinux.php#partition_bios_uefi)
* [鳥哥的 Linux 私房菜 -- 第二章、主機規劃與磁碟分割 # MSDOS(MBR) 與 GPT 磁碟分割表(partition table)](http://linux.vbird.org/linux_basic/0130designlinux.php#partition_table)
* [GUID磁碟分割表 - 維基百科](https://zh.wikipedia.org/wiki/GUID磁碟分割表)

