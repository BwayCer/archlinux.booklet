#!/bin/bash
# Arch Linux 最小化安裝


echo -e '（"S"、"skip" 可略過步驟）\n'

echo -e "一． 劃分磁碟 Partition the disks\n"

    echo "本程式並未幫忙做磁碟分區。"

    promptDisksPartition() {
        local isOk

        printf "請確認磁碟已完成分區 check if Check if disks partitioning has been completed (y/n)： "
        read isOk

        case $isOk in
            y|Y)
                echo
                echo fdisk -l:
                fdisk -l
                ;;
            n|N)
                exit 0
                ;;
            *)
                echo
                promptDisksPartition
        esac
    }

    promptDisksPartition


echo
echo
echo -e "二． 磁碟配置 Configure the disk\n"

    printf "輸入磁碟位置 (default: /dev/sda)： "
    read disk
    if [ ! $disk ]; then
        disk="/dev/sda"
    fi

    echo $disk


    configureDiskInfo="Device\tFileSystem\tMountPoint\n"

    mkfsAndMount() {
        local isActMount=true
        local isWriteInfo=true
        local diskPartition="$disk$1"
        local info="$diskPartition"

        case $2 in
            ext4)
                info="$info\text4"
                mkfs.ext4 $diskPartition
                ;;
            vfat)
                info="$info\tvfat"
                mkfs.vfat $diskPartition
                ;;
            swap)
                info="$info\tswap"
                mkswap $diskPartition
                swapon $diskPartition
                isActMount=false
                ;;
            *)
                isActMount=false
                isWriteInfo=false
                echo -e "\e[1;31m 錯誤： 請確認檔案系統是否支援。\e[0m"
        esac

        if $isActMount ; then
            if [ "$3" ]; then
                info="$info\t/mnt$3"
                mkdir /mnt$3
                mount $diskPartition /mnt$3
            fi
        fi

        if $isWriteInfo ; then
            configureDiskInfo="$configureDiskInfo$info\n"
            echo -e $info
        fi
    }

    showDiskInfo() {
        echo
        echo lsblk:
        lsblk
        echo
        echo lsblk -f:
        lsblk -f
    }

    promptConfigureDisk() {
        printf "輸入格式化與掛載位置選項 (h: help, f: finish)： "
        local mmopts
        read mmopts

        case $mmopts in
            ""|h)
                echo "依照順序填入 磁碟紀錄區編號、檔案系統、掛載位置，並以空格分開。 (ex: 1 ext4 /mnt)"
                echo
                promptConfigureDisk
                ;;
            f)
                showDiskInfo
                echo
                echo -e $configureDiskInfo
                ;;
            S|skip)
                showDiskInfo
                echo
                ;;
            *)
                mkfsAndMount $mmopts
                echo
                promptConfigureDisk
        esac
    }

    echo
    promptConfigureDisk


echo
echo -e "三． 安裝系統 Installation\n"

    printf "選擇映射站： vim /etc/pacman.d/mirrorlist (enter)"
    read tem
    case $tem in
        S|skip) ;;
        *)
            vim /etc/pacman.d/mirrorlist
    esac


    echo
    printf "安裝基本程式包： pacstrap /mnt <pkg> (default: base)"
    read tem
    case $tem in
        S|skip) ;;
        "")
            pacstrap /mnt base
            ;;
        *)
            pacstrap /mnt $tem
    esac


echo
echo
echo -e "四． 配置系統 Configure the system\n"

    printf "建立文件系統列表： genfstab -U /mnt >> /mnt/etc/fstab (enter)"
    read tem
    case $tem in
        S|skip) ;;
        *)
            genfstab -U /mnt >> /mnt/etc/fstab
    esac
    cat /mnt/etc/fstab


    echo
    printf "改變根目錄： arch-chroot /mnt (enter)"
    read tem
    case $tem in
        S|skip) ;;
        *)
            echo -e "\n接下來你需要： （\e[33m請依自身需求調整命令\e[0m）"
            echo "    建立開機映像："
            echo "        mkinitcpio -p linux"
            echo
            echo "    安裝開機程式："
            echo "        pacman -S grub-bios"
            echo "        grub-install --target=i386-pc --recheck /dev/sda"
            echo "        grub-mkconfig -o /boot/grub/grub.cfg"
            echo

            arch-chroot /mnt
    esac


exit 0

