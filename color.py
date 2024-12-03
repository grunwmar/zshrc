""" Make color from credential """

import sys
import os

def main(username, hostname):
    num_username = sum(ord(x) for x in username)
    num_hostname = sum(ord(x) for x in hostname)
    value = 16 + (num_username + num_hostname) % 240
    return value

if __name__ == "__main__":    
    val = main(os.environ["USER"], os.environ["HOSTNAME"])
    print(val)
