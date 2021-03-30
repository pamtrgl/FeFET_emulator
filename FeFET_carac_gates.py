# −∗− coding : utf−8 −∗− 
""" 
Created on Mon March 29 08 :15 :00 2021
@author : MATRANGOLO Paul-Antoine

@description : These program aim to recover data from CSV file with multiple
 data source.

@release : 1.0
"""

import csv
import numpy as np
import matplotlib.pyplot as plt


plotTab = [] # table of tables for ploting
# raw values
valuesX = []
valuesY = []
# sorted values
prePlotTabX = []
prePlotTabY = []


with open(r"C:\Users\pmatrangolo\Documents\FeFET_model\models\carac_Nand.csv", newline='') as csvfile:
    for row in csv.reader(csvfile, dialect='excel', delimiter=','):
        for i in range(0, len(row), 2):
            valuesX.append(row[i])
            valuesY.append(row[i+1])

for i in range(0, 28, 1):
    for j in range(0, 1443, 1):
        prePlotTabX.append(valuesX[i + j*28])
        prePlotTabY.append(valuesY[i + j*28])

# print(prePlotTabX[0: 1443],"\n")
# print(prePlotTabY[0: 1443],"\n")

#-- conversion in float
fltPrePlotTabX = []
fltPrePlotTabY = []

for i in range(0, 28, 1):
    for j in range(1, 1443, 1):
        fltPrePlotTabX.append(float(prePlotTabX[j+i*1443]))
        fltPrePlotTabY.append(float(prePlotTabY[j+i*1443]))

# print(fltPrePlotTabX[0: 1442],"\n")
# print(fltPrePlotTabY[0: 1442],"\n")

#-- saving figures
for i in range(0, 28, 1):
    plt.plot(fltPrePlotTabX[i*1442:(i+1)*1442], fltPrePlotTabY[i*1442:(i+1)*1442])
    plt.xlabel(str(prePlotTabX[i*1443])) 
    plt.ylabel(str(prePlotTabY[i*1443]))
    figFileName = str(prePlotTabX[i*1443]) + "_-_" + str(prePlotTabY[i*1443]) + ".png"
    figFileName = figFileName.replace(':', '_')
    figFileName = figFileName.replace(' ', '')
    plt.title(figFileName)
    # plt.show()    # checking figures
    plt.savefig(figFileName)
    plt.clf()
