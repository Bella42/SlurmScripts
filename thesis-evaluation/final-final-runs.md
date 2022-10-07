# Final runs

## HeatTransfer


#### BP 283
- 1 node: 588407 (all)
    + 1 node query for every process config: 596847
- 2 nodes: 588406 (all)
- 4 nodes:
    - BP3: 588383
    - BP4: 588382
    - BP5: 588381
- 6 nodes: 596735
- 8 nodes: 588408 (all)

<!-- error for 6 nodes: -->
<!-- 6 nodes: line 64: 20060 Floating point exception(core dumped) mpirun -n $proc -ppn $(($proc/8)) $htWriteBin $configFile $inputOutput ${N[$i]} ${M[$i]} $size $size $steps $iterations >> "${writeFile}" -->
<!-- ls: cannot access '/home/urz/kduwe/ht-output/heat-bp3-2nodes.bp': No such file or directory -->


#### BP 271
- 1 node:  
    + 1 node query for every process config: 596846
    - BP3:
    - BP4:
- 2 nodes: 596845
    - BP3:
    - BP4:
- 4 nodes: 596637
    - BP3:
    - BP4:
- 6 nodes: 596545
    - BP3:
    - BP4:




#### 2 JULEA Servers on ant10/11
<!-- neue ht messungen 271 -->
<!-- https://github.com/julea-io/adios2/commit/2c6b0aa13f1b36329746d607a816441b7521e4e5 -->

##### DB
- 1 node:  
    + 1 node query for every process config: 596883
- 2 nodes: 596857
- 4 nodes: 596833
- 6 nodes: 596543 -> letzter query fehlt, weil node failure
596634


##### KV
- 1 node:  
    + 1 node query for every process config: 596885
- 2 nodes: 596877
- 4 nodes: 596837
- 6 nodes: 596886
