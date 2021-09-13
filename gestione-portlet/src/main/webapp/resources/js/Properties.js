/*
* Standard Properties
*/
var STANDARD_PROPERTIES = {
  pathImportLoinc: ENV_PROPERTIES.basePath + "/sti-gestione-portlet/api/import/loinc",
  pathImportIcd9Cm: ENV_PROPERTIES.basePath + "/sti-gestione-portlet/api/import/icd9-cm",
  pathImportAic: ENV_PROPERTIES.basePath + "/sti-gestione-portlet/api/import/aic",
  pathImportAtc: ENV_PROPERTIES.basePath + "/sti-gestione-portlet/api/import/atc",
  pathImportMapping: ENV_PROPERTIES.basePath + "/sti-gestione-portlet/api/import/mapping",
  pathImportLocalLoinc: ENV_PROPERTIES.basePath + "/sti-gestione-portlet/api/importLocal/loinc",
  pathDeleteCodeSystem: ENV_PROPERTIES.basePath + "/cts2framework/codesystem/{CODE_SYSTEM}/version/{VERSION}?changesetcontext=pingas",
  jsonFormatHttpParam : "&format=json",
  readAssociations: ENV_PROPERTIES.basePath + "/cts2framework/associations?list=true&sourceortargetentity=TO_VALIDATE&format=json",
  associationOperation: ENV_PROPERTIES.basePath + "/cts2framework/changeset/pingas",
  checkStatus: ENV_PROPERTIES.basePath + "/cts2framework/changeset/{CODE_SYSTEM}",
  getVersions: ENV_PROPERTIES.solr + "sti_{CODE_SYSTEM}/select?q=*:*&stats=on&stats.field=VERSION&rows=0&stats.calcdistinct=true&wt=json",
  getVersionsCodeSystemLocal: ENV_PROPERTIES.solr + "sti_standard_local/select?q=*:*&fq=NAME:{CODE_SYSTEM}&stats=on&stats.field=VERSION&rows=0&stats.calcdistinct=true&wt=json",
  pathDeleteLocalCodeLoinc: ENV_PROPERTIES.basePath + "/sti-gestione-portlet/api/deleteLocalCode/loinc",
  getMappingList: ENV_PROPERTIES.basePath + "/cts2framework/maps?format=json",
  deleteMapping: ENV_PROPERTIES.basePath + "/cts2framework/map/nomemap/version/{MAP_NAME}?changesetcontext=123123",
  getLocalCodes: ENV_PROPERTIES.solr + "sti_{CODE_SYSTEM}/select?q=*:*&stats=on&stats.field=LOCAL_CODE_LIST&rows=0&stats.calcdistinct=true&wt=json&fq=VERSION:{VERSION}",
  pathInspectStandardLocal: ENV_PROPERTIES.basePath + "/sti-gestione-portlet/api/import/local/inspect",
  pathImportLocal: ENV_PROPERTIES.basePath + "/sti-gestione-portlet/api/import/local/import",
  pathManageGetCodeSystem: ENV_PROPERTIES.basePath + "/sti-gestione-portlet/api/manage/codeSystems",
  pathGetCsVersions: ENV_PROPERTIES.basePath + "/cts2framework/extras/cs/:id/versions?format=json",
  pathManageGetValueSets: ENV_PROPERTIES.basePath + "/cts2framework/extras/valueSets?format=json",
  pathGetVsVersions:ENV_PROPERTIES.basePath + "/cts2framework/extras/valueSets/:id/versions?format=json",
  getDomains: ENV_PROPERTIES.basePath + "/cts2framework/extras/domains?format=json",
};

var APP_PROPERTIES = _.merge(ENV_PROPERTIES, STANDARD_PROPERTIES);

