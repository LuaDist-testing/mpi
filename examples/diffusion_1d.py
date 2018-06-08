#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Plot 1-dimensional density distribution.
# Copyright © 2013–2015 Peter Colberg.
# Distributed under the MIT license.
#

import matplotlib as mpl
mpl.use("agg")
import matplotlib.pyplot as plt
import numpy as np
import h5py
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("output", help="plot filename")
parser.add_argument("input", help="input filename")
args = parser.parse_args()

with h5py.File(args.input, "r") as f:
  rho = f["density"][:]
  x = np.linspace(0., 1., rho.shape[1])

mpl.rc("font", size=14)

fig = plt.figure(figsize=(6.0, 3.5))
ax = fig.add_subplot(1, 1, 1)

# http://colorbrewer2.org/
# 11-class RdYlBu
ax.set_color_cycle([
  "#a50026",
  "#d73027",
  "#f46d43",
  "#fdae61",
  "#fee090",
  "#ffffbf",
  "#e0f3f8",
  "#abd9e9",
  "#74add1",
  "#4575b4",
  "#313695",
])

ax.plot(x, rho.T, lw=1.5)
ax.minorticks_on()
ax.set_ylim(bottom=0.)
ax.set_xlabel(r"$x$")
ax.set_ylabel(r"$\rho(x)$")
fig.tight_layout(pad=0.2)
fig.savefig(args.output)
