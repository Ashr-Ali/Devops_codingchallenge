#!/usr/bin/env python3

import re
import sys

def verify_test_output(log_file):
    try:
        with open(log_file, 'r') as f:
            log_content = f.read()
        
        # Check for expected patterns in simulation output
        patterns = [
            r"System initialized",
            r"LED toggled \d+ times",
            r"System running normally"
        ]
        
        for pattern in patterns:
            if not re.search(pattern, log_content):
                raise ValueError(f"Pattern not found: {pattern}")
        
        print("Test verification passed")
        return True
        
    except Exception as e:
        print(f"Test verification failed: {str(e)}")
        return False

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: test_runner.py <log_file>")
        sys.exit(1)
    
    if not verify_test_output(sys.argv[1]):
        sys.exit(1)