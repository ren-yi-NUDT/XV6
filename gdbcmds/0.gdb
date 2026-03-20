file kernel/kernel

show environment GDBTARGET
python import os; target = os.getenv('GDBTARGET')
python gdb.execute('target remote ' + target)

set confirm off
set architecture riscv:rv64
set disassemble-next-line auto
set riscv use-compressed-breakpoints yes

b start
b procdump

display $priv
display/x cpus[$mhartid].proc
display cpus[$mhartid].proc.pid
display cpus[$mhartid].proc.name
