#!/bin/bash

#SBATCH --partition=parcio
#SBATCH -N 2 --ntasks-per-node=32
#SBATCH --nodelist=ant11,ant12
#SBATCH --error=/home/urz/kduwe/thesis_eval/output/benchmark-%j.err --output=/home/urz/kduwe/thesis_eval/output/benchmark-%j.out

# ---------------- Parameters ----------------------------------------
# runtimeDB="1 10 60"
iterations=10

# dbClient="mysql"
# dbClient="sqlite mysql" 

# ---------------- Cluster Setup ----------------------------------------
export JULEA_PREFIX="/home/urz/kduwe/julea-install"

. /home/urz/kduwe/mein-julea/scripts/environment.sh
echo ". /home/urz/kduwe/mein-julea/scripts/environment.sh"

spack load mysql

mkdir -p /tmp/kduwe/localdb

singularity run --writable-tmpfs -B /tmp/kduwe/localdb:/var/lib/mysql --env MARIADB_RANDOM_ROOT_PASSWORD=yes --env MARIADB_DATABASE=julea_db --env MARIADB_USER=julea_user --env MARIADB_PASSWORD=julea_pw  mariadb.sif &
sleep 1m


export JULEA_CONFIG="~/.config/julea/$(hostname)-db-mysql-${SLURM_JOBID}"
echo "Exported JULEA config: ~/.config/julea/$(hostname)-db-mysql-${SLURM_JOBID}"

    
julea-server &

if [ $(hostname) == "ant11" ]
then
    mysql -h $(hostname) -u julea_user --password=julea_pw julea_db -e "drop table schema_structure; rop table benchmark_insert_index_single_table; drop table schema_structure;"
fi

/home/urz/kduwe/mein-julea/scripts/benchmark.sh -p /kv --duration=1
sleep 10m

killall julea-server
rm -rf /tmp/julea-${SLURM_JOBID}
