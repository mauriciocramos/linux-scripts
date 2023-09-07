START_TIME=$(date +%s)
source "$HOME"/miniconda3/etc/profile.d/conda.sh

# remove previous environment
conda deactivate
conda env remove --name tf
ENVDIR=~/miniconda3/envs/
rm "$ENVDIR"tf -rf
ls "$ENVDIR"

conda update -y -n base conda

# create conda python=3.9 environment
conda create --no-default-packages --override-channels -c conda-forge -y -n tf python=3.9
conda activate tf

# Instructions to install tensorflow: https://www.tensorflow.org/install/pip
#conda install --override-channels -c conda-forge -y -n tf cudatoolkit=11.2.2 cudnn=8.1.0
conda install --override-channels -c conda-forge -y -n tf cudatoolkit cudnn
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/
mkdir -p $CONDA_PREFIX/etc/conda/activate.d
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/' > $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh

# workaround for missing ptxas: cuda-nvcc
# https://stackoverflow.com/questions/66623541/tensorflow-2-4-1-couldnt-invoke-ptxas-exe
# conda install --override-channels -c nvidia -y -n tf cuda-nvcc=11.3.58
conda install --override-channels -c nvidia -y -n tf cuda-nvcc

pip install --upgrade pip

#pip install nvidia-pyindex
#pip install nvidia-tensorrt
pip install tensorrt #--extra-index-url https://pypi.ngc.nvidia.com
#conda list "python|cud|tensor|keras"

# pip install "tensorflow==2.11.*"
pip install tensorflow
conda list "python|cud|tensor|keras"

# workaround to missing libnvinfer.so.7 and libnvinfer_pluging.so.7 available in TensorRT:
# https://forums.developer.nvidia.com/t/could-not-load-dynamic-library-libnvinfer-so-7/231606
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/python3.9/site-packages/tensorrt/
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/python3.9/site-packages/tensorrt/' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
ln -s $CONDA_PREFIX/lib/python3.9/site-packages/tensorrt/libnvinfer.so.8 $CONDA_PREFIX/lib/python3.9/site-packages/tensorrt/libnvinfer.so.7
ln -s $CONDA_PREFIX/lib/python3.9/site-packages/tensorrt/libnvinfer_plugin.so.8 $CONDA_PREFIX/lib/python3.9/site-packages/tensorrt/libnvinfer_plugin.so.7

# WORKAROUND to the missing libdevice.10.bc:
# https://github.com/tensorflow/tensorflow/issues/58681#issuecomment-1333849966
# https://discuss.tensorflow.org/t/cant-find-libdevice-directory-cuda-dir-nvvm-libdevice/11896/7
mkdir -p $CONDA_PREFIX/lib/nvvm/libdevice
ln -s $CONDA_PREFIX/lib/libdevice.10.bc $CONDA_PREFIX/lib/nvvm/libdevice/libdevice.10.bc
export XLA_FLAGS=--xla_gpu_cuda_data_dir=$CONDA_PREFIX/lib/
echo 'export XLA_FLAGS=--xla_gpu_cuda_data_dir=$CONDA_PREFIX/lib' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh

END_TIME=$(date +%s)
echo "Elased time: $(($END_TIME - $START_TIME)) seconds"
