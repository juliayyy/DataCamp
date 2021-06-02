# Going Deeper
# EX 1: Creating a deep learning network
from keras.models import Sequential
from keras.layers import Dense, Conv2D, Flatten

model = Sequential()

# Add a convolutional layer (15 units)
model.add(Conv2D(15, kernel_size = 2, activation = 'relu', input_shape = (img_rows, img_cols, 1)))


# Add another convolutional layer (5 units)
model.add(Conv2D(5, kernel_size = 2, activation = 'relu'))

# Flatten and feed to output layer
model.add(Flatten())
model.add(Dense(3, activation='softmax'))

# EX 2: Train a deep CNN to classify clothing images

# Compile model
model.compile(optimizer= 'adam',
              loss='categorical_crossentropy',
              metrics=['accuracy'])

# Fit the model to training data
model.fit(train_data, train_labels,
          validation_split=0.2,
          epochs=3, batch_size=10)

# Evaluate the model on test data
model.evaluate(test_data, test_labels , batch_size=10)

# How many parameters
# CNN model
model = Sequential()
model.add(Conv2D(10, kernel_size=2, activation='relu',
                 input_shape=(28, 28, 1)))
model.add(Conv2D(10, kernel_size=2, activation='relu'))
model.add(Flatten())
model.add(Dense(3, activation='softmax'))

# Summarize the model
model.summary()

# Reducing parameters with pooling
# Write your own pooling operation
# Result placeholder
result = np.zeros((im.shape[0]//2, im.shape[1]//2))

# Pooling operation
for ii in range(result.shape[0]):
    for jj in range(result.shape[1]):
        result[ii, jj] = np.max(im[ii*2:ii*2+2, jj*2:jj*2+1])

# Keras pooling layers
# Add a convolutional layer
model.add(Conv2D(15, kernel_size=2, activation='relu',
                 input_shape=(img_rows, img_cols, 1)))

# Add a pooling operation
model.add(MaxPool2D(2))

# Add another convolutional layer
model.add(Conv2D(5,kernel_size =2, activation = 'relu'))

# Flatten and feed to output layer
model.add(Flatten())
model.add(Dense(3, activation='softmax'))
model.summary()

# Train a deep CNN with pooling to classify images
# Compile the model
model.compile(optimizer = 'adam', loss = 'categorical_crossentropy', metrics = ['accuracy'])

# Fit to training data
model.fit(train_data, train_labels,validation_split = 0.2, epochs = 3, batch_size = 10)

# Evaluate on test data
model.evaluate(test_data, test_labels, batch_size = 10)