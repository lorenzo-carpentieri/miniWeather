# num of runs
CXX_COMPILER=$1
NUM_GPUS=$2
NUM_NODES=$3
NUM_RUNS=$4
# create the path to build directory
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
BUILD_DIR=$SCRIPT_DIR/../build
LOG_DIR=logs_${NUM_GPUS}gpus_${NUM_NODES}nodes_${NUM_RUNS}runs

EXECUTABLE_DIR="executables"

if [ ! -d "$SCRIPT_DIR/../${LOG_DIR}" ]; then
    # Create the directory
    mkdir -p "$SCRIPT_DIR/../${LOG_DIR}"
    echo "Directory created: $SCRIPT_DIR/../${LOG_DIR}"
else
    echo "Directory already exists: $SCRIPT_DIR/../${LOG_DIR}"
    rm -rf $SCRIPT_DIR/../${LOG_DIR}/*
fi


## APP
rm -rf $BUILD_DIR/*
cd $BUILD_DIR
${SCRIPT_DIR}/compile_miniweather.sh APP 0 ${CXX_COMPILER} ${NUM_GPUS}
make -j 
mv ./parallelfor ../${EXECUTABLE_DIR}/parallelfor_per_app_${NUM_GPUS}gpus

## KERNEL
rm -rf $BUILD_DIR/*
cd $BUILD_DIR
${SCRIPT_DIR}/compile_miniweather.sh KERNEL 0 ${CXX_COMPILER} ${NUM_GPUS}
make -j 
mv ./parallelfor ../${EXECUTABLE_DIR}/parallelfor_per_kernel_${NUM_GPUS}gpus



## NO_HIDING
rm -rf $BUILD_DIR/*
cd $BUILD_DIR
${SCRIPT_DIR}/compile_miniweather.sh PHASE 0 ${CXX_COMPILER} ${NUM_GPUS}
make -j 
mv ./parallelfor ../${EXECUTABLE_DIR}/parallelfor_per_phase_no_hiding_${NUM_GPUS}gpus


## HIDING
rm -rf $BUILD_DIR/*
cd $BUILD_DIR
${SCRIPT_DIR}/compile_miniweather.sh PHASE 1 ${CXX_COMPILER} ${NUM_GPUS}
make -j 
mv ./parallelfor ../${EXECUTABLE_DIR}/parallelfor_per_phase_hiding_${NUM_GPUS}gpus





