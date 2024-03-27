#!/bin/bash

# Create an array with the specified numbers
NUM_NODES=(1 1 2 4)
NUM_GPUS=(2 4 8 16)
PATH_TO_MINIWEATHER_REPO=$1
NUM_RUNS=$2
EXECUTABLES=("parallelfor_per_app" "parallelfor_per_kernel" "parallelfor_per_phase_no_hiding" "parallelfor_per_phase_hiding")
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

#TODO: in miniweather to handle different size we have to compile the application multiple times with each different size
${SCRIPT_DIR}/generate_executables.sh

for ((i=0; i<${NUM_RUNS}; i++)); do
    for ((i=0; i<${#NUM_NODES[@]}; i++)); do
        for exe in "${EXECUTABLES[@]}"; do
            ${SCRIPT_DIR}/slurm_run.sh "${NUM_GPUS[i]}" "${NUM_NODES[i]}"  ${exe} ${PATH_TO_MINIWEATHER_REPO} ${NUM_RUNS}
        done
    done
done