# Annotate Linux/ARM (EABI) system calls and arguments.
# @author b0bb
# @category Pwn
# @keybinding
# @menupath Analysis.Pwn.Syscalls.arm.eabi
# @toolbar

import ghidra.app.util.opinion.ElfLoader as ElfLoader
from lib.Syscalls import Syscalls


def run():
    if currentProgram.getExecutableFormat() != ElfLoader.ELF_NAME:
        popup("Not an ELF file, cannot continue")
        return

    arch = "arm"
    abi = "eabi"

    obj = Syscalls(currentProgram, currentSelection, monitor, arch, abi)


run()
