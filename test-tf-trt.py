import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '1'
os.environ['CUDA_MODULE_LOADING'] = 'LAZY'
import tensorflow as tf

# Source: https://www.tensorflow.org/tutorials/quickstart/beginner
# Create your model using Tensorflow. For illustration purposes, we’ll be using a Keras sequential model.

## Define a simple sequential model
model = tf.keras.models.Sequential([
    tf.keras.layers.Flatten(input_shape=(28, 28)),
    tf.keras.layers.Dense(128, activation='relu'),
    tf.keras.layers.Dropout(0.2),
    tf.keras.layers.Dense(10)
])

model.compile(optimizer='adam',
              loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
              metrics=['accuracy'])

## Get the dataset and preprocess it as needed.
mnist = tf.keras.datasets.mnist

(x_train, y_train), (x_test, y_test) = mnist.load_data()
x_train, x_test = x_train / 255.0, x_test / 255.0
x_train = tf.cast(x_train, dtype=tf.float32)
y_train = tf.cast(y_train, dtype=tf.float32)
x_test = tf.cast(x_test, dtype=tf.float32)
y_test = tf.cast(y_test, dtype=tf.float32)

# Train the model and evaluate accuracy as required, as shown here.

## Train the model
model.fit(x_train, y_train, epochs=5)

## Evaluate your model accuracy
model.evaluate(x_test, y_test, verbose=2)

# Save the model in the saved_model format.

## Save model in the saved_model format
SAVED_MODEL_DIR = "./models/native_saved_model"
model.save(SAVED_MODEL_DIR)

# Convert the model using the TF-TRT converter.

from tensorflow.python.compiler.tensorrt import trt_convert as trt

## Instantiate the TF-TRT converter
converter = trt.TrtGraphConverterV2(
    input_saved_model_dir=SAVED_MODEL_DIR,
    precision_mode=trt.TrtPrecisionMode.FP32
)

## Convert the model into TRT compatible segments
trt_func = converter.convert()
converter.summary()

# Build the TRT engines.

MAX_BATCH_SIZE = 128


def input_fn():
    batch_size = MAX_BATCH_SIZE
    x = x_test[0:batch_size, :]
    yield [x]


converter.build(input_fn=input_fn)

# Save the converted model for future use.

OUTPUT_SAVED_MODEL_DIR = "./models/tftrt_saved_model"
converter.save(output_saved_model_dir=OUTPUT_SAVED_MODEL_DIR)

# Run an inference using the converted model.

## Get batches of test data and run inference through them
infer_batch_size = MAX_BATCH_SIZE // 2
for i in range(10):
    print(f"Step: {i}")

    start_idx = i * infer_batch_size
    end_idx = (i + 1) * infer_batch_size
    x = x_test[start_idx:end_idx, :]

    trt_func(x)
