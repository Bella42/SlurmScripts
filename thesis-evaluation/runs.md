# Final Runs

## JULEA Benchmark

### DB

#### Large Nodes
- SQLite: 551455        (ant10)
- MariaDB (MySQL): 551474 (ant11)
<!-- - MariaDB: 551465       (ant11)    (MySQL in file name) -->

#### Small Nodes
<!-- - SQLite: 551464        (ant17) -->
<!-- - MariaDB: 551464       (ant17)    (MySQL in file name) -->

### KV & Message & OS

#### Large Nodes    (551462) - ant10
- LMDB
- LevelDB
- SQLite
- SQLite Memory
- RocksDB

- POSIX lokal
- POSIX Ceph

#### Small Nodes (551463)   - ant18
- LMDB
- LevelDB
- SQLite
- SQLite Memory
- RocksDB

- POSIX lokal
- POSIX Ceph



# Job List

JobID       Nodes       Final Run?      Script
-----------------------------------------------------------------------------------------------------

<!-- 551444      ant11       ?              srun -p parcio -N 1 -w ant11 slurm-scripts/julea-benchmark.sh        -->
<!-- 551449      ant11                      srun -p parcio -N 1 -w ant11 slurm-scripts/julea-benchmark.sh -->
<!-- 551451      ant19                      srun -p parcio -N 1 -w ant19 slurm-scripts/julea-benchmark.sh -->
<!-- 551452      ant11                      srun -p parcio -N 1 -w ant11 slurm-scripts/julea-benchmark.sh -->
<!-- 551453      ant11                      sbatch -p parcio -w ant11 -N 1 thesis_eval/slurm-scripts/julea-benchmark.slurm  -->
551455      ant10                      sbatch -p parcio -w ant10 -N 1 Thesis-results/slurm-scripts/julea-benchmark.slurm 
-------------------------------------------------------------------------------------------------------------------------
<!-- 551461      ant11                      sbatch -p parcio -w ant11 -N 1 Thesis-results/slurm-scripts/julea-benchmark-db.slurm  (iterator) -->
551462      ant10                      sbatch -p parcio -w ant10 -N 1 Thesis-results/slurm-scripts/julea-benchmark-kv-os.slurm

551463      ant18                      sbatch -p parcio -w ant18 -N 1 Thesis-results/slurm-scripts/julea-benchmark-kv-os.slurm
551464      ant17                      sbatch -p parcio -w ant17 -N 1 Thesis-results/slurm-scripts/julea-benchmark-db.slurm (db all)

<!-- 551465      ant11                      sbatch -p parcio -w ant11 -N 1 Thesis-results/slurm-scripts/julea-benchmark-db.slurm  (db all only mariadb) -->
551468      ant11                      sbatch -p parcio -w ant11 -N 1 Thesis-results/slurm-scripts/julea-benchmark-db.slurm  (db all only mariadb)
551474      ant11                      sbatch -p parcio -w ant11 -N 1 Thesis-results/slurm-scripts/julea-benchmark-db.slurm  (db all only mariadb)


## Configs & Notes

551461: db iterator run on large node
551462: kv + rest on large node
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
