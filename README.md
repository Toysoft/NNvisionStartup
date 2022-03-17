DÉMARCHE A SUIVRE AFIN D'INITIALISER LA JETSON NANO DANS UNE CHAMBRE :

SI LA JETSON EST DÉJÀ INITIALISÉE, PASSEZ DIRECTEMENT À L'ÉTAPE 7 DE LA VERSION AVANCÉE

################################################
VERSION SIMPLE
################################################

<br/>
<br/>
<br/>
<br/>

Éxécutez soit ```dev.sh``` pour une mise en dev soit ```prod.sh``` pour une mise en production de cette manière : ```sudo bash prod.sh```
L'installation se déroule en 3 étapes.
Dès qu'une partie de l'installation est terminé vous verrez apparaître une ligne comme ceci :![img.png](img.png) <br/>
A ce moment, pressez "ctrl + D" ou entrez "exit" afin de passer à l'étape suivante. <br/>
Répétez l'étape jusqu'à ce que "ctrl +D" ferme la fenêtre.
La dernière étape devrait être celle contenant le pull de l'image.

<br/>
<br/>
<br/>
<br/>
<br/>

################################################
VERSION AVANCÉE
################################################


<br/>
<br/>
<br/>
<br/>


1 : Copier les scripts dans ```/home/nnvision```
(L'architecture doit être comme ci dessous :
```/home/nnvision/NNvisionStartup```)

2 : Si ce n'est pas déjà fait : 

```sudo chmod +x initJouvenciaProd.sh initJouvenciaDev.sh initUx.sh initService.py```


3 : Lancer  avec sudo initUx.sh en passant en premier argument "nnvision" puis en second le nom de la machine, par exemple si la machine se nomme "jouvencia" :

```sudo ./initUx.sh nnvision jouvencia```


Accepter les demandes, ignorer les avertissement.


4 : Lancer au choix initJouvenciaProd.sh ou initJouvenciaDev.sh en fonction de l'environnement (prod ou dev) :

```sudo ./initJouvenciaProd.sh```


5 : Lancer avec initService.py : 

```python3 initService.py```


Patienter le temps que l'image se télécharge 

6 : ```sudo reboot```

7 :
-> Se rendre sur l'interface administrateur puis dans résidences 

-> Choisir la résidence dans laquelle on veut initialiser la jetson 

-> Dans le menu déroulant "machineid" sélectionner la jetson configurée 

-> Dans le menu déroulant "version" vérifier que la version demandée soit égale à la version actuellement utilisée en prod (Dans le cas d'une première installation elle doit toujours être supérieure à 1.12 !) 

	
8 : ```sudo reboot```

