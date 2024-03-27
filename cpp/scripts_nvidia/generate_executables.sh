# num of runs
CXX_COMPILER=$1
# create the path to build directory
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
BUILD_DIR=$SCRIPT_DIR/../build
LOG_DIR=logs_${NUM_GPUS}gpus_${NUM_NODES}nodes_${NUM_RUNS}runs
EXECUTABLE_DIR="executables"
# Create the directory with all the executables for the different approach 
if [ ! -d "$SCRIPT_DIR/../${EXECUTABLE_DIR}" ]; then
    # Create the directory
    mkdir -p "$SCRIPT_DIR/../${EXECUTABLE_DIR}"
    echo "Directory created: $SCRIPT_DIR/../${EXECUTABLE_DIR}"
else
    echo "Directory already exists: $SCRIPT_DIR/../${EXECUTABLE_DIR}"
    rm -rf $SCRIPT_DIR/../${EXECUTABLE_DIR}/*
fi

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
${SCRIPT_DIR}/compile_miniweather.sh APP 0 ${CXX_COMPILER}
make -j 
mv ./parallelfor ../${EXECUTABLE_DIR}/parallelfor_per_app

## KERNEL
rm -rf $BUILD_DIR/*
cd $BUILD_DIR
${SCRIPT_DIR}/compile_miniweather.sh KERNEL 0 ${CXX_COMPILER}
make -j 
mv ./parallelfor ../${EXECUTABLE_DIR}/parallelfor_per_kernel



## NO_HIDING
rm -rf $BUILD_DIR/*
cd $BUILD_DIR
${SCRIPT_DIR}/compile_miniweather.sh PHASE 0 ${CXX_COMPILER}
make -j 
mv ./parallelfor ../${EXECUTABLE_DIR}/parallelfor_per_phase_no_hiding


## HIDING
rm -rf $BUILD_DIR/*
cd $BUILD_DIR
${SCRIPT_DIR}/compile_miniweather.sh PHASE 1 ${CXX_COMPILER}
make -j 
mv ./parallelfor ../${EXECUTABLE_DIR}/parallelfor_per_phase_hiding





