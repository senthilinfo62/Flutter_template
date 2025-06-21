#!/bin/bash

# Bundle Size Analysis Script
# Analyzes Flutter app bundle size and provides optimization recommendations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Function to format file size
format_size() {
    local size=$1
    if [ $size -gt 1048576 ]; then
        echo "$(echo "scale=2; $size/1048576" | bc) MB"
    elif [ $size -gt 1024 ]; then
        echo "$(echo "scale=2; $size/1024" | bc) KB"
    else
        echo "$size B"
    fi
}

# Function to analyze APK size
analyze_apk_size() {
    print_header "APK Size Analysis"
    
    if [ ! -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
        print_warning "Release APK not found. Building..."
        flutter build apk --release --analyze-size
    fi
    
    local apk_path="build/app/outputs/flutter-apk/app-release.apk"
    if [ -f "$apk_path" ]; then
        local apk_size=$(stat -f%z "$apk_path" 2>/dev/null || stat -c%s "$apk_path" 2>/dev/null)
        print_info "APK Size: $(format_size $apk_size)"
        
        # Size recommendations
        if [ $apk_size -gt 52428800 ]; then # 50MB
            print_error "APK size is very large (>50MB). Consider optimization."
        elif [ $apk_size -gt 20971520 ]; then # 20MB
            print_warning "APK size is large (>20MB). Optimization recommended."
        else
            print_success "APK size is reasonable (<20MB)."
        fi
        
        # Analyze APK contents
        print_info "Analyzing APK contents..."
        if command -v aapt &> /dev/null; then
            aapt list -v "$apk_path" | head -20
        else
            print_warning "aapt not found. Install Android SDK tools for detailed analysis."
        fi
    else
        print_error "APK file not found at $apk_path"
    fi
}

# Function to analyze App Bundle size
analyze_bundle_size() {
    print_header "App Bundle Size Analysis"
    
    if [ ! -f "build/app/outputs/bundle/release/app-release.aab" ]; then
        print_warning "Release App Bundle not found. Building..."
        flutter build appbundle --release --analyze-size
    fi
    
    local bundle_path="build/app/outputs/bundle/release/app-release.aab"
    if [ -f "$bundle_path" ]; then
        local bundle_size=$(stat -f%z "$bundle_path" 2>/dev/null || stat -c%s "$bundle_path" 2>/dev/null)
        print_info "App Bundle Size: $(format_size $bundle_size)"
        
        # Size recommendations
        if [ $bundle_size -gt 157286400 ]; then # 150MB
            print_error "App Bundle size is very large (>150MB). Optimization required."
        elif [ $bundle_size -gt 104857600 ]; then # 100MB
            print_warning "App Bundle size is large (>100MB). Optimization recommended."
        else
            print_success "App Bundle size is reasonable (<100MB)."
        fi
    else
        print_error "App Bundle file not found at $bundle_path"
    fi
}

# Function to analyze web bundle size
analyze_web_size() {
    print_header "Web Bundle Size Analysis"
    
    if [ ! -d "build/web" ]; then
        print_warning "Web build not found. Building..."
        flutter build web --release
    fi
    
    if [ -d "build/web" ]; then
        local web_size=$(du -sh build/web | cut -f1)
        print_info "Web Bundle Size: $web_size"
        
        # Analyze main.dart.js size
        if [ -f "build/web/main.dart.js" ]; then
            local js_size=$(stat -f%z "build/web/main.dart.js" 2>/dev/null || stat -c%s "build/web/main.dart.js" 2>/dev/null)
            print_info "Main Dart JS Size: $(format_size $js_size)"
            
            if [ $js_size -gt 5242880 ]; then # 5MB
                print_warning "Main JS file is large (>5MB). Consider code splitting."
            else
                print_success "Main JS file size is reasonable (<5MB)."
            fi
        fi
        
        # List largest files
        print_info "Largest web files:"
        find build/web -type f -exec ls -lh {} \; | sort -k5 -hr | head -10
    else
        print_error "Web build directory not found"
    fi
}

# Function to analyze dependencies
analyze_dependencies() {
    print_header "Dependency Analysis"
    
    print_info "Analyzing pubspec.yaml dependencies..."
    
    # Count dependencies
    local dep_count=$(grep -c "^  [a-zA-Z]" pubspec.yaml || echo "0")
    print_info "Total dependencies: $dep_count"
    
    if [ $dep_count -gt 50 ]; then
        print_warning "High number of dependencies ($dep_count). Consider removing unused ones."
    else
        print_success "Reasonable number of dependencies ($dep_count)."
    fi
    
    # Check for large dependencies
    print_info "Checking for potentially large dependencies..."
    
    large_deps=("video_player" "camera" "webview_flutter" "google_maps_flutter" "firebase_storage")
    for dep in "${large_deps[@]}"; do
        if grep -q "^  $dep:" pubspec.yaml; then
            print_warning "Large dependency detected: $dep"
        fi
    done
    
    # Run dependency validator if available
    if flutter pub deps --json > /dev/null 2>&1; then
        print_info "Running dependency analysis..."
        flutter pub deps --json | jq '.packages[] | select(.kind == "direct") | .name' 2>/dev/null || print_warning "jq not available for JSON parsing"
    fi
}

# Function to check for unused assets
check_unused_assets() {
    print_header "Asset Usage Analysis"
    
    if [ -d "assets" ]; then
        print_info "Checking for unused assets..."
        
        # Find all asset files
        find assets -type f > /tmp/all_assets.txt
        
        # Check which assets are referenced in code
        unused_count=0
        while IFS= read -r asset; do
            asset_name=$(basename "$asset")
            if ! grep -r "$asset_name" lib/ > /dev/null 2>&1; then
                print_warning "Potentially unused asset: $asset"
                ((unused_count++))
            fi
        done < /tmp/all_assets.txt
        
        if [ $unused_count -eq 0 ]; then
            print_success "No obviously unused assets found."
        else
            print_warning "Found $unused_count potentially unused assets."
        fi
        
        rm -f /tmp/all_assets.txt
    else
        print_info "No assets directory found."
    fi
}

# Function to provide optimization recommendations
provide_recommendations() {
    print_header "Optimization Recommendations"
    
    echo "📋 Bundle Size Optimization Tips:"
    echo ""
    echo "1. 🗜️  Enable code obfuscation:"
    echo "   flutter build apk --release --obfuscate --split-debug-info=debug-info/"
    echo ""
    echo "2. 📦 Use App Bundle instead of APK:"
    echo "   flutter build appbundle --release"
    echo ""
    echo "3. 🎯 Enable tree shaking (automatic in release mode)"
    echo ""
    echo "4. 🖼️  Optimize images:"
    echo "   - Use WebP format for images"
    echo "   - Compress images before adding to assets"
    echo "   - Use vector graphics (SVG) when possible"
    echo ""
    echo "5. 📚 Remove unused dependencies:"
    echo "   flutter pub deps --json | jq '.packages[] | select(.kind == \"transitive\")'"
    echo ""
    echo "6. 🔧 Use --split-per-abi for multiple APKs:"
    echo "   flutter build apk --release --split-per-abi"
    echo ""
    echo "7. 🌐 For web, enable gzip compression on server"
    echo ""
    echo "8. 📱 Use deferred loading for large features"
    echo ""
    echo "9. 🎨 Optimize fonts:"
    echo "   - Use only required font weights"
    echo "   - Consider system fonts"
    echo ""
    echo "10. 🧹 Run 'flutter clean' before release builds"
}

# Main execution
main() {
    print_header "Flutter Bundle Size Analysis"
    
    # Check if we're in a Flutter project
    if [ ! -f "pubspec.yaml" ]; then
        print_error "Not in a Flutter project directory"
        exit 1
    fi
    
    # Clean before analysis
    print_info "Cleaning project..."
    flutter clean
    flutter pub get
    
    # Run analyses
    analyze_dependencies
    check_unused_assets
    analyze_apk_size
    analyze_bundle_size
    analyze_web_size
    provide_recommendations
    
    print_header "Analysis Complete"
    print_success "Bundle size analysis finished!"
    echo ""
    print_info "For detailed size analysis, use:"
    echo "flutter build apk --analyze-size"
    echo "flutter build appbundle --analyze-size"
}

# Run main function
main "$@"
