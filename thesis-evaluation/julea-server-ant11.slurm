#!/bin/bash

#SBATCH --partition=parcio
#SBATCH -N 1 --ntasks-per-node=32
#SBATCH --nodelist=ant11
#SBATCH --error=/home/urz/kduwe/thesis_eval/output/benchmark-%j.err --output=/home/urz/kduwe/thesis_eval/output/benchmark-%j.out

export JULEA_PREFIX="/home/urz/kduwe/julea-install"

. /home/urz/kduwe/mein-julea/scripts/environment.sh
echo ". /home/urz/kduwe/mein-julea/scripts/environment.sh"

spack load mysql

mkdir -p /tmp/kduwe/localdb

singularity run --writable-tmpfs -B /tmp/kduwe/localdb:/var/lib/mysql --env MARIADB_RANDOM_ROOT_PASSWORD=yes --env MARIADB_DATABASE=julea_db --env MARIADB_USER=julea_user --env MARIADB_PASSWORD=julea_pw  mariadb.sif &
sleep 1m

# export JULEA_CONFIG="/home/urz/kduwe/.config/julea/config-ant11-ant12"
# echo "Exported JULEA config: /home/urz/kduwe/.config/julea/config-ant11-ant12"


julea-config --user \
--object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
--object-backend=posix --object-component=server --object-path="/tmp/julea-${SLURM_JOBID}/posix" \
--kv-backend=leveldb --kv-component=server --kv-path="/tmp/julea-${SLURM_JOBID}/leveldb" \
--db-backend=mysql --db-component=client --db-path="$(hostname):julea_db:julea_user:julea_pw" --name="$(hostname)-db-mysql"

echo "julea-config --user \
--object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
--object-backend=posix --object-component=server --object-path="/tmp/julea-${SLURM_JOBID}/posix" \
--kv-backend=leveldb --kv-component=server --kv-path="/tmp/julea-${SLURM_JOBID}/leveldb" \
--db-backend=mysql --db-component=client --db-path="$(hostname):julea_db:julea_user:julea_pw" --name="$(hostname)-db-mysql""

export JULEA_CONFIG="~/.config/julea/$(hostname)-db-mysql"
echo "Exported JULEA config: ~/.config/julea/$(hostname)-db-mysql"

julea-server &

sleep 400m

killall julea-server
rm -rf /tmp/julea-424242
