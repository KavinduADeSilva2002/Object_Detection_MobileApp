# 📱 Object Detection Mobile App (Flutter + TFLite)

This is a Flutter-based mobile application that performs real-time object detection using a TensorFlow Lite (TFLite) model. The app captures live camera feed, detects objects, and provides an analysis of what those objects are.

## 🚀 Features

- 🔍 Real-time object detection
- 📷 Camera integration using `camera` package
- 🧠 Machine learning inference using TFLite
- 🎯 Multi-class object recognition
- 📋 Easy-to-use and clean UI

## 🛠️ Tech Stack

- **Flutter** & **Dart**
- **TensorFlow Lite** (TFLite)
- **camera** package
- **tflite** package

## 📁 Project Structure

```plaintext
assets/
├── detect.tflite          # Place for your .tflite model
├── labels.txt    
lib/
│
├── main.dart         # Entry point of the app
├── home.dart         # Home screen UI & logic
    # Label file for object classes
