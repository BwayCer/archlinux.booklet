免費的安全通訊協定證書
=======


> 2018.01.15



## 頁籤


* [簡介](#簡介)
* [取得證書](#取得證書)
* [安裝證書](#安裝證書)
* [自動更新證書](#自動更新證書)
* [命令功能翻譯（部分）](#命令功能翻譯（部分）)
* [參考](#參考)



## 簡介


[Let's Encrypt](https://letsencrypt.org/)
是一個免費的、自動的、開放的
安全通訊協定 [SSL](/appendix/bilingual.md#安全通訊協定)
認證機構 certificate authority (CA)
。<br />
（ [查看其贊助商](https://letsencrypt.org/sponsors/) ）


如果是在免費與付費間猶豫不決，可以先閱讀
[此文章](https://www.inside.com.tw/2017/01/12/ssl_certificate)
。



## 取得證書


首先必須先下載 Certbot 程式包：
（ [或許你有更好的選擇？](https://letsencrypt.org/docs/client-options/) ）

```sh
pacman -S certbot
```

> 註： Certbot 程式的 [輯中心倉庫](https://github.com/certbot/certbot)

> 註： 關於 Certbot 完整使用方式請見 [官方文件](https://certbot.eff.org/docs/using.html) 。


以交互互動的方式請求認證：

```sh
$ sudo certbot certonly --manual \
    -m admin@example.com \
    -d example.com -d aaa.example.com -d bbb.example.com

Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator manual, Installer None

-------------------------------------------------------------------------------
請先閱讀服務條款 ...
-------------------------------------------------------------------------------
(A)gree/(C)ancel:

-------------------------------------------------------------------------------
你要訂閱電子報嗎 ...
-------------------------------------------------------------------------------
(Y)es/(N)o:

Obtaining a new certificate
Performing the following challenges:
http-01 challenge for example.com
http-01 challenge for aaa.example.com
http-01 challenge for bbb.example.com

-------------------------------------------------------------------------------
NOTE: The IP of this machine will be publicly logged as having requested this
certificate. If you're running certbot in manual mode on a machine that is not
your server, please ensure you're okay with that.

Are you OK with your IP being logged?

# 注意：本機的 IP 將會因為請求證書而被公開記錄。
# 如果你在其他非服務器的機器上以 manual 模式運行 certbot，
# 請先確保沒任何問題。

# 這會記錄你的 IP，你確定了嗎？
-------------------------------------------------------------------------------
(Y)es/(N)o:

-------------------------------------------------------------------------------
Create a file containing just this data:

vl2gUDEPsjNZU8Ui8V9wvU5vIC78sfGaIcRjaOjf3cY.M99HaGcleY_FD44xwCevknZEPm9V9RhI1R9cf4Mac_c

And make it available on your web server at this URL:

http://example.com/.well-known/acme-challenge/vl2gUDEPsjNZU8Ui8V9wvU5vIC78sfGaIcRjaOjf3cY

# 在指定網址路徑上提供僅顯示指定資料的頁面，此步驟可能有數次。
-------------------------------------------------------------------------------
Press Enter to Continue


# 如果失敗

Waiting for verification...
Cleaning up challenges
Failed authorization procedure.
...


# 如果成功

Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   # 證書 certificate 和 chain 已保存在：
   /etc/letsencrypt/live/example.com/fullchain.pem
   Your key file has been saved at:
   # 密鑰文件已保存在：
   /etc/letsencrypt/live/example.com/privkey.pem
   Your cert will expire on 2018-04-15. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
   # 您的證書將於 2018-04-15 到期。
   # 取得新的或者調整證書版本，請再次執行 `certbot`
   # 以非交互方式更新所有證書，請執行 `certbot renew`
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

> 註： 浮動網路協定位址似乎只現在國內使用，使用此方法會因為不具有公開路由而驗證失敗。

> 註： Certbot 有 apache、standalone、nginx、webroot、manual 等模式獲取證書，
> 原本想以由程式自行建立服務器、自行完成驗證的 standalone 模式來執行的，
> 但卻一直卡於 `Problem binding to port 80: Could not bind to IPv4 or IPv6.`
> 80 埠無法綁定 IPv4 或是 IPv6 的問題。



## 安裝證書


`ls /etc/letsencrypt/live/example.com/` 在證書目錄中有以下文件：

- cert.pem
- chain.pem
- fullchain.pem
- privkey.pem


**Node.js**

```javascript
const https = require( 'https' );
const fs = require( 'fs' );

var options = {
    key: fs.readFileSync( '/etc/letsencrypt/live/baltoy.7er.info/privkey.pem' ),
    cert: fs.readFileSync( '/etc/letsencrypt/live/baltoy.7er.info/cert.pem' ),
    ca: fs.readFileSync( '/etc/letsencrypt/live/baltoy.7er.info/chain.pem' )
};

https.createServer( options, function ( req, res ) {
    console.log( req.headers );
    res.writeHead( 200 );
    res.end( 'Hello World HTTPs 2' );
} ).listen( 443 );
```


**Apache**

```ApacheConf
LoadModule ssl_module libexec/apache2/mod_ssl.so
Listen 443
<VirtualHost *:443>
    ServerName example.com
    SSLEngine on
    SSLCertificateFile "/etc/letsencrypt/live/example.com/cert.pem"
    SSLCertificateKeyFile "/etc/letsencrypt/live/example.com/privkey.pem"
    SSLCertificateChainFile "/etc/letsencrypt/live/example.com/chain.pem"
</VirtualHost>
```


**NGINX**

```Nginx
server {
    listen              443 ssl;
    server_name         example.com;
    ssl_certificate     /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
}
```



## 自動更新證書


Certbot 具有在證書過期之前自動更新證書的功能。
執行以下命令可以測試證書的自動續訂功能：

```
sudo certbot renew --dry-run
```

如果顯示 `be working correctly`，
您可以使用 `cron` 或 `systemd` 計時器去執行以下命令來安排自動更新作業：

```
certbot renew
```

> 註：
> 我們建議每天運行兩次更新證書命令
> （在證書到期或者被撤銷之前，它不會有任何動作，
> 但是定期運行它會給你的網站多一個機會假如 Let's Encrypt 頒布的證書因某種原因而被撤銷）。

例如： 一個每天中午和午夜運行的 `cron` 工作可能像這個樣子：

```
0 0,12 * * * python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew
```

關於更多更新的資訊請見
[官方文件 #renewal](https://certbot.eff.org/docs/using.html#renewal)
。



## 命令功能翻譯（部分）


```
letsencrypt-auto [SUBCOMMAND] [options] [-d DOMAIN] [-d DOMAIN] ...

  run   (default)   在當前的網絡服務器上獲取並安裝證書
  certonly          獲取或更新證書，但不安裝它
  renew             續訂所有先前獲得但即將到期的證書

  -d DOMAINS        以逗號分隔要驗證的網域清單

  --standalone      運行獨立的網絡服務器去進行驗證
  --webroot         在服務器的網絡跟目錄 webroot 放置文件進行驗證
  --manual          以交互方式獲取證書，或使用 shell script hooks
  --dry-run         測試 "renew" 或 "certonly"，但不保存任何證書。

  certificates      顯示從 Certbot 獲得的證書信息
```



## 參考


* [Let’s Encrypt - ArchWiki](https://wiki.archlinux.org/index.php/Let’s_Encrypt)
* [入門 - Certbot](https://certbot.eff.org/#arch-other)
* [GitHub Gist: Let’s Encrypt setup for Apache, NGINX & Node.js](https://gist.github.com/davestevens/c9e437afbb41c1d5c3ab)
* [Can I use letsencrypt in more than one subdomain? - Let's Encrypt Community Support](https://community.letsencrypt.org/t/16588)

