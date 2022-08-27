#!/bin/bash

#SBATCH -N 1 --ntasks-per-node=24
#SBATCH --partition=parcio
#SBATCH --nodelist=ant10 --exclusive
#SBATCH --error=/home/urz/kduwe/thesis_eval/output/heattransfer-%j.err --output=/home/urz/kduwe/thesis_eval/output/heattransfer-%j.out

# ---------------------------------------- HEATTRANSFER PARAMS ----------------------------------------
# processes="4 12 24 48 96 192"
# processes="4 12 24 48 96"
processes="1 3 6 12 24"
sizes="1024 2048 4096"
engines="julea-db"
iterations=10
steps=100

htWriteBin="/home/urz/kduwe/julea-adios2/build/bin/thesis_eval_heatTransfer_write_adios2"
htReadBin="/home/urz/kduwe/julea-adios2/build/bin/thesis_eval_heatTransfer_read"
htQueryBin="/home/urz/kduwe/spack-adios2/build/bin/thesis_eval_heatTransfer_queryAdios"

# ---------------- Cluster Setup ----------------------------------------
# . /opt/spack/main/env.sh
. mein-spack/share/spack/setup-env.sh 
spack load mpi
# echo ". /home/urz/kduwe/mein-julea/scripts/environment.sh"
. /home/urz/kduwe/mein-julea/scripts/environment.sh
spack load mysql
# spack load adios2

export JULEA_PREFIX="/home/urz/kduwe/julea-install"
# export JULEA_CONFIG="~/.config/julea/ant19-mariadb"
export JULEA_CONFIG="/home/urz/kduwe/SlurmScripts/thesis-evaluation/ant10-mariadb"
echo "Exported JULEA config: /home/urz/kduwe/SlurmScripts/thesis-evaluation/ant10-mariadb"

# ------- Setup MariaDB ---------------
mkdir -p /tmp/kduwe/localdb

singularity run --writable-tmpfs -B /tmp/kduwe/localdb:/var/lib/mysql --env MARIADB_RANDOM_ROOT_PASSWORD=yes --env MARIADB_DATABASE=julea_db --env MARIADB_USER=julea_user --env MARIADB_PASSWORD=julea_pw  mariadb.sif &

echo "started Singularity container: sleeping now to give enough time for starting"

sleep 1m


# ------- Start Benchmark ---------------
for engine in $engines
do

	declare -a N 
	N=(1 3 3 4 6)
	M=(1 1 2 3 4)
	i=0

	# ---------------------------------------- Output Files ----------------------------------------
	writeFile="/home/urz/kduwe/thesis_eval/results-ht-q/db/${engine}-271-1node-ceph-write-${SLURM_JOBID}.tsv"
	readFile="/home/urz/kduwe/thesis_eval/results-ht-q/db/${engine}-271-1node-ceph-read-${SLURM_JOBID}.tsv"
	queryFile="/home/urz/kduwe/thesis_eval/results-ht-q/db/${engine}-271-1node-ceph-query-${SLURM_JOBID}.tsv"

	# configFile="../examples/julea_EuroSys2021/heatTransfer/heat_${engine}_sync.xml"
	# configFile="mein-adios-fork/examples/heatTransfer/heat_${engine}_sync.xml"
    configFile="/home/urz/kduwe/julea-adios2/examples/thesis/heatTransfer/heat_${engine}_sync.xml"

	# Will be deleted at the end!
	inputOutput="/home/urz/kduwe/ht-output/heat-${engine}-1node.bp"
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
    		echo mpirun -n $proc -ppn $(($proc/1)) $htWriteBin $configFile $inputOutput ${N[$i]} ${M[$i]}  $size $size $steps $iterations ${engine}
    		mpirun -n $proc -ppn $(($proc/1)) $htWriteBin $configFile $inputOutput ${N[$i]} ${M[$i]}  $size $size $steps $iterations ${engine} >> "${writeFile}"
    		echo "finished writing"

			echo "# File Size:" >> "${writeFile}"
			if [ "${engine}" == "bp3" ];
			then
				ls -lah $inputOutput >> "${writeFile}"
				ls -lah "${inputOutput}.dir" >> "${writeFile}"
			else 
				ls -lah $inputOutput >> "${writeFile}"
			fi

    
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
    		echo mpirun -n $proc -ppn $(($proc/1)) $htReadBin $configFile $inputOutput $analysisOutput ${N[$i]} ${M[$i]} 
    		mpirun -n $proc -ppn $(($proc/1)) $htReadBin $configFile $inputOutput $analysisOutput ${N[$i]} ${M[$i]} >> "${readFile}"
    		echo "finished reading"


			echo "# File Size:" >> "${readFile}"
			if [ "${engine}" == "bp3" ];
			then
				ls -lah $inputOutput >> "${readFile}"
				ls -lah "${inputOutput}.dir" >> "${readFile}"
			else 
				ls -lah $inputOutput >> "${readFile}"
			fi
    
    		# ---------------------------------------- Query ADIOS ----------------------------------------

			if [ "${proc}" == 24 ] && [ "${size}" == 4096 ];
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
				if [ "${engine}" == "bp3" ];
				then
					ls -lah $inputOutput >> "${queryFile}"
					ls -lah "${inputOutput}.dir" >> "${queryFile}"
				else 
					ls -lah $inputOutput >> "${queryFile}"
				fi
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