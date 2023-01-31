#!/usr/bin/env python3

###################################################
#
# file: 1.gc_serdes.py
#
# @Author:   Iacovos G. Kolokasis
# @Version:  07-03-2021
# @email:    kolokasis@ics.forth.gr
#
# Plot serializaiton vs gc using different cache size
#
###################################################

import csv
import optparse
import matplotlib
import matplotlib.pyplot as plt
import config
import sys
import numpy as np
matplotlib.use('Agg')

usage = "usage: %prog [options]"
parser = optparse.OptionParser(usage=usage)
parser.add_option("-i", "--inputFile", metavar="PATH", dest="inFile",
                  help="Input CSV File")
parser.add_option("-n", "--numApps", metavar="PATH", dest="num_apps",
                  help="Number of Workloads")
parser.add_option("-c", "--numConfig", metavar="PATH", dest="numconf",
                  help="Number of Configurations")
parser.add_option("-o", "--outFile", metavar="PATH", dest="outFile",
                  default="output.svg", help="Output PNG File")
(options, args) = parser.parse_args()

# [[], [], []]
execution = [[] for i in range(int(options.numconf))]
minor = [[] for i in range(int(options.numconf))]
major = [[] for i in range(int(options.numconf))]
cgc = [[] for i in range(int(options.numconf))]
serdes = [[] for i in range(int(options.numconf))]
other = [[] for i in range(int(options.numconf))]

# Open file
inputFile = open(options.inFile, 'r')
data = csv.reader(inputFile, delimiter=',')

# Skip the firts row
next(data)

counter = 0                 # Line counter
r = 0                       # Row number
num = int(options.num_apps)

for row in data:
    if (counter != 0) and (counter % num == 0):
        r = r + 1

    execution[r].append(float(row[2]))
    minor[r].append(float(row[3]))
    major[r].append(float(row[4]))
    cgc[r].append(float(row[5]))
    serdes[r].append(float(row[6]))
    diff = float(row[2]) - float(row[3]) - float(row[4]) - float(row[5]) - float(row[6])
    # Other contains serialization
    other[r].append(diff)

    counter = counter + 1

# Plot figure with fix size
fig, ax = plt.subplots(figsize=config.halffigsize)

# Grid
ax.grid(which='major', axis='y', linestyle=':')

bar_width = 1
opacity = 1
index = []

for i in range(0, 10):
    index.append(i * int(options.numconf) * 1.1)

for i in range(len(execution)):
    tmp_index = [x + i*bar_width for x in index]

    ax.bar(tmp_index, other[i], bar_width, color=config.monochrom[10],
           edgecolor=config.edgecolor, zorder=2,
           linewidth=config.edgewidth,
           label="Compute" if i == 0 else None)

    ax.bar(tmp_index, serdes[i], bar_width, bottom=other[i],
           color=config.monochrom[2], edgecolor=config.edgecolor,
           linewidth=config.edgewidth,
           zorder=2, label="Serdes+I/O" if i == 0 else None)

    tmp2 = [x+y for x, y in zip(serdes[i], other[i])]

    ax.bar(tmp_index, minor[i], bar_width, bottom=tmp2,
           color=config.monochrom[0], edgecolor=config.edgecolor,
           linewidth=config.edgewidth,
           zorder=2, label="Minor GC" if i == 0 else None)

    tmp = [x+y for x, y in zip(tmp2, minor[i])]

    ax.bar(tmp_index, major[i], bar_width, bottom=tmp,
           color=config.monochrom[10], edgecolor=config.edgecolor,
           linewidth=config.edgewidth,
           hatch=config.d_patterns[3],
           zorder=2, label="Major GC" if i == 0 else None)

    tmp0 = [x+y for x, y in zip(major[i], tmp)]

    ax.bar(tmp_index, cgc[i], bar_width, bottom=tmp0,
           color=config.monochrom[10], edgecolor=config.edgecolor,
           linewidth=config.edgewidth,
           hatch=config.d_patterns[5],
           zorder=2, label="CGC" if i == 0 else None)

ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)

# Axis name
plt.ylabel('Normalized Execution Time', ha="center", fontsize=config.fontsize)

x_label_index = [0.05, 1.05, 2.05, 1.15,
                 3.35, 4.35, 5.35, 4.25,
                 6.75, 7.75, 8.75, 7.65,
                 10.15, 11.15, 12.15, 11.10,
                 13.25, 14.25, 15.25, 14.15,
                 16.55, 17.55, 18.55, 17.45,
                 19.95, 20.95, 21.95, 20.85,
                 23.15, 24.15, 25.15, 24.10,
                 26.45, 27.45, 28.45, 27.35,
                 29.75, 30.75, 31.75, 30.65]

label_index = np.array(x_label_index)

print(x_label_index)

plt.xticks(label_index, ("PS", "G1", "TH", "PR",
                         "PS", "G1", "TH", "CC",
                         "PS", "G1", "TH", "SSSP",
                         "PS", "G1", "TH", "SVD",
                         "PS", "G1", "TH", "TR",
                         "PS", "G1", "TH", "LR",
                         "PS", "G1", "TH", "LgR",
                         "PS", "G1", "TH", "SVM",
                         "PS", "G1", "TH", "BC",
                         "PS", "G1", "TH", "RL"),
                         fontsize=config.fontsize, rotation=90)

plt.yticks(fontsize=config.fontsize)

# vertical alignment of xtick labels
va = [0, 0, 0, -0.15,
      0, 0, 0, -0.15,
      0, 0, 0, -0.15,
      0, 0, 0, -0.15,
      0, 0, 0, -0.15,
      0, 0, 0, -0.15,
      0, 0, 0, -0.15,
      0, 0, 0, -0.15,
      0, 0, 0, -0.15,
      0, 0, 0, -0.15]
for t, y in zip(ax.get_xticklabels(), va):
    t.set_y(y)

counter = 1
for label in ax.get_xticklabels():
    if counter % 4 == 0:
        label.set_rotation(0)
    else:
        label.set_rotation(90)
    counter = counter + 1

ax.tick_params(axis='x', which='minor', direction='out', length=40,
               width=config.edgewidth)
ax.tick_params(axis='x', which='major', bottom=False, top=False)

# Vertical lines in x axis
xticks_minor = [2.65]
step = 3.3
for i in range(0, 10):
    xticks_minor.append(xticks_minor[-1] + step)
ax.set_xticks(xticks_minor, minor=True)
ax.set_xlim(-0.5, 32.3)

plt.yticks(fontsize=config.fontsize)

ax.annotate('OOM', (23.75, 0.02), rotation=90)
ax.annotate('OOM', (27, 0.02), rotation=90)
ax.annotate('OOM', (30.35, 0.02), rotation=90)

# Save figure
plt.savefig('%s' % options.outFile, bbox_inches='tight', dpi=900)
