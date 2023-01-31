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
parser.add_option("-l", "--legend", metavar="PATH", dest="legend",
                  action="append", help="Legend")
parser.add_option("-o", "--outFile", metavar="PATH", dest="outFile",
                  default="output.svg", help="Output PNG File")
(options, args) = parser.parse_args()

# [[], [], []]
execution = [[] for i in range(int(options.numconf))]
minor = [[] for i in range(int(options.numconf))]
major = [[] for i in range(int(options.numconf))]
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

    execution[r].append(float(row[1]))
    minor[r].append(float(row[2]))
    major[r].append(float(row[3]))
    serdes[r].append(float(row[4]))
    diff = float(row[1]) - float(row[2]) - float(row[3]) - float(row[4])
    # Other contains serialization
    other[r].append(diff)

    counter = counter + 1

# Plot figure with fix size
fig, ax = plt.subplots(figsize=config.quartfigsize)

# Grid
ax.grid(which='major', axis='y', linestyle=':')

bar_width = 1.1
opacity = 1
index = [0, 1.5, 3, 4.5, 6, 7.5]

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

ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)

ax.annotate('OOM', (-0.5, 0.02))

# Axis name
plt.ylabel('Normalized Execution Time', ha="center", fontsize=config.fontsize)
plt.xlabel('DRAM (GB)', fontsize=config.fontsize)

# plt.xticks(index, options.legend, fontsize=config.fontsize)

index = np.array([0, 1.5, 3, 4.5, 2.1, 6, 6.9, 7.5])

plt.xticks(index, options.legend, fontsize=config.fontsize)

# vertical alignment of xtick labels
va = [0, 0, 0, 0, -0.1, 0, -0.1, 0]
for t, y in zip(ax.get_xticklabels(), va):
    t.set_y(y)

ax.tick_params(axis='x', which='minor', direction='out', length=30,
               width=config.edgewidth)
ax.tick_params(axis='x', which='major', bottom=False, top=False)

# Vertical lines in x axis
xticks_minor = [-1, 5.05]
ax.set_xticks(xticks_minor, minor=True)
ax.set_xlim(-1, 8.1)

plt.yticks(fontsize=config.fontsize)

# Save figure
plt.savefig('%s' % options.outFile, bbox_inches='tight', dpi=900)
