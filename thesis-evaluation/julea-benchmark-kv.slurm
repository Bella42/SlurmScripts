#!/bin/bash

#SBATCH -N 1 
#SBATCH --partition=parcio
#SBATCH --error=/home/urz/kduwe/thesis_eval/output/benchmark-%j.err --output=/home/urz/kduwe/thesis_eval/output/benchmark-%j.out

# ---------------- Parameters ----------------------------------------
runtime="1 10"
iterations=10

kvServer="lmdb leveldb rocksdb sqlite sqlite-memory"

# ---------------- Cluster Setup ----------------------------------------
export JULEA_PREFIX="/home/urz/kduwe/julea-install"

. /home/urz/kduwe/mein-julea/scripts/environment.sh
echo ". /home/urz/kduwe/mein-julea/scripts/environment.sh"

# spack load mysql

# mkdir -p /tmp/kduwe/localdb

# singularity run --writable-tmpfs -B /tmp/kduwe/localdb:/var/lib/mysql --env MARIADB_RANDOM_ROOT_PASSWORD=yes --env MARIADB_DATABASE=julea_db --env MARIADB_USER=julea_user --env MARIADB_PASSWORD=julea_pw  mariadb.sif &


# ---------------- KV Server ---
for server in $kvServer
do 
     killall julea-server
    if [ "${server}" == "sqlite-memory" ];
    then
         julea-config --user \
        --object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
        --object-backend=posix --object-component=server --object-path="/tmp/julea-${SLURM_JOBID}/posix" \
        --kv-backend=sqlite --kv-component=server --kv-path=":memory:" \
        --db-backend=sqlite --db-component=server --db-path="/tmp/julea-${SLURM_JOBID}/sqlite-db" --name="$(hostname)-kv-sqlite-memory-${SLURM_JOBID}"

        echo "julea-config --user \
        --object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
        --object-backend=posix --object-component=server --object-path="/tmp/julea-${SLURM_JOBID}/posix" \
        --kv-backend=sqlite --kv-component=server --kv-path=":memory" \
        --db-backend=sqlite --db-component=server --db-path="/tmp/julea-${SLURM_JOBID}/sqlite-db" --name="$(hostname)-kv-sqlite-memory-${SLURM_JOBID}""

        export JULEA_CONFIG="~/.config/julea/$(hostname)-kv-sqlite-memory-${SLURM_JOBID}"
        echo "Exported JULEA config: ~/.config/julea/$(hostname)-kv-sqlite-memory-${SLURM_JOBID} "
    else
        julea-config --user \
        --object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
        --object-backend=posix --object-component=server --object-path="/tmp/julea-${SLURM_JOBID}/posix" \
        --kv-backend=${server} --kv-component=server --kv-path="/tmp/julea-${SLURM_JOBID}/${server}" \
        --db-backend=sqlite --db-component=server --db-path="/tmp/julea-${SLURM_JOBID}/sqlite-db"  --name="$(hostname)-kv-${server}-${SLURM_JOBID}"

        echo "julea-config --user \
        --object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
        --object-backend=posix --object-component=server --object-path="/tmp/julea-${SLURM_JOBID}/posix" \
        --kv-backend=${server} --kv-component=server --kv-path="/tmp/julea-${SLURM_JOBID}/${server}" \
        --db-backend=sqlite --db-component=server --db-path="/tmp/julea-${SLURM_JOBID}/sqlite-db" --name="$(hostname)-kv-${server}-${SLURM_JOBID}""

        export JULEA_CONFIG="~/.config/julea/$(hostname)-kv-${server}-${SLURM_JOBID}"
        echo "Exported JULEA config: ~/.config/julea/$(hostname)-kv-${server}-${SLURM_JOBID}"
    fi
    

    for time in $runtime
    do 
        # ---------------- Output ----------------------------------------
        kvServerFile="/home/urz/kduwe/thesis_eval/results-jbench/kv/kv-${server}-$(hostname)-${SLURM_JOBID}.tsv"
        messageFile="/home/urz/kduwe/thesis_eval/results-jbench/misc/misc-${server}-$(hostname)-${SLURM_JOBID}.tsv"

        echo "${kvServerFile}"

        echo " " >> "${kvServerFile}"
        echo "# Runtime = $time" >> "${kvServerFile}"
        
        # for iteration in $iterations
        for ((it = 0; it < $iterations; it++))
        do
            echo "Runtime = $time    Iteration = $it"
            echo " " >> "${kvServerFile}" 
            echo "# Iteration = $it" >> "${kvServerFile}"  
            julea-server &

            /home/urz/kduwe/mein-julea/scripts/benchmark.sh -p /kv --duration=$time -v 2 -m  >> "${kvServerFile}"

            # measure rest of benchmarks once as well (easier to call in here instead of writing another large loop)
            if [ "${server}" == "leveldb" ];
            then
                echo "Runtime = $time    Iteration = $it"
                echo " " >> "${messageFile}" 
                echo "# Iteration = $it" >> "${messageFile}" 
                /home/urz/kduwe/mein-julea/scripts/benchmark.sh -p /message --duration=$time -v 2 -m  >> "${messageFile}"
            fi

            killall julea-server
            rm -rf /tmp/julea-${SLURM_JOBID}
        done
    done
done