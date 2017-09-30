#!/bin/bash
# 映像檔小幫手


## 更新映像檔程式包

pacman -Sy


## 是否改變字體大小

printf "to change the font size? (12~32/N) :"
read fontSize
case $fontSize in
    S|skip|N|n) ;;
    *)
        pacman -S terminus-font

        if [ $fontSize -le 12 ]; then
            setfont ter-v12n
        elif [ $fontSize -le 14 ]; then
            setfont ter-v14n
        elif [ $fontSize -le 16 ]; then
            setfont ter-v16n
        elif [ $fontSize -le 18 ]; then
            setfont ter-v18n
        elif [ $fontSize -le 20 ]; then
            setfont ter-v20n
        elif [ $fontSize -le 24 ]; then
            setfont ter-v24n
        elif [ $fontSize -le 28 ]; then
            setfont ter-v28n
        elif [ $fontSize -gt 28 ]; then
            setfont ter-v32n
        else
            setfont ter-v20n
        fi
esac


## 是否使用 SSH

echo
echo
printf "to link by ssh? (Y/N) :"
read fontSize
case $fontSize in
    Y|y)
        passwd

        echo -e "PermitRootLogin yes" >> /etc/ssh/sshd_config

        systemctl restart sshd.socket

        ip -ts -c addr

        ss -tnlp
        echo -e "\n\e[33mcheck if \"Local Address:Port\" have \":::22\" to allow ssh access.\e[0m"
esac


## 載入安裝包

echo
echo
printf "What installGuide do you need? (BIOS/UEFI) "

$(ls /sys/firmware/efi > /dev/null 2>&1)
isUEFI=$?
if [ $isUEFI -eq 0 ]; then
    printf "(default UEFI) :"
else
    printf "(default BIOS) :"
fi

read fontSize
if [ -z $fontSize ]; then
    if [ $isUEFI -eq 0 ]; then
        fontSize=UEFI
    else
        fontSize=BIOS
    fi
fi
echo $fontSize
case $fontSize in
    S|skip) ;;
    B|BIOS|b|bios)
        wget https://bwaycer.github.io/archlinux.booklet/mmrepo/installGuide/isoMinimizeInstall.sh
        wget https://bwaycer.github.io/archlinux.booklet/mmrepo/installGuide/chRoot.sh
        sh isoMinimizeInstall.sh BIOS
        ;;
    U|UEFI|u|uefi|EFI|efi)
        wget https://bwaycer.github.io/archlinux.booklet/mmrepo/installGuide/isoMinimizeInstall.sh
        wget https://bwaycer.github.io/archlinux.booklet/mmrepo/installGuide/chRoot.sh
        sh isoMinimizeInstall.sh UEFI
        ;;
esac

