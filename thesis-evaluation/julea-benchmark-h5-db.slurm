#!/bin/bash

#SBATCH -N 1 
#SBATCH --partition=parcio
#SBATCH --error=/home/urz/kduwe/thesis_eval/output/benchmark-%j.err --output=/home/urz/kduwe/thesis_eval/output/benchmark-%j.out

# ---------------- Parameters ----------------------------------------
runtimeDB="1 10 60"
iterations=10

# dbClient="mysql"
dbClient="sqlite mysql"

# ---------------- Cluster Setup ----------------------------------------
export JULEA_PREFIX="/home/urz/kduwe/julea-install"
export HDF5_VOL_CONNECTOR=julea-db

. /home/urz/kduwe/mein-julea/scripts/environment.sh
echo ". /home/urz/kduwe/mein-julea/scripts/environment.sh"

spack load mysql

mkdir -p /tmp/kduwe/localdb

singularity run --writable-tmpfs -B /tmp/kduwe/localdb:/var/lib/mysql --env MARIADB_RANDOM_ROOT_PASSWORD=yes --env MARIADB_DATABASE=julea_db --env MARIADB_USER=julea_user --env MARIADB_PASSWORD=julea_pw  mariadb.sif &

echo "started Singularity container: sleeping now to give enough time for starting"

sleep 1m


# ---------------- DB ---
for server in $dbClient
do 
     killall julea-server
    if [ "${server}" == "sqlite" ];
    then
        julea-config --user \
        --object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
        --object-backend=posix --object-component=server --object-path="/tmp/julea-${SLURM_JOBID}/posix" \
        --kv-backend=leveldb --kv-component=server --kv-path="/tmp/julea-${SLURM_JOBID}/leveldb" \
        --db-backend=${server} --db-component=server --db-path=":memory:" --name="$(hostname)-db-sqlite-${SLURM_JOBID}"
            
        echo " julea-config --user \
        --object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
        --object-backend=posix --object-component=server --object-path="/tmp/julea-${SLURM_JOBID}/posix" \
        --kv-backend=leveldb --kv-component=server --kv-path="/tmp/julea-${SLURM_JOBID}/leveldb" \
        --db-backend=${server} --db-component=server --db-path=":memory:" --name="$(hostname)-db-sqlite-${SLURM_JOBID}""

        export JULEA_CONFIG="~/.config/julea/$(hostname)-db-sqlite-${SLURM_JOBID}"
        echo "Exported JULEA config: ~/.config/julea/$(hostname)-db-sqlite-${SLURM_JOBID}"
    else
         julea-config --user \
        --object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
        --object-backend=posix --object-component=server --object-path="/tmp/julea-${SLURM_JOBID}/posix" \
        --kv-backend=leveldb --kv-component=server --kv-path="/tmp/julea-${SLURM_JOBID}/leveldb" \
        --db-backend=${server} --db-component=client --db-path="$(hostname):julea_db:julea_user:julea_pw" --name="$(hostname)-db-mysql-${SLURM_JOBID}"

        echo "julea-config --user \
        --object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
        --object-backend=posix --object-component=server --object-path="/tmp/julea-${SLURM_JOBID}/posix" \
        --kv-backend=leveldb --kv-component=server --kv-path="/tmp/julea-${SLURM_JOBID}/leveldb" \
        --db-backend=${server} --db-component=client --db-path="$(hostname):julea_db:julea_user:julea_pw" --name="$(hostname)-db-mysql-${SLURM_JOBID}""

        export JULEA_CONFIG="~/.config/julea/$(hostname)-db-mysql-${SLURM_JOBID}"
        echo "Exported JULEA config: ~/.config/julea/$(hostname)-db-mysql-${SLURM_JOBID}"
    fi
    
        
    for time in $runtimeDB
    do 
        # ---------------- Output ----------------------------------------
        dbServerFile="/home/urz/kduwe/thesis_eval/results-jbench/h5-db/h5-db-${server}-$(hostname)-${SLURM_JOBID}.tsv"

        echo "${dbServerFile}"
        echo " " >> "${dbServerFile}"
        echo "# Runtime = $time" >> "${dbServerFile}"
        
        for ((it = 0; it < $iterations; it++))
        do
            echo "Runtime = $time    Iteration = $it"
            echo " " >> "${dbServerFile}" 
            echo "# Iteration = $it" >> "${dbServerFile}"  
            julea-server &

            if [ $(hostname) == "ant10" || $(hostname) == "ant11"]
            then
                mysql -h $(hostname) -u julea_user --password=julea_pw julea_db -e "drop table schema_structure; rop table benchmark_insert_index_single_table; drop table schema_structure;"
            fi

            /home/urz/kduwe/mein-julea/scripts/benchmark.sh -p /hdf5 --duration=$time -v 2 -m  >> "${dbServerFile}"

            killall julea-server
            rm -rf /tmp/julea-${SLURM_JOBID}
        done
    done
done
