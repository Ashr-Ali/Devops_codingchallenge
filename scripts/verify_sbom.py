#!/usr/bin/env python3

import json
import sys
from jsonschema import validate

# SPDX 2.3 schema (simplified)
SPDX_SCHEMA = {
    "type": "object",
    "required": [
        "SPDXID",
        "name",
        "spdxVersion",
        "creationInfo",
        "dataLicense",
        "documentNamespace",
        "documentDescribes",
        "packages"
    ],
    "properties": {
        "SPDXID": {"type": "string"},
        "name": {"type": "string"},
        "spdxVersion": {"type": "string"},
        "creationInfo": {
            "type": "object",
            "required": ["created", "creators"],
            "properties": {
                "created": {"type": "string"},
                "creators": {"type": "array"}
            }
        },
        "dataLicense": {"type": "string"},
        "documentNamespace": {"type": "string"},
        "documentDescribes": {"type": "array"},
        "packages": {"type": "array"}
    }
}

def validate_sbom(file_path):
    try:
        with open(file_path, 'r') as f:
            sbom = json.load(f)
        
        validate(instance=sbom, schema=SPDX_SCHEMA)
        
        # Additional semantic validation
        if not sbom["SPDXID"].startswith("SPDXRef-DOCUMENT"):
            raise ValueError("Invalid SPDXID for document")
            
        if not sbom["spdxVersion"].startswith("SPDX-2"):
            raise ValueError("Unsupported SPDX version")
            
        print(f"SBOM validation successful: {file_path}")
        return True
        
    except Exception as e:
        print(f"SBOM validation failed: {str(e)}")
        return False

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: validate_sbom.py <sbom_file>")
        sys.exit(1)
    
    if not validate_sbom(sys.argv[1]):
        sys.exit(1)