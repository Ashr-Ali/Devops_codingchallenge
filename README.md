
# Embedded DevOps CI/CD Pipeline for ARM Cortex-M

![CI/CD](https://img.shields.io/github/actions/workflow/status/your-username/embedded-devops-pipeline/ci.yml?label=Build%20%26%20Test)
![License](https://img.shields.io/badge/License-MIT-blue)

A complete CI/CD pipeline for embedded firmware targeting ARM Cortex-M processors.  
This project demonstrates automated build, hardware simulation testing, SBOM generation, metadata tracking, and supply chain integrity verification — aligned with modern compliance and DevOps best practices.

---

## 📂 Repository Structure

```bash
embedded-devops-pipeline/
├── .github/
│   └── workflows/
│       └── ci.yml                   # GitHub Actions pipeline
├── README.md                        # Project documentation
├── renode_script.resc               # Renode simulation script
├── scripts/                         # Build + validation scripts
│   ├── generate_metadata.sh
│   ├── generate_sbom.sh
│   └── verify_sbom.py
├── src/                             # Firmware source code
│   ├── linker_script.ld
│   ├── main.c
│   └── startup.c
└── tests/                           # Test infrastructure
    └── test_runner.py
```

---

## ⚙️ Prerequisites

Install these tools locally:

```bash
sudo apt-get install gcc-arm-none-eabi qemu-system-arm python3 python3-pip
pip3 install jsonschema
```

---

## 🚀 Local Build & Test

### 1️⃣ Clone the repository

```bash
git clone https://github.com/Ashr-Ali/Devops_codingchallenge.git
cd embedded-devops-pipeline
```

### 2️⃣ Build firmware

```bash
mkdir -p build
arm-none-eabi-gcc -mcpu=cortex-m4 -mthumb -nostdlib \
  -T src/linker_script.ld -Wl,-Map=build/firmware.map \
  -o build/firmware.elf src/main.c src/startup.c
```

### 3️⃣ Generate artifacts

```bash
./scripts/generate_metadata.sh build/firmware.elf
./scripts/generate_sbom.sh build/firmware.elf
python3 scripts/verify_sbom.py build/firmware.spdx.json
sha256sum build/firmware.elf > build/firmware.sha256
```

### 4️⃣ Run tests

```bash
qemu-system-arm -machine netduinoplus2 -cpu cortex-m4 \
  -nographic -kernel build/firmware.elf \
  -serial file:build/test_output.log

python3 tests/test_runner.py build/test_output.log
```

---

## ⚡ CI/CD Pipeline (GitHub Actions)

The CI/CD pipeline is configured in `.github/workflows/ci.yml` and triggers on every push or pull request.

### Stages:
✅ Build firmware using ARM GCC  
✅ Generate metadata (Git SHA, timestamp, toolchain info)  
✅ Generate SPDX SBOM (v2.3)  
✅ Validate SBOM structure  
✅ Compute SHA256 checksums  
✅ Run QEMU simulation tests  
✅ Upload artifacts:  
- `firmware.elf`  
- `firmware.spdx.json`  
- `firmware.sha256`  
- `test_output.log`  

🔗 **[Example CI run](https://github.com/your-username/embedded-devops-pipeline/actions)**  
(Replace with your actual link!)

Artifacts can be downloaded from the *Actions* tab under each run.

---

## 📝 Extending the Solution

- **Add new targets**: Update matrix in `ci.yml`  
- **Use Renode**: Integrate `renode_script.resc` in CI  
- **Add hardware-in-loop tests**: Extend pipeline with HIL stages  
- **Enable signing**: Use GPG or Cosign for artifact signing  

---

## 🎥 Walk-through Video

👉 See `walkthrough.mp4` in the repository root for a project explanation and demo.

---

## 📌 License

This project is licensed under the MIT License — see `LICENSE`.

---

## ✅ Notes

- CI artifacts include firmware binary, SBOM, metadata, checksum, and test logs.  
- Designed for reproducibility and compliance in regulated embedded environments.