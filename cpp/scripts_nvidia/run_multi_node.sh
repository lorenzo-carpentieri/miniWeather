#!/bin/bash
# arg1: oneAPI compiler icpx
# arg2: num. bench iteration
# arg3: location of the miniweather folder

# Create an array with the specified numbers
NUM_NODES=(1 1 2 4)
NUM_GPUS=(2 4 8 16)
CXX_COMPILER=$1
NUM_RUNS=$2
PATH_TO_MINIWEATHER_REPO=$3
EXECUTABLES=("parallelfor_per_app" "parallelfor_per_kernel" "parallelfor_per_phase_no_hiding" "parallelfor_per_phase_hiding")
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

for ((i=0; i<${#NUM_NODES[@]}; i++)); do
    LOG_DIR=logs_"${NUM_GPUS[i]}"gpus_"${NUM_GPUS[i]}"nodes_${NUM_RUNS}runs

    # Generate log dir for each configuration of GPUS 
    if [ ! -d "$SCRIPT_DIR/../${LOG_DIR}" ]; then
        # Create the directory
        mkdir -p "$SCRIPT_DIR/../${LOG_DIR}"
        echo "Directory created: $SCRIPT_DIR/../${LOG_DIR}"
    else
        echo "Directory already exists: $SCRIPT_DIR/../${LOG_DIR}"
        rm -rf $SCRIPT_DIR/../${LOG_DIR}/*
    fi
done
# miniweather must be compiled differently for each values of num_gpus to do weak scaling
for ((i=0; i<${#NUM_GPUS[@]}; i++)); do    
    ${SCRIPT_DIR}/generate_executables.sh ${CXX_COMPILER} "${NUM_GPUS[i]}" "${NUM_NODES[i]}" ${NUM_RUNS}
done

for ((i=0; i<${NUM_RUNS}; i++)); do
    for ((i=0; i<${#NUM_NODES[@]}; i++)); do
        for exe in "${EXECUTABLES[@]}"; do
            ${SCRIPT_DIR}/slurm_run.sh "${NUM_GPUS[i]}" "${NUM_NODES[i]}"  ${exe} ${PATH_TO_MINIWEATHER_REPO} ${NUM_RUNS}
        done
    done
done