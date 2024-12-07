riscv64-unknown-linux-gnu-as -march=rv64im -mabi=lp64 -o 06.o -c 06.s
riscv64-unknown-linux-gnu-ld -T 06.ld --no-dynamic-linker -m elf64lriscv -static -nostdlib --strip-all --output 06.elf
{
    #cat 06.example.txt
    cat 06.txt
    printf '\x04' # end of transmission
} | qemu-system-riscv64 -machine virt -bios 06.elf -serial stdio -display none -gdb tcp::9000 "$@"

# Debug with
#   gdb -tui --eval-command="target remote localhost:9000" --eval-command="layout asm" --eval-command="layout regs"    
# Run this script with -S to wait for debugger