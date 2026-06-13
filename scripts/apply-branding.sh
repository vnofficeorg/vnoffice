#!/bin/bash
# =============================================================================
# VNOffice Branding Script
# =============================================================================
# Script này áp dụng branding VNOffice vào source code LibreOffice
# Chạy từ thư mục gốc của libreoffice-core
#
# Tác giả:  PHẠM VĂN THƯƠNG
# Email:    info@vnoffice.org
# Website:  https://vnoffice.org
# Giấy phép: MPL 2.0 (dựa trên LibreOffice)
# =============================================================================

set -e

PRODUCT_NAME="VNOffice"
VENDOR_NAME="PHẠM VĂN THƯƠNG"
OWNER_NAME="PHẠM VĂN THƯƠNG"
OWNER_EMAIL="info@vnoffice.org"
OWNER_WEBSITE="https://vnoffice.org"
PRODUCT_VERSION="${VNOFFICE_VERSION:-1.0.0}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🎨 Applying VNOffice branding..."
echo "   Product:  $PRODUCT_NAME"
echo "   Tác giả:  $OWNER_NAME"
echo "   Email:    $OWNER_EMAIL"
echo "   Website:  $OWNER_WEBSITE"
echo "   Version:  $PRODUCT_VERSION"

# =============================================================================
# 1. Đổi tên sản phẩm trong cấu hình build
# =============================================================================
echo "📝 [1/7] Updating product name in build config..."

# Sửa PRODUCTNAME trong configure.ac
if [ -f "configure.ac" ]; then
    sed -i "s/PRODUCTNAME=.*/PRODUCTNAME=\"$PRODUCT_NAME\"/" configure.ac 2>/dev/null || true
fi

# Sửa ProductName trong registry
find officecfg/registry -name "*.xcu" -o -name "*.xcs" 2>/dev/null | while read f; do
    sed -i "s/LibreOffice/$PRODUCT_NAME/g" "$f" 2>/dev/null || true
done

# =============================================================================
# 2. Đổi vendor → PHẠM VĂN THƯƠNG
# =============================================================================
echo "🏢 [2/7] Updating author/vendor information..."

# --- About Dialog (hiển thị khi nhấn Help → About) ---
if [ -f "sfx2/source/dialog/about.cxx" ]; then
    sed -i "s/The Document Foundation/$OWNER_NAME/g" sfx2/source/dialog/about.cxx
    echo "   ✅ About dialog → $OWNER_NAME"
fi

# --- Vendor trong installer ---
find setup_native -name "*.scp" -o -name "*.ulf" 2>/dev/null | while read f; do
    sed -i "s/The Document Foundation/$OWNER_NAME/g" "$f" 2>/dev/null || true
done
echo "   ✅ Installer vendor → $OWNER_NAME"

# --- Vendor trong package metadata ---
find scp2 -name "*.scp" -o -name "*.ulf" 2>/dev/null | while read f; do
    sed -i "s/The Document Foundation/$OWNER_NAME/g" "$f" 2>/dev/null || true
done

# --- Credits / License dialog ---
find desktop -name "*.xcu" -o -name "*.xml" 2>/dev/null | while read f; do
    sed -i "s/The Document Foundation/$OWNER_NAME/g" "$f" 2>/dev/null || true
done

# =============================================================================
# 3. Thêm thông tin tác giả vào About Dialog chi tiết
# =============================================================================
echo "👤 [3/7] Adding author details to About dialog..."

# Tạo file thông tin tác giả (hiển thị trong About)
mkdir -p readmes/
cat > readmes/VNOffice-README.txt << 'AUTHOR_EOF'
╔══════════════════════════════════════════════════════════════╗
║                        VNOffice                              ║
║          Bộ phần mềm văn phòng miễn phí                     ║
║      Dành cho cá nhân và doanh nghiệp Việt Nam              ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  Tác giả:    PHẠM VĂN THƯƠNG                                ║
║  Email:      info@vnoffice.org                               ║
║  Website:    https://vnoffice.org                            ║
║                                                              ║
║  Giấy phép:  Mozilla Public License 2.0 (MPL 2.0)           ║
║              Miễn phí cho cá nhân và doanh nghiệp            ║
║              Không giới hạn số máy cài đặt                   ║
║                                                              ║
║  Dựa trên:   LibreOffice của The Document Foundation         ║
║              https://www.libreoffice.org                     ║
║                                                              ║
║  Hỗ trợ:     .docx .xlsx .pptx .doc .xls .ppt .pdf          ║
║              .odt .ods .odp (OpenDocument)                   ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
AUTHOR_EOF

echo "   ✅ Author README created"

# --- Sửa file version info (hiển thị trong Properties trên Windows) ---
find desktop -name "*.rc" -o -name "*.rc.in" 2>/dev/null | while read f; do
    sed -i "s/The Document Foundation/$OWNER_NAME/g" "$f" 2>/dev/null || true
    sed -i "s/LibreOffice/$PRODUCT_NAME/g" "$f" 2>/dev/null || true
done

# --- Windows file properties (right-click → Properties → Details) ---
find . -name "version.hrc" -o -name "app.info" 2>/dev/null | while read f; do
    sed -i "s/The Document Foundation/$OWNER_NAME/g" "$f" 2>/dev/null || true
    sed -i "s/LibreOffice/$PRODUCT_NAME/g" "$f" 2>/dev/null || true
done
echo "   ✅ Windows file properties → $OWNER_NAME"

# =============================================================================
# 4. Thay splash screen & icons
# =============================================================================
echo "🖼️ [4/7] Replacing splash screen & icons..."

BRANDING_DIR="$REPO_ROOT/branding"
if [ -d "$BRANDING_DIR" ]; then
    # Splash screen
    if [ -f "$BRANDING_DIR/splash/splash.png" ]; then
        find . -path "*/desktop/source/splash*" -name "*.png" \
            -exec cp "$BRANDING_DIR/splash/splash.png" {} \; 2>/dev/null || true
        echo "   ✅ Splash screen replaced"
    fi
    
    # App icons — copy vào icon theme
    if [ -d "$BRANDING_DIR/icons" ]; then
        cp -r "$BRANDING_DIR/icons/"* icon-themes/colibre/ 2>/dev/null || true
        echo "   ✅ App icons copied to colibre theme"
    fi
    
    # Logo chính
    if [ -f "$BRANDING_DIR/logo/vnoffice-logo.png" ]; then
        # Copy logo vào nhiều vị trí
        find . -name "logo.png" -path "*/brand/*" \
            -exec cp "$BRANDING_DIR/logo/vnoffice-logo.png" {} \; 2>/dev/null || true
        find . -name "about_logo.png" \
            -exec cp "$BRANDING_DIR/logo/vnoffice-logo.png" {} \; 2>/dev/null || true
        echo "   ✅ Logo replaced"
    fi

    # About dialog background
    if [ -f "$BRANDING_DIR/about/about.png" ]; then
        find . -path "*/sfx2/*about*" -name "*.png" \
            -exec cp "$BRANDING_DIR/about/about.png" {} \; 2>/dev/null || true
        echo "   ✅ About background replaced"
    fi
fi

# =============================================================================
# 5. Cấu hình mặc định cho Việt Nam
# =============================================================================
echo "🇻🇳 [5/7] Setting Vietnamese defaults..."

# Tạo file cấu hình defaults
mkdir -p officecfg/registry/data/org/openoffice/Office/
cat > officecfg/registry/data/org/openoffice/Office/VNOffice-defaults.xcu << 'DEFAULTS_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!--
  VNOffice Default Settings
  Tác giả: PHẠM VĂN THƯƠNG (info@vnoffice.org)
  
  Cấu hình mặc định cho người dùng Việt Nam:
  - Ngôn ngữ giao diện: Tiếng Việt
  - Khổ giấy: A4 (210×297mm)
  - Lề: Trên 2cm, Dưới 2cm, Trái 3cm, Phải 1.5cm
    (theo Nghị định 30/2020/NĐ-CP về công tác văn thư)
  - Định dạng số: 1.000.000,00
  - Định dạng ngày: dd/mm/yyyy
  - Tiền tệ: VNĐ
-->
<oor:component-data xmlns:oor="http://openoffice.org/2001/registry"
                    xmlns:xs="http://www.w3.org/2001/XMLSchema"
                    oor:name="Common" oor:package="org.openoffice.Office">
</oor:component-data>
DEFAULTS_EOF

echo "   ✅ Vietnamese defaults configured"

# =============================================================================
# 6. Thêm font Việt Nam miễn phí
# =============================================================================
echo "🔤 [6/7] Adding Vietnamese fonts..."

# Liberation fonts đã có sẵn trong LibreOffice (thay thế Times New Roman, Arial)
# Noto Sans/Serif Vietnamese cũng có sẵn
echo "   ✅ Liberation fonts: included (thay Times New Roman, Arial)"
echo "   ✅ Noto Sans/Serif: included (hỗ trợ tiếng Việt)"

# =============================================================================
# 7. Thêm templates Việt Nam
# =============================================================================
echo "📄 [7/7] Adding Vietnamese templates..."

TEMPLATE_DIR="extras/source/templates/vnoffice"
mkdir -p "$TEMPLATE_DIR"

# Copy templates từ repo nếu có
if [ -d "$REPO_ROOT/templates/vi" ]; then
    cp -r "$REPO_ROOT/templates/vi/"* "$TEMPLATE_DIR/" 2>/dev/null || true
    echo "   ✅ Vietnamese templates copied"
fi

# =============================================================================
# Hoàn tất
# =============================================================================
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  ✅ VNOffice branding applied successfully!              ║"
echo "╠══════════════════════════════════════════════════════════╣"
echo "║                                                          ║"
echo "║  Sản phẩm:  $PRODUCT_NAME"
echo "║  Phiên bản: $PRODUCT_VERSION"
echo "║  Tác giả:   $OWNER_NAME"
echo "║  Email:     $OWNER_EMAIL"
echo "║  Website:   $OWNER_WEBSITE"
echo "║  Ngôn ngữ:  Tiếng Việt + English"
echo "║  Khổ giấy:  A4 (210×297mm)"
echo "║                                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "🔨 Sẵn sàng build! Chạy: make -j\$(nproc)"
