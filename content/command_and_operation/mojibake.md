亂碼
=======


> 2017.09.30



## 頁籤


* [終端機](#終端機)
* [Vim](#vim)
* [Git](#git)



## 終端機


```sh
# 移除欲選取語言包前的 "#" 符號
vim /etc/locale.gen
# 將該語言寫入設定文件
vim /etc/locale.conf
  # LANG=zh_TW.UTF-8
locale-gen
# 登出再登入
```



## Vim


```sh
vim ~/.vimrc
  # set enc=utf8
```



## Git


```
# 移除欲選取語言包前的 "#" 符號
vim /etc/locale.gen
# 將該語言寫入設定文件
vim /etc/locale.conf
  # 不用全寫 但確切是那些忘記了
  # LANG=zh_TW.UTF-8
  # LC_CTYPE="zh_TW.UTF-8"
  # LC_NUMERIC="zh_TW.UTF-8"
  # LC_TIME="zh_TW.UTF-8"
  # LC_COLLATE="zh_TW.UTF-8"
  # LC_MONETARY="zh_TW.UTF-8"
  # LC_MESSAGES="zh_TW.UTF-8"
  # LC_PAPER="zh_TW.UTF-8"
  # LC_NAME="zh_TW.UTF-8"
  # LC_ADDRESS="zh_TW.UTF-8"
  # LC_TELEPHONE="zh_TW.UTF-8"
  # LC_MEASUREMENT="zh_TW.UTF-8"
  # LC_IDENTIFICATION="zh_TW.UTF-8"
  # LC_ALL=
locale-gen
# 登出再登入

# 重新安裝
pacman -Rs git
pacman -S git
```

