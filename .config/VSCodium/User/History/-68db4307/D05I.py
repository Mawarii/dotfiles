#!/usr/bin/env python3
"""
A do-not-disturb button for muting Dunst notifications in i3 using i3blocks

Mute is handled using the `dunstctl` command.
"""

__author__ = "Jessey White-Cinis <j@cin.is>"
__copyright__ = "Copyright (c) 2019 Jessey White-Cinis"
__license__ = "MIT"
__version__ = "1.1.0"

import os
import subprocess as sp

def muted():
    '''Returns True if Dunst is muted'''
    output = sp.check_output(('dunstctl', 'is-paused'))
    return u'true' ==  output.strip().decode("UTF-8")

if clicked():
    # toggle button click to turn mute on and off
    mute_toggle()

args = os.sys.argv[1:]
if args and args[0] == '--toggle':
    mute_toggle()

if muted():
    print("")
else:
    print("")
