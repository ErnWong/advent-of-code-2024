#riscv64-unknown-linux-gnu-as -march=rv64im -mabi=lp64 -o 06.a.o -c 06.a.s
#riscv64-unknown-linux-gnu-ld -T 06.a.ld --no-dynamic-linker -m elf64lriscv -static -nostdlib --strip-all --output 06.a.elf
#{
#    #cat 06.example.txt
#    cat 06.txt
#    printf '\x04' # end of transmission
#} | qemu-system-riscv64 -machine virt -bios 06.a.elf -serial stdio -display none -gdb tcp::9000 "$@"

riscv64-unknown-linux-gnu-as -march=rv64im -mabi=lp64 -o 06.b.o -c 06.b.s
riscv64-unknown-linux-gnu-ld -T 06.b.ld --no-dynamic-linker -m elf64lriscv -static -nostdlib --strip-all --output 06.b.elf
{
    cat 06.example.txt
    #cat 06.txt
    printf '\x04' # end of transmission
} | qemu-system-riscv64 -machine virt -bios 06.b.elf -serial stdio -display none -gdb tcp::9000 "$@"

# Debug with
#   gdb -tui --eval-command="target remote localhost:9000" --eval-command="layout asm" --eval-command="layout regs"    
# Run this script with -S to wait for debugger