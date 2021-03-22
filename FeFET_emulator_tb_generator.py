# −∗− coding : utf−8 −∗− 
""" 
Created on Fri March 12 11 :25 :00 2021
@author : MATRANGOLO Paul-Antoine 
""" 

import numpy as np 
import pyperclip 
import matplotlib .pyplot as pl

hex_val = ['F', 'E', 'D', 'C', 'B', 'A', '9', '8', '7', '6', '5' , '4', '3', '2', '1', '0']


def ecrire(signal , valeurs , temps, nbBits = 8) :
    chaine = signal + " <= "
    for i in range(len(valeurs)) : 
        #chaine += "std_logic_vector(X\"" 
        val_str = str(hex(int(valeurs [ i ])))[2: 11]
        while(len(val_str) != (nbBits/4)) :
            val_str = "0" + val_str
        
        chaine += "X\"" + val_str + "\""
        #chaine += str(nbBits) + ")"
        chaine += " after " + str(float(temps[ i ])) + "us" 
        
        if i == len(valeurs) - 1 : 
            chaine += ";" 
        else : 
            chaine +=",\n"
    print(chaine) 
    pyperclip.copy(chaine)

t = np. linspace(0, 200, 1000)



#rampe simple 

val = [ 8388608 + i*8388607/250 for i in range(250)]
val += [i*8388607/250 for i in range(250)]
val += [8388607 - i*8388607/250 for i in range(250)]
val += [16777215 - i*8388608/250 for i in range(250)]


"""
#caractérisation en tension
val = [0 for i in range(50)]
#initialisation de la FeFET 
val += [2147483648 for i in range(100)]
val += [0 for i in range(150)]
val += [2139095040 for i in range(100)]
val += [0 for i in range(600)]
# +4V pour sotcker un 0 logique
val += [2139095040 for i in range(100)]
val += [0 for i in range(150)]
# Lecture 
val += [641728512 for i in range(50)]
val += [0 for i in range(200)]
#-4V pour sotcker un 1 logique
val += [2147483648 for i in range(100)]
val += [0 for i in range(150)]
# Lecture 
val += [641728512 for i in range(50)]
val += [0 for i in range(200)]
"""

pl. plot(t , val) 
pl. xlabel("t(ns)") 
pl. ylabel("Vin(binaire)") 
pl.show()
ecrire("Vin" , val , t , 24)
