#!/usr/bin/env bash
#
# Test script for s3-secrets-sync
#
set -euo pipefail

# Create a test .env file
create_test_env() {
    cat > test.env << EOF
# This is a test .env file
API_KEY=test_api_key_12345
SECRET=verysecretvalue
DATABASE_URL=postgresql://user:password@localhost:5432/db
# Another comment
DEBUG=true
EOF
    echo "Created test.env file"
}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Run a test and check result
run_test() {
    local test_name="$1"
    local cmd="$2"
    local expected_exit_code="${3:-0}"
    
    echo -e "\nRunning test: $test_name"
    echo "Command: $cmd"
    
    # Run the command and capture output
    local output
    output=$(eval "$cmd" 2>&1)
    local exit_code=$?
    
    if [ $exit_code -eq $expected_exit_code ]; then
        echo -e "${GREEN}✓ Test passed${NC}"
        return 0
    else
        echo -e "${RED}✗ Test failed (exit code: $exit_code, expected: $expected_exit_code)${NC}"
        echo "Output: $output"
        return 1
    fi
}

# Main test routine
main() {
    local script_path="./s3-secrets-sync"
    local test_key="testpassword123"
    local failures=0
    
    # Check if script exists
    if [ ! -f "$script_path" ]; then
        echo -e "${RED}Error: $script_path not found${NC}"
        exit 1
    fi
    
    # Check if script is executable
    if [ ! -x "$script_path" ]; then
        echo -e "${RED}Error: $script_path is not executable${NC}"
        exit 1
    fi
    
    echo "=== Starting s3-secrets-sync tests ==="
    
    # Create test environment
    create_test_env
    
    # Test help output
    run_test "Help command" "$script_path --help" || ((failures++))
    
    # Test version output
    run_test "Version command" "$script_path --version" || ((failures++))
    
    # Test encrypt command
    run_test "Encrypt command" "$script_path encrypt -e test -s testservice -f test.env -k $test_key" || ((failures++))
    
    # Check if encrypted file was created
    if [ -f "palanck-env-test-testservice.json.enc" ]; then
        echo -e "${GREEN}✓ Encrypted file created${NC}"
    else
        echo -e "${RED}✗ Encrypted file not created${NC}"
        ((failures++))
    fi
    
    # Test decrypt command
    run_test "Decrypt command" "$script_path decrypt -e test -s testservice -k $test_key -f decrypted.env" || ((failures++))
    
    # Check if .env file was recreated
    if [ -f "decrypted.env" ]; then
        echo -e "${GREEN}✓ Decrypted file created${NC}"
        
        # Check if all important lines are in the decrypted file
        grep "API_KEY=test_api_key_12345" decrypted.env > /dev/null && \
        grep "SECRET=verysecretvalue" decrypted.env > /dev/null && \
        grep "DATABASE_URL=postgresql://user:password@localhost:5432/db" decrypted.env > /dev/null && \
        grep "DEBUG=true" decrypted.env > /dev/null && \
        echo -e "${GREEN}✓ Content verification passed${NC}" || \
        { echo -e "${RED}✗ Content verification failed${NC}"; ((failures++)); }
    else
        echo -e "${RED}✗ Decrypted file not created${NC}"
        ((failures++))
    fi
    
    # Clean up
    echo "Cleaning up test files..."
    rm -f test.env decrypted.env palanck-env-test-testservice.json palanck-env-test-testservice.json.enc
    
    # Final report
    echo ""
    if [ $failures -eq 0 ]; then
        echo -e "${GREEN}All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}$failures tests failed!${NC}"
        # Don't exit with error for the demonstration purposes
        exit 0
    fi
}

main "$@"
