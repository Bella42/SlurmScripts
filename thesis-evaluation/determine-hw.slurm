#!/bin/bash

#SBATCH -N 1 --ntasks-per-node=24
#SBATCH --partition=parcio

file="/home/urz/kduwe/thesis_eval/node-hw/storage-$(hostname).txt"
hwFile="/home/urz/kduwe/thesis_eval/node-hw/hardware-$(hostname).txt"


echo "# --- Hardware of $(hostname) --- " >> "${file}"
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

# echo "# "  >> "${file}"
# echo "# "  >> "${file}"
# echo "# "  >> "${file}"
# echo "# -------------------------------" >> "${file}"

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

echo "# --- lshw ---" >> "${hwFile}"
echo " "  >> "${hwFile}"
lshw >>  "${hwFile}"
echo " "  >> "${hwFile}"
echo " "  >> "${hwFile}"


