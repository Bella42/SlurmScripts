#!/bin/bash

#SBATCH -N 3 --ntasks-per-node=1 --cpus-per-task=3
# SBATCH -N 3 --ntasks-per-node=1 --cpus-per-task=3
#SBATCH --partition=parcio
#SBATCH --nodelist=ant10,ant11,ant14
#SBATCH --exclusive
#SBATCH --error=/home/urz/kduwe/thesis_eval/output/benchmark-%j.err --output=/home/urz/kduwe/thesis_eval/output/benchmark-%j.out

# ---------------- Parameters ----------------------------------------
runtime="1 10"
# iterations=10
iterations=1

# kvServer="lmdb leveldb rocksdb sqlite sqlite-memory"
osServer="posix"

# ---------------- Cluster Setup ----------------------------------------
export JULEA_PREFIX="/home/urz/kduwe/julea-install"

. /home/urz/kduwe/mein-julea/scripts/environment.sh
echo ". /home/urz/kduwe/mein-julea/scripts/environment.sh"


## ---------------- OS Server ---
for server in $osServer
do 
    # julea-config --user \
    # --object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
    # --object-backend=posix --object-component=server --object-path="/tmp/julea-${SLURM_JOBID}/posix" \
    # --kv-backend=leveldb --kv-component=server --kv-path="/tmp/julea-${SLURM_JOBID}/leveldb" \
    # --db-backend=sqlite --db-component=server --db-path=":memory:" --name="$(hostname)-posix-distributed-object-${SLURM_JOBID}"
            
    # echo " julea-config --user \
    # --object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
    # --object-backend=posix --object-component=server --object-path="/tmp/julea-${SLURM_JOBID}/posix" \
    # --kv-backend=leveldb --kv-component=server --kv-path="/tmp/julea-${SLURM_JOBID}/leveldb" \
    # --db-backend=sqlite --db-component=server --db-path=":memory:" --name="$(hostname)-posix-distributed-object-${SLURM_JOBID}""

    # export JULEA_CONFIG="$(hostname)-posix-distributed-object-${SLURM_JOBID}"
    # echo "Exported JULEA config: ~/.config/julea/$(hostname)-posix-distributed-object-${SLURM_JOBID}"

    # export JULEA_CONFIG="~/.config/julea/ant10-ant11-ant13-dos"
    # echo "Exported JULEA config: ~/.config/julea/ant10-ant11-ant13-dos"
    export JULEA_CONFIG="~/.config/julea/ant10-ant11-ant14-dos"
    echo "Exported JULEA config: ~/.config/julea/ant10-ant11-ant14-dos"
  
        
    for time in $runtime
    do 
        # ---------------- Output ----------------------------------------
        #  results-jbench/kv/kv-lmdb-jobid.tsv
        osServerFile="/home/urz/kduwe/thesis_eval/results-jbench/os/dist-os-${server}-ant10-11-14-${SLURM_JOBID}.tsv"

        echo "${osServerFile}"
        echo " " >> "${osServerFile}"
        echo "# Runtime = $time" >> "${osServerFile}"
        
        # for iteration in $iterations
        for ((it = 0; it < $iterations; it++))
        do
            echo "Runtime = $time    Iteration = $it"
            echo " " >> "${osServerFile}" 
            echo "# Iteration = $it" >> "${osServerFile}"  

            srun julea-server &
            echo "Julea server started"

            # if [[ "$HOSTNAME" = "ant14" ]];
            if [[ $(srun hostname) = "ant14" ]];
            then
                echo "inside if"
                srun hostname
                /home/urz/kduwe/mein-julea/scripts/benchmark.sh -p /object/distributed-object --duration=$time -v 2 -m  >> "${osServerFile}"
                echo "after benchmark"
            fi

            srun killall julea-server
            srun rm -rf /tmp/julea-424242
            # rm -rf /home/urz/kduwe/julea-424242
        done
    done
done
