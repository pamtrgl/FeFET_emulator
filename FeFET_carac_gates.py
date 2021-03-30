# −∗− coding : utf−8 −∗− 
""" 
Created on Mon March 29 08 :15 :00 2021
@author : MATRANGOLO Paul-Antoine

@description : This program aim to recover data from CSV file with multiple
 data source.

@release : 1.1

@release_note : This release includes functions for column and row counting and a function with
 parameters to be use with different file.
"""

import csv
import numpy as np
import matplotlib.pyplot as plt


#file size
fileSize = []
# raw values
valuesX = []
valuesY = []
# sorted values
prePlotTabX = []
prePlotTabY = []
#-- conversion in float
fltPrePlotTabX = []
fltPrePlotTabY = []


"""--------------------------------------------------------------------
@name : col_counter

@param :
    - filname (str) : filename or path
    - delim : delimiter of the data (default: ',')

@description : function to count the number of col in a csv file.
---------------------------------------------------------------------"""
def col_counter(filename, delim=','):
    with open(filename, newline='') as csvfile:
        for row in csv.reader(csvfile, dialect='excel', delimiter=delim):
            break
    return(len(row))


""" ----------------------------------------------------------------------
@name : row_counter

@param :
    - filname (str) : filename or path
    - delim : delimiter of the data (default: ',')

@description : function to count the number of row in a csv file.
----------------------------------------------------------------------- """
def row_counter(filename, delim=','):
    # col = []
    with open(filename, newline='') as csvfile:
        csvReader = csv.reader(csvfile, dialect='excel', delimiter=delim)
        for row in csvReader:
            continue
    return(csvReader.line_num)

""" ----------------------------------------------------------------------
@name : row_counter

@param :
    - filname (str) : filename or path
    - nb_row (int) : number of row (default: 1)
    - nb_col (int) : number of row (default: 1)
    - delim : delimiter of the data (default: ',')

@description : function to recover data and save figures.
----------------------------------------------------------------------- """
def recover_data(filename, nb_row=1, nb_col=1, delim=','):

    nb_col = int(nb_col/2)

    with open(filename, newline='') as csvfile:
        for row in csv.reader(csvfile, dialect='excel', delimiter=delim):
            for i in range(0, len(row), 2):
                valuesX.append(row[i])
                valuesY.append(row[i+1])


    for i in range(0, nb_col, 1):
        for j in range(0, nb_row, 1):
            prePlotTabX.append(valuesX[i + j*nb_col])
            prePlotTabY.append(valuesY[i + j*nb_col])

    # print(prePlotTabX[0: 1443],"\n")
    # print(prePlotTabY[0: 1443],"\n")

    for i in range(0, nb_col, 1):
        for j in range(1, nb_row, 1):
            fltPrePlotTabX.append(float(prePlotTabX[j+i*nb_row]))
            fltPrePlotTabY.append(float(prePlotTabY[j+i*nb_row]))

    # print(fltPrePlotTabX[0: 1442],"\n")
    # print(fltPrePlotTabY[0: 1442],"\n")

    #-- saving figures
    for i in range(0, nb_col, 1):
        plt.plot(fltPrePlotTabX[i*(nb_row-1):(i+1)*(nb_row-1)], fltPrePlotTabY[i*(nb_row-1):(i+1)*(nb_row-1)])
        plt.xlabel(str(prePlotTabX[i*nb_row])) 
        plt.ylabel(str(prePlotTabY[i*nb_row]))
        figFileName = str(prePlotTabX[i*nb_row]) + "_-_" + str(prePlotTabY[i*nb_row]) + ".png"
        figFileName = figFileName.replace(':', '_')
        figFileName = figFileName.replace('/', '_')
        figFileName = figFileName.replace(' ', '')
        plt.title(figFileName)
        # plt.show()    # checking figures
        plt.savefig(figFileName)
        plt.clf()

#-----------------------------------------------------------------------------------------------------------------#
####---                                        start of the program                                         ---####
#-----------------------------------------------------------------------------------------------------------------#

# counting row and line
nb_row = row_counter(r"C:\Users\pmatrangolo\Documents\FeFET_model\models\carac_Nand.csv")
nb_col = col_counter(r"C:\Users\pmatrangolo\Documents\FeFET_model\models\carac_Nand.csv")

# recovering data
recover_data(r"C:\Users\pmatrangolo\Documents\FeFET_model\models\carac_Nand.csv", nb_row, nb_col)