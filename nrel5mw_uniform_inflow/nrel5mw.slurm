#!/bin/bash

#SBATCH --nodes=28
#SBATCH --time=2:00:00
#SBATCH --account=hfm
#SBATCH --job-name=nrel5mw
#SBATCH --output=out.%x_%j

module load cray-python
module load PrgEnv-intel
export EXAWIND_MANAGER=${HOME}/exawind-manager
source ${EXAWIND_MANAGER}/start.sh
spack-start
quick-activate ${EXAWIND_MANAGER}/environments/fsi
spack load exawind

export FI_MR_CACHE_MONITOR=memhooks
export MPICH_SMP_SINGLE_COPY_MODE=NONE
export FI_CXI_RX_MATCH_MODE=software
export LD_LIBRARY_PATH=/nopt/nrel/apps/cray-mpich-stall/libs_mpich_nrel_intel:$LD_LIBRARY_PATH
export MPICH_OFI_CQ_STALL=1
export MPICH_OFI_CQ_STALL_USECS=163

#cd mesh
#srun -N7 -n672 --ntasks-per-node=96 --distribution=cyclic:cyclic stk_balance.exe *exo &> log.decompose2
#cd ../
#srun -N14 -n1344 --ntasks-per-node=96 --distribution=cyclic:cyclic --cpu_bind=cores exawind --nwind 672 --awind 672 nrel5mw-01.yaml &> log.2

srun -N28 -n1456 --ntasks-per-node=52 --distribution=cyclic:cyclic --cpu_bind=cores exawind --nwind 728 --awind 728 nrel5mw-01.yaml &> log



#cd mesh
#srun -N14 -n728 --ntasks-per-node=52 --distribution=cyclic:cyclic stk_balance.exe *exo &> log.decompose
#cd ../


# module load libfabric/1.15.2.0
# module load cray-libsci/23.12.5
# module load intel/2023.2.0
# module load craype-network-ofi
# module load craype-x86-spr
# module load cray-mpich/8.1.28
# export LD_LIBRARY_PATH=/projects/hpesupport/cray-mpich-stall/libs_mpich_nrel_intel:$LD_LIBRARY_PATH
