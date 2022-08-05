#!/bin/bash

#SBATCH -N 4 --ntasks-per-node=24
#SBATCH --partition=parcio
#SBATCH --nodelist=ant20,ant19,ant18,ant17
#SBATCH --error=/home/urz/kduwe/thesis_eval/output/heattransfer-%j.err --output=/home/urz/kduwe/thesis_eval/output/heattransfer-%j.out

# ---------------------------------------- HEATTRANSFER PARAMS ----------------------------------------
# processes="4 12 24 48 96 192"
processes="4 12 24 48 96"
sizes="1024 2048 4096"

engines="bp3 bp4 bp5"

declare -a N 
# N=(2 4 6 8 12 16)
# M=(2 3 4 6 8 12)
N=(2 4 6 8 12)
M=(2 3 4 6 8)

iterations=10
steps=100
i=0


# htWriteBin="/tmp/kduwe/spack-stage/spack-stage-adios2-2.8.3-4fsljmie2zepgprmdtx6if2ogvi7pru7/spack-build-4fsljmi/bin/heatTransfer_write_adios2"
# htReadBin="/tmp/kduwe/spack-stage/spack-stage-adios2-2.8.3-4fsljmie2zepgprmdtx6if2ogvi7pru7/spack-build-4fsljmi/bin/heatTransfer_read"
htWriteBin="/home/urz/kduwe/spack-adios2/spack-build-4fsljmi/bin/heatTransfer_write_adios2"
htReadBin="/home/urz/kduwe/spack-adios2/spack-build-4fsljmi/bin/heatTransfer_read"

# ---------------- Cluster Setup ----------------------------------------
# export JULEA_PREFIX="/home/urz/kduwe/julea-install"

. /opt/spack/main/env.sh
. mein-spack/share/spack/setup-env.sh 
# spack load adios2

# . /home/urz/kduwe/mein-julea/scripts/environment.sh
# echo ". /home/urz/kduwe/mein-julea/scripts/environment.sh"

for engine in $engines
do

	# ---------------------------------------- Output Files ----------------------------------------
	writeFile="/home/urz/kduwe/thesis_eval/results-ht-q/${engine}/${engine}-4node-ceph-write-${SLURM_JOBID}.tsv"
	readFile="/home/urz/kduwe/thesis_eval/results-ht-q/${engine}/${engine}-4node-ceph-read-${SLURM_JOBID}.tsv"
	queryFile="/home/urz/kduwe/thesis_eval/results-ht-q/${engine}/${engine}-4node-ceph-query-${SLURM_JOBID}.tsv"

	configFile="../examples/julea_EuroSys2021/heatTransfer/heat_${engine}_sync.xml"

	# Will be deleted at the end!
	inputOutput="/home/urz/kduwe/ht-output/heat-${engine}-4nodes.bp"
	analysisOutput="/home/urz/kduwe/ht-output/heat-${engine}-analysis-output.bp"

    for proc in $processes
    do
    	for size in $sizes
    	do
    		# ---------------------------------------- Writing ----------------------------------------
    		echo "# i = $i, N = ${N[$i]}, M = ${M[$i]}"
    		echo "# x = $proc, size = $size"
    		echo "# engine = ${engine} "
    
			mpirun -n 24 /tmp/kduwe/spack-stage/spack-stage-adios2-2.8.3-4fsljmie2zepgprmdtx6if2ogvi7pru7/spack-build-4fsljmi/bin/heatTransfer_write_adios2 mein-adios-fork/examples/heatTransfer/heat_bp5_sync.xml ht-output/test-bp5-4096-100.bp 6 4 4096 4096 10 10


    		# echo mpirun -n $proc -ppn $(($proc/4)) ./bin/heatTransfer_write_adios2 $configFile $inputOutput ${N[$i]} ${M[$i]}  $size $size $steps $iterations 
    		echo mpirun -n $proc -ppn $(($proc/4)) $htWriteBin $configFile $inputOutput ${N[$i]} ${M[$i]}  $size $size $steps $iterations 
    		mpirun -n $proc -ppn $(($proc/4)) $htWriteBin $configFile $inputOutput ${N[$i]} ${M[$i]}  $size $size $steps $iterations >> "${writeFile}"
    		echo "finished writing"

			ls -lah $inputOutput >> "${writeFile}"
    
    		# srun sudo /home/hr/drop-caches.sh
    
    		# ---------------------------------------- Reading ----------------------------------------
    
    		echo "# --- Read time in mikroseconds ---" >> "${readFile}"
    		echo "# MPI_Comm_size: $proc" >> "${readFile}"
            echo "# configfile: ${configFile}" >> "${readFile}"
            echo "# inputOutput: ${inputOutput}" >> "${readFile}"
            echo "# analysisOutput: ${analysisOutput}" >> "${readFile}"
    		echo -e "# N \t M \t nx \t ny \t steps \t iterations" >> "${readFile}"
    		echo -e "${N[$i]} \t ${M[$i]} \t $size \t $size \t $steps \t $iterations" >> "${readFile}"
    
    		# echo mpirun -n $proc -ppn $(($proc/4)) ./bin/heatTransfer_read $configFile $inputOutput $analysisOutput ${N[$i]} ${M[$i]} 
    		echo mpirun -n $proc -ppn $(($proc/4)) $htReadBin $configFile $inputOutput $analysisOutput ${N[$i]} ${M[$i]} 
    		mpirun -n $proc -ppn $(($proc/4)) $htReadBin $configFile $inputOutput $analysisOutput ${N[$i]} ${M[$i]} >> "${readFile}"
    		echo "finished reading"
    
    		# ---------------------------------------- Query ADIOS ----------------------------------------
    
    		# echo "# --- QueryAdios time in mikroseconds ---" >> $queryADIOSFile
    		# echo "# MPI_Comm_size: $proc" >> $queryADIOSFile
    		# echo -e "# N \t M \t nx \t ny \t steps \t iterations" >> $queryADIOSFile
    		# echo -e "${N[$i]} \t ${M[$i]} \t $size \t $size \t $steps \t $iterations" >> $queryADIOSFile
    
    		# echo mpirun -n 1 ./bin/julea_heatTransfer_queryAdios $configFile $inputOutput 1 1 
    		# mpirun -n 1 ./bin/julea_heatTransfer_queryAdios $configFile $inputOutput 1 1 >> $queryADIOSFile
    		# echo "finished querying"
    
    		# ---------------------------------------- Clean Up ----------------------------------------
            "/home/urz/kduwe/ht-output/"
    		echo "rm -rf ${inputOutput}"
            rm -rf ${inputOutput}
    		# rm -rf /mnt/lustre/duwe/heat-bp4-4nodes.bp*
    
    		echo "rm -rf ${analysisOutput}"
    		rm -rf ${analysisOutput}
    	done
    	i=$((i+1))
    done
done