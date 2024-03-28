APPROACH=$1
HIDING=$2
CXX_COMPILER=$3
NUM_GPUS=$4
X_SIZE=$((32 * NUM_GPUS)) #TODO: change 32 with the maximum X_SIZE on a single GPU
Y_SIZE=$((X_SIZE / 2))

# echo $NUM_GPUS
# echo $X_SIZE
# echo $Y_SIZE

cmake \
  -DCMAKE_CXX_COMPILER="$CXX_COMPILER" \
  -DCMAKE_CXX_FLAGS="-lmpi -ffast-math -Wno-deprecated -fsycl -fsycl-targets=nvptx64-nvidia-cuda -Xsycl-target-backend --cuda-gpu-arch=sm_80 -O3" \
  -DSYNERGY_SYCL_IMPL="DPC++" \
  -DSYNERGY_KERNEL_PROFILING=OFF \
  -DSYNERGY_DEVICE_PROFILING=ON \
  -DSYNERGY_HOST_PROFILING=OFF \
  -DSYNERGY_USE_PROFILING_ENERGY=ON \
  -DSYNERGY_CUDA_SUPPORT=ON \
  -DSYNERGY_CUDA_ARCH=sm_80 \
  -DYAKL_ARCH=SYCL \
  -DYAKL_SYCL_FLAGS="-fsycl -fsycl-targets=nvptx64-nvidia-cuda -Xsycl-target-backend --cuda-gpu-arch=sm_80 -O3" \
  -DNX=$X_SIZE \
  -DNZ=$Y_SIZE \
  -DFREQ_SCALING_APPROACH="$APPROACH" \
  -DMPI_HIDING=$HIDING \
  -DSIM_TIME=10 \
  -DLDFLAGS="-lpnetcdf" \
  -DHARDWARE_VENDOR="NVIDIA" \
  ..