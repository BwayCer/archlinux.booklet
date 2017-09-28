節點安裝
=======


## 頁籤


* [節點](#節點)
* [nvm 版本管理器](#nvm-版本管理器)



# 節點


筆者透過下載二進制包（[官方載點](https://nodejs.org/en/download/)）進行安裝，
透過如下指令解壓縮並移動至 `/usr/local/` 目錄就完成了。

```
tar -xJf /mnt/vhost/nodejs/node-v8.5.0-linux-x64.tar.xz --strip-components 1 -C /usr/local/
```


> 註： 起初是想試試編譯源碼， 但是跑了好久， 跑了好久，
> 跑到我以另一種方式完成安裝後它還再跑！ 噗



# nvm 版本管理器


[GitHub: creationix/nvm](https://github.com/creationix/nvm)


官方已寫好安裝腳本， 相當方便呢！

```
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
source ~/.bashrc
```

