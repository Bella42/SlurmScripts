# Final runs

## HeatTransfer


### Notes

#### 1 Node
sbatch SlurmScripts/thesis-evaluation/bp-engines-1node.slurm 
<!-- Submitted batch job 588403 -->
<!-- Submitted batch job 588404 -->
Submitted batch job 588407

#### 2 Nodes

sbatch SlurmScripts/thesis-evaluation/bp-engines-2nodes.slurm 
<!-- Submitted batch job 588405 -->
Submitted batch job 588406

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

<!-- Note: abgebrochen, weil query zu lange dauert; schreiben lesen daten sind ok; Reihenfolge getauscht auf eine Iteration zurückgeschraubt -->
<!-- 595684    parcio ht-jdb-4    kduwe  R       1:47      4 ant[15-18] -->

595685    parcio ht-jdb-4    kduwe  R       0:43      4 ant[15-18]

595686    parcio ht-jkv-4    kduwe PD       0:00      4 (Resources)
595688    parcio ht-jdb-2    kduwe PD       0:00      2 (ReqNodeNotAvail, UnavailableNodes:ant[15-16])
595689    parcio ht-jkv-2    kduwe PD       0:00      2 (ReqNodeNotAvail, UnavailableNodes:ant[15-16])
595685    parcio ht-jdb-4    kduwe  R    3:06:00      4 ant[15-18]


#### 8 Nodes

sbatch SlurmScripts/thesis-evaluation/bp-engines-8nodes.slurm 
Submitted batch job 588408
