/*
* Standard Objects
*/
var PageObject = function(page, pageSize) {
  this.page = page;
  this.pageSize = pageSize;

  this.asHttpRequestParam = function() {
    return "&page="+this.page+"&maxtoreturn="+pageSize;
  }
};

var SearchDetailLanguagePropertyObject = function() {
  this.component = "";
  this.property = "";
  this.time = "";
  this.system = "";
  this.scale = "";
  this.method = "";
  this.class = "";
  this.longCommonName = "";

};

var SearchDetailObject = function() {
  this.resourceName = "";
  this.defLang = "it";
  this.info = {
    status: "",
    versionLastChanged : "",
    definitionDescription: "",
    additionalInfo: [],
  },
  this.it = new SearchDetailLanguagePropertyObject(),
  this.en = new SearchDetailLanguagePropertyObject()
};

var MappingDetailObj = function() {
  this.code  = "";
  this.description = "";
  this.batteryCode = "";
  this.batteryDescription = "";
  this.units = "";
};


var MAPPING_ATC_AIC_DEFAULT_VALUE = {
	codeSystemReference: "AIC",
	codeDescription: 'ATC-AIC',
	version: 'ATC (2014) - AIC (16.01.2017)',
};

var MAPPING_TYPE = {
	GENERIC: 'GENERIC',	
	ATC_AIC: MAPPING_ATC_AIC_DEFAULT_VALUE.codeDescription,	
	LOCAL_LOINC: 'LOCAL-LOINC',	
}


var DEFAULT_PAGING = new PageObject(0, 30);
//var DEFAULT_PAGING = new PageObject(0, 6);
/*
* Standard Properties
*/
var STANDARD_PROPERTIES = {
  pathSearchEntities: ENV_PROPERTIES.basePath + "/cts2framework/entities?",
  pathGetRelations: ENV_PROPERTIES.basePath + "/cts2framework/associations?list=true",
  pathSendRelation: ENV_PROPERTIES.basePath + "/cts2framework/association?format=json&changesetcontext=new",
  pathSearchRelations: ENV_PROPERTIES.basePath + "/cts2framework/extras/mapping/search?mapping=MAPPING&sourceOrTargetEntity=TEXT",
  getLanguages: ENV_PROPERTIES.basePath + "/cts2framework/extras/languages/NAME/VERSION_NAME",  
  
  jsonFormatHttpParam : "&format=json",
  getVersions: ENV_PROPERTIES.basePath + "/cts2framework/codesystem/{CODE_SYSTEM}",
  getAicVersions: ENV_PROPERTIES.solr + "sti_{CODE_SYSTEM}/select?q=*:*&stats=on&stats.field=VERSIONI_MAPPING&rows=0&stats.calcdistinct=true&wt=json",
  getCsVersions: ENV_PROPERTIES.basePath + "/cts2framework/extras/cs/:idOrName/versions?format=json",
  
  getStatuses: ENV_PROPERTIES.solr + "sti_{CODE_SYSTEM}/select?q=*:*&stats=on&stats.field=STATUS&rows=0&stats.calcdistinct=true&wt=json",
  getClasses: ENV_PROPERTIES.solr + "sti_{CODE_SYSTEM}/select?q=*:*&stats=on&stats.field=CLASS_{LANGUAGE}&rows=0&stats.calcdistinct=true&wt=json",
  getAicClasses: ENV_PROPERTIES.solr + "sti_{CODE_SYSTEM}/select?q=*:*&stats=on&stats.field=CLASSE&rows=0&stats.calcdistinct=true&wt=json",
  getSystems: ENV_PROPERTIES.solr + "sti_{CODE_SYSTEM}/select?q=*:*&stats=on&stats.field=SYSTEM_{LANGUAGE}&rows=0&stats.calcdistinct=true&wt=json",
  getProperties: ENV_PROPERTIES.solr + "sti_{CODE_SYSTEM}/select?q=*:*&stats=on&stats.field=PROPERTY_{LANGUAGE}&rows=0&stats.calcdistinct=true&wt=json",
  getMethods: ENV_PROPERTIES.solr + "sti_{CODE_SYSTEM}/select?q=*:*&stats=on&stats.field=METHOD_TYP_{LANGUAGE}&rows=0&stats.calcdistinct=true&wt=json",
  getScales: ENV_PROPERTIES.solr + "sti_{CODE_SYSTEM}/select?q=*:*&stats=on&stats.field=SCALE_TYP_{LANGUAGE}&rows=0&stats.calcdistinct=true&wt=json",
  getTimes: ENV_PROPERTIES.solr + "sti_{CODE_SYSTEM}/select?q=*:*&stats=on&stats.field=TIME_ASPECT_{LANGUAGE}&rows=0&stats.calcdistinct=true&wt=json",
  getChapters: ENV_PROPERTIES.solr + "sti_{CODE_SYSTEM}/select?q=*:*&stats=on&stats.field=CAPITOLO&rows=0&stats.calcdistinct=true&wt=json",
  getFirstNodesClassification: ENV_PROPERTIES.solr + "sti_standard_local/select?fl=CS_CODE,CS_DESCRIPTION_{LANG}&fq=-SUBCLASS_OF:*&fq=CS_SUBTYPE:classification&fq=NAME:{CODE_SYSTEM}&indent=on&q=*:*&rows=1000&wt=json",
  getAnatomicalGroups: ENV_PROPERTIES.solr + "sti_{CODE_SYSTEM}/select?q=*:*&stats=on&stats.field=GRUPPO_ANATOMICO&rows=0&stats.calcdistinct=true&wt=json",
  getActivePrinciples: ENV_PROPERTIES.solr + "sti_{CODE_SYSTEM}/select?q=*:*&stats=on&stats.field=PRINCIPIO_ATTIVO&rows=0&stats.calcdistinct=true&wt=json",
  getCompanies: ENV_PROPERTIES.solr + "sti_{CODE_SYSTEM}/select?q=*:*&stats=on&stats.field=DITTA&rows=0&stats.calcdistinct=true&wt=json",
  getLocalCodes: ENV_PROPERTIES.solr + "sti_{CODE_SYSTEM}/select?q=*:*&stats=on&stats.field=LOCAL_CODE_LIST&rows=0&stats.calcdistinct=true&wt=json&fq=VERSION:{VERSION}",
  getAicMapping: ENV_PROPERTIES.solr + "sti_{CODE_SYSTEM}/select?indent=on&q=VERSIONI_MAPPING:\"{VERSION}\"&wt=json&rows={ROWS}&start={START}",
  getAicMappingSearch: ENV_PROPERTIES.solr + "sti_{CODE_SYSTEM}/select?indent=on&q={TEXT}&fq=VERSIONI_MAPPING:\"{VERSION}\"&wt=json&rows={ROWS}&start={START}",
  getLocalCodeList: ENV_PROPERTIES.basePath + "/cts2framework/codesystem/{CODE_SYSTEM}/version/{VERSION}/entities?page=0&maxtoreturn=250&matchvalue=LOCAL_CODE_LIST:{LOCAL_CODE}&format=json",
  getLocalCodeListSearch: ENV_PROPERTIES.basePath + "/cts2framework/codesystem/{CODE_SYSTEM}/version/{VERSION}/entities?page={PAGE}&maxtoreturn={ROWS}&format=json&matchvalue=q={TEXT}%26fq%3DLOCAL_CODE_LIST%3A{LOCAL_CODE}",
  getAicDetails: ENV_PROPERTIES.basePath + "/cts2framework/codesystem/{CODE_SYSTEM}/version/{VERSION}/entity/{CODE_SYSTEM}:{CODE}?",
  getLocalsList: ENV_PROPERTIES.basePath + "/cts2framework/extras/cs?format=json&listCsType=['LOCAL','STANDARD_NATIONAL']",
  export:  ENV_PROPERTIES.basePath + "/cts2framework/exporter",
  exportSearch: ENV_PROPERTIES.basePath + "/cts2framework/exporter/search?",
  pathManageGetCodeSystem: ENV_PROPERTIES.basePath + "/sti-gestione-portlet/api/manage/codeSystems",
  getValueSetsList: ENV_PROPERTIES.basePath + "/cts2framework/extras/valueSets?format=json",
  getCodeSystemSolrFields: ENV_PROPERTIES.basePath + "/cts2framework/extras/cs/{CS_NAME}/solrextrafields?format=json",
  getValueSetSolrFields: ENV_PROPERTIES.basePath + "/cts2framework/extras/vs/{VS_NAME}/solrextrafields?format=json",
  getDomains: ENV_PROPERTIES.basePath + "/cts2framework/extras/domains?format=json",
  //getMappingList: ENV_PROPERTIES.basePath + "/cts2framework/maps?format=json",
  getMappingList: ENV_PROPERTIES.basePath + "/cts2framework/extras/mapping/list?format=json",
  getValuesForField: ENV_PROPERTIES.solr + "sti_{ELEM_TYPE}/select?q=NAME:{CODE_SYSTEM}&stats=on&stats.field={FIELD_NAME}&rows=0&stats.calcdistinct=true&wt=json",
  getValuesForFieldDB: ENV_PROPERTIES.basePath + "/cts2framework/extras/values/{CODE_SYSTEM}/{VERSION_NAME}/{FIELD_NAME}/{LANG}?format=json",
  getQuerySolrExportMappingAtcAic:'q={TEXT}&fq=VERSIONI_MAPPING:\"{VERSION}\"',
  getQuerySolrExportMappingLocalLoinc:'q={TEXT}&fq=LOCAL_CODE_LIST:{LOCAL_CODE}&fq=VERSION:{VERSION}',
};

var APP_PROPERTIES = _.merge(ENV_PROPERTIES, STANDARD_PROPERTIES);

var ASSOCIATION_TYPES = [{
  label: 'appartiene a <-> appartiene a',
  value: 1,
  forwardName: 'Appartiene a',
  reverseName: 'Appartiene a'
}, {
  label: 'preferito a <-> sinonimo',
  value: 2,
  forwardName: 'Preferito a',
  reverseName: 'Sinonimo'
}, {
  label: 'equivalente di <-> equivalente di',
  value: 3,
  forwardName: 'Equivalente di',
  reverseName: 'Equivalente di'
}, {
  label: 'correlato a <-> correlato a',
  value: 4,
  forwardName: 'Correlato a',
  reverseName: 'Correlato a'
}, {
  label: 'esclude <-> escluso da',
  value: 5,
  forwardName: 'Esclude',
  reverseName: 'Escluso da'
} ,{
  label: 'include <-> incluso in',
  value: 6,
  forwardName: 'Include',
  reverseName: 'Incluso in'
}];
