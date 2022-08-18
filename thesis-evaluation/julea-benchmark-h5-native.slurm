#!/bin/bash

#SBATCH -N 1 
#SBATCH --partition=parcio
#SBATCH --error=/home/urz/kduwe/thesis_eval/output/benchmark-%j.err --output=/home/urz/kduwe/thesis_eval/output/benchmark-%j.out

# ---------------- Parameters ----------------------------------------
runtime="1"
iterations=10

# ---------------- Cluster Setup ----------------------------------------
export JULEA_PREFIX="/home/urz/kduwe/julea-install"
export HDF5_VOL_CONNECTOR=native


. /home/urz/kduwe/mein-julea/scripts/environment.sh
echo ". /home/urz/kduwe/mein-julea/scripts/environment.sh"


killall julea-server

 julea-config --user \
--object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
--object-backend=posix --object-component=server --object-path="/tmp/julea-$(id -u)/posix" \
--kv-backend=lmdb --kv-component=server --kv-path="/tmp/julea-$(id -u)/lmdb" \
--db-backend=sqlite --db-component=server --db-path="/tmp/julea-$(id -u)/sqlite" --name="$(hostname)-${SLURM_JOBID}"

echo "julea-config --user \
--object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
--object-backend=posix --object-component=server --object-path="/tmp/julea-$(id -u)/posix" \
--kv-backend=lmdb --kv-component=server --kv-path="/tmp/julea-$(id -u)/lmdb" \
--db-backend=sqlite --db-component=server --db-path="/tmp/julea-$(id -u)/sqlite" --name="$(hostname)-${SLURM_JOBID}""

export JULEA_CONFIG="~/.config/julea/$(hostname)-${SLURM_JOBID}"
echo "Exported JULEA config: ~/.config/julea/$(hostname)-${SLURM_JOBID} "
  
for time in $runtime
do 
    # ---------------- Output ----------------------------------------
    file="/home/urz/kduwe/thesis_eval/results-jbench/h5-native/h5-$(hostname)-${SLURM_JOBID}.tsv"

    echo "${file}"

    echo " " >> "${file}"
    echo "# Runtime = $time" >> "${file}"
        
    # for iteration in $iterations
    for ((it = 0; it < $iterations; it++))
    do
        echo "Runtime = $time    Iteration = $it"
        echo " " >> "${file}" 
        echo "# Iteration = $it" >> "${file}"  
        julea-server &

        /home/urz/kduwe/mein-julea/scripts/benchmark.sh -p /hdf5 --duration=$time -v 2 -m  >> "${file}"

        killall julea-server
        rm -rf /tmp/julea-${SLURM_JOBID}
    done
done
