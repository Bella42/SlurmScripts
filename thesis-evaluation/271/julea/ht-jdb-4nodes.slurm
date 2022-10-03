#!/bin/bash

#SBATCH -N 4 --ntasks-per-node=24
#SBATCH --partition=parcio
#SBATCH --error=/home/urz/kduwe/thesis_eval/output/heattransfer-%j.err --output=/home/urz/kduwe/thesis_eval/output/heattransfer-%j.out

# ---------------------------------------- HEATTRANSFER PARAMS ----------------------------------------
# processes="1 3 6 12 24"
processes="4 12 24 48 96"
sizes="1024"
engines="julea-db"
iterations=10
steps=100

htWriteBin="/home/urz/kduwe/julea-adios2/build/bin/thesis_eval_heatTransfer_write_adios2"
htReadBin="/home/urz/kduwe/julea-adios2/build/bin/thesis_eval_heatTransfer_read"
htADIOSQueryBin="/home/urz/kduwe/julea-adios2/build/bin/thesis_eval_heatTransfer_queryAdios"
htDAIQueryBin="/home/urz/kduwe/julea-adios2/build/bin/thesis_eval_heatTransfer_queryDAI"

# osServer="/tmp/julea-551823/posix"
# kvServer="/tmp/julea-551823/leveldb"
# dbServer="/tmp/kduwe/localdb:/var/lib/mysql"

# ---------------- Cluster Setup ----------------------------------------
# . /opt/spack/main/env.sh
. mein-spack/share/spack/setup-env.sh 
spack load mpi
. /home/urz/kduwe/mein-julea/scripts/environment.sh
# echo ". /home/urz/kduwe/mein-julea/scripts/environment.sh"
spack load mysql
# spack load adios2

sleep 5m

export JULEA_PREFIX="/home/urz/kduwe/julea-install"

# export JULEA_CONFIG="/home/urz/kduwe/.config/julea/test-1-server"
export JULEA_CONFIG="/home/urz/kduwe/.config/julea/ant11-db-mysql"
echo "Exported JULEA config: /home/urz/kduwe/.config/julea/ant11-db-mysql"

# ------- Start Benchmark ---------------
for engine in $engines
do

	declare -a N 
	# N=(1 3 3 4 6)
	# M=(1 1 2 3 4)

    N=(2 4 6 8 16)
	M=(2 3 4 6 6)
	i=0

	# ---------------------------------------- Output Files ----------------------------------------
	writeFile="/home/urz/kduwe/thesis_eval/results-ht-q/db/${engine}-4node-$(hostname)-write-${SLURM_JOBID}.tsv"
	readFile="/home/urz/kduwe/thesis_eval/results-ht-q/db/${engine}-4node-$(hostname)-read-${SLURM_JOBID}.tsv"
	queryADIOSFile="/home/urz/kduwe/thesis_eval/results-ht-q/db/${engine}-4node-$(hostname)-query-${SLURM_JOBID}.tsv"
	queryDAIFile="/home/urz/kduwe/thesis_eval/results-ht-q/db/${engine}-4node-$(hostname)-query-dai-${SLURM_JOBID}.tsv"


	# configFile="../examples/julea_EuroSys2021/heatTransfer/heat_${engine}_sync.xml"
	# configFile="mein-adios-fork/examples/heatTransfer/heat_${engine}_sync.xml"
    configFile="/home/urz/kduwe/julea-adios2/examples/thesis/heatTransfer/heat_${engine}.xml"

    # inputOutput="/home/urz/kduwe/ht-output/heat-${engine}-4node.bp"
	# analysisOutput="/home/urz/kduwe/ht-output/heat-${engine}-analysis-output.bp"

    for proc in $processes
    do
	    # Will be deleted at the end!
	    inputOutput="/home/urz/kduwe/ht-output/heat-${engine}-${proc}-4node.bp"
	    analysisOutput="/home/urz/kduwe/ht-output/heat-${engine}-${proc}-analysis-output.bp"
    	for size in $sizes
    	do
            # ----------------------------- Make sure DB is emptied ----------------------------------------
            mysql -h ant11 -u julea_user --password=julea_pw julea_db -e "drop table adios2_Thesis_eval_ColderThanMinus12; drop table adios2_Thesis_eval_block-metadata; drop table adios2_Thesis_eval_climate-indices; drop table adios2_Thesis_eval_config_precompute; drop table adios2_Thesis_eval_config_tags; drop table adios2_Thesis_eval_daily-global-statistics; drop table adios2_Thesis_eval_variable-metadata; drop table schema_structure;"

    		# ---------------------------------------- Writing ----------------------------------------
    		echo "# i = $i, N = ${N[$i]}, M = ${M[$i]}"
    		echo "# x = $proc, size = $size"
    		echo "# engine = ${engine} "
    
    		# echo mpirun -n $proc -ppn $(($proc/4)) ./bin/heatTransfer_write_adios2 $configFile $inputOutput ${N[$i]} ${M[$i]}  $size $size $steps $iterations 
    		echo mpirun -n $proc -ppn $(($proc/1)) $htWriteBin $configFile $inputOutput ${N[$i]} ${M[$i]}  $size $size $steps $iterations ${engine}
    		mpirun -n $proc -ppn $(($proc/1)) $htWriteBin $configFile $inputOutput ${N[$i]} ${M[$i]}  $size $size $steps $iterations ${engine} >> "${writeFile}"
    		echo "finished writing"

			# echo "# File Size:" >> "${writeFile}"
			# ls -lah $osServer >> "${writeFile}"
			# ls -lah $kvServer >> "${writeFile}"
			# ls -lah $dbServer >> "${writeFile}"
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


			# echo "# File Size:" >> "${readFile}"
			# ls -lah $osServer >> "${readFile}"
			# ls -lah $kvServer >> "${readFile}"
			# ls -lah $dbServer >> "${readFile}"

            # ---------------------------------------- Query DAI ----------------------------------------
			if [ "${proc}" == 96 ];
    		then

    			echo "# --- QueryDAI time in mikroseconds ---" >> "${queryDAIFile}"
    			echo "# MPI_Comm_size: 1" >> "${queryDAIFile}"
    			echo -e "# N \t M \t nx \t ny \t steps \t iterations" >> "${queryDAIFile}"
    			echo -e "${N[$i]} \t ${M[$i]} \t $size \t $size \t $steps \t $iterations" >> "${queryDAIFile}"

				for (( c=1; c<=10; c++ ))
				do  
					echo "# Iteration = $c" >> "${queryDAIFile}"
    				echo mpirun -n 1 $htDAIQueryBin $configFile $inputOutput 1 1 
    				mpirun -n 1 $htDAIQueryBin $configFile $inputOutput 1 1 >> "${queryDAIFile}"
				done
    			echo "finished querying"

				# echo "# File Size:" >> "${queryDAIFile}"
				# ls -lah $osServer >> "${queryFile}"
				# ls -lah $kvServer >> "${queryFile}"
				# ls -lah $dbServer >> "${queryFile}"

			fi

    		# ---------------------------------------- Query ADIOS ----------------------------------------

			if [ "${proc}" == 96 ];
    		then

    			echo "# --- QueryAdios time in mikroseconds ---" >> "${queryADIOSFile}"
    			echo "# MPI_Comm_size: 1" >> "${queryADIOSFile}"
    			echo -e "# N \t M \t nx \t ny \t steps \t iterations" >> "${queryADIOSFile}"
    			echo -e "${N[$i]} \t ${M[$i]} \t $size \t $size \t $steps \t $iterations" >> "${queryADIOSFile}"

				for (( c=1; c<=1; c++ ))
				do  
					echo "# Iteration = $c" >> "${queryADIOSFile}"
    				echo mpirun -n 1 $htADIOSQueryBin $configFile $inputOutput 1 1 
    				mpirun -n 1 $htADIOSQueryBin $configFile $inputOutput 1 1 >> "${queryADIOSFile}"
				done
    			echo "finished querying"

				# echo "# File Size:" >> "${queryADIOSFile}"
				# ls -lah $osServer >> "${queryFile}"
				# ls -lah $kvServer >> "${queryFile}"
				# ls -lah $dbServer >> "${queryFile}"

			fi


    		# ---------------------------------------- Clean Up ----------------------------------------
			# killall julea-server
            # rm -rf /tmp/julea-551823

            # "/home/urz/kduwe/ht-output/"
    		echo "rm -rf ${inputOutput}"
            rm -rf ${inputOutput}
    		# rm -rf /mnt/lustre/duwe/heat-bp4-4nodes.bp*
    
    		# echo "rm -rf ${analysisOutput}"
    		# rm -rf ${analysisOutput}
    	done
    	i=$((i+1))
    done
done