#!/usr/bin/python
from macholib import MachO
from macholib import mach_o
from macholib.ptypes import *
import os
import sys
def main(executableName):
    print
    print 'Macho RemovePIE'
    print
    print 'This script may cause some unpredictable issues.'
    rawFile = open(executableName, 'r');
    print '[+]Making backup'
    os.system('cp %s %s_bak' % (executableName, executableName))
    print '[+]Reading raw executable'
    machoHeader = MachO.MachO(executableName)
    print '[+]%s readed' % machoHeader.filename
    for h in machoHeader.headers:
		  print h

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print 'Useage: python',sys.argv[0],'[executable path]'
        exit()
    
    if not os.path.exists(sys.argv[1]):
        print '#Error: File does not exist'
        exit()

    main(sys.argv[1])
    exit()