# CustomCode.py
# Author Petri Laakkonen
# petri@laakkonen.io

def string2float(string):
    a = string.split()
    b = a[0]
    c = b[1:]
    d = c.replace(",", ".")
    value = float(d)
    return value

