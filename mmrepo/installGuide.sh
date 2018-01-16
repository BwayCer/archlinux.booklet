#!/bin/bash
# Arch Linux 安裝導引程式


fnAssistant() {
    local fontSize bisUse

    printf "是否改變字體大小 to change the font size？ ( 12~32 ； \e[01;32mNo: 取消 ；\e[00m ) : "
    read fontSize
    if [ -n "`echo "$fontSize" | grep "^[0-9]+$"`" ]; then
        printf "\e[01;33m%s\e[00m\n" "pacman -Sy --noconfirm terminus-font"
        pacman -Sy
        pacman -S --noconfirm terminus-font

        if [ $fontSize -le 12 ];   then fontSize=12
        elif [ $fontSize -le 14 ]; then fontSize=14
        elif [ $fontSize -le 16 ]; then fontSize=16
        elif [ $fontSize -le 18 ]; then fontSize=18
        elif [ $fontSize -le 20 ]; then fontSize=20
        elif [ $fontSize -le 24 ]; then fontSize=24
        elif [ $fontSize -le 28 ]; then fontSize=28
        elif [ $fontSize -gt 28 ]; then fontSize=32
        fi

        printf "\e[01;33m%s\e[00m\n" "setfont ter-v${fontSize}n"
        setfont ter-v${fontSize}n
    fi


    ## 是否使用 SSH

    printf "\n\n"
    printf "是否使用 SSH to link by ssh？ ( Yes: 確定 ； \e[01;32mNo: 取消 ；\e[00m ) : "
    read bisUse
    case "$bisUse" in
        [Yy] | Yes | yes )
            printf "\e[01;33m%s\e[00m\n" "passwd"
            passwd

            printf "\e[01;33m%s\e[00m\n" "echo -e "PermitRootLogin yes" >> /etc/ssh/sshd_config"
            echo -e "PermitRootLogin yes" >> /etc/ssh/sshd_config

            printf "\e[01;33m%s\e[00m\n" "systemctl restart sshd.socket"
            systemctl restart sshd.socket

            printf "\e[01;33m%s\e[00m\n" "ip -ts -c addr"
            ip -ts -c addr

            printf "\n"
            printf "\e[01;33m%s\e[00m\n" "ss -tnlp"
            ss -tnlp

            echo -e "\n# \e[33mcheck if \"Local Address:Port\" have \":::22\" to allow ssh access.\e[0m"
            ;;
    esac
}

fnMain() {
    printf "\e[00;37m# %s\e[00m\n" "一． 劃分磁碟 Partition the disks"
    printf "\n"

        printf "\e[00;37m# %s\e[00m\n" "本程式並未幫忙做磁碟分區。"

        fnPrompt \
            "# 請確認磁碟已完成分區 check if Check if disks partitioning has been completed" \
            "Yes|yes|Y|y::確定" \
            "No|no|N|n:*:取消"

        case "$rtnPrompt" in
            Yes )
                printf "\n"
                printf "\e[01;33m%s\e[00m\n" "fdisk -l"
                fdisk -l
                ;;
            No )
                exit 0
                ;;
        esac


    printf "\n\n"
    printf "\e[00;37m# %s\e[00m\n" "二． 磁碟配置 Configure the disk"

        printf "\e[01;31m# %s\e[00m\n" "注意： 此操作必需在磁區未掛載之情況下進行！"
        printf "\e[01;31m# %s\e[00m\n" "       this operation need to be executed with the partition has unmounted"

        fnConfigureDisk() {
            local tmp inputTxt

            echo "# 輸入格式化與掛載位置選項 input mkfs and mount option "
            printf "( \e[01;32mcommand: 輸入命令 ；\e[00m f: 完成 ； help: 幫助 ； skip: 略過步驟 ； ) : "

            read inputTxt
            case "$inputTxt" in
                f | finish )
                    printf "# %-12s %-15s %s\n" $fnConfigureDisk_info
                    ;;
                h | help )
                    printf "\e[00;37m#"
                    printf "# 依照順序填入 磁區、檔案系統、掛載位置，並以分號分隔。 (ex: /dev/sda1:ext4:/boot)"
                    printf "\e[00m\n"
                    fnConfigureDisk
                    ;;
                S | skip)
                    ;;
                *)
                    if [ -z "`echo "$inputTxt" | grep "^\([^:]\+:\)\{2\}[^:]\+$"`" ]; then
                        printf "\e[01;31m# %s\e[00m\n" "不符合預期的參數。"
                    else
                        fnHandleGrain "$inputTxt"
                        if [ $? == 0 ]; then
                            tmp=`echo "$inputTxt" | sed "s/ /_/g" | sed "s/:/ /g"`
                            fnConfigureDisk_info=$fnConfigureDisk_info" "$tmp
                        else
                            printf "\e[01;31m# %s\e[00m\n" "請檢查錯誤事項 check error"
                        fi
                    fi

                    fnConfigureDisk
                    ;;
            esac
        }
        fnConfigureDisk_info="Device FileSystem MountPoint"

        printf "\n"
        fnConfigureDisk

        printf "\n"
        printf "\e[01;33m%s\e[00m\n" "lsblk -o NAME,SIZE,RA,RO,RM,RAND,PARTFLAGS,PARTLABEL,PARTUUID"
        lsblk -o NAME,SIZE,RA,RO,RM,RAND,PARTFLAGS,PARTLABEL,PARTUUID
        printf "\e[01;33m%s\e[00m\n" "lsblk -o NAME,MOUNTPOINT,FSTYPE,LABEL,UUID"
        lsblk -o NAME,MOUNTPOINT,FSTYPE,LABEL,UUID


    printf "\n\n"
    printf "\e[00;37m# %s\e[00m\n" "三． 安裝系統 Installation"

        local mirrorFile mirrorArea
        mirrorFile=/etc/pacman.d/mirrorlist

        if [ ! -f "$mirrorFile" ]; then
            printf "\e[01;31m# %s\e[00m\n" '鏡像表文件不存在。 ('$mirrorFile')'
            exit 1
        fi

        fnPrompt \
            "# 選擇映射站 edit /etc/pacman.d/mirrorlist" \
            "Yes|yes|Y|y:*:確定" \
            "skip|S::略過步驟"

        case "$rtnPrompt" in
            Yes )
                fnPrompt \
                    "# 是否選擇鏡像所在區域 臺灣 Taiwan" \
                    "Yes|yes|Y|y::是" \
                    "No|no|N|n:*:不是"

                case "$rtnPrompt" in
                    Yes )
                        mirrorArea=Taiwan
                        ;;
                    No )
                        fnChooseMirrorArea "$mirrorFile"
                        mirrorArea="$rtnChooseMirrorArea"
                        ;;
                esac

                fnHandleMirrorList "$mirrorFile" "$mirrorArea"
                ;;
            skip )
                ;;
        esac

        printf "\e[01;33m%s\e[00m\n" "cat $mirrorFile"
        cat "$mirrorFile"


        printf "\n"

        local basePkg

        fnPrompt \
            "# 初始化環境 pacstrap /mnt <pkg>" \
            "Yes|yes|Y|y:*:確定" \
            "skip|S::略過步驟"

        case "$rtnPrompt" in
            Yes )
                printf "\e[00;37m# %s\e[00m\n" "選擇要安裝的程式包 (default: base) : "

                read basePkg
                if [ -z "$basePkg" ]; then basePkg=base; fi

                printf "\e[01;33m%s\e[00m\n" "pacstrap /mnt $basePkg"
                pacstrap /mnt $basePkg
                ;;
            skip )
                ;;
        esac


    printf "\n\n"
    printf "\e[00;37m# %s\e[00m\n" "四． 配置系統 Configure the system"

        fnPrompt "# 建立文件系統列表 genfstab -U /mnt >> /mnt/etc/fstab" \
            "Yes|yes|Y|y:*:確定" \
            "skip|S::略過步驟"

        case "$rtnPrompt" in
            Yes )
                printf "\e[01;33m%s\e[00m\n" "genfstab -U /mnt >> /mnt/etc/fstab"
                genfstab -U /mnt >> /mnt/etc/fstab
                ;;
            skip )
                ;;
        esac

        printf "\e[01;33m%s\e[00m\n" "cat /mnt/etc/fstab"
        cat /mnt/etc/fstab


        printf "\n"

        local timeZonefile

        fnPrompt "# 調整時區 Time Zone" \
            "Yes|yes|Y|y:*:確定" \
            "skip|S::略過步驟"

        case "$rtnPrompt" in
            Yes )
                fnPrompt "# 是否選擇臺灣所在之時間 臺北時間" \
                    "Yes|yes|Y|y::是" "No|no|N|n:*:不是"

                case "$rtnPrompt" in
                    Yes )
                        timeZonefile=/usr/share/zoneinfo/Asia/Taipei
                        ;;
                    No )
                        fnChooseTimeZone
                        timeZonefile="$rtnfnChooseTimeZone"
                        ;;
                esac

                printf "\e[01;33m%s\e[00m\n" "echo \"ln -sf $timeZonefile /etc/localtime\" | arch-chroot /mnt"
                echo "ln -sf $timeZonefile /etc/localtime" | arch-chroot /mnt

                # timedatectl
                # date
                # hwclock --show
                # hwclock -w   # 以軟體時間（本地時間）寫入硬體時間
                ;;
            skip )
                ;;
        esac


        printf "\n"

        local localeChoose

        fnPrompt "# 選擇語系 Locale"
            "Yes|yes|Y|y:*:確定" \
            "skip|S::略過步驟"

        case "$rtnPrompt" in
            Yes )
                echo "# 目前語系僅提供預設選項："
                echo "#   1. 語言包： en_US、zh_TW"
                echo "#   2. 設定選項： zh_TW"
                echo

                printf "# 是否下載 en_US、zh_TW 語言包 locale-gen？"
                printf " ( Yes: 確定 ； \e[01;32mNo: 取消 ；\e[00m ) : "
                read localeChoose
                case "$localeChoose" in
                    [Yy] | Yes | yes )
                        printf "\e[01;33m""echo '"
                        printf 'sed -i "s/^#\(\(en_US\|zh_TW\).UTF-8 UTF-8\)/\1/" /etc/locale.gen'
                        printf "' | arch-chroot /mnt"
                        printf "\e[00m\n"
                        echo 'sed -i "s/^#\(\(en_US\|zh_TW\).UTF-8 UTF-8\)/\1/" /etc/locale.gen'
                            | arch-chroot /mnt

                        printf "\e[01;33m%s\e[00m\n" 'echo "locale-gen" | arch-chroot /mnt'
                        echo "locale-gen" | arch-chroot /mnt
                        ;;
                esac

                printf "# 是否設定選項 en_US、zh_TW 語言包？"
                printf "( Yes: 確定 ； \e[01;32mNo: 取消 ；\e[00m ) : "
                read localeChoose
                case "$localeChoose" in
                    [Yy] | Yes | yes )
                        printf "\e[01;33m""echo '"
                        printf 'locale | sed "s/\([A-Z_]=\).*/\1\"zh_TW.UTF-8\"/" > /etc/locale.conf'
                        printf "' | arch-chroot /mnt"
                        printf "\e[00m\n"
                        echo 'locale | sed "s/\([A-Z_]=\).*/\1\"zh_TW.UTF-8\"/" > /etc/locale.conf' \
                            | arch-chroot /mnt

                        printf "\e[01;33m%s\e[00m\n" "cat /mnt/etc/locale.conf"
                        cat /mnt/etc/locale.conf
                        ;;
                esac
                ;;
            skip )
                ;;
        esac


        printf "\n"

        local hostname

        fnPrompt "# 主機管理 Host management" \
            "Yes|yes|Y|y:*:確定" \
            "skip|S::略過步驟"

        case "$rtnPrompt" in
            Yes )
                printf "# 請輸入主機名稱 hostname : "
                read hostname
                printf "\e[01;33m%s\e[00m\n" "echo \"$hostname\" > /mnt/etc/hostname"
                echo "$hostname" > /mnt/etc/hostname

                printf "\e[01;33m%s\e[00m\n" "cat /mnt/etc/hostname"
                cat /mnt/etc/hostname
                ;;
            skip )
                ;;
        esac


        printf "\n"

        local biosType rootPartition partuuid bootMenu

        fnPrompt "# 安裝開機程式 install boot program" \
            "Yes|yes|Y|y:*:確定" \
            "skip|S::略過步驟"

        case "$rtnPrompt" in
            Yes )
                fnPrompt "# 請選擇韌體" "BIOS|B|b::" "UEFI|U|u|E|e::"
                biosType="$rtnPrompt"

                printf "# 請問根目錄磁區位置 (ex: /dev/sda1 or /dev/sda (若選擇 BIOS)) : "
                read rootPartition

                printf "\e[01;33m%s\e[00m\n" 'echo "mkinitcpio -p linux" | arch-chroot /mnt'
                echo "mkinitcpio -p linux" | arch-chroot /mnt

                case "$biosType" in
                    BIOS )
                        printf "\e[01;33m%s\e[00m\n" "echo \"pacman -S grub-bios\" | arch-chroot /mnt"
                        echo "pacman -S grub-bios" | arch-chroot /mnt

                        printf "\e[01;33m%s\e[00m\n" "echo \"grub-install --target=i386-pc --recheck $rootPartition\" | arch-chroot /mnt"
                        echo "grub-install --target=i386-pc --recheck $rootPartition" | arch-chroot /mnt

                        printf "\e[01;33m%s\e[00m\n" "echo \"grub-mkconfig -o /boot/grub/grub.cfg\" | arch-chroot /mnt"
                        echo "grub-mkconfig -o /boot/grub/grub.cfg" | arch-chroot /mnt
                        ;;
                    UEFI )
                        printf "\e[01;33m%s\e[00m\n" "echo \"bootctl install\" | arch-chroot /mnt"
                        echo "bootctl install" | arch-chroot /mnt

                        echo -e "default arch\ntimeout 3" > /mnt/boot/loader/loader.conf
                        printf "\e[01;33m%s\e[00m\n" "cat /mnt/boot/loader/loader.conf"
                        cat /mnt/boot/loader/loader.conf

                        partuuid=`blkid -s PARTUUID $rootPartition | sed "s/.*PARTUUID=\"\([a-f0-9-]\+\)\"/\1/"`
                        bootMenu=$bootMenu"title Archlinux\n"
                        bootMenu=$bootMenu"linux /vmlinuz-linux\n"
                        bootMenu=$bootMenu"initrd /initramfs-linux.img\n"
                        bootMenu=$bootMenu"options root=PARTUUID=$partuuid rw"
                        echo -e "$bootMenu" > /mnt/boot/loader/entries/arch.conf
                        printf "\e[01;33m%s\e[00m\n" "cat /mnt/boot/loader/entries/arch.conf"
                        cat /mnt/boot/loader/entries/arch.conf
                        ;;
                esac
                ;;
            skip )
                ;;
        esac


    printf "\n\n"
    echo "# 恭喜你 congratulations\n\n"

    echo "# 接下來你只需要："
    echo "#     卸載 /mnt： umount -R /mnt"
    echo "#     重啟機器： systemctl reboot"
}


fnAllowVal() {
    local allowList maybeVal caseInsensitive
    allowList=`echo " "$1" "`
    maybeVal="$2"
    caseInsensitive=$3

    if [ -z "`echo "$maybeVal" | grep " "`" ]; then
        if [ "$caseInsensitive" != "1" ] && [ -n "`echo "$allowList" | grep " $maybeVal "`" ]; then
            echo "$maybeVal"
        elif [ -n "`echo "$allowList" | grep -i " $maybeVal "`" ]; then
            echo "$allowList" | sed "s/^.* \($maybeVal\) .*$/\1/i"
        fi
    fi
}

fnHandleGrain() {
    local inputTxt
    inputTxt="$1"

    local tmp
    local mkfsList
    local grain mkfsCmd mountPath

    mkfsList=$mkfsList" ext2     ext3     ext4  vfat        "
    mkfsList=$mkfsList" btrfs    cramfs   exfat fat  f2fs   "
    mkfsList=$mkfsList" jfs      minix    msdos ntfs nilfs2 "
    mkfsList=$mkfsList" reiserfs reiserfs xfs               "

    grain=`    echo "$inputTxt" | cut -d ":" -f 1`
    mkfsCmd=`  echo "$inputTxt" | cut -d ":" -f 2`
    mountPath=`echo "$inputTxt" | cut -d ":" -f 3`

    mountPath=/mnt$mountPath

    tmp=$(fnAllowVal "$mkfsList" "$mkfsCmd")
    if [ -n "$tmp" ]; then
        mkfsCmd=mkfs.$tmp
    fi

    if [ ! -d "$mountPath" ]; then
        mkdir "$mountPath"
    fi
    $mkfsCmd "$grain"
    [ $? != 0 ] && return $?
    mount "$grain" "$mountPath"
    [ $? != 0 ] && return $?
}

fnHandleMirrorList() {
    local mirrorFile mirrorArea
    mirrorFile="$1"
    mirrorArea="$1"

    local mirrorList serverList deleteList
    local lineNumber newMirrorList

    mirrorList=`cat $mirrorFile`
    serverList=`echo -e "$mirrorList" | grep -n -B 1 "^Server = http" | grep "^[0-9]*-"`

    deleteList=`echo -e "$serverList" | grep -iv "$mirrorArea" | cut -d "-" -f 1`
    newMirrorList=$mirrorList

    for lineNumber in `echo -e "$deleteList" | sort -rn`
    do
        newMirrorList=`echo -e "$newMirrorList" | sed "$lineNumber,$(( $lineNumber + 1 ))d"`
    done

    echo "`echo "$newMirrorList" | sed 's/\$\(\w\)/\\\\$\1/g'`" ">" $mirrorFile
}

rtnChooseMirrorArea=""
fnChooseMirrorArea() {
    local mirrorFile
    mirrorFile="$1"

    local inputTxt serverList

    serverList=`cat $mirrorFile | grep -n -B 1 "^Server = http" | grep "^[0-9]*-"`

    fnAsk() {
        printf "# 請選擇鏡像所在區域 choose mirror area : "

        read inputTxt
        if [ -n "`echo -e "$serverList" | grep -i "$inputTxt"`" ]; then
            rtnChooseMirrorArea=$inputTxt
        else
            printf "\e[01;31m# %s\e[00m\n" '找不到指定的鏡像區域。 ('$inputTxt')'
            fnAsk
        fi
    }
}

rtnChooseTimeZone=""
fnChooseTimeZone() {
    local inputTxt

    fnAsk() {
        printf "\e[01;33m# %s\e[00m\n" \
            "提醒 你將進入 less 模式查閱資料並從中找尋合適的時區文件， 輸入 p 及可離開。 (enter) "
        printf "%-38s   %-38s\n" \
            `find /mnt/usr/share/zoneinfo/ -type f | sed "s/^\/mnt\/usr\/share\/zoneinfo\///"` \
            | less
        printf "# 請選擇時區文件 choose time zone file (ex: Asia/Taipei) : "

        read inputTxt
        if [ -f "/mnt/usr/share/zoneinfo/$inputTxt" ]; then
            rtnChooseTimeZone=/usr/share/zoneinfo/$inputTxt
        else
            printf "\e[01;31m# %s\e[00m\n" '找不到指定的時區文件。 ('$inputTxt')'
            fnAsk
        fi
    }
}


## 程式包區

# basesh/prompt
rtnPrompt=""
fnPrompt() {
    local txtQuestion
    txtQuestion=$1

    local val describe
    local option optionName optionDefault optionDescribe
    local defaultOption txtList txtDescribe

    txtList=""
    defaultOption=""
    txtDescribe=""

    for val in "${@:1}"
    do
        if [ -z "`echo "$val" | grep "[A-Za-z0-9_-][A-Za-z0-9_|-]*\(:\*\?\)\?\(:.\*\)\?"`" ]; then continue; fi

        option=`        echo ":$val"   | cut -d ":" -f 2`
        optionName=`    echo "$option" | cut -d "|" -f 1`
        optionDefault=` echo ":$val"   | cut -d ":" -f 3`
        optionDescribe=`echo ":$val"   | cut -d ":" -f 4-`

        describe=$optionName
        if [ -n "$optionDescribe" ]; then
            describe=$describe": "$optionDescribe
        fi

        txtList=$txtList"\n|$option|"

        if [ "$optionDefault" == "*" ]; then
            defaultOption="$optionName"
            txtDescribe=$txtDescribe" \e[01;32m${describe} ;\e[00m"
        else
            txtDescribe=$txtDescribe" $describe ;"
        fi
    done

    if [ -z "$txtList" ]; then
        tmpErrMsg='[錯誤] 不符合預期的參數。 ($ ./prompt <問題> <選項 "[A-Za-z0-9_|-]*:\*\?:.*" ...>'
        echo -e "\e[01;31m${tmpErrMsg}\e[00m"
        exit 1
    fi

    fnPrompt_ask "$txtQuestion ($txtDescribe )" "$txtList" "$defaultOption"
}
fnPrompt_ask() {
    local txtQuestion txtList defaultOption
    txtQuestion=$1
    txtList=$2
    defaultOption=$3

    local tmpCho

    printf "$txtQuestion : "
    read tmpCho

    if [ -z "$tmpCho" ] && [ -n "$defaultOption" ]; then
        rtnPrompt="$defaultOption"
    elif [ -z "$tmpCho" ] || [ -n "`echo "$tmpCho" | grep "[^A-Za-z0-9_-]"`" ]; then
        fnPrompt_ask "$txtQuestion" "$txtList" "$defaultOption"
    elif [ -n "`echo "$txtList" | grep "|$tmpCho|"`" ]; then
        rtnPrompt=`echo -e "$txtList" | grep "|$tmpCho|" | cut -d "|" -f 2`
    else
        fnPrompt_ask "$txtQuestion" "$txtList" "$defaultOption"
    fi
}


# 映像檔小幫手
fnAssistant

fnMain "$@"

