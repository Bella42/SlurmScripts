#!/bin/bash

#SBATCH -N 1 --ntasks-per-node=3 --partition=parcio --nodelist=ant10 --exclusive
#SBATCH hetjob
#SBATCH -N 1 --ntasks-per-node=3 --partition=parcio --nodelist=ant11 --exclusive
#SBATCH hetjob
#SBATCH -N 1 --ntasks-per-node=6 --partition=parcio --nodelist=ant14 --exclusive

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

            # srun julea-server & 

            host10=$(srun --het-group=0 hostname)
            host11=$(srun --het-group=1 hostname)
            host14=$(srun --het-group=2 hostname)

            echo {$host10}
            echo {$host11}
            echo {$host14}

            srun --het-group=0 julea-server --daemon --host "${host10}" : --het-group=1 julea-server --daemon --host "${host11}" : --het-group=2 julea-server --daemon --host "${host14}" 
            
            echo "Julea server started"

            # if [[ "$HOSTNAME" = "ant14" ]];
            # if [[ $(srun hostname) = "ant14" ]];
            # then
            #     echo "inside if"

            srun --het-group=2 /home/urz/kduwe/mein-julea/scripts/benchmark.sh -p /object/distributed-object --duration=$time -v 2 -m  >> "${osServerFile}"
            #     echo "after benchmark"
            # fi

            srun --het-group=0,1,2 killall julea-server
            srun --het-group=0,1,2 rm -rf /tmp/julea-424242
            # rm -rf /home/urz/kduwe/julea-424242
        done
    done
done
