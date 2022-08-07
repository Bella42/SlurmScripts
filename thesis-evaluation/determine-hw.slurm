#!/bin/bash

#SBATCH -N 1 --ntasks-per-node=24
#SBATCH --partition=parcio

file="/home/urz/kduwe/thesis_eval/node-hw/storage-$(hostname).txt"
hwFile="/home/urz/kduwe/thesis_eval/node-hw/hardware-$(hostname).txt"


echo "# --- Storage Hardware of $(hostname) --- " >> "${file}"
echo "# -------------------------------" >> "${file}"
echo " "  >> "${file}"
echo " "  >> "${file}"

echo "# ---  lsblk ---" >> "${file}"
echo " "  >> "${file}"
lsblk >>  "${file}"
echo " "  >> "${file}"
echo " "  >> "${file}"

echo "# --- free -h ---" >> "${file}"
echo " "  >> "${file}"
free -h >>  "${file}"
echo " "  >> "${file}"
echo " "  >> "${file}"

echo "# --- df -h ---" >> "${file}"
echo " "  >> "${file}"
df -h >>  "${file}"
echo " "  >> "${file}"
echo " "  >> "${file}"

echo "# --- findmnt / ---">> "${file}"
echo " "  >> "${file}"
findmnt / >>  "${file}"
echo " "  >> "${file}"
echo " "  >> "${file}"

echo "# --- blkid ---" >> "${file}"
echo " "  >> "${file}"
blkid >>  "${file}"
echo " "  >> "${file}"
echo " "  >> "${file}"

echo "# -------------- dd sync-----------------" >> "${file}"
echo " "  >> "${file}"
echo "# --- dd if=/dev/zero of=dummy bs=4k count=1000 oflag=sync ---"" >> "${file}"
# echo "# --- dd if=/dev/zero of=dummy bs=4k count=1000 oflag=sync status=progress ---" >> "${file}"
echo " "  >> "${file}"
dd if=/dev/zero of=dummy bs=4k count=1000 oflag=sync >>  "${file}"
echo " "  >> "${file}"

echo "# --- dd if=/dev/zero of=dummy bs=4M count=100 oflag=sync ---" >> "${file}"
echo " "  >> "${file}"
dd if=/dev/zero of=dummy bs=4M count=100 oflag=sync >>  "${file}"
echo " "  >> "${file}"

echo "# -------------- dd-----------------" >> "${file}"
echo " "  >> "${file}"

echo "# --- dd if=/dev/zero of=dummy bs=4k count=1000 ---" >> "${file}"
echo " "  >> "${file}"
dd if=/dev/zero of=dummy bs=4k count=1000 >>  "${file}"
echo " "  >> "${file}"

echo "# --- dd if=/dev/zero of=dummy bs=4M count=100 ---" >> "${file}"
echo " "  >> "${file}"
dd if=/dev/zero of=dummy bs=4M count=100 >>  "${file}"
echo " "  >> "${file}"
echo " "  >> "${file}"

echo "# --- cat /proc/cmdline | grep root ---" >> "${file}"
echo " "  >> "${file}"
cat /proc/cmdline | grep root >>  "${file}"
echo " "  >> "${file}"
echo " "  >> "${file}"


echo "# --- mount ---" >> "${file}"
echo " "  >> "${file}"
mount >>  "${file}"
echo " "  >> "${file}"
echo " "  >> "${file}"

echo "# --- ls -l /dev/disk/by-id ---" >> "${file}"
echo " "  >> "${file}"
ls -l /dev/disk/by-id >>  "${file}"
echo " "  >> "${file}"
echo " "  >> "${file}"

# ------------------------------------------------

echo "# --- Hardware of $(hostname) --- " >> "${hwFile}"
echo "# -------------------------------" >> "${hwFile}"
echo " "  >> "${hwFile}"
echo " "  >> "${hwFile}"

echo "# --- lshw ---" >> "${hwFile}"
echo " "  >> "${hwFile}"
lshw >>  "${hwFile}"
echo " "  >> "${hwFile}"
echo " "  >> "${hwFile}"


