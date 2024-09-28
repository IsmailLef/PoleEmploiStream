# SDTD 

## Lancement du cluster avec terraform. 

Une simple commande suffit : 

```
terraform apply [--auto-approve]
```

Le script met une petite dizaine de minutes pour se terminer. Vous aurez alors tous les services disponibles.


## Pour usage de l'application en local

1. Dirigez-vous vers le répertoire dev/src/stream_pole_emploi :

```
cd dev/src/stream_pole_emploi
```

2. Créez un fichier **.env** afin de spécifier vos informations d'identification. Vous pouvez utiliser les mêmes informations que celles fournies dans le fichier **.envexemple.**

3. Exécutez la commande suivante pour construire les images Docker définies dans la configuration Docker Compose :

```
docker compose build
```

4. Exécutez la commande suivante pour démarrer les services définis dans le fichier Docker Compose : 

```
docker compose up
```
***

5. Attendez jusqu'à ce que les données commencent à être insérées dans les tables puis ouvrez l'application dans : http://localhost:3001/

***
