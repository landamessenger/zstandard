#!/bin/bash

echo "🧹 Cleaning Flutter project..."
flutter clean

echo "🗑️ Removing iOS build artifacts..."
rm -rf ios/Pods ios/Podfile.lock ios/.symlinks
rm -rf ~/Library/Developer/Xcode/DerivedData

echo "📦 Getting Flutter dependencies..."
flutter pub get

echo "🍎 Installing iOS pods..."
cd ios && pod install --repo-update
cd ..

echo "🚀 Running Flutter app..."

flutter run -d "iPhone 16e" -v --verbose