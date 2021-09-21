DÉMARCHE A SUIVRE AFIN D'INITIALISER LA JETSON NANO DANS UNE CHAMBRE :

1 : Si ce n'est pas déjà fait : 
```sudo chmod +x initJouvenciaProd.sh initJouvenciaDev.sh initUx.sh```
2 : Lancer  avec sudo initUx.sh en passant en argument le nom de la machine, par exemple si la machine se nomme "jouvencia" :
```sudo ./initUx.sh jouvencia```
Accepter les demandes, ignorer les avertissement.
3 : Lancer au choix initJouvenciaProd.sh ou initJouvenciaDev.sh en fonction de l'environnement (prod ou dev) :
```./initJouvenciaProd.sh```
4 : Lancer avec sudo initService.py : 
```sudo python3 initService.py```

Patienter le temps que l'image se télécharge 

5 : -Se rendre sur l'interface administrateur puis dans résidences
	-Choisir la résidence dans laquelle on veut initialiser la jetson
	-Dans le menu déroulant "machineid" sélectionner la jetson configurée
	-Dans le menu déroulant "version" vérifier que la version demandée soit égale à la version actuellement utilisée en prod (Dans le cas d'une première installation elle doit toujours être supérieure à 1.0 !)