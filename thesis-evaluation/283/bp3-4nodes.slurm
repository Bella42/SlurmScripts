#!/bin/bash

# set -v
# set -n

#SBATCH -N 4 --ntasks-per-node=24
#SBATCH --partition=parcio
#SBATCH --exclusive
#SBATCH --nodelist=ant20,ant19,ant18,ant17
#SBATCH --error=/home/urz/kduwe/thesis_eval/output/heattransfer-%j.err --output=/home/urz/kduwe/thesis_eval/output/heattransfer-%j.out

# ---------------------------------------- HEATTRANSFER PARAMS ----------------------------------------
# processes="4 12 24 48 96 192"
processes="4 12 24 48 96"
sizes="1024 2048"

engines="bp3"

# declare -a N 
# N=(2 4 6 8 12 16)
# M=(2 3 4 6 8 12)
# N=(2 4 6 8 12)
# M=(2 3 4 6 8)

iterations=10
steps=100
# i=0


# htWriteBin="/tmp/kduwe/spack-stage/spack-stage-adios2-2.8.3-4fsljmie2zepgprmdtx6if2ogvi7pru7/spack-build-4fsljmi/bin/heatTransfer_write_adios2"
# htReadBin="/tmp/kduwe/spack-stage/spack-stage-adios2-2.8.3-4fsljmie2zepgprmdtx6if2ogvi7pru7/spack-build-4fsljmi/bin/heatTransfer_read"
# htWriteBin="/home/urz/kduwe/spack-adios2/spack-build-4fsljmi/bin/heatTransfer_write_adios2"

# with Query application patch
htWriteBin="/home/urz/kduwe/spack-adios2/spack-build-vcltssw/bin/heatTransfer_write_adios2"
htReadBin="/home/urz/kduwe/spack-adios2/spack-build-vcltssw/bin/heatTransfer_read"
htQueryBin="/home/urz/kduwe/spack-adios2/spack-build-vcltssw/bin/thesis_eval_heatTransfer_queryAdios_283"

# ---------------- Cluster Setup ----------------------------------------
# export JULEA_PREFIX="/home/urz/kduwe/julea-install"

# . /opt/spack/main/env.sh
. mein-spack/share/spack/setup-env.sh 
spack load mpi
# spack load adios2

# . /home/urz/kduwe/mein-julea/scripts/environment.sh
# echo ". /home/urz/kduwe/mein-julea/scripts/environment.sh"

for engine in $engines
do

	declare -a N 
	N=(2 4 6 8 12)
	M=(2 3 4 6 8)
	i=0

	# ---------------------------------------- Output Files ----------------------------------------
	writeFile="/home/urz/kduwe/thesis_eval/results-ht-q/${engine}/${engine}-4node-ceph-write-${SLURM_JOBID}.tsv"
	readFile="/home/urz/kduwe/thesis_eval/results-ht-q/${engine}/${engine}-4node-ceph-read-${SLURM_JOBID}.tsv"
	queryFile="/home/urz/kduwe/thesis_eval/results-ht-q/${engine}/${engine}-4node-ceph-query-${SLURM_JOBID}.tsv"

	# configFile="../examples/julea_EuroSys2021/heatTransfer/heat_${engine}_sync.xml"
	configFile="mein-adios-fork/examples/heatTransfer/heat_${engine}_sync.xml"

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
    
			# mpirun -n 24 /tmp/kduwe/spack-stage/spack-stage-adios2-2.8.3-4fsljmie2zepgprmdtx6if2ogvi7pru7/spack-build-4fsljmi/bin/heatTransfer_write_adios2 mein-adios-fork/examples/heatTransfer/heat_bp5_sync.xml ht-output/test-bp5-4096-100.bp 6 4 4096 4096 10 10


    		# echo mpirun -n $proc -ppn $(($proc/4)) ./bin/heatTransfer_write_adios2 $configFile $inputOutput ${N[$i]} ${M[$i]}  $size $size $steps $iterations 
    		echo mpirun -n $proc -ppn $(($proc/4)) $htWriteBin $configFile $inputOutput ${N[$i]} ${M[$i]}  $size $size $steps $iterations 
    		mpirun -n $proc -ppn $(($proc/4)) $htWriteBin $configFile $inputOutput ${N[$i]} ${M[$i]}  $size $size $steps $iterations >> "${writeFile}"
    		echo "finished writing"

			echo "# File Size:" >> "${writeFile}"

			ls -lah $inputOutput >> "${writeFile}"
			ls -lah "${inputOutput}.dir" >> "${writeFile}"

    
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


			echo "# File Size:" >> "${readFile}"

			ls -lah $inputOutput >> "${readFile}"
			ls -lah "${inputOutput}.dir" >> "${readFile}"
    
    		# ---------------------------------------- Query ADIOS ----------------------------------------

			# if [ "${proc}" == 96 ] && [ "${size}" == 4096 ];
			if [ "${proc}" == 96 ];
    		then

    			echo "# --- QueryAdios time in mikroseconds ---" >> "${queryFile}"
    			echo "# MPI_Comm_size: 1" >> "${queryFile}"
    			echo -e "# N \t M \t nx \t ny \t steps \t iterations" >> "${queryFile}"
    			echo -e "${N[$i]} \t ${M[$i]} \t $size \t $size \t $steps \t $iterations" >> "${queryFile}"

				for (( c=1; c<=10; c++ ))
				do  
					echo "# Iteration = $c" >> "${queryFile}"
    				echo mpirun -n 1 $htQueryBin $configFile $inputOutput 1 1 
    				mpirun -n 1 $htQueryBin $configFile $inputOutput 1 1 >> "${queryFile}"
				done
    			echo "finished querying"

				echo "# File Size:" >> "${queryFile}"
			echo "# File Size:" >> "${queryFile}"

			ls -lah $inputOutput >> "${queryFile}"
			ls -lah "${inputOutput}.dir" >> "${queryFile}"
			fi

    		# ---------------------------------------- Clean Up ----------------------------------------
            # "/home/urz/kduwe/ht-output/"
    		echo "rm -rf ${inputOutput}"
            rm -rf ${inputOutput}
    		# rm -rf /mnt/lustre/duwe/heat-bp4-4nodes.bp*
    
    		echo "rm -rf ${analysisOutput}"
    		rm -rf ${analysisOutput}
    	done
    	i=$((i+1))
    done
done