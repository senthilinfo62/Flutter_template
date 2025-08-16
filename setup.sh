#!/bin/bash

# Flutter Template Setup Script
# Simple wrapper for the Python setup script

echo "🚀 Flutter Template Setup"
echo "========================="
echo ""

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed."
    echo "Please install Python 3 and try again."
    exit 1
fi

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is required but not installed."
    echo "Please install Flutter and try again."
    echo "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Run the Python setup script
python3 setup_new_project.py

echo ""
echo "🎯 Setup script completed!"
echo "Check PROJECT_SETUP.md for your project configuration."
