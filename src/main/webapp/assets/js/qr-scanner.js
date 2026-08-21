// qr-scanner.js
// Yêu cầu: Đã load thư viện jsQR trước (https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.min.js)

/**
 * Đọc file ảnh và giải mã QR
 * @param {File} file 
 * @returns {Promise<string>} Chuỗi giải mã được
 */
function decodeQR(file) {
    return new Promise((resolve, reject) => {
        if (!window.jsQR) {
            reject(new Error("Thư viện jsQR chưa được load."));
            return;
        }

        const reader = new FileReader();
        reader.onload = (e) => {
            const img = new Image();
            img.onload = () => {
                const canvas = document.createElement("canvas");
                const context = canvas.getContext("2d", { willReadFrequently: true });
                
                // Giới hạn ảnh không quá lớn để tránh crash, nhưng đủ lớn (2500px) để không làm vỡ mã QR góc nhỏ
                const MAX_WIDTH = 2500;
                let width = img.width;
                let height = img.height;
                if (width > MAX_WIDTH) {
                    height = Math.round(height * MAX_WIDTH / width);
                    width = MAX_WIDTH;
                }

                canvas.width = width;
                canvas.height = height;
                context.drawImage(img, 0, 0, width, height);
                
                const imageData = context.getImageData(0, 0, width, height);
                const code = jsQR(imageData.data, imageData.width, imageData.height);
                
                if (code && code.data) {
                    resolve(code.data);
                } else {
                    reject(new Error("Khong tim thay ma QR hop le trong anh. Vui long crop (cat) anh chi de lai ma QR, hoac chup gan, ro net nhat co the."));
                }
            };
            img.onerror = () => reject(new Error("Loi khi doc file anh. Dam bao file tai len la dinh dang anh."));
            img.src = e.target.result;
        };
        reader.onerror = () => reject(new Error("Loi khi doc file."));
        reader.readAsDataURL(file);
    });
}

/**
 * Phan tich chuoi CCCD
 * VD: 001095000001|123456789|Nguyen Van A|15051995|Nam|So 10 Duong ABC, Phuong XYZ, Quan 1, TP.HCM|25122021
 * @param {string} qrText 
 * @returns {Object} { cccd, cmnd, fullName, dob, gender, address, issueDate }
 */
function parseCccdString(qrText) {
    if (!qrText) throw new Error("Ma QR rong.");
    
    const parts = qrText.split('|');
    if (parts.length < 7) {
        throw new Error("Ma QR khong dung dinh dang CCCD cua Viet Nam.");
    }
    
    // Ngày sinh: DDMMYYYY -> YYYY-MM-DD
    const rawDob = parts[3];
    let dob = "";
    if (rawDob && rawDob.length === 8) {
        dob = rawDob.substring(4, 8) + "-" + rawDob.substring(2, 4) + "-" + rawDob.substring(0, 2);
    }
    
    // Giới tính: Nam (1), Nữ (0)
    const genderText = parts[4] || "";
    let genderVal = "1"; // Default Nam
    if (genderText.toLowerCase() === "nữ" || genderText.toLowerCase() === "nu") {
        genderVal = "0";
    }
    
    return {
        cccd: parts[0],
        cmnd: parts[1],
        fullName: parts[2],
        dob: dob,
        gender: genderVal,
        address: parts[5],
        issueDate: parts[6]
    };
}
