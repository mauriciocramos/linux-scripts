#!/home/mauricio/miniconda3/envs/tf/bin/python
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '1'
os.environ['CUDA_MODULE_LOADING'] = 'LAZY'
import tensorflow as tf

print(f'{tf.version.VERSION=}')
print(f'{tf.version.COMPILER_VERSION=}')
print(f'{tf.version.GIT_VERSION=}')
print(f'{tf.version.GRAPH_DEF_VERSION_MIN_PRODUCER=}')
print(f'{tf.version.GRAPH_DEF_VERSION_MIN_CONSUMER=}')
print(f'{tf.version.GRAPH_DEF_VERSION=}')

print('-'*80)
print('tf.sysconfig.get_build_info():')
for k,v in tf.sysconfig.get_build_info().items():
    print('\t', k,':',v)
print('tf.sysconfig.get_compile_flags():')
for f in tf.sysconfig.get_compile_flags():
    print('\t', f)
print(f'{tf.sysconfig.get_include()=}')
print(f'{tf.sysconfig.get_lib()=}')
print(f'tf.sysconfig.get_link_flags():')
for f in tf.sysconfig.get_link_flags():
    print('\t', f)
print('-'*80)
print('tf.config.list_physical_devices():')
for d in tf.config.list_physical_devices():
    print('\t', d)
print('tf.config.list_logical_devices():')
for d in tf.config.list_logical_devices():
    print('\t', d)
print('tf.config.get_logical_device_configuration():')
for d in tf.config.list_physical_devices():
    print('\t', d, ':', tf.config.get_logical_device_configuration(d))
print(f'{tf.config.get_soft_device_placement()=}')
print('tf.config.get_visible_devices():')
for d in tf.config.get_visible_devices():
    print('\t', d)

print('-'*80)
print(f'{tf.test.gpu_device_name()=}')
print(f'{tf.test.is_built_with_cuda()=}')
print(f'{tf.test.is_built_with_gpu_support()=}')
print(f'{tf.test.is_built_with_rocm()=}')
print(f'{tf.test.is_built_with_xla()=}')

print('-'*80)
from tensorflow.python.compiler.tensorrt import trt_convert as trt
print(f'{trt.trt_utils._pywrap_py_utils.is_tensorrt_enabled()=}')  # when false, tensorrt still runs?
print(f'{trt.trt_utils._pywrap_py_utils.get_linked_tensorrt_version()=}')
print(f'{trt.trt_utils._pywrap_py_utils.get_loaded_tensorrt_version()=}')

print('-'*80)
import tensorrt
print(f'{tensorrt.__version__=}')
print(f'{tensorrt.Builder(tensorrt.Logger())=}')  # tensorrt still runs when is_tensorrt_enable() is false

# print('-'*80)
# print('tf.test.main(argv=None):')
# print(tf.test.main(argv=None))
# print('-'*80)
