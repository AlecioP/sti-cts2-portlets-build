var locales = {
  en: {
    message:{
      welcome: "Welcome to the STI Terminology Service",
      labelAdditionalInfo : "Additional info",
      labelLoading : "Please wait...",
      labelUnits: "Units",
      labelStatus: "Status",
      labelOthers : "Others",
      labelHL7Specs : "HL7 Specifications",
      labelLocalMapping: "Local mapping",
      labelMapping: "Mapping",
      labelMappingToLocalCode: "Mapping to local code",
      labelMappingToOtherCodingSystems: "Mapping to other coding systems",
      labelOntology: "Ontology",
      labelVersioning: "Versioning",
      labelCode: "Code",
      labelDescription : "Description",
      labelBatteryCode: "Battery code",
      labelBatteryDescription: "Battery description",
      noResults:"No results",
      labelReleaseDate: "Creation date",
      labelLocalCatalog: "Local catalog: ",
      labelVersion: "Version",
      labelDomain: "Domain",
      labelVersions: "Versions",
      labelClass: "Class",
      labelSystem: "System",
      labelProperty: "Property",
      labelMethod : "Method",
      labelTime : "Time",
      labelMatchValue : "Text or code to search",
      labelSearch : "Search",
      labelAllMale: "All",
      labelAllFemale: "All",
      labelActive: "ACTIVE",
      labelDeprecated: "DEPRECATED",
      labelDiscouraged: "DISCOURAGED",
      labelTrial: "TRIAL",
      labelSelectTypeSearch : "Select the type of resource",
      labelSelectCodeSystem : "Select the code system",
      labelSelectValueSet : "Select the value set",
      labelSelectMapping : "Select themapping",
      labelSelectMode: "Select the mode",
      labelLanguage: "Language",
      labelFormat: "Select export format",
      labelType: "Type",
      labelJsonFormat: "JSON",
      labelCsvFormat: "CSV",
      labelSearchResults : "Search results: ",
      labelScale : "Scale",
      labelOpenLodView: "Open in Lod View",
      labelOpenLodLive: "Open in Lod Live",
      labelChapter: "Chapter",
      labelDetails: "Details",
      labelPrevVersion: "Prev version",
      labelNextVersion: "Next version",
      labelCreateAssociation: "Create association",
      labelRelation: "Relation",
      labelSaveAssociations: "Save associations",
      labelAssociation: "Association",
      labelKind: 'Kind',
      labelOntological: 'Ontological',
      labelTaxonomic: 'Taxonomic',
      labelCrossMapping: 'Cross Mapping',
      labelExportAction: 'Export',
      labelLink: 'Link',
      labelHierarchicalRelationships: 'Hierarchical Relationships',
      labelValueSet: 'Value Set',
      labelCodeSystemStandardNational: "Standard/National",
      labelCodeSystemLocal: "Local",
      labelCodeSystemLocals: "Locals",
      labelMappingG1: "Code System local - LOINC",
      labelMappingG2: "Other Mapping",
      labelIcd9Cm: 'ICD9-CM',
      labelLoinc: 'LOINC',
      labelAtc: 'ATC',
      labelAic: 'AIC',
      labelNotice: 'Notice!',
      crossMappingNotice: 'The created associations are pending approval by the terminology system administrators.',
      localCode: 'Local code',
      localCodeLabel: 'Local Code',
      localDescription: 'Local Description',
      redirectedTo: 'redirected to',
      labelMapTo: 'Map To',
      labelComment: 'Comment',
      labelActualVersion: 'Actual Version',
      labelOtherVersions: 'Other Versions',
      labelAnatomicalGroup: 'Anatomical Group',
      labelAtcCode: 'ATC Code',
      labelDenomination: 'Description',
      labelActiveIngredient: 'Active Ingredient',
      labelCompany: 'Pharmaceutical Company',
      labelAicCode: 'AIC Code',
      labelPackage: 'Package',
      labelEquivalenceGroupCode: 'Equivalence Group Code',
      labelEquivalenceGroupDescription: 'Equivalence Group Description',
      labelCubicMetersOxygen: 'Cubic Meters Oxygen',
      labelRetailPrice: 'Retail Price',
      labelExFactoryPrice: 'Ex-factory Price',
      labelMaximumSalePrice: 'Maximum Sale Price',
      labelInAifaTransparencyList: 'In Aifa transparency list',
      labelOnlyInTheRegionList: 'Only In The Region List',
      labelYes: 'Yes',
      labelNo: 'No',
      labelDosageUnit: 'Dosage Unit',
      labelPricePerDosageUnit: 'Price Per Dosage Unit',
      labelMedicineType: 'Drug Type',
      labelNotPresent: 'Not Present',
      labelCatalog: 'Catalog',
      labelSelectLoincVersion: 'Select the LOINC version to view the associated mappings to local code systems:',
      labelSelectOneLocalCodeSystem: 'Select one of the following local code systems:',
      labelCodeSystemCode: 'Code system code',
      labelDescriptionCodeSystemCode: 'Code system code description',
      labelLocalCodeSystem: 'Local code system',
      labelGenericMapping: 'Generic Mapping',
      labelOid: 'Oid',
      labelResourceNavigations: 'Resources Navigations',
      labelAdvancedSearch:'Advanced Search',
      labelIsAssociated : "View existing maps by accessing the code detail",
      labelDomain: "Domain",
      labelOrganization: "Organization",
      labelCodeSystem: "Code System",
      labelTitleSelect:"Select a tipology",
      labelContentNotPresent: "Content not present in the selected language, change the language and click on 'Search' again to view the results.",
    },
    loinc : {
      labelCode: "Code",
      labelComponent : "Component",
      labelLongCommonName : "Long Common Name",
      labeVersionLastChanged: "Version Last Changed",
      labelDefinitionDescription : "Definition Description",
      labelOrderObs : "Order/Observation",
      labelExampleUnits : "Example Units",
      labelExampleUcumUnits: "Example Ucum Units",
      labelExampleSiUcumUnits: "Example SI UCUM Units",
      labelUnitsRequired: "Units required",
      labelStatusReason: "Status Reason",
      labelStatusText: "Status Text",
      labelChangeReasonPublic:  "Change Reason Public",
      labelCommonTestRank : "Common Test Rank",
      labelCommonOrderRank : "Common Order Rank",
      labelCommonSiRank : "Common SI Rank",
      labelAssociatedObservations : "Associated Observations",
      labelCodeSystem: "Code System",
      labelCodeSystemName : "Code System Name",
      labelCodeSystemVersion : "Code System Version",
      labelDisplayName : "Display Name",
    },
    icd9cm: {
      labelName: 'Name',
      labelOtherDescriptions: 'Other Descriptions',
      labelInclusions: 'Inclusions',
      labelExclusions: 'Exclusions',
      labelNotes: 'Notes',
    },
    valueset: {
        labelOid: 'Oid',
        labelName: 'Name of the Value Set',
        labelVersion: 'Version of the Value Set',
        labelDisplayName : "Display Name",
    }
  },
  it: {
    message: {
      welcome: "Benvenuto nel Servizio Terminologico Integrato",
      labelAdditionalInfo : "Info aggiuntive",
      labelLoading : "Attendere..",
      labelUnits: "Unità",
      labelStatus: "Stato",
      labelOthers : "Altro",
      labelHL7Specs : "Specifiche HL7",
      labelLocalMapping: "Mapping locale",
      labelMapping: "Mapping",
      labelMappingToLocalCode: "Mapping a codifica locale",
      labelMappingToOtherCodingSystems: "Mapping ad altri sistemi di codifica",
      labelOntology: "Ontologia",
      labelVersioning: "Versioni",
      labelCode: "Codice",
      labelDescription : "Descrizione",
      labelBatteryCode: "Codice della batteria",
      labelBatteryDescription: "Descrizione della batteria",
      noResults:"Nessun risultato",
      labelReleaseDate: "Data creazione",
      labelLocalCatalog: "Catalogo locale: ",
      labelVersion: "Versione",
      labelDomain: "Dominio",
      labelVersions: "Versioni",
      labelClass: "Classe",
      labelSystem: "Sistema",
      labelProperty: "Proprietà",
      labelMethod : "Metodo",
      labelTime : "Tempo",
      labelMatchValue : "Testo o codice da ricercare",
      labelSearch : "Ricerca",
      labelAllMale: "Tutti",
      labelAllFemale: "Tutte",
      labelActive: "ATTIVO",
      labelDeprecated: "DEPRECATO",
      labelDiscouraged: "SCONSIGLIATO",
      labelTrial: "PROVA",
      labelSelectTypeSearch : "Seleziona tipologia di risorsa",
      labelSelectCodeSystem : "Seleziona il sistema di codifica",
      labelSelectValueSet : "Seleziona il value set",
      labelSelectMapping : "Seleziona il mapping",
      labelSelectMode: "Seleziona la modalità",
      labelLanguage: "Lingua",
      labelFormat: "Seleziona formato da esportare",
      labelType: "Tipo",
      labelJsonFormat: "JSON",
      labelCsvFormat: "CSV",
      labelSearchResults : "Risultati della ricerca: ",
      labelScale: "Scala",
      labelOpenLodView: "Vedi in Lod View",
      labelOpenLodLive: "Vedi in Lod Live",
      labelChapter: "Capitolo",
      labelDetails: "Dettagli",
      labelPrevVersion: "Versione precedente",
      labelNextVersion: "Versione successiva",
      labelCreateAssociation: "Crea associazione",
      labelRelation: "Relazione",
      labelSaveAssociations: "Salva associazioni",
      labelAssociation: "Associazione",
      labelKind: 'Tipo',
      labelOntological: 'Ontologico',
      labelTaxonomic: 'Tassonomico',
      labelCrossMapping: 'Cross Mapping',
      labelExportAction: 'Esporta',
      labelLink: 'Link',
      labelHierarchicalRelationships: 'Relazioni Gerarchiche',
      labelValueSet: 'Value Set',
      labelCodeSystemStandardNational: "Standard/Nazionali",
      labelCodeSystemLocal: "Locale",
      labelCodeSystemLocals: "Locali",
      labelMappingG1: "Codifiche locali - LOINC",
      labelMappingG2: "Altri Mapping",
      labelIcd9Cm: 'ICD9-CM',
      labelLoinc: 'LOINC',
      labelAtc: 'ATC',
      labelAic: 'AIC',
      labelNotice: 'Nota!',
      crossMappingNotice: 'Le associazioni create sono in attesa di validazione da parte dell\'amministratore del sistema terminologico.',
      localCode: 'Codifica Locale',
      localCodeLabel: 'Codice Locale',
      localDescription: 'Descrizione Locale',
      redirectedTo: 'reindirizzato a',
      labelMapTo: 'Map To',
      labelComment: 'Commento',
      labelActualVersion: 'Versione Attuale',
      labelOtherVersions: 'Altre Versioni',
      labelAnatomicalGroup: 'Gruppo Anatomico',
      labelAtcCode: 'Codice ATC',
      labelDenomination: 'Denominazione',
      labelActiveIngredient: 'Principio Attivo',
      labelCompany: 'Ditta',
      labelAicCode: 'Codice AIC',
      labelPackage: 'Confezione',
      labelEquivalenceGroupCode: 'Codice Gruppo Equivalenza',
      labelEquivalenceGroupDescription: 'Descrizione Gruppo Equivalenza',
      labelCubicMetersOxygen: 'Metri Cubi Ossigeno',
      labelRetailPrice: 'Prezzo Al Pubblico',
      labelExFactoryPrice: 'Prezzo Ex-factory',
      labelMaximumSalePrice: 'Prezzo massimo di cessione',
      labelInAifaTransparencyList: 'In Lista di Trasparenza Aifa',
      labelOnlyInTheRegionList: 'Solo In Lista Regione',
      labelYes: 'Sì',
      labelNo: 'No',
      labelDosageUnit: 'Unità Posologica',
      labelPricePerDosageUnit: 'Prezzo Per Unità Posologica',
      labelMedicineType: 'Tipo Farmaco',
      labelNotPresent: 'Non Presente',
      labelCatalog: 'Catalogo',
      labelSelectLoincVersion: 'Selezionare la versione LOINC per la quale si vuole visualizzare il mapping a codifiche locali:',
      labelSelectOneLocalCodeSystem: 'Selezionare una delle seguenti codifiche locali:',
      labelCodeSystemCode: 'Codice sistema di codifica',
      labelDescriptionCodeSystemCode: 'Descrizione codice sistema di codifica',
      labelLocalCodeSystem: 'Sistema di codifica locale',
      labelGenericMapping: 'Mapping Generico',
      labelOid: 'Oid',
      labelResourceNavigations: 'Navigazione Risorse',
      labelAdvancedSearch:'Ricerca avanzata',
      labelIsAssociated : "Visualizzare mapping esistenti accedendo alla scheda di dettaglio del codice",
      labelDomain: "Dominio",
      labelOrganization: "Organizzazione",
      labelCodeSystem: "Code System",
      labelTitleSelect:"Seleziona una tipologia",
      labelContentNotPresent: "Contenuto non presente nella lingua selezionata, cambiare la lingua e cliccare nuovamente su 'Ricerca' per visualizzare i risultati.",
    },
    loinc : {
      labelCode : "Codice LOINC",
      labelComponent : "Componente",
      labelLongCommonName : "Long Common Name",
      labelVersionLastChanged: "Versione Ultima Modifica",
      labelDefinitionDescription : "Descrizione della Definizione",
      labelOrderObs : "Ordine/Osservazione",
      labelExampleUnits : "Unità di Esempio",
      labelExampleUcumUnits: "Unità di Esempio UCUM",
      labelExampleSiUcumUnits: "Unità di Esempio SI UCUM",
      labelUnitsRequired: "Unità richieste",
      labelStatusReason: "Ragione dello Stato",
      labelStatusText: "Testo dello Stato",
      labelChangeReasonPublic:  "Cambiamento Ragione Pubblica",
      labelCommonTestRank : "Common Test Rank",
      labelCommonOrderRank : "Common Order Rank",
      labelCommonSiRank : "Common SI Rank",
      labelAssociatedObservations : "Osservazioni Associate",
      labelCodeSystem: "Sistema di Codifica",
      labelCodeSystemName : "Nome del Sistema di Codifica",
      labelCodeSystemVersion : "Versione del Sistema di Codifica",
      labelDisplayName : "Nome da Visualizzare",
    },
    icd9cm: {
      labelName: 'Nome',
      labelOtherDescriptions: 'Altre Descrizioni',
      labelInclusions: 'Inclusioni',
      labelExclusions: 'Esclusioni',
      labelNotes: 'Note',
    },
    valueset: {
        labelOid: 'Oid',
        labelName: 'Nome del Value Set',
        labelVersion: 'Versione del Value Set',
        labelDisplayName : "Nome da Visualizzare",
    }
  }
};


Vue.use(VueI18n);
Vue.config.lang = 'it';
Vue.config.fallbackLang = 'it'

Object.keys(locales).forEach(function (lang) {
  Vue.locale(lang, locales[lang])
});

