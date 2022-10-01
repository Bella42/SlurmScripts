# Final runs

## HeatTransfer



##### DB
- 1 node:  596328
- 2 nodes: 596318
- 4 nodes: 596327
- 6 nodes: 595702

<!-- - 1 node:  596319 -->
<!-- -> query fehlt inhalt -->
<!-- - 4 nodes: 
595685 -> letzter dai query fehlt -->
<!-- 596326 -> wrong config -->

##### KV
- 1 node:  596320
- 2 nodes: 595902
- 4 nodes: 595768
- 6 nodes: 595903


##### BP
- 1 node: 588407 (all)
- 2 nodes: 588406 (all)
- 4 nodes:
    - BP3: 588383
    - BP4: 588382
    - BP5: 588381
- 6 nodes:
- 8 nodes: 588408 (all)



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
