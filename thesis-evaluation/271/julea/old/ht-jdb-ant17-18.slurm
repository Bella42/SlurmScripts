#!/bin/bash

#SBATCH --partition=parcio
#SBATCH -w ant[17-18]
# Redirect output and error output
#SBATCH --error=/home/urz/kduwe/thesis_eval/output/heattransfer-%j.err --output=/home/urz/kduwe/thesis_eval/output/heattransfer-%j.out

# ---------------------------------------- HEATTRANSFER PARAMS ----------------------------------------
# processes="1 3 6 12 24"
processes="2 6 12 24 48"
sizes="1024"
engines="julea-db"
iterations=10
steps=100
# steps=100

htWriteBin="/home/urz/kduwe/julea-adios2/build/bin/thesis_eval_heatTransfer_write_adios2"
htReadBin="/home/urz/kduwe/julea-adios2/build/bin/thesis_eval_heatTransfer_read"
htADIOSQueryBin="/home/urz/kduwe/julea-adios2/build/bin/thesis_eval_heatTransfer_queryAdios"
htDAIQueryBin="/home/urz/kduwe/julea-adios2/build/bin/thesis_eval_heatTransfer_queryDAI"


# ---------------- Cluster Setup ----------------------------------------
# . /opt/spack/main/env.sh
. mein-spack/share/spack/setup-env.sh 
spack load mpi
. /home/urz/kduwe/mein-julea/scripts/environment.sh
# echo ". /home/urz/kduwe/mein-julea/scripts/environment.sh"
spack load mysql
# spack load adios2

mkdir -p /tmp/kduwe/localdb

singularity run --writable-tmpfs -B /tmp/kduwe/localdb:/var/lib/mysql --env MARIADB_RANDOM_ROOT_PASSWORD=yes --env MARIADB_DATABASE=julea_db --env MARIADB_USER=julea_user --env MARIADB_PASSWORD=julea_pw  mariadb.sif &
sleep 1m


export JULEA_PREFIX="/home/urz/kduwe/julea-install"
# export JULEA_CONFIG="/home/urz/kduwe/.config/julea/ant11-db-mysql"
export JULEA_CONFIG="/home/urz/kduwe/.config/julea/ant17-18-mariadb"
echo "Exported JULEA config: /home/urz/kduwe/.config/julea/ant17-18-mariadb"


# ------- Start Benchmark ---------------
for engine in $engines
do

	declare -a N 
	N=(1 3 3 4 6)
	M=(1 1 2 3 4)
	i=0

	# ---------------------------------------- Output Files ----------------------------------------
	writeFile="/home/urz/kduwe/thesis_eval/results-ht-q/db/${engine}-1node-$(hostname)-write-${SLURM_JOBID}.tsv"
	readFile="/home/urz/kduwe/thesis_eval/results-ht-q/db/${engine}-1node-$(hostname)-read-${SLURM_JOBID}.tsv"
	queryADIOSFile="/home/urz/kduwe/thesis_eval/results-ht-q/db/${engine}-1node-$(hostname)-query-${SLURM_JOBID}.tsv"
	queryDAIFile="/home/urz/kduwe/thesis_eval/results-ht-q/kv/${engine}-1node-$(hostname)-query-dai-${SLURM_JOBID}.tsv"


	# configFile="../examples/julea_EuroSys2021/heatTransfer/heat_${engine}_sync.xml"
	# configFile="mein-adios-fork/examples/heatTransfer/heat_${engine}_sync.xml"
    configFile="/home/urz/kduwe/julea-adios2/examples/thesis/heatTransfer/heat_${engine}.xml"

	# Will be deleted at the end!
	inputOutput="/home/urz/kduwe/ht-output/heat-${engine}-1node.bp"
	analysisOutput="/home/urz/kduwe/ht-output/heat-${engine}-analysis-output.bp"

    for proc in $processes
    do
    	for size in $sizes
    	do
            killall julea-server

            # mysql -h $(hostname) -u julea_user --password=julea_pw julea_db -e "drop table schema_structure; drop table benchmark_insert_index_single_table; drop table schema_structure;"
            mysql -h $(hostname) -u julea_user --password=julea_pw julea_db -e "drop table adios2_Thesis_eval_ColderThanMinus12; drop table adios2_Thesis_eval_block-metadata; drop table adios2_Thesis_eval_climate-indices; drop table adios2_Thesis_eval_config_precompute; drop table adios2_Thesis_eval_config_tags; drop table adios2_Thesis_eval_daily-global-statistics; drop table adios2_Thesis_eval_variable-metadata; drop table adios2_block-metadata; drop table adios2_variable-metadata; drop table schema_structure;"

			# julea-server &
            srun -w ant[17-18] rm -rf /tmp/kduwe/julea
            srun -w ant[17-18] --exact --overlap julea-server &
            sleep 20s




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
	
			ls -lah $osServer >> "${writeFile}"
			ls -lah $kvServer >> "${writeFile}"
			ls -lah $dbServer >> "${writeFile}"

    
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
	
			ls -lah $osServer >> "${readFile}"
			ls -lah $kvServer >> "${readFile}"
			ls -lah $dbServer >> "${readFile}"

    
    		# ---------------------------------------- Query ADIOS ----------------------------------------

			if [ "${proc}" == 24 ];
    		then

    			echo "# --- QueryAdios time in mikroseconds ---" >> "${queryADIOSFile}"
    			echo "# MPI_Comm_size: 1" >> "${queryADIOSFile}"
    			echo -e "# N \t M \t nx \t ny \t steps \t iterations" >> "${queryADIOSFile}"
    			echo -e "${N[$i]} \t ${M[$i]} \t $size \t $size \t $steps \t $iterations" >> "${queryADIOSFile}"

				for (( c=1; c<=10; c++ ))
				do  
					echo "# Iteration = $c" >> "${queryADIOSFile}"
    				echo mpirun -n 1 $htADIOSQueryBin $configFile $inputOutput 1 1 
    				mpirun -n 1 $htADIOSQueryBin $configFile $inputOutput 1 1 >> "${queryADIOSFile}"
				done
    			echo "finished querying"

				echo "# File Size:" >> "${queryADIOSFile}"

				ls -lah $osServer >> "${queryADIOSFile}"
				ls -lah $kvServer >> "${queryADIOSFile}"
				ls -lah $dbServer >> "${queryADIOSFile}"

			fi


    		# ---------------------------------------- Query DAI ----------------------------------------
			if [ "${proc}" == 24 ];
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

				echo "# File Size:" >> "${queryDAIFile}"

				ls -lah $osServer >> "${queryDAIFile}"
				ls -lah $kvServer >> "${queryDAIFile}"
				ls -lah $dbServer >> "${queryDAIFile}"

			fi

    		# ---------------------------------------- Clean Up ----------------------------------------
			# killall julea-server
            srun -w ant[17-18] --exact killall -v julea-server

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






































