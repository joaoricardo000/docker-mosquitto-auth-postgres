#!/usr/bin/env python
"""
Original from: https://github.com/jpmens/mosquitto-auth-plug/tree/master/contrib/python
"""

import sys
from getpass import getpass
import hashing_passwords as hp

pw = getpass("Enter password: ")
pw2 = getpass("Re-enter password: ")

if pw != pw2:
    sys.exit("Passwords don't match!")

print(hp.make_hash(pw))
