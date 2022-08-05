# Final Runs

## JULEA HDF5 Benchmark

### KV

### DB



## JULEA Benchmark

### DB

#### Large Node:
- SQLite: 551455        (ant10)
- MariaDB (MySQL): 551474 (ant11)
<!-- - MariaDB: 551465       (ant11)    (MySQL in file name) -->

#### Small Node: ant15  551500
<!-- - SQLite: 551464        (ant17) -->
<!-- - MariaDB: 551464       (ant17)    (MySQL in file name) -->

### KV 

#### Large Node: ant10  551498
- LMDB   
- LevelDB
- RocksDB
- SQLite
- SQLite Memory

#### Small Node: ant16 551499
- LMDB
- LevelDB
- SQLite
- SQLite Memory
- RocksDB

### OS

#### Large Node: ant11 551496
- POSIX lokal
- POSIX Ceph

#### Small Node: ant17 551497
- POSIX lokal
- POSIX Ceph

### MISC
Message called in KV Benchmark



# Job List

JobID       Nodes       Final Run?      Script
-----------------------------------------------------------------------------------------------------
551830      ant15       Yes?         sbatch -p parcio -w ant15 -N 1 SlurmScripts/thesis-evaluation/julea-benchmark-h5-db.slurm 
551829      ant10       Yes?         sbatch -p parcio -w ant10 -N 1 SlurmScripts/thesis-evaluation/julea-benchmark-h5-db.slurm 

551828      ant16       Yes?         sbatch -p parcio -w ant16 -N 1 SlurmScripts/thesis-evaluation/julea-benchmark-h5-kv.slurm 
551827      ant11       Yes?         sbatch -p parcio -w ant11 -N 1 SlurmScripts/thesis-evaluation/julea-benchmark-h5-kv.slurm 

<!-- 551826      ant11       No         sbatch -p parcio -w ant11 -N 1 SlurmScripts/thesis-evaluation/julea-benchmark-h5-kv.slurm 
551825      ant16       No         sbatch -p parcio -w ant16 -N 1 SlurmScripts/thesis-evaluation/julea-benchmark-h5-kv.slurm 
551824      ant11       No         sbatch -p parcio -w ant11 -N 1 SlurmScripts/thesis-evaluation/julea-benchmark-h5-kv.slurm 

551823      ant10       Yes?         sbatch -p parcio -w ant10 -N 1 SlurmScripts/thesis-evaluation/julea-benchmark-h5-db.slurm
551822      ant15       Yes?         sbatch -p parcio -w ant15 -N 1 SlurmScripts/thesis-evaluation/julea-benchmark-h5-db.slurm  -->


#### 551500      ant15   **Yes**        sbatch -p parcio -w ant16 -N 1 SlurmScripts/thesis-evaluation/julea-benchmark-db.slurm

#### 551499      ant16   **Yes**        sbatch -p parcio -w ant16 -N 1 SlurmScripts/thesis-evaluation/julea-benchmark-kv.slurm
#### 551498      ant10   **Yes**        sbatch -p parcio -w ant10 -N 1 SlurmScripts/thesis-evaluation/julea-benchmark-kv.slurm

#### 551497      ant17   **Yes**        sbatch -p parcio -w ant17 -N 1 SlurmScripts/thesis-evaluation/julea-benchmark-os.slurm 
#### 551496      ant11   **Yes**        sbatch -p parcio -w ant11 -N 1 SlurmScripts/thesis-evaluation/julea-benchmark-os.slurm

#### 551474      ant11   **Yes**     sbatch -p parcio -w ant11 -N 1 Thesis-results/slurm-scripts/julea-benchmark-db.slurm  (only mariadb)
#### 551455      ant10   **Yes**     sbatch -p parcio -w ant10 -N 1 Thesis-results/slurm-scripts/julea-benchmark.slurm 
-------------------------------------------------------------------------------------------------------------------------

<!-- 551468      ant11                sbatch -p parcio -w ant11 -N 1 Thesis-results/slurm-scripts/julea-benchmark-db.slurm  (db all only mariadb) -->
<!-- 551465      ant11                sbatch -p parcio -w ant11 -N 1 Thesis-results/slurm-scripts/julea-benchmark-db.slurm  (db all only mariadb) -->
<!-- 551464      ant17                sbatch -p parcio -w ant17 -N 1 Thesis-results/slurm-scripts/julea-benchmark-db.slurm (db all) -->
<!-- 551463      ant18                sbatch -p parcio -w ant18 -N 1 Thesis-results/slurm-scripts/julea-benchmark-kv-os.slurm -->
<!-- 551462      ant10                sbatch -p parcio -w ant10 -N 1 Thesis-results/slurm-scripts/julea-benchmark-kv-os.slurm -->
<!-- 551461      ant11                sbatch -p parcio -w ant11 -N 1 Thesis-results/slurm-scripts/julea-benchmark-db.slurm  (iterator) -->

<!-- 551453      ant11                sbatch -p parcio -w ant11 -N 1 thesis_eval/slurm-scripts/julea-benchmark.slurm  -->
<!-- 551452      ant11                srun -p parcio -N 1 -w ant11 slurm-scripts/julea-benchmark.sh -->
<!-- 551451      ant19                srun -p parcio -N 1 -w ant19 slurm-scripts/julea-benchmark.sh -->
<!-- 551449      ant11                srun -p parcio -N 1 -w ant11 slurm-scripts/julea-benchmark.sh -->
<!-- 551444      ant11       ?        srun -p parcio -N 1 -w ant11 slurm-scripts/julea-benchmark.sh        -->


### Configs & Notes

--------------------------------------------------------
<!-- 551461: db iterator run on large node -->
**551462**: kv + rest on large node
-> lmdb -> erste 10 iterationen ok
-> level -> 9/10 iterationen ok
-> rocksdb -> erste 10 iterationen ok -> hier hängen geblieben 
-> misc -> 20 iterationen ok
-> no sqlite
-> no sqlite memory

**551458**: 
-> os: local -> erste 10 iterationen ok

551463: kv + rest on small node
551461: db all run on small node

--------------------------------------------------------
- 551444: runtime="1 10" runtimeDB="1 10 60" iterations=10 kvServer="lmdb leveldb rocksdb sqlite sqlite-memory" dbClient="sqlite mariadb" osServer="posix-local posix-ceph"

<!-- Everything on weaker node -->
- 551451: runtime="1 10" runtimeDB="1 10 60" iterations=10 kvServer="lmdb leveldb rocksdb sqlite sqlite-memory" dbClient="sqlite mariadb" osServer="posix-local posix-ceph"

<!-- Just measure db and following -->
- 551452: runtime="1 10" runtimeDB="1 10 60" iterations=10 kvServer="" dbClient="sqlite mariadb" osServer="posix-local posix-ceph"
<!-- Just measure db and following (fixed outputfile for duration in db)-->
- 551453: runtime="1 10" runtimeDB="1 10 60" iterations=10 kvServer="" dbClient="sqlite mariadb" osServer="posix-local posix-ceph"
- 551445: run db benchmark again without any other benchmarks


-------------- Notes -----------
Debugging DB benchmark

sbatch -p parcio -w ant11 -N 1 Thesis-results/slurm-scripts/julea-benchmark-db.slurm 
Submitted batch job 551468

 JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
551458    parcio julea-be    kduwe  R      20:53      1 ant10
551457    parcio julea-be    kduwe  R      29:46      1 ant11

sbatch -p parcio -w ant11 -N 1 Thesis-results/slurm-scripts/julea-benchmark-db.slurm 
Submitted batch job 551461
kduwe@ants ~ $ sbatch -p parcio -w ant10 -N 1 Thesis-results/slurm-scripts/julea-benchmark-kv-os.slurm 
Submitted batch job 551462
