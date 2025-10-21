# 📁 Minimalist File Management System

A lightweight file management system implemented entirely in x86 assembly language, demonstrating low-level file operations and system programming.

![Language](https://img.shields.io/badge/Language-x86%20Assembly-red)
![Platform](https://img.shields.io/badge/Platform-Linux-yellow)
![Tested](https://img.shields.io/badge/Tested-Verified-green)

## 📋 Overview

This project is a minimalist file management system written in pure x86 assembly that performs essential file operations at the system call level. The implementation showcases direct interaction with the Linux kernel for file handling without any high-level abstractions.

## ✨ Features

- 📂 File creation and deletion
- 📝 Read and write operations
- 🔍 File metadata access
- 💾 Direct system call implementation
- ✅ Automated testing and verification

## 🛠️ Technical Details

- **Architecture**: x86 (32-bit)
- **Assembler**: GNU Assembler (GAS)
- **System**: Linux syscalls for file I/O
- **Compiler Driver**: GCC with `-m32` flag

## 🚀 Building & Running

### Prerequisites

- GCC with 32-bit support
- Python 3 (for checker)
- Linux operating system

### Build Instructions

**Task 1:**
```bash
gcc -m32 132_Cuntan_Paul_0.s -o task1 -no-pie
./task1
```

**Task 2:**
```bash
gcc -m32 132_Cuntan_Paul_1.s -o task2 -no-pie
./task2
```

### Running the Checker

To verify the implementation is working correctly:

```bash
python3 checker.py
```

**Checker Credits**: The automated verification system was created by [Iancu Ivasciuc](https://github.com/iancuivasciuc/csa/tree/master/project)

## 💡 Learning Opportunities

This project provides hands-on experience with:

### Low-Level Programming Concepts
- **System Calls**: Direct invocation of Linux kernel functions (`open`, `read`, `write`, `close`, etc.)
- **File Descriptors**: Managing file handles at the OS level
- **Memory Management**: Manual buffer allocation and data manipulation
- **Error Handling**: Checking return values and managing edge cases in assembly

### Assembly Programming Techniques
- **Register Management**: Efficient use of CPU registers for operations
- **Stack Operations**: Preserving and restoring state during function calls
- **Data Structures**: Implementing buffers and data storage in assembly
- **Control Flow**: Conditional jumps and loops for program logic

### System Programming Skills
- **POSIX Interface**: Understanding Unix/Linux system call conventions
- **ABI Compliance**: Following calling conventions for system interactions
- **Binary I/O**: Working with raw bytes and file streams
- **Performance Optimization**: Writing efficient low-level code

## 🎯 Implementation Strategies

### Modular Design
- Separation of concerns between different file operations
- Reusable code blocks for common syscall patterns
- Clear procedure boundaries with proper stack management

### Robust Error Handling
- Validation of syscall return values
- Graceful handling of file operation failures
- Resource cleanup and proper file descriptor management

### Syscall Optimization
- Minimizing syscall overhead
- Efficient buffer management
- Strategic use of registers to reduce memory access

### Testing-Driven Development
- Integration with automated checker
- Verification of edge cases
- Validation against expected behavior

## 🎓 Educational Value

This project bridges the gap between high-level programming concepts and actual hardware execution, demonstrating:

- How file systems work at the kernel level
- The role of system calls in operating systems
- Why abstractions in high-level languages exist
- Performance considerations in low-level code
- The foundation of system programming

## 🙏 Acknowledgments

- **Checker System**: [Iancu Ivasciuc](https://github.com/iancuivasciuc/csa/tree/master/project)

## 📝 License

This project is open source and available for educational purposes.

---
