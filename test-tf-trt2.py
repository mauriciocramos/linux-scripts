#!/home/mauricio/miniconda3/envs/tf/bin/python
import os

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '1'
os.environ['CUDA_MODULE_LOADING'] = 'LAZY'

# https://github.com/NVIDIA/TensorRT/blob/main/quickstart/IntroNotebooks/2.%20Using%20the%20Tensorflow%20TensorRT%20Integration.ipynb

# 1. What format should I save my model in?
from tensorflow.keras.applications import ResNet50
model_dir = 'tmp_savedmodels/resnet50_saved_model'
model = ResNet50(include_top=True, weights='imagenet')
model.save(model_dir)

# 2. What batch size(s) am I running inference at?
import numpy as np
BATCH_SIZE = 32
dummy_input_batch = np.zeros((BATCH_SIZE, 224, 224, 3))

# 3. What precision am I running inference at?
PRECISION = "FP32"  # Options are "FP32", "FP16", or "INT8"

# 4. What TensorRT path am I using to convert my model?
from helper import ModelOptimizer # using the helper from <URL>
model_dir = 'tmp_savedmodels/resnet50_saved_model'
opt_model = ModelOptimizer(model_dir)
model_fp32 = opt_model.convert(model_dir+'_FP32', precision=PRECISION)

# 5. What TensorRT runtime am I targeting?
model_fp32.predict(dummy_input_batch)
# Warm up - the first batch through a model generally takes longer
model.predict(dummy_input_batch)
model_fp32.predict(dummy_input_batch)
import timeit
timeit.timeit('model.predict_on_batch(dummy_input_batch)')
timeit.timeit('model_fp32.predict(dummy_input_batch)')

# Reducing Precision:
model_fp16 = opt_model.convert(model_dir+'_FP16', precision="FP16")
model_fp16.predict(dummy_input_batch)
timeit.timeit('model_fp16.predict(dummy_input_batch)')

dummy_calibration_batch = np.zeros((8, 224, 224, 3))
opt_model.set_calibration_data(dummy_calibration_batch)

model_int8 = opt_model.convert(model_dir+'_INT8', precision="INT8")
model_int8.predict(dummy_input_batch)
timeit.timeit('model_int8.predict(dummy_input_batch')









