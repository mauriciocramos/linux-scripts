START_TIME=$(date +%s)
source /home/mauricio/miniconda3/etc/profile.d/conda.sh
conda update -y conda

# Instructions to install tensorflow: https://www.tensorflow.org/install/pip
conda create --no-default-packages --override-channels -c conda-forge -y -n tf python=3.9
conda activate tf
conda install --override-channels -c conda-forge -y -n tf cudatoolkit=11.2 cudnn=8.1.0
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/
mkdir -p $CONDA_PREFIX/etc/conda/activate.d
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/' > $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
pip install --upgrade pip
pip install tensorflow

# Verifyng tensorflow:
# Notice the tensorflow.reduce_sum() seemt to work.
# Notice warnings about missing libnvinfer.so.7 and libnvinfer_pluging.so.7 which belongs to tensorrt.
# Notice tensorrt was stated as optional in https://www.tensorflow.org/install/pip. This instructions seems wrong.
python -c "import tensorflow as tf; print(tf.reduce_sum(tf.random.normal([1000, 1000])))"
# Verifying GPU: notice GPU recognition but same warnings
python -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"
# listing conda and pip most relevant installations so far: notice conda-forge and pypi in the column "Channel" as expected
conda list "python|cudatoolkit|cudnn|tensorflow|keras"
# Notice this tensorflow build is linked to tensorrt but same warnings
python -c "import tensorflow as tf; print(tf.sysconfig.get_build_info()['is_tensorrt_build'])"
# However, Notice this tensorflow build seems not to have tensorrt enabled
python -c "from tensorflow.python.compiler.tensorrt import trt_convert as trt; print(trt.trt_utils._pywrap_py_utils.is_tensorrt_enabled())"
# Notice this tensorflow build is linked to tensorrt 7.2.2 but same warnings
python -c "from tensorflow.python.compiler.tensorrt import trt_convert as trt; print(trt.trt_utils._pywrap_py_utils.get_linked_tensorrt_version())"
# Notice when I tried to get the loaded tensorrt version I got a failure:
# tensorflow/compiler/tf2tensorrt/stub/nvinfer_stub.cc:49] getInferLibVersion symbol not found. Aborted (core dumped)
python -c "from tensorflow.python.compiler.tensorrt import trt_convert as trt; print(trt.trt_utils._pywrap_py_utils.get_loaded_tensorrt_version())"

# As it seems tensorrt is not optional, lets install it following intructions at https://www.tensorflow.org/install/pip.
# Notice tensorflow site points to tensorrt 7: https://docs.nvidia.com/deeplearning/tensorrt/archives/index.html#trt_7
# As instructed, I used --extra-index-url https://pypi.ngc.nvidia.com rather than pip install nvidia-pyindex.
# nvidia-pyindex would create ~/.config/pip/pip.conf, ~/.pip/pip.conf.  Those pip.conf would possibly affect ANY future pip
# installations under my linux account by letting pip always look for packages in https://pypi.ngc.nvidia.com
pip install tensorrt --extra-index-url https://pypi.ngc.nvidia.com

# Verifying tensorrt:
# Notice installed tensorrt version is 8.5.2.2 but remember that the tensorflow build is linked to 7.2.2
python -c "import tensorrt; print(tensorrt.__version__); assert tensorrt.Builder(tensorrt.Logger())"
# listing conda and pip most relevant installations so far: notice conda-forge and pypi in the column "Channel" as expected
conda list "python|cudatoolkit|cudnn|tensorflow|keras|tensor"

# Workaround to missing libnvinfer.so.7 and libnvinfer_pluging.so.7 well known issues:
# https://forums.developer.nvidia.com/t/could-not-load-dynamic-library-libnvinfer-so-7/231606
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/python3.9/site-packages/tensorrt/
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/python3.9/site-packages/tensorrt/' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
ln -s $CONDA_PREFIX/lib/python3.9/site-packages/tensorrt/libnvinfer.so.8 $CONDA_PREFIX/lib/python3.9/site-packages/tensorrt/libnvinfer.so.7
ln -s $CONDA_PREFIX/lib/python3.9/site-packages/tensorrt/libnvinfer_plugin.so.8 $CONDA_PREFIX/lib/python3.9/site-packages/tensorrt/libnvinfer_plugin.so.7
# Verifying this workaround:
# Notice that just from now on this tensorflow build has tensorrt enabled and no more warnings.
python -c "from tensorflow.python.compiler.tensorrt import trt_convert as trt; print(trt.trt_utils._pywrap_py_utils.is_tensorrt_enabled())"
# Notice that this tensorflow build is still linked to 7.2.2 as expected
python -c "from tensorflow.python.compiler.tensorrt import trt_convert as trt; print(trt.trt_utils._pywrap_py_utils.get_linked_tensorrt_version())"
# Notice that just now we can see the loaded tensorrt version is 8.5.2
python -c "from tensorflow.python.compiler.tensorrt import trt_convert as trt; print(trt.trt_utils._pywrap_py_utils.get_loaded_tensorrt_version())"
# Notice the tensorrt 8.5.2 was imported and the tensorrt.Builder() assertions has no warnings
python -c "import tensorrt; print(tensorrt.__version__); assert tensorrt.Builder(tensorrt.Logger())"

# Workaround to the missing libdevice.10.bc well know issue:
# https://github.com/tensorflow/tensorflow/issues/58681#issuecomment-1333849966
# https://discuss.tensorflow.org/t/cant-find-libdevice-directory-cuda-dir-nvvm-libdevice/11896/7?u=mauriciocramos
mkdir -p $CONDA_PREFIX/lib/nvvm/libdevice
ln -s $CONDA_PREFIX/lib/libdevice.10.bc $CONDA_PREFIX/lib/nvvm/libdevice/libdevice.10.bc
export XLA_FLAGS=--xla_gpu_cuda_data_dir=$CONDA_PREFIX/lib
echo 'export XLA_FLAGS=--xla_gpu_cuda_data_dir=$CONDA_PREFIX/lib' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh

#export XLA_FLAGS=--xla_gpu_cuda_data_dir=$CONDA_PREFIX
#echo 'XLA_FLAGS=--xla_gpu_cuda_data_dir=$CONDA_PREFIX' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh

END_TIME=$(date +%s)
echo "Elased time: $(($END_TIME - $START_TIME)) seconds"
