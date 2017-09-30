#!/bin/bash
# Arch Linux 安裝 - 模擬目錄


echo -e '（"S"、"skip" 可略過步驟）\n'


echo
echo
echo -e "1. 時區 Time zone\n"

    printf "請輸入 /usr/share/zoneinfo/? (default Asia/Taipei)： "
    read tem
    case $tem in
        S|skip) ;;
        *)
            if [ ! $tem ]; then
                tem="Asia/Taipei"
            fi

            ln -sf /usr/share/zoneinfo/$tem /etc/localtime
    esac

    echo
    echo "ls -al /etc/localtime :"
    ls -al /etc/localtime

    echo
    echo "date :"
    date
    echo "hwclock --show :"
    hwclock --show
    echo
    echo "timedatectl :"
    timedatectl


    echo
    printf "以軟體時間（本地時間）寫入硬體時間： hwclock -w (enter)"
    read tem
    case $tem in
        S|skip) ;;
        *)
            hwclock -w
    esac

    echo "timedatectl :"
    timedatectl


echo
echo
echo -e "2. 語系 Locale\n"

    printf "選擇語言包： vim /etc/locale.gen (enter)"
    read tem
    case $tem in
        S|skip) ;;
        *)
            vim /etc/locale.gen
            locale-gen
    esac

    echo
    printf "設定語系選項： echo LANG=en_US.UTF-8 > /etc/locale.conf (enter)"
    read tem
    case $tem in
        S|skip) ;;
        *)
            $(echo LANG=en_US.UTF-8 > /etc/locale.conf)
    esac
    cat /etc/locale.conf


echo
echo
echo -e "3. 主機管理 Host management\n"

    printf "設定主機名稱 (default unown)： "
    read tem
    case $tem in
        S|skip) ;;
        *)
            if [ ! $tem ]; then
                tem="unown"
            fi

            echo $tem > /etc/hostname
    esac
    cat /etc/hostname


echo
echo
echo -e "4. 安裝程式包 Install package\n"

    installPkg() {
        local pkgs=$(echo $2 | tr '__' " ")

        printf "$1： pacman -S $pkgs (enter)"
        read tem
        case $tem in
            S|skip) ;;
            *)
                pacman -S $pkgs
        esac
    }

    installPkg 常用工具 gcc__make__which__openssh__git__tmux
    echo
    installPkg 網路工具 net-tools


echo
echo
echo -e "5. mkinitcpio\n"

    printf "建立開機映像： mkinitcpio -p linux (enter)"
    read tem
    case $tem in
        S|skip) ;;
        *)
            mkinitcpio -p linux
    esac


echo
echo
echo -e "6. 建立開機程式 Build boot loader\n"

    if [ "$1" == "BIOS" ] && [ -n "$2" ]; then
        firmware=BIOS
    elif [ "$1" == "UEFI" ]
        firmware=UEFI
    fi
    case $firmware in
        BIOS)
            printf "依照 BIOS 建立開機程式： (enter)"
            read tem
            case $tem in
                S|skip) ;;
                *)
                    pacman -S grub-bios
                    grub-install --target=i386-pc --recheck $2
                    grub-mkconfig -o /boot/grub/grub.cfg
            esac
            ;;
        UEFI)
            printf "依照 UEFI 建立開機程式： (enter)"
            read tem
            case $tem in
                S|skip) ;;
                *)
                    bootctl install
                    echo -e 'default arch\ntimeout 3' > /boot/loader/loader.conf
                    echo -e 'title Archlinux\nlinux /vmlinuz-linux\ninitrd /initramfs-linux.img\noptions root=PARTUUID=xxx rw' > /boot/loader/entries/arch.conf
                    echo -e '請修改 /boot/loader/entries/arch.conf 檔案中 PARTUUID=xxx 的 xxx 參數，請查找 "根目錄" 的 PARTUUID 取代 `blkid -s PARTUUID /dev/sdaX`' >
            ;;
        *)
            echo -e "\e[31m沒有提供韌體環境。\e[0m）"
            echo "關於此部分安裝請參考 https://bwaycer.github.io/archlinux.booklet/content/install/installation_guide.html#建立開機程式"
    esac


rm ./chRoot.sh

echo
echo
echo "完成 Finish"
echo
echo "你可以離開模擬目錄： exit"


exit 0

