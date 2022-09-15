#!/bin/bash

#SBATCH --partition=parcio
#SBATCH -N 2 --ntasks-per-node=32
#SBATCH --nodelist=ant11,ant12
#SBATCH --error=/home/urz/kduwe/thesis_eval/output/benchmark-%j.err --output=/home/urz/kduwe/thesis_eval/output/benchmark-%j.out

export JULEA_PREFIX="/home/urz/kduwe/julea-install"

. /home/urz/kduwe/mein-julea/scripts/environment.sh
echo ". /home/urz/kduwe/mein-julea/scripts/environment.sh"

spack load mysql

mkdir -p /tmp/kduwe/localdb

singularity run --writable-tmpfs -B /tmp/kduwe/localdb:/var/lib/mysql --env MARIADB_RANDOM_ROOT_PASSWORD=yes --env MARIADB_DATABASE=julea_db --env MARIADB_USER=julea_user --env MARIADB_PASSWORD=julea_pw  mariadb.sif &
sleep 1m

export JULEA_CONFIG="~/.config/julea/config-ant11-ant12"
echo "Exported JULEA config: ~/.config/julea/config-ant11-ant12"

julea-server &

sleep 200m

killall julea-server
rm -rf /tmp/julea-424242
