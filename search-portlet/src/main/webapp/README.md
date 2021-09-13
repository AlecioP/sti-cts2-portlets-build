Sviluppo Frontend
=================

Per velocizzare lo sviluppo è stato pensato di creare un piccolo ambiente che migliora l'esperienza dello sviluppatore e quindi ne minimizza le perdite di tempo.

Installazione
-------------

Eseguire i seguenti passi:

* installare [Node](https://nodejs.org/it/download/);
* eseguire da linea di comando `npm install`.

Esecuzione
----------

Lanciare il comando `grunt serve` per eseguire il server e sviluppare nel modo più veloce possibile. L'applicazione sarà accessibile su [localhost:8000](http://localhost:8000/) e le modifiche fatte saranno rese immediatamente disponibili, senza la necessità di effettuare il deploy.
È importante notare che il server `Liferay` dovrà comunque essere avviato.
È necessario [lanciare il browser in modalità non sicura](http://stackoverflow.com/a/3177718) che non fa controlli sul CORS.

Informazioni aggiuntive
-----------------------

#### Come funziona questo ambiente?

L'ambiente sfrutta il task runner [Grunt](http://gruntjs.com/). È stato definito il task `serve` che effettua due operazioni:

* fa partire un server che serve staticamente il contenuto della cartella `dist`;
* effettua il `watch` sulle cartelle `resources` e `views`.

Il comando `watch` a sua volta lancia una serie di task:

* `copy`: copia tutto ciò che c'è nella cartella `resources` nella catella `dist`;
* `convert`: converte il contenuto di `liferay-portlet.xml` in JSON e lo salva nella cartella `dist` con il nome `liferay-portlet-json`;
* `indexhtmlwriter`: carica nella configurazione del task successivo dei dati importanti che includono: tutti i `JavaScript`, i `CSS` e il contenuto del file `view.jsp`;
* `template`: processa il template e i dati passati dal task precedente e crea il file `index.html`, posizionandolo nella cartella `dist`.


#### Cosa committare

**Non** bisogna assolutamente committare la cartella `dist` e `node_modules`; la prima perchè è generata in fase di sviluppo, mentre la seconda perchè è la cartella che contiene tutte le librerie utilizzate in fase di sviluppo per lanciare il comando `grunt`.
