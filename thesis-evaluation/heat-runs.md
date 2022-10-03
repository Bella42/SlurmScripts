# Final runs

## HeatTransfer


#### BP 283
- 1 node: 588407 (all)
    + 1 node query for every process config: TODO: 596459
- 2 nodes: 588406 (all)
- 4 nodes:
    - BP3: 588383
    - BP4: 588382
    - BP5: 588381
- 6 nodes: TODO: 596450
- 8 nodes: 588408 (all)


#### BP 271
- 1 node:  596376
    + 1 node query for every process config: TODO: 596456
    - BP3:
    - BP4:
- 2 nodes: 596375
    - BP3:
    - BP4:
- 4 nodes: 596374
    - BP3:
    - BP4:
- 6 nodes: 596388 & 596392
    - BP3:
    - BP4:


#### 2 JULEA Servers on ant10/11
<!-- neue ht messungen 271 -->
<!-- https://github.com/julea-io/adios2/commit/2c6b0aa13f1b36329746d607a816441b7521e4e5 -->

##### DB
- 1 node:  
    + 1 node query for every process config: TODO: 
- 2 nodes: TODO: 
- 4 nodes: TODO: 
- 6 nodes: TODO: 596469


##### KV
- 1 node:  
    + 1 node query for every process config: TODO: 
- 2 nodes: TODO: 
- 4 nodes: TODO: 
- 6 nodes: TODO: 596468


### ----------------- FALSCHE CONFIG auf ant10--------------
kduwe@ant10 ~ $ cat .config/julea/julea 
[core]
max-operation-size=0
max-inject-size=0
port=0

[clients]
max-connections=0
stripe-size=0

[servers]
object=ant10;
kv=ant10;
db=ant10;

[object]
backend=posix
component=server
path=/tmp/julea-2567/posix

[kv]
backend=leveldb
component=server
path=/tmp/julea-2567/leveldb

[db]
backend=sqlite
component=server
path=/tmp/julea-2567/sqlite-db



##### DB
- 1 node:  596431
    + 1 node query for every process config: todo 596454
- 2 nodes: 596411
- 4 nodes: 596406
- 6 nodes: 596383, 596386
-> zweimal gemessen zum sichergehen
5963869    -> nur 144 procs


##### KV
- 1 node:  596430
    + 1 node query for every process config: todo 596452
- 2 nodes: 596409
- 4 nodes: 595768
- 6 nodes: 596387









#### 1 JULEA Server on ant11
<!-- -----------------  nur ein juleaserver auf ant11 -->
<!-- alte ht messungen 271 -> zuviel output beim read -->
<!-- https://github.com/julea-io/adios2/commit/9b807d0c2acb4773b1d1dec1ee16b41cadf29bd2 -->


##### KV
- 1 node:  596320
- 2 nodes: 595902
- 4 nodes: 596440
<!-- - 4 nodes: 595768 -->
- 6 nodes: 595903

##### DB
- 1 node:  596328
- 2 nodes: 596318
- 4 nodes: 596327
<!-- - 4 nodes: 596365 -->
- 6 nodes: 595702

<!-- - 1 node:  596319 -->
<!-- -> query fehlt inhalt -->
<!-- - 4 nodes: 
596327 -> letzer query fehlt
595685 -> letzter dai query fehlt -->
<!-- 596326 -> wrong config -->



### Notes

#### 1 Node
sbatch SlurmScripts/thesis-evaluation/bp-engines-1node.slurm 
<!-- Submitted batch job 588403 -->
<!-- Submitted batch job 588404 -->
Submitted batch job 588407

sbatch -p parcio -w ant[20] --exclusive --mem=0 SlurmScripts/thesis-evaluation/ht-jdb-1nodes.slurm 
Submitted batch job 596319

sbatch -p parcio -w ant[20] --exclusive --mem=0 SlurmScripts/thesis-evaluation/ht-jkv-1nodes.slurm 
Submitted batch job 596320


#### 2 Nodes

sbatch SlurmScripts/thesis-evaluation/bp-engines-2nodes.slurm 
<!-- Submitted batch job 588405 -->
Submitted batch job 588406

596318



#### 4 Nodes

<!-- sbatch SlurmScripts/thesis-evaluation/bp-engines-4nodes.slurm 
Submitted batch job 587946

sbatch SlurmScripts/thesis-evaluation/bp4-4nodes.slurm 
Submitted batch job 588222

sbatch SlurmScripts/thesis-evaluation/bp3-4nodes.slurm 
Submitted batch job 588223 -->

588382    parcio bp4-4nod    kduwe PD       0:00      4 (Resources)
588383    parcio bp3-4nod    kduwe PD       0:00      4 (ReqNodeNotAvail, UnavailableNodes:ant[17-20])
588381    parcio bp5-4nod    kduwe  R    2:50:27      4 ant[17-20]



#### 8 Nodes

sbatch SlurmScripts/thesis-evaluation/bp-engines-8nodes.slurm 
Submitted batch job 588408


----------------------------------

<!-- 595903    parcio ht-jkv-6    kduwe  R    1:47:16      6 ant[15-20] -->

<!-- sbatch -p parcio -w ant[19-20] --exclusive --mem=0 SlurmScripts/thesis-evaluation/ht-jkv-2nodes.slurm  -->
Submitted batch job 595902

<!-- sbatch -p parcio -w ant[19-20] --exclusive --mem=0 SlurmScripts/thesis-evaluation/ht-jdb-2nodes.slurm 
Submitted batch job 596318 -->


------------------------------
<!-- Note: abgebrochen, weil query zu lange dauert; schreiben lesen daten sind ok; Reihenfolge getauscht auf eine Iteration zurückgeschraubt -->
<!-- 595684    parcio ht-jdb-4    kduwe  R       1:47      4 ant[15-18] -->
595685    parcio ht-jdb-4    kduwe  R       0:43      4 ant[15-18]

<!-- 595686    parcio ht-jkv-4    kduwe PD       0:00      4 (Resources) -->
595688    parcio ht-jdb-2    kduwe PD       0:00      2 (ReqNodeNotAvail, UnavailableNodes:ant[15-16])
<!-- 595689    parcio ht-jkv-2    kduwe PD       0:00      2 (ReqNodeNotAvail, UnavailableNodes:ant[15-16]) -->
595685    parcio ht-jdb-4    kduwe  R    3:06:00      4 ant[15-18]

sbatch -p parcio -w ant[17-20] --exclusive --mem=0 SlurmScripts/thesis-evaluation/ht-jkv-4nodes.slurm 
Submitted batch job 595768

<!-- -> error for larges process config: potentially because julea-server was full? 595769    parcio ht-jkv-6    kduwe  R      27:42      6 ant[15-20] -->
