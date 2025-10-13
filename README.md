# KittenOS - Operating System

Operating System written from scratch in x86 assembly and C 🐈.

## Prerequisites Installation on Ubuntu

### 1. Install Essential Build Tools
```bash
sudo apt update
sudo apt install build-essential git make
```

### 2. Install Cross-Compiler for i686 Architecture
```bash
sudo apt install gcc-i686-linux-gnu binutils-i686-linux-gnu g++-i686-linux-gnu
```

### 3. Install Assembler and Emulator
```bash
sudo apt install nasm qemu-system-x86
```

### 4. Install Debugger
```bash
sudo apt install gdb
```

### 5. Optional: Install 32-bit Support Libraries
```bash
sudo apt install gcc-multilib
```

### Complete One-Line Installation
```bash
sudo apt update && sudo apt install build-essential git make gcc-i686-linux-gnu binutils-i686-linux-gnu g++-i686-linux-gnu nasm qemu-system-x86 gdb
```

## Build Commands

### Build the Complete OS Image
```bash
make
```
This creates `os-image.bin` which contains both the bootloader and kernel.

### Run the Operating System

#### Console Mode (Recommended for SSH/headless)
```bash
make run-console
```
- Uses text-only display
- **To exit**: Press `Ctrl+A` then `X`

#### Curses Display
```bash
make run
```
- Uses text-based graphical display
- **To exit**: Press `Ctrl+A` then `X`

#### VNC Graphical Server
```bash
make run-vnc
```
- Opens a graphical window at localhost:5900
- **To exit**: Close the window or press `Ctrl+Alt+2` then type `quit`

### Debug the Operating System

#### Start Debugging Session
```bash
make debug
```
This will:
1. Start QEMU in debug mode (paused at startup)
2. Launch GDB and connect to QEMU
3. Load kernel symbols for debugging

## Troubleshooting

### Common Issues and Solutions

#### "GTK initialization failed"
- **Cause**: No graphical display available
- **Solution**: Use `make run-console` or `make run` (with curses)

#### QEMU won't start
- **Solution**: Try different run options:
  ```bash
  make run-console    # Most reliable
  make run           # Text-based graphics
  make run-vnc       # VNC server
  ```

## Useful Resources

- [OSDev.org](https://wiki.osdev.org/) - Operating System Development Wiki
- [Intel® 64 and IA-32 Architectures Software Developer Manuals](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html)
- [NASM Documentation](https://www.nasm.us/doc/)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `make` and `make run-console`
5. Submit a pull request

Happy kernel hacking! 🐱💻
