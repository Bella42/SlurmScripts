#!/bin/bash

#SBATCH -N 1 
#SBATCH --partition=parcio
#SBATCH --error=/home/urz/kduwe/thesis_eval/output/benchmark-%j.err --output=/home/urz/kduwe/thesis_eval/output/benchmark-%j.out

# ---------------- Parameters ----------------------------------------
runtime="1 10"
iterations=10

# kvServer="lmdb leveldb rocksdb sqlite sqlite-memory"
osServer="posix-local posix-ceph"

# ---------------- Cluster Setup ----------------------------------------
export JULEA_PREFIX="/home/urz/kduwe/julea-install"

. /home/urz/kduwe/mein-julea/scripts/environment.sh
echo ". /home/urz/kduwe/mein-julea/scripts/environment.sh"

# spack load mysql

# mkdir -p /tmp/kduwe/localdb

# singularity run --writable-tmpfs -B /tmp/kduwe/localdb:/var/lib/mysql --env MARIADB_RANDOM_ROOT_PASSWORD=yes --env MARIADB_DATABASE=julea_db --env MARIADB_USER=julea_user --env MARIADB_PASSWORD=julea_pw  mariadb.sif &


## ---------------- OS Server ---
for server in $osServer
do 
     killall julea-server
    if [ "${server}" == "posix-local" ];
    then
        julea-config --user \
        --object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
        --object-backend=posix --object-component=server --object-path="/tmp/julea-${SLURM_JOBID}/posix" \
        --kv-backend=leveldb --kv-component=server --kv-path="/tmp/julea-${SLURM_JOBID}/leveldb" \
        --db-backend=sqlite --db-component=server --db-path=":memory:" --name="$(hostname)-posix-local-${SLURM_JOBID}"
            
        echo "julea-config --user \
        --object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
        --object-backend=posix --object-component=server --object-path="/tmp/julea-${SLURM_JOBID}/posix" \
        --kv-backend=leveldb --kv-component=server --kv-path="/tmp/julea-${SLURM_JOBID}/leveldb" \
        --db-backend=sqlite --db-component=server --db-path=":memory:" --name="$(hostname)-posix-local-${SLURM_JOBID}""

        export JULEA_CONFIG="~/.config/julea/$(hostname)-posix-local-${SLURM_JOBID}"
        echo "Exported JULEA config: ~/.config/julea/$(hostname)-posix-local-${SLURM_JOBID} "
    else
        julea-config --user \
        --object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
        --object-backend=posix --object-component=server --object-path="/home/urz/kduwe/julea-${SLURM_JOBID}/posix-ceph" \
        --kv-backend=leveldb --kv-component=server --kv-path="/tmp/julea-${SLURM_JOBID}/leveldb" \
        --db-backend=sqlite --db-component=server --db-path=":memory:" --name="$(hostname)-posix-ceph-${SLURM_JOBID}"

        echo "julea-config --user \
        --object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
        --object-backend=posix --object-component=server --object-path="/home/urz/kduwe/julea-${SLURM_JOBID}/posix-ceph" \
        --kv-backend=leveldb --kv-component=server --kv-path="/tmp/julea-${SLURM_JOBID}/leveldb" \
        --db-backend=sqlite --db-component=server --db-path=":memory:" --name="$(hostname)-posix-ceph-${SLURM_JOBID}""

        export JULEA_CONFIG="~/.config/julea/$(hostname)-posix-ceph-${SLURM_JOBID}"
        echo "Exported JULEA config: ~/.config/julea/$(hostname)-posix-ceph-${SLURM_JOBID} "
    fi
    
        
    for time in $runtime
    do 
        # ---------------- Output ----------------------------------------
        #  results-jbench/kv/kv-lmdb-jobid.tsv
        osServerFile="/home/urz/kduwe/thesis_eval/results-jbench/os/os-${server}-$(hostname)-${SLURM_JOBID}.tsv"

        echo "${osServerFile}"
        echo " " >> "${osServerFile}"
        echo "# Runtime = $time" >> "${osServerFile}"
        
        # for iteration in $iterations
        for ((it = 0; it < $iterations; it++))
        do
            echo "Runtime = $time    Iteration = $it"
            echo " " >> "${osServerFile}" 
            echo "# Iteration = $it" >> "${osServerFile}"  

            julea-server &

            /home/urz/kduwe/original-julea/scripts/benchmark.sh -p /object --duration=$time -v 2 -m  >> "${osServerFile}"

            killall julea-server
            rm -rf /tmp/julea-${SLURM_JOBID}
            rm -rf /home/urz/kduwe/julea-${SLURM_JOBID}
        done
    done
done
