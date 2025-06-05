#!/bin/bash

FIRMWARE_NAME=$1

# Create SPDX SBOM
cat <<EOF > ${FIRMWARE_NAME}.spdx.json
{
  "SPDXID": "SPDXRef-DOCUMENT",
  "name": "${FIRMWARE_NAME} SBOM",
  "spdxVersion": "SPDX-2.3",
  "creationInfo": {
    "created": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "creators": [
      "Tool: GitHub Actions",
      "Organization: InfoMagnus"
    ],
    "licenseListVersion": "3.19"
  },
  "dataLicense": "CC0-1.0",
  "documentNamespace": "https://github.com/infomagnus/embedded-devops-pipeline",
  "documentDescribes": [
    "SPDXRef-FIRMWARE"
  ],
  "packages": [
    {
      "SPDXID": "SPDXRef-FIRMWARE",
      "name": "${FIRMWARE_NAME}",
      "versionInfo": "$(git describe --tags --always --dirty 2>/dev/null || echo "unknown")",
      "downloadLocation": "NOASSERTION",
      "filesAnalyzed": false,
      "licenseConcluded": "NOASSERTION",
      "licenseDeclared": "NOASSERTION",
      "copyrightText": "NOASSERTION",
      "externalRefs": [
        {
          "referenceCategory": "SECURITY",
          "referenceLocator": "cpe:2.3:a:infomagnus:${FIRMWARE_NAME}_firmware:*:*:*:*:*:*:*:*",
          "referenceType": "cpe23Type"
        },
        {
          "referenceCategory": "PACKAGE_MANAGER",
          "referenceLocator": "pkg:github/infomagnus/embedded-devops-pipeline@$(git rev-parse HEAD)",
          "referenceType": "purl"
        }
      ],
      "primaryPackagePurpose": "APPLICATION"
    },
    {
      "SPDXID": "SPDXRef-TOOLCHAIN",
      "name": "arm-none-eabi-gcc",
      "versionInfo": "$(arm-none-eabi-gcc --version | head -n1 | awk '{print $NF}')",
      "downloadLocation": "NOASSERTION",
      "filesAnalyzed": false,
      "licenseConcluded": "NOASSERTION",
      "licenseDeclared": "NOASSERTION",
      "copyrightText": "NOASSERTION",
      "primaryPackagePurpose": "TOOL"
    }
  ],
  "relationships": [
    {
      "spdxElementId": "SPDXRef-DOCUMENT",
      "relatedSpdxElement": "SPDXRef-FIRMWARE",
      "relationshipType": "DESCRIBES"
    },
    {
      "spdxElementId": "SPDXRef-TOOLCHAIN",
      "relatedSpdxElement": "SPDXRef-FIRMWARE",
      "relationshipType": "BUILD_TOOL_OF"
    }
  ]
}
EOF

echo "Generated SBOM:"
cat ${FIRMWARE_NAME}.spdx.json