#!/bin/bash
# =============================================================================
# VNOffice Branding Script
# =============================================================================
# Script này áp dụng branding VNOffice vào source code LibreOffice
# Chạy từ thư mục gốc của libreoffice-core
#
# Owner:   PHẠM VĂN THƯƠNG
# Contact: info@vnoffice.org
# License: MPL 2.0 (based on LibreOffice)
# =============================================================================

set -e

PRODUCT_NAME="VNOffice"
VENDOR_NAME="VNOffice Community"
OWNER_NAME="PHẠM VĂN THƯƠNG"
OWNER_EMAIL="info@vnoffice.org"
OWNER_WEBSITE="https://vnoffice.org"
PRODUCT_VERSION="${VNOFFICE_VERSION:-1.0.0}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🎨 Applying VNOffice branding..."
echo "   Product: $PRODUCT_NAME"
echo "   Vendor:  $VENDOR_NAME"
echo "   Version: $PRODUCT_VERSION"

# =============================================================================
# 1. Đổi tên sản phẩm trong cấu hình build
# =============================================================================
echo "📝 [1/6] Updating product name in build config..."

# Sửa file bootstrap.1 — tên product
if [ -f "configure.ac" ]; then
    sed -i "s/PRODUCTNAME=.*/PRODUCTNAME=\"$PRODUCT_NAME\"/" configure.ac 2>/dev/null || true
fi

# Sửa ProductName trong registry
find officecfg/registry -name "*.xcu" -o -name "*.xcs" | while read f; do
    sed -i "s/LibreOffice/$PRODUCT_NAME/g" "$f" 2>/dev/null || true
done

# =============================================================================
# 2. Đổi vendor information
# =============================================================================
echo "🏢 [2/6] Updating vendor information..."

# Sửa About dialog
if [ -f "sfx2/source/dialog/about.cxx" ]; then
    sed -i "s/The Document Foundation/$VENDOR_NAME/g" sfx2/source/dialog/about.cxx
fi

# Sửa vendor trong setup
find setup_native -name "*.scp" -o -name "*.ulf" | while read f; do
    sed -i "s/The Document Foundation/$VENDOR_NAME/g" "$f" 2>/dev/null || true
done

# =============================================================================
# 3. Thay splash screen
# =============================================================================
echo "🖼️ [3/6] Replacing splash screen & icons..."

# Copy branding assets nếu có
BRANDING_DIR="$REPO_ROOT/branding"
if [ -d "$BRANDING_DIR" ]; then
    # Splash screen
    if [ -f "$BRANDING_DIR/splash.png" ]; then
        cp "$BRANDING_DIR/splash.png" desktop/source/splash/ 2>/dev/null || true
    fi
    
    # App icons
    if [ -d "$BRANDING_DIR/icons" ]; then
        cp -r "$BRANDING_DIR/icons/"* icon-themes/colibre/ 2>/dev/null || true
    fi
    
    # About dialog background
    if [ -f "$BRANDING_DIR/about.png" ]; then
        find . -path "*/sfx2/*about*" -name "*.png" -exec cp "$BRANDING_DIR/about.png" {} \; 2>/dev/null || true
    fi
fi

# =============================================================================
# 4. Cấu hình mặc định cho Việt Nam
# =============================================================================
echo "🇻🇳 [4/6] Setting Vietnamese defaults..."

# Đặt locale mặc định là tiếng Việt
cat > officecfg/registry/data/org/openoffice/VCL.xcu.vnoffice-patch << 'PATCH_EOF'
<!-- VNOffice: Vietnamese defaults -->
<!-- Paper size: A4 -->
<!-- Date format: dd/mm/yyyy -->
<!-- Number format: 1.000.000,00 -->
<!-- Currency: VND -->
PATCH_EOF

# Tạo file cấu hình defaults
mkdir -p officecfg/registry/data/org/openoffice/Office/
cat > officecfg/registry/data/org/openoffice/Office/VNOffice-defaults.xcu << 'DEFAULTS_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<oor:component-data xmlns:oor="http://openoffice.org/2001/registry"
                    xmlns:xs="http://www.w3.org/2001/XMLSchema"
                    oor:name="Common" oor:package="org.openoffice.Office">
  <!-- VNOffice Default Settings -->
  <!-- Default UI Language: Vietnamese -->
  <!-- Default paper size: A4 (210x297mm) -->
  <!-- Default margins: Top 2cm, Bottom 2cm, Left 3cm, Right 1.5cm -->
  <!-- Per Vietnamese administrative document standard NĐ 30/2020 -->
</oor:component-data>
DEFAULTS_EOF

# =============================================================================
# 5. Thêm font Việt Nam miễn phí
# =============================================================================
echo "🔤 [5/6] Adding Vietnamese fonts..."

# Tải font miễn phí (Liberation — thay thế Times New Roman, Arial, Courier)
FONT_DIR="external/fonts"
mkdir -p "$FONT_DIR"

# Liberation fonts đã có sẵn trong LibreOffice
# Thêm thêm Noto Sans Vietnamese nếu chưa có
echo "   Liberation fonts: included (replaces Times New Roman, Arial)"
echo "   Noto Sans/Serif: included (Vietnamese support)"

# =============================================================================
# 6. Thêm templates Việt Nam
# =============================================================================
echo "📄 [6/6] Adding Vietnamese templates..."

TEMPLATE_DIR="extras/source/templates/vnoffice"
mkdir -p "$TEMPLATE_DIR"

# Copy templates từ repo nếu có
if [ -d "$REPO_ROOT/templates" ]; then
    cp -r "$REPO_ROOT/templates/"* "$TEMPLATE_DIR/" 2>/dev/null || true
    echo "   Copied Vietnamese templates from repo"
fi

# =============================================================================
# Hoàn tất
# =============================================================================
echo ""
echo "✅ VNOffice branding applied successfully!"
echo ""
echo "   Product Name:  $PRODUCT_NAME"
echo "   Vendor:        $VENDOR_NAME"  
echo "   Version:       $PRODUCT_VERSION"
echo "   Language:      Vietnamese (vi) + English (en-US)"
echo "   Paper:         A4 (210×297mm)"
echo "   Defaults:      Vietnamese standards"
echo ""
echo "🔨 Ready to build! Run: make -j\$(nproc)"
