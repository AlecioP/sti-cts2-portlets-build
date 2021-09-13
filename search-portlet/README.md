# search-portlet
webapp search module
-------------
Modulo responsabile della ricerca e visualizzazione delle codifiche

## Info
Portlet Liferay in vue.js


La ricerca sulle codifiche memorizzate a sistema viene effettuata in modalità Full Text, ovvero scrivendo in una apposita area di ricerca un termine, un testo o un codice.
E’ inoltre possibile filtrare la ricerca, limitandola ad un singolo sistema di codifica oppure ricercare su più o su tutte le codifiche contemporaneamente. Nel caso di ricerca su un singolo sistema di codifica, è possibile applicare dei filtri specifici su uno o più campi della struttura dati (ove previsto dal punto di vista funzionale).


## Build
Per effettuare la build i comandi da dare sono i seguenti 
```sh
mvn clean install
```


## deploy
una volta buildato i modui bisognerà deployare i 2 war genearti sotto ...liferay/deploy




