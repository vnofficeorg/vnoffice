# 🇻🇳 VNOffice — Bộ Phần Mềm Văn Phòng Miễn Phí

<p align="center">
  <img src="branding/logo/vnoffice-logo.png" alt="VNOffice Logo" width="128">
</p>

<p align="center">
  <strong>Bộ phần mềm văn phòng miễn phí cho cá nhân và doanh nghiệp</strong><br>
  Dựa trên LibreOffice (MPL 2.0) — Không lo bản quyền!
</p>

<p align="center">
  <a href="https://vnoffice.org">Website</a> •
  <a href="#tải-về">Tải về</a> •
  <a href="#tính-năng">Tính năng</a> •
  <a href="#giấy-phép">Giấy phép</a>
</p>

---

## ✨ Tính Năng

| Ứng dụng | Thay thế | Mô tả |
|----------|---------|-------|
| 📝 **VNOffice Writer** | Microsoft Word | Soạn thảo văn bản |
| 📊 **VNOffice Calc** | Microsoft Excel | Bảng tính |
| 🎬 **VNOffice Impress** | Microsoft PowerPoint | Trình chiếu |
| 🖼️ **VNOffice Draw** | Microsoft Visio | Vẽ sơ đồ |
| 🗄️ **VNOffice Base** | Microsoft Access | Cơ sở dữ liệu |
| 🔢 **VNOffice Math** | Equation Editor | Công thức toán |

### 🇻🇳 Đặc biệt cho người Việt

- ✅ Giao diện **tiếng Việt** đầy đủ
- ✅ **Font tiếng Việt** có sẵn (Liberation, Noto Sans Vietnamese)
- ✅ **Templates** công văn, hợp đồng, bảng lương theo chuẩn Việt Nam
- ✅ Cấu hình mặc định: **A4, lề chuẩn NĐ 30/2020, dd/mm/yyyy, VNĐ**
- ✅ Tương thích **.docx, .xlsx, .pptx** (Microsoft Office)

## 📦 Tải Về

| Hệ điều hành | Link | Dung lượng |
|---------------|------|-----------|
| 🪟 Windows (.exe) | [Tải về](https://github.com/phamvanthuong/vnoffice/releases/latest) | ~350MB |
| 🍎 macOS (.dmg) | [Tải về](https://github.com/phamvanthuong/vnoffice/releases/latest) | ~320MB |
| 🐧 Linux (.deb) | [Tải về](https://github.com/phamvanthuong/vnoffice/releases/latest) | ~280MB |

## 💰 Giấy Phép — Miễn Phí 100%

VNOffice dựa trên [LibreOffice](https://www.libreoffice.org/) và được phân phối theo giấy phép **Mozilla Public License 2.0 (MPL 2.0)**.

| Bạn muốn... | Được phép? |
|-------------|:---------:|
| Dùng cho **cá nhân** | ✅ Miễn phí |
| Dùng cho **doanh nghiệp** | ✅ Miễn phí |
| Cài trên **nhiều máy** | ✅ Không giới hạn |
| Dùng **mãi mãi** | ✅ Không hết hạn |
| Không cần **đăng ký / đăng nhập** | ✅ Offline hoàn toàn |

> **Không lo bản quyền. Không lo pháp lý. Dùng thoải mái.**

## 🔨 Build Từ Source

### Yêu cầu
- Ubuntu 22.04+ (Linux), Windows 10+ (Windows), macOS 13+ (macOS)
- 16GB+ RAM
- 50GB+ ổ cứng trống

### Build nhanh (Linux)
```bash
# Clone repo
git clone https://github.com/phamvanthuong/vnoffice.git
cd vnoffice

# Clone LibreOffice source
git clone --depth 1 --branch libreoffice-25-2 \
  https://git.libreoffice.org/core libreoffice-core
cd libreoffice-core

# Áp dụng branding
bash ../scripts/apply-branding.sh

# Cấu hình & build
./autogen.sh
make -j$(nproc)
```

### Build tự động (GitHub Actions)
Push tag mới để trigger build tự động cho cả 3 OS:
```bash
git tag v1.0.0
git push origin v1.0.0
# → GitHub Actions tự động build Windows, macOS, Linux
```

## 📞 Liên Hệ

| | |
|---|---|
| **Chủ sở hữu** | PHẠM VĂN THƯƠNG |
| **Email** | info@vnoffice.org |
| **Website** | https://vnoffice.org |
| **GitHub** | https://github.com/phamvanthuong/vnoffice |

## 🙏 Cảm Ơn

VNOffice được xây dựng dựa trên [LibreOffice](https://www.libreoffice.org/) — dự án mã nguồn mở của [The Document Foundation](https://www.documentfoundation.org/). Xin gửi lời cảm ơn đến cộng đồng LibreOffice và tất cả contributors đã đóng góp trong hơn 20 năm qua.

---

<p align="center">
  Made with ❤️ in Vietnam 🇻🇳
</p>
