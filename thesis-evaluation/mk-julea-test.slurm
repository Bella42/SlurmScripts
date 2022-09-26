#!/bin/bash

#SBATCH --partition=parcio
#SBATCH -w ant[17-18]
# Redirect output and error output
#SBATCH --output=job.out
#SBATCH --error=job.err

export G_MESSAGES_DEBUG=all

export JULEA_PREFIX="/home/urz/kduwe/julea-install"
export JULEA_CONFIG="/home/urz/kduwe/.config/julea/ant17-18"

. mein-spack/share/spack/setup-env.sh 
spack load mpi
# . julea/scripts/environment.sh
. /home/urz/kduwe/mein-julea/scripts/environment.sh

srun -w ant[17-18] rm -rf /tmp/kduwe/julea
srun -w ant[17-18] --exact julea-server &
# srun -w ant[17-18] julea-server &
sleep 5
srun -w ant[17-18] --exact ps xww
# srun -w ant[17-18] ps xww

# make -C julea/example
# make -C . /home/urz/kduwe/mein-julea/example
# ./julea/example/hello-world
# /home/urz/kduwe/mein-julea/example/hello-world
mpirun -n 2 hostname
mpirun -n 2 /home/urz/kduwe/mein-julea/example/mpi_hello_world

srun -w ant[17-18] --exact killall -v julea-server
# srun -w ant[17-18] killall -v julea-server