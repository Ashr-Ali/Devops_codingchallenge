#!/bin/bash

FIRMWARE_NAME=$1

# Get git information
GIT_SHA=$(git rev-parse HEAD)
GIT_TAG=$(git describe --tags --always --dirty 2>/dev/null || echo "unknown")
BUILD_TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
TOOLCHAIN_VERSION=$(arm-none-eabi-gcc --version | head -n1)

# Create metadata JSON
cat <<EOF > ${FIRMWARE_NAME}.metadata.json
{
  "firmware_name": "${FIRMWARE_NAME}",
  "git_sha": "${GIT_SHA}",
  "git_tag": "${GIT_TAG}",
  "build_timestamp": "${BUILD_TIMESTAMP}",
  "toolchain": "arm-none-eabi-gcc",
  "toolchain_version": "${TOOLCHAIN_VERSION}",
  "target": "STM32F407"
}
EOF

echo "Generated metadata:"
cat ${FIRMWARE_NAME}.metadata.json