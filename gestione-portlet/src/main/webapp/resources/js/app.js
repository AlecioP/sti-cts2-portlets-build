
Vue.filter("fallbackstring", function(value , alternative) {
  if (_.trim(value)) {
    return value;
  }else {
    return alternative;
  }
});


Vue.filter('clearUnderscore', function (value) {
    return value.trim().split("_").join(" ");
});

Vue.filter('clearVersionForView', function (value) {
	value = _.trim(value);
	//console.log("value::"+value);
	var separator = "__";
	if(value.indexOf(separator)!=-1){
		var tmp = value.trim().split(separator);
		return tmp[1];		
	}
	else{
		return value;
	}
});

Vue.filter('clearNameMapping', function (value) {
	value = _.trim(value);
	var separator = "__";
	//console.log(value);
	if(value.indexOf(separator)!=-1){
		var tmp = value.split(" - ");

		var src = tmp[0].split("(");
		var trg = tmp[1].split("(");

		var csSrc = src[0];
		var csTrg = trg[0];
		var versionSrc = src[1];
		var versionTrg = trg[1];
		
		if(versionSrc.indexOf(separator)!=-1){
			var versionSrcTmp = src[1].split(separator);
			versionSrc = versionSrcTmp[1];
		}
		
		if(versionTrg.indexOf(separator)!=-1){
			var versionTrgTmp = trg[1].split(separator);
			versionTrg = versionTrgTmp[1];
		}
		
		versionSrc = versionSrc.replace(")","");
		versionTrg = versionTrg.replace(")","");

		value = csSrc +" ("+versionSrc+")"+" - "+csTrg+" ("+versionTrg+")";
		return value;
	}
	else{
		return value;
	}
	return value;
});

var appVue;

$(document).ready(function() {

 appVue = new Vue({
    el: '#app',
    data: {
      lang: "it",
	  currentTypeObj:'',
	  
      /*Upload code system*/
      fileLoincItalia:  '',
      fileLoincInternational: '',
      fileLoincMapTo: '',
      majorVersion: '',
      minorVersion: '',
      releaseDate: '',
      oid: '',
      description: '',

      /*Upload Loinc locale code system*/
      localCodeSystemName: '',
      fileImport: '',
      section: 'manage-code-system', /*'import-code-system',*/
      subSection: 'LOINC',

      /*Upload ICD9-CM locale code system*/
      icd9CmVersion: '',
      fileItaIcd9Cm: '',
      fileEnIcd9Cm: '',
      icd9CmReleaseDate: '',
      icd9CmOid: '',
      icd9CmDescription: '',

      /*Upload AIC locale code system*/
      aicVersion: '',
      fileFarmaciClasseA: '',
      fileFarmaciClasseH: '',
      fileFarmaciClasseC: '',
      fileFarmaciEquivalenti: '',
      aicReleaseDate: '',
      aicOid: '',
      aicDescription: '',

      /*Upload ATC locale code system*/
      atcVersion: '',
      fileFarmaciAtc: '',
      atcReleaseDate: '',
      atcOid: '',
      atcDescription: '',

      /*Cross-mapping approval*/
      associations: [],
      canImport: false,
      statusChecked: false,

      /*Delete code system*/
      versions: [],
      versionToDelete: '',

      /*Import of mapping resources*/
      codeSystem1: '',
      versions1: [],
      version1: '',
      codeSystem2: '',
      versions2: [],
      version2: '',
      resourceMappingFile: '',
      mappingReleaseDate: '',
      mappingDescription: '',
      mappingOrganization : '',

      /*Delete local code*/
      localCodeToDelete: '',
      localCodes: [],

      /*Delete mapping*/
      mappingList: [],
      mappingToDelete: '',
      
      /*StandardLocal*/
      fileItStandardLocal: '',
      fileEnStandardLocal: '',
      standardLocalImport: {
    	header: [],
    	rowsCount: 0,
    	tmpFileNameIt: "",
    	tmpFileNameEn: "",
    	status: "blank"
      },
	  localCodificationName: "",
	  localCodificationVersion: "",
	  localCodificationReleaseDate: "",
	  localCodificationDescription: "",
	  localCodificationOid: "",
	  localCodificationOidPrefix: "",
	  prefxDominioSalute: "2.16.840.1.113883.",
	  localCodificationDomain: "",
	  localCodificationCodeSystemType: "",
	  localCodificationCodeSystemSubType: "nomenclature",
	  localCodificationCodeSystemHasOntology: "N",
	  localCodificationCodeSystemOntologyName:"",
      hideTyping: false,
      localTypeMapping: {
    	  
      },
      localTypeMappingSubOptionsVisibility: {
    	  
      },
      localCodificationsMapping: {
    	  
      },
      localCodificationFileName: "",
      localCodificationOrganization: "",
      localCodificationValueSet: false,
	  

      /*List all the errors*/
      errors: {
        'import-code-system-loinc': [],
        'import-code-system-icd9-cm': [],
        'import-code-system-aic': [],
        'import-code-system-atc': [],
        'locale-code-upload-loinc': [],
        'import-of-mapping-resources': [],
        'locale-code-delete-loinc': [],
        'import-code-system-locale': [],
		'import-code-system-standard': [],
		'import-code-system-valueset': [],
      },

      /*List of code systems old*/
//      codeSystems: [{
//        label: 'LOINC',
//        value: 'LOINC'
//      },{
//        label: 'ICD9-CM',
//        value: 'ICD9-CM'
//      },{
//        label: 'ATC',
//        value: 'ATC'
//      },{
//        label: 'AIC',
//        value: 'AIC'
//      },
//      ],
      
      /*List of code systems not local*/
      codeSystemsNotStandardLocal: ['LOINC','ICD9-CM','ATC','AIC'],


      /*List of the file validators*/
      fileValidators: {
        exists: 'exists',
        csv: 'isCsv',
      },
      
      /**
       * MANGE CODE SYSTEMS
       */
      codeSystemsRemote: [],
      importMode: '',
      selectedCs: {},
      csDeleteVersions : [],
      
      
      /**
       * Value Set
       */
      valuesetRemote: [],
      vsDeleteVersions : [],
      vsVersionToDelete: "",
	  
	  domains: [],
      
    },

    methods: {
    	
      /**
       * Import files.
       */
      importFiles: function(e){
        e.preventDefault(); /*Disable submit*/
        console.log('importFiles');
        var formData = new FormData();
        /* append Blob/File object*/
        formData.append('version', this.majorVersion + '.' + this.minorVersion);
        formData.append('fileLoincItalia', this.fileLoincItalia, this.fileLoincItalia.name);
        formData.append('fileLoincInternational', this.fileLoincInternational, this.fileLoincInternational.name);
        formData.append('fileLoincMapTo', this.fileLoincMapTo, this.fileLoincMapTo.name);
        formData.append('releaseDate', this.releaseDate);
        formData.append('oid', this.oid);
        formData.append('description', this.description);
        this.showLoading();
        this.uploadFile(APP_PROPERTIES.pathImportLoinc, formData);
      },

      /**
       * Import files for ICD9-CM.
       */
      importIcd9CmFiles: function(e){
        e.preventDefault(); /*Disable submit*/
        console.log('importIcd9CmFiles');
        var formData = new FormData();
        /* append Blob/File object*/
        formData.append('version', this.icd9CmVersion);
        formData.append('fileItaIcd9Cm', this.fileItaIcd9Cm, this.fileItaIcd9Cm.name);
        formData.append('fileEnIcd9Cm', this.fileEnIcd9Cm, this.fileEnIcd9Cm.name);
        formData.append('releaseDate', this.icd9CmReleaseDate);
        formData.append('oid', this.icd9CmOid);
        formData.append('description', this.icd9CmDescription);
        this.showLoading();
        this.uploadFile(APP_PROPERTIES.pathImportIcd9Cm, formData);
      },

      /**
       * Import files for AIC.
       * @param e The event.
       */
      importAicFiles: function(e){
        e.preventDefault(); /*Disable submit*/
        console.log('importAicFiles');
        var formData = new FormData();
        /* append Blob/File object*/
        formData.append('version', this.aicVersion);
        formData.append('fileFarmaciClasseA', this.fileFarmaciClasseA, this.fileFarmaciClasseA.name);
        formData.append('fileFarmaciClasseH', this.fileFarmaciClasseH, this.fileFarmaciClasseH.name);
        formData.append('fileFarmaciClasseC', this.fileFarmaciClasseC, this.fileFarmaciClasseC.name);
        formData.append('fileFarmaciEquivalenti', this.fileFarmaciEquivalenti, this.fileFarmaciEquivalenti.name);
        formData.append('releaseDate', this.aicReleaseDate);
        formData.append('oid', this.aicOid);
        formData.append('description', this.aicDescription);
        this.uploadFile(APP_PROPERTIES.pathImportAic, formData);
      },

      /**
       * Import files for ATC.
       * @param e The event.
       */
      importAtcFiles: function(e){
        e.preventDefault(); /*Disable submit*/
        console.log('importAtcFiles');
        var formData = new FormData();
        /* append Blob/File object*/
        formData.append('version', this.atcVersion);
        formData.append('fileFarmaciAtc', this.fileFarmaciAtc, this.fileFarmaciAtc.name);
        formData.append('releaseDate', this.atcReleaseDate);
        formData.append('oid', this.atcOid);
        formData.append('description', this.atcDescription);
        this.uploadFile(APP_PROPERTIES.pathImportAtc, formData);
      },
      
      inspectStandardLocalFile: function(e){
    	  e.preventDefault();
		   var self = this;
    	  //console.log("fileItStandardLocal::"+self.fileItStandardLocal.name);
		  //console.log("fileEnStandardLocal::"+self.fileEnStandardLocal.name);
    	  var formData = new FormData();
    	  if(self.fileItStandardLocal!==undefined && self.fileItStandardLocal.name!=undefined){
    		formData.append('localCodFileIt', self.fileItStandardLocal, self.fileItStandardLocal.name);
    	  }
		  if(self.fileEnStandardLocal!==undefined && self.fileEnStandardLocal.name!=undefined){
    		formData.append('localCodFileEn', self.fileEnStandardLocal, self.fileEnStandardLocal.name);
    	  }
		  
    	  if(self.selectedCs && self.selectedCs.typeMapping) {    		  
    		  formData.append('typeMapping', JSON.stringify(self.selectedCs.typeMapping) );
    	  }
		  if(self.selectedCs && self.selectedCs.name) {    		  
    		  formData.append('codeSystemId', _.trim(self.selectedCs.id));
    	  }
		  
		  if(self.localCodificationValueSet!==undefined) {    		  
    		  formData.append('isValueSet', self.localCodificationValueSet );
    	  }
		  
    	  var url = APP_PROPERTIES.pathInspectStandardLocal;
          self.$http.post(url, formData).then(function(response){
            var body = response.body;
            if(response.status != 200){
              console.log('Error importing', body);
              noty({text: self.$t("message.importError", self.lang), type: 'error', timeout:5000});
            } else {
            	
				/*	vecchia versione per nome di campo*/
            	/*
				body.header.forEach(function(h) {
            		if(self.selectedCs && self.selectedCs.typeMapping){
            			self.localTypeMapping[h.columnName] = self.selectedCs.typeMapping[h.columnName];
            		}else {            			
            			self.localTypeMapping[h.columnName] = "java.lang.String";
            		}
            	});
				*/
				
				/*	vecchia versione per posizione*/
				if(self.selectedCs!==undefined && self.selectedCs.typeMapping!==undefined){
					var idx = 0;
					var arrayPosizioneTipoMapping = _.values(self.selectedCs.typeMapping);
					body.header.forEach(function(h) {
						if(self.selectedCs && self.selectedCs.typeMapping){
							//self.localTypeMapping[h.columnName] = self.selectedCs.typeMapping[h.columnName];
							self.localTypeMapping[h.columnName] = arrayPosizioneTipoMapping[idx];
						}else {            			
							self.localTypeMapping[h.columnName] = "java.lang.String";
						}
						idx++;
					});
				}
            	
            	var tmpFileNameIt = this.standardLocalImport.tmpFileNameIt;
            	var tmpFileNameEn = this.standardLocalImport.tmpFileNameEn;
				
				//console.log("tmpFileNameIt::"+tmpFileNameIt);
				//console.log("tmpFileNameEn::"+tmpFileNameEn);
            	
            	this.standardLocalImport = body;
            	this.standardLocalImport.status = "ready"; 
              console.log('Import ok', body);
              noty({text: self.$t("message.uploadDone", self.lang), type: 'success', timeout:5000});
            }
          }, function(error){
        	  console.log('Error importing', error);
        	  var message="";
        	  switch (error.status) {
				case 400:
					var headerMessagePrimary = "";
					var headerMessageTranslate = "";
					var columnsMessages = "";
					var separatorMessages = "<br>";
					
					
					/*errorMessage*/
					if(error.body.errorMessage!==undefined && !_.isEmpty(error.body.errorMessage)){
						var errorMessage = error.body.errorMessage;
						var msg = self.$t("message.uploadStandardLocalError400_"+errorMessage, self.lang);
						columnsMessages = columnsMessages + separatorMessages + msg;
					}
					
					/*headerValidationResult*/
					if(error.body.headerValidationResult!=undefined && !_.isEmpty(error.body.headerValidationResult)){
						var valPrimary = error.body.headerValidationResult.validationsPrimary;
						var langPrimary = error.body.headerValidationResult.langPrimary;
						
						var valTranslate = error.body.headerValidationResult.validationsTranslate;
						var langTranslate = (langPrimary=='IT' ? 'EN' : 'IT');
						
						var messages = error.body.headerValidationResult.messages;
						
						//console.log("valPrimary::"+JSON.stringify(valPrimary));
						//console.log("valTranslate::"+JSON.stringify(valTranslate));
						//console.log("messages::"+JSON.stringify(messages));
						//console.log("langPrimary::"+langPrimary);
						//console.log("langTranslate::"+langTranslate);
						
						/*primary*/
						var columns = "";
						var separator = "";
						if(valPrimary!==undefined && !_.isEmpty(valPrimary)){
							for(var key in valPrimary){
								if(valPrimary[key] === false) {
									columns = columns + separator + key;
									separator = ", ";
								}
							}
							
							headerMessagePrimary = self.$t("message.uploadStandardLocalError400", self.lang);
							headerMessagePrimary = headerMessagePrimary.replace(":lang", langPrimary);
							headerMessagePrimary = headerMessagePrimary.replace(":columns", columns)
						}
						
						/*translate*/
						var columnsTranslate = "";
						var separatorTranslate = "";
						if(valTranslate!==undefined && !_.isEmpty(valTranslate)){
							for(var key in valTranslate){
								if(valTranslate[key] === false) {
									columnsTranslate = columnsTranslate + separatorTranslate + key;
									separatorTranslate = ", ";
								}
							}
							
							headerMessageTranslate = self.$t("message.uploadStandardLocalError400", self.lang);
							headerMessageTranslate = headerMessageTranslate.replace(":lang", langTranslate);
							headerMessageTranslate = headerMessageTranslate.replace(":columns", columnsTranslate);
						}
						
						/*message header*/
						if(messages!==undefined && !_.isEmpty(messages)){
							messages.forEach(function(msg) {
								if(msg!==undefined && msg!=""){
									msg = self.$t("message.uploadStandardLocalError400_"+msg, self.lang);
									columnsMessages = columnsMessages + separatorMessages + msg;
								}
							});
						}
					}
					
					message = message+" "+headerMessagePrimary+" "+headerMessageTranslate+" "+columnsMessages;
					break;
	
				case 422: 
					message = self.$t("message.uploadStandardLocalError422", self.lang);
					break;
				
					
				default:
					message = self.$t("message.uploadStandardLocalError", self.lang);
					break;
        	  }
              noty({text: message, type: 'error', timeout:10000});
          }).finally(function(){
            this.hideLoading();
          });
		  
		  
      },
      
      importLocal: function(e) {
    	  e.preventDefault();
		  var self = this;
    	  
		  
		  
		  var errorMappingMsg = "";
		  var errorMapping = false;
		  _.each(self.standardLocalImport.header, function(k){
			  if(self.localTypeMapping[k.columnName]===undefined){
				  errorMapping = true;
				  errorMappingMsg = errorMappingMsg +"Definire un tipo per ["+k.columnName+ "] <br>";
				  //console.log(errorMappingMsg);
			  }
		  });
		 if(errorMapping){
		   noty({text: errorMappingMsg, type: 'error', timeout:15000});
		 }
		 else{
			 self.showLoading();
			  var oid = "";
			  if(self.localCodificationDomain!==undefined 
					&& self.localCodificationDomain!=null 
					&& self.localCodificationDomain!="" 
					&& self.localCodificationDomain=='salute'
					& self.localCodificationOid!=undefined
					&& self.localCodificationOid!=null
					&& self.localCodificationOid!=""
					&& !_.startsWith(self.localCodificationOid,self.prefxDominioSalute)){
				//oid = self.localCodificationOidPrefix+""+self.localCodificationOid;
				oid = self.localCodificationOid;
			}else{ 
				 oid = self.localCodificationOid;
			}
			  
			  var form = {
					  name: self.localCodificationName,
					  description: self.localCodificationDescription,
					  version: self.localCodificationVersion,
					  oid: oid,
					  releaseDate: self.localCodificationReleaseDate,
					  typeMapping: self.localTypeMapping,
					  tmpFileNameIt: self.standardLocalImport.tmpFileNameIt,
					  tmpFileNameEn: self.standardLocalImport.tmpFileNameEn,
					  type: !self.localCodificationValueSet ? self.localCodificationCodeSystemType : null,
					  subtype: !self.localCodificationValueSet ? self.localCodificationCodeSystemSubType : null,
					  domain: self.localCodificationDomain,
					  codificationMapping:self.localCodificationsMapping,
					  organization: self.localCodificationOrganization,
					  valueSet: self.localCodificationValueSet,
					  hasOntology: self.localCodificationCodeSystemHasOntology,
					  ontologyName: self.localCodificationCodeSystemOntologyName,
					  importMode: self.importMode,
					  codeSystemId: (self.selectedCs!==undefined ? self.selectedCs.id : ""),
			  };
			  //console.log("Local Form" , form);
			  
			  var url = APP_PROPERTIES.pathImportLocal;
			  
			 /* console.log("oid oid::"+oid);
			  console.log("URL IMPORT::"+url);
			  self.hideLoading();
			  */
			  
			  self.$http.post(url, form).then(function(response) {
				  var body = response.body;
				  if(body.status === 'ERROR'){
					console.log('Error importing', body);
					noty({text: self.$t("message."+body.title, self.lang), type: 'error', timeout:5000});
				  }else if(body.status === 'BAD_REQUEST'){
						console.log('Error importing', body);
						var errorMsg = self.$t("message."+body.title, self.lang)+"<br><br>";
						var objFields = body.validationsFields;
						var keys = _.keys(objFields);
						_.each(keys, function(k){
							errorMsg = errorMsg +"<b>"+k+ "</b>: "+objFields[k]+"<br>";
							//console.log("k="+k+" v="+objFields[k]);
						});
						noty({text: errorMsg, type: 'error', timeout:15000});
					}  else if(body.status === 'OK'){
						console.log('Import ok', body);
						noty({text: self.$t("message.importInProgress", self.lang), type: 'success', timeout:5000});
						self.resetImportLocal(false);
						self.importMode="";
						//location.reload();
					  }
			  }, function(error) {
				  console.log('Error importing', error);
				  noty({text: self.$t("message.importError", self.lang), type: 'error', timeout:5000});
			  }).finally(function() {
				  self.hideLoading();
			  });
			  
			  
			  
		 }


		  
    	  
    	  
      },

      /**
       * Delete code locale LOINC.
       * @param e The event.
       */
      deleteCodeLocaleLoincByLocalCode: function(localCode){
          console.log('deleteCodeLocaleLoinc::'+JSON.stringify(localCode));
          this.showLoading();
          var formData = new FormData();
          formData.append('version', localCode.version);
          formData.append('localCodeSystemName', localCode.value);
          var self = this;
          this.$http.post(APP_PROPERTIES.pathDeleteLocalCodeLoinc, formData, {
             headers: {
               'Content-Type': 'multipart/form-data'
             }
          }).then(function(response){
            var body = response.body;
            if(body.status === 'ERROR'){
              console.log('Error deleting', body);
              noty({text: self.$t("message.deleteLocalCodeSystemError", self.lang), type: 'error', timeout:30000});
            } else if(body.status === 'OK'){
              console.log('Delete ok', body);
              noty({text: self.$t("message.deleteLocalCodeSystemOk", self.lang), type: 'success', timeout:3000});
            }
          }, function(error){
            console.log('Error deleting', error);
            noty({text: self.$t("message.deleteLocalCodeSystemError", self.lang), type: 'error', timeout:3000});
          }).finally(function(){
            self.localCodeToDelete = '';
            self.readAllLocalCodes();
            this.hideLoading();
          });
        },
      
      

      /**
       * General function to upload file for various code system.
       * @param url The endpoint.
       * @param formData The form data to send.
       */
      uploadFile: function(url, formData){
        var self = this;
        this.$http.post(url, formData, {
           headers: {
             'Content-Type': 'multipart/form-data'
           }
        }).then(function(response){
          var body = response.body;
          if(body.status === 'ERROR'){
            console.log('Error importing', body);
            noty({text: self.$t("message.importError", self.lang), type: 'error', timeout:5000});
          } else if(body.status === 'OK'){
            console.log('Import ok', body);
            noty({text: self.$t("message.importInProgress", self.lang), type: 'success', timeout:5000});
          }
        }, function(error){
          console.log('Error importing', error);
          noty({text: self.$t("message.importError", self.lang), type: 'error', timeout:5000});
        }).finally(function(){
          this.hideLoading();
        });
      },

      /**
       * Show release date tooltip for LOINC.
       */
      showReleaseDateTooltip: function(){
          $("#releaseDateTooltip").tooltip('show');
      },

      /**
       * Show release date tooltip for ICD9-CM.
       */
      showIcd9CmReleaseDateTooltip: function(){
          $("#icd9CmReleaseDateTooltip").tooltip('show');
      },

      /**
       * Show release date tooltip for AIC.
       */
      showAicReleaseDateTooltip: function(){
          $("#aicReleaseDateTooltip").tooltip('show');
      },

      /**
       * Show release date tooltip for ATC.
       */
      showAtcReleaseDateTooltip: function(){
          $("#atcReleaseDateTooltip").tooltip('show');
      },

      /**
       * Cancel import operation for ICD9-CM.
       */
      cancelIcd9CmFiles: function(e){
        e.preventDefault(); /*Disable submit*/
      },

      /**
       * Cancel import operation for AIC.
       */
      cancelAicFiles: function(e){
        e.preventDefault(); /*Disable submit*/
      },

      /**
       * Cancel import operation for ATC.
       */
      cancelAtcFiles: function(e){
        e.preventDefault(); /*Disable submit*/
      },

      cancelLocalFiles: function(e){
	      e.preventDefault(); /*Disable submit*/
	    },
      
      /**
       * On LOINC version change.
       */
      onLoincVersionChange: function(){
        var fieldName = 'version';
        var section = 'import-code-system-loinc';
        this.removeErrorByName(fieldName, section);
        var error = 'La versione deve avere un formato X.XX';
        if(_.toString(this.majorVersion).length !== 1){
          this.addError(fieldName, error, section);
        } else if(_.toString(this.minorVersion).length !== 2){
          this.addError(fieldName, error, section);
        }
      },

      /**
       * On general version change.
       * @param field The field name.
       * @param section The section of the field.
       */
      onVersionChange: function(field, section){
        this.removeErrorByName(field, section);
        var error = 'La versione non deve essere vuota';
        if(_.toString(this[field]).length === 0){
          this.addError(field, error, section);
        }
      },

      /**
       * On code system 1 change.
       */
      onCodeSystem1Change: function(){
        var self = this;
        var fieldName = 'codeSystem1';
        var section = 'import-of-mapping-resources';
        self.removeErrorByName(fieldName, section);
        var error = 'La codifica non deve essere vuota';
		
		
		
		
        if(_.toString(self.codeSystem1).length === 0){
          self.addError(fieldName, error, section);
        } else {
		  var currentElementSelected =  _.find(self.codeSystemsRemote, {name: self.codeSystem1});
          self.version1 = '';
		  if(currentElementSelected!==undefined){
			self.loadCsVersions(currentElementSelected.id,'versions1');
		  }
		  /*
          self.getVersionsByCodeSystem(self.codeSystem1).then(function(versions){
            self.handleVersions(versions, 'versions1');
            self.hideLoading();
          });
		  */
        }
      },

      /**
       * On code system 2 change.
       */
      onCodeSystem2Change: function(){
        var self = this;
        var fieldName = 'codeSystem2';
        var section = 'import-of-mapping-resources';
        self.removeErrorByName(fieldName, section);
        var error = 'La codifica non deve essere vuota';

        if(_.toString(self.codeSystem2).length === 0){
          self.addError(fieldName, error, section);
        } else {
		  var currentElementSelected =  _.find(self.codeSystemsRemote, {name: self.codeSystem2});
          self.version2 = '';
		   if(currentElementSelected!==undefined){
			   self.loadCsVersions(currentElementSelected.id,'versions2');
		   }
          /*self.getVersionsByCodeSystem(self.codeSystem2).then(function(versions){
            self.handleVersions(versions, 'versions2');
            self.hideLoading();
          });*/
        }
      },

      /**
       * On general oid change.
       * @param field The field name.
       * @param section The section of the field.
       */
      onOidChange: function(field, section){
        this.removeErrorByName(field, section);
        if(!this[field]){
          this.addError(field, 'Il campo non può essere vuoto', section);
        }
      },

      /**
       * On description change.
       * @param field The field name.
       * @param section The section of the field.
       */
      onDescriptionChange: function(field, section){
        this.onOidChange(field, section);
      },

      /**
       * On general date change.
       * @param field The field name.
       * @param section The section of the field.
       */
      onDateChange: function(field, section){
        this.removeErrorByName(field, section);
        /*console.log('this.' + field, this[field]);*/
        if(!this[field]){
          this.addError(field, 'Il campo non può essere vuoto', section);
        } else if(!this.isValidDate(this[field])){
          this.addError(field, 'La data non è valida', section);
        }
      },

      /**
       * On general file change.
       * @param e The event that contains the file.
       * @param field The field name.
       * @param section The section.
       * @param validators The validators to use too validate the file.
       */
      onFileChange: function(e, field, section, validators){
        var file = this.getFileFromEvent(e);
        this.removeErrorByName(field, section);

        /*File existst validation*/
        if(_.indexOf(validators, this.fileValidators.exists) > -1){
          if (!file.length){
            this.addError(field, 'File non valido', section);
            return;
          }
        }

        /*File is csv*/
        if(_.indexOf(validators, this.fileValidators.isCsv) > -1){
          if(!this.isCsvFile(file[0])){
            this.addError(field, 'File non valido', section);
            return;
          }
        }
        this[field] = file[0];
      },

      /**
       * On file change Loinc Italia file.
       * @param e The event.
       */
      onFileChangeLoincItalia: function(e){
        this.onFileChange(e, 'fileLoincItalia', 'import-code-system-loinc', [
          this.fileValidators.exists, this.fileValidators.isCsv
        ]);
      },

      /**
       * On file change Loinc International file.
       * @param e The event.
       */
      onFileChangeLoincInternational: function(e){
        this.onFileChange(e, 'fileLoincInternational', 'import-code-system-loinc', [
          this.fileValidators.exists, this.fileValidators.isCsv
        ]);
      },

      /**
       * On file change Loinc Map To file.
       * @param e The event.
       */
      onFileChangeLoincMapTo: function(e){
        this.onFileChange(e, 'fileLoincMapTo', 'import-code-system-loinc', [
          this.fileValidators.exists, this.fileValidators.isCsv
        ]);
      },

      /**
       * On file change ICD9-CM italian file.
       * @param e The event.
       */
      onFileChangeItaIcd9Cm: function(e){
        this.onFileChange(e, 'fileItaIcd9Cm', 'import-code-system-icd9-cm', [
          this.fileValidators.exists,
        ]);
      },

      /**
       * On file change ICD9-CM english file.
       * @param e The event.
       */
      onFileChangeEnIcd9Cm: function(e){
        this.onFileChange(e, 'fileEnIcd9Cm', 'import-code-system-icd9-cm', [
          this.fileValidators.exists,
        ]);
      },

      /**
       * On file change farmaci classe A file.
       * @param e The event.
       */
      onFileChangeFarmaciClasseA: function(e){
        this.onFileChange(e, 'fileFarmaciClasseA', 'import-code-system-aic', [
          this.fileValidators.exists, this.fileValidators.isCsv
        ]);
      },

      /**
       * On file change farmaci classe H file.
       * @param e The event.
       */
      onFileChangeFarmaciClasseH: function(e){
        this.onFileChange(e, 'fileFarmaciClasseH', 'import-code-system-aic', [
          this.fileValidators.exists, this.fileValidators.isCsv
        ]);
      },

      /**
       * On file change farmaci classe C file.
       * @param e The event.
       */
      onFileChangeFarmaciClasseC: function(e){
        this.onFileChange(e, 'fileFarmaciClasseC', 'import-code-system-aic', [
          this.fileValidators.exists, this.fileValidators.isCsv
        ]);
      },

      /**
       * On file change farmaci equivalenti file.
       * @param e The event.
       */
      onFileChangeFarmaciEquivalenti: function(e){
        this.onFileChange(e, 'fileFarmaciEquivalenti', 'import-code-system-aic', [
          this.fileValidators.exists, this.fileValidators.isCsv
        ]);
      },

      /**
       * On file change ATC file.
       * @param e The event.
       */
      onFileChangeAtc: function(e){
        this.onFileChange(e, 'fileFarmaciAtc', 'import-code-system-atc', [
          this.fileValidators.exists, this.fileValidators.isCsv
        ]);
      },
      
      
	  
	  
	  
	onFileChangeStandardLocalIt: function(e){
	  this.onFileChange(e, 'fileItStandardLocal', 'import-code-system-standard', [
		this.fileValidators.exists, this.fileValidators.isCsv
	  ]);
	},
	onFileChangeStandardLocalEn: function(e){
	  this.onFileChange(e, 'fileEnStandardLocal', 'import-code-system-standard', [
		this.fileValidators.exists, this.fileValidators.isCsv
	  ]);
	},
	
	
	
	
	
	
	
	
	
	
	
	
	
	    
	onFieldChange: function(field, section){
		this.removeErrorByName(field, section);
		var error = "";
		//console.log("onFieldChange", _.toString(this[field]));
		switch (field) {
		/*TODO: Eventualmente, aggiungere campi specifici*/
		default:
			error = "Il campo non può essere vuoto";
			break;
		}
		if(_.toString(this[field]).length === 0){
		  this.addError(field, error, section);
		}
	  },
	      

      /**
       * Add an error.
       * @param name The name of the field.
       * @param error The error to add for the given field.
       * @param section The section in which add the error.
       */
      addError: function(name, error, section){
        this.errors[section].push({
          name: name,
          value: error
        });
      },

      /**
       * Remove the error by the given name.
       * @param name The name of the field from which remove error.
       * @param section The section of the field.
       */
      removeErrorByName: function(name, section){
        var index = _.findIndex(this.errors[section], {name: name});
        if(index !== -1){
          this.errors[section].splice(index, 1);
        }
      },


      /**
       * Is this CSV file.
       * @param file The file to check.
       * @returns Returns true if the file is csv, false otherwise.
       */
      isCsvFile: function(file){
        if(file.type === 'text/csv' || file.type === 'application/vnd.ms-excel'){
          return true;
        } else {
          return false;
        }
      },

      /**
       * Retrieve the file by the given event.
       * @param event The event from which retrieve the file.
       *
       */
      getFileFromEvent: function(event){
        return event.target.files || event.dataTransfer.files;
      },

      /**
       * Returns true if the from should be disabled, false otherwise.
       */
      importDisabled: function(){
        return !this.majorVersion || !this.minorVersion || !this.fileLoincItalia ||
          !this.fileLoincInternational || !this.fileLoincMapTo || !this.releaseDate ||
          !this.oid || !this.description || this.errors['import-code-system-loinc'].length > 0;
      },

      /**
       * Returns true if the from should be disabled, false otherwise.
       */
      importIcd9CmDisabled: function(){
        return !this.icd9CmVersion || !this.fileItaIcd9Cm || !this.fileEnIcd9Cm
          || !this.icd9CmReleaseDate || !this.icd9CmDescription || !this.icd9CmOid ||
          this.errors['import-code-system-icd9-cm'].length > 0;
      },

      /**
       * Returns true if the from should be disabled, false otherwise.
       */
      importAicDisabled: function(){
        return !this.aicVersion || !this.fileFarmaciClasseA || !this.fileFarmaciClasseH
          || !this.fileFarmaciClasseC || !this.fileFarmaciEquivalenti || !this.aicReleaseDate
          || !this.aicOid || !this.aicDescription ||
          this.errors['import-code-system-aic'].length > 0;
      },

      /**
       * Returns true if the from should be disabled, false otherwise.
       */
      importAtcDisabled: function(){
        return !this.atcVersion || !this.fileFarmaciAtc || !this.atcReleaseDate
          || !this.atcOid || !this.atcDescription ||
          this.errors['import-code-system-atc'].length > 0;
      },

      inspectStandardLocalDisabled: function(){
    	  if(this.isLocal){
    		  !this.fileItStandardLocal || this.errors['import-code-system-locale'].length > 0;
    	  }
    	  if(this.isStandard){
    		  !this.fileItStandardLocal || !this.fileEnStandardLocal || this.errors['import-code-system-standard'].length > 0;
    	  }
        },
      
      /**
       * Returns true if the from should be disabled, false otherwise.
       */
      resourceMappingImportDisabled: function(){
        return !this.codeSystem1 || !this.version1 || !this.codeSystem2
          || !this.version2 || !this.resourceMappingFile
          || !this.mappingReleaseDate ||
          this.errors['import-of-mapping-resources'].length > 0;
      },

      /**
       * Returns true if the given field has errors.
       * @param name The name of the field.
       * @param section The section from which retrieve the error.
       * @returns Returns true if the given field in the given section has errors,
       * false otherwise.
       */
      hasErrorByName: function(name, section){
        return _.findIndex(this.errors[section], {name: name}) > -1;
      },

      /**
       * Get the error by the given name.
       * @param name The name of the field from which retrieve the error.
       * @param section The section from which retrieve the error.
       * @returns Returns the error by the given name and section.
       */
      getErrorByName: function(name, section){
        var element = _.find(this.errors[section], {name: name});
        if(element){
          return element.value;
        } else {
          return '';
        }
      },

      /**
       * On file change import.
       * @param e The event.
       */
      onFileChangeImport: function(e){
        this.onFileChange(e, 'fileImport', 'locale-code-upload-loinc', [
          this.fileValidators.exists, this.fileValidators.isCsv
        ]);
      },

      /**
       * On file change resource mapping.
       * @param e The event.
       */
      onFileChangeResourceMapping: function(e){
        this.onFileChange(e, 'resourceMappingFile', 'import-of-mapping-resources', [
          this.fileValidators.exists, this.fileValidators.isCsv
        ]);
      },

      /**
       * Returns true if the from should be disabled, false otherwise.
       */
      uploadLoincDisabled: function(){
        return !this.majorVersion || !this.minorVersion || !this.fileImport ||
          !this.localCodeSystemName || this.errors['locale-code-upload-loinc'].length > 0;
      },

      /**
       * Returns true if the from should be disabled, false otherwise.
       */
      deleteLoincDisabled: function(){
        return !this.localCodeToDelete ||
          this.errors['locale-code-delete-loinc'].length > 0;
      },

      /**
       * Returns true if the from should be disabled, false otherwise.
       */
      deleteMappingDisabled: function(){
        return !this.mappingToDelete;
      },

      /**
       * Delete the selected mapping.
       */
      deleteMappingByName: function(mapName){
        var self = this;
        self.showLoading();
//        var url = _.replace(APP_PROPERTIES.deleteMapping, '{MAP_NAME}', self.mappingToDelete);
        var url = _.replace(APP_PROPERTIES.deleteMapping, '{MAP_NAME}', mapName);
        self.$http.delete(url).then(function(response){
          if(response.status === 204) {
            noty({text: self.$t("message.successDeletingMapping", self.lang), type: 'success', timeout:5000});
          } else {
            noty({text: self.$t("message.errorDeletingMapping", self.lang), type: 'error', timeout:5000});
          }
        }, function(error){
          noty({text: self.$t("message.errorDeletingMapping", self.lang), type: 'error', timeout:5000});
        }).finally(function(){
            self.mappingList = [];
            self.mappingToDelete = '';
            self.readMapping();
        });
      },

      /**
       * On local code system name change.
       */
      onLocalCodeSystemNameChange: function(){
        var fieldName = 'localCodeSystemName';
        var section = 'locale-code-upload-loinc';
        this.removeErrorByName(fieldName, section);
        if (!this.localCodeSystemName){
          this.addError(fieldName, 'Il campo non può essere vuoto', section);
          return;
        }
      },

      /**
       * Action to do the resource mapping import.
       * @param event The event.
       */
      resourceMappingImport: function(event){
        console.log('resourceMappingImport');
        event.preventDefault();
        var formData = new FormData();
        formData.append('codeSystem1', this.codeSystem1);
        formData.append('version1', this.version1);
        formData.append('codeSystem2', this.codeSystem2);
        formData.append('version2', this.version2);
        formData.append('resourceMappingFile', this.resourceMappingFile, this.resourceMappingFile.name);
        formData.append('releaseDate', this.mappingReleaseDate);
		formData.append('mappingDescription', this.mappingDescription);
		formData.append('mappingOrganization', this.mappingOrganization);
        this.showLoading();
        var self = this;
        this.$http.post(APP_PROPERTIES.pathImportMapping, formData, {
           headers: {
             'Content-Type': 'multipart/form-data'
           }
        }).then(function(response){
          var body = response.body;
          if(body.status === 'ERROR'){
            console.log('Error importing', body);
            noty({text: self.$t("message.importError", self.lang), type: 'error', timeout:5000});
          } else if(body.status === 'OK'){
            console.log('Import ok', body);
            noty({text: self.$t("message.importInProgress", self.lang), type: 'success', timeout:5000});
          }
        }, function(error){
          console.log('Error importing', error);
          noty({text: self.$t("message.importError", self.lang), type: 'error', timeout:5000});
        }).finally(function(){
          this.hideLoading();
        });
      },

      /**
       * Action to upload code locale Loinc.
       */
      uploadCodeLocaleLoinc: function(){
        console.log('uploadCodeLocaleLoinc');
        var formData = new FormData();
        formData.append('version', this.majorVersion + '.' + this.minorVersion);
        formData.append('localCodeSystemName', this.localCodeSystemName);
        formData.append('fileImport', this.fileImport, this.fileImport.name);
        this.showLoading();
        var self = this;
        this.$http.post(APP_PROPERTIES.pathImportLocalLoinc, formData, {
           headers: {
             'Content-Type': 'multipart/form-data'
           }
        }).then(function(response){
          var body = response.body;
          if(body.status === 'ERROR'){
            console.log('Error importing', body);
            noty({text: self.$t("message.importError", self.lang), type: 'error', timeout:5000});
          } else if(body.status === 'OK'){
            console.log('Import ok', body);
            noty({text: self.$t("message.importInProgress", self.lang), type: 'success', timeout:5000});
          }
        }, function(error){
          console.log('Error importing', error);
          noty({text: self.$t("message.importError", self.lang), type: 'error', timeout:5000});
        }).finally(function(){
          this.hideLoading();
        });
      },

      /**
       * Read the list of associations.
       */
      readAssociations: function(){
        this.showLoading();
        var self = this;
        this.$http.get(APP_PROPERTIES.readAssociations).then(function(response){
          if(response.status === 200) {
            body = response.body;
            if(body.AssociationList.entry) {
              self.associations = body.AssociationList.entry;
              console.log('self.associations', self.associations);
              _.each(self.associations, function(mappingRelation){
                _.each(mappingRelation.associationQualifier, function(associationQualifier){
                  var name = associationQualifier.predicate.name;

                  if(name === 'forwardName'){
                    mappingRelation.forwardName = associationQualifier.value[0].literal.value;
                  } else if(name === 'reverseName'){
                    mappingRelation.reverseName = associationQualifier.value[0].literal.value;
                  } else if(name === 'associationKind'){
                    mappingRelation.associationKind = associationQualifier.value[0].literal.value;
                    mappingRelation.textualKind = self.generateTextKind(mappingRelation.associationKind);
                  } else if(name === 'sourceTitle_en'){
                    mappingRelation.sourceTitle_en = associationQualifier.value[0].literal.value;
                  } else if(name === 'sourceTitle_it'){
                    mappingRelation.sourceTitle_it = associationQualifier.value[0].literal.value;
                  } else if(name === 'targetTitle_it'){
                    mappingRelation.targetTitle_it = associationQualifier.value[0].literal.value;
                  } else if(name === 'targetTitle_en'){
                    mappingRelation.targetTitle_en = associationQualifier.value[0].literal.value;
                  }
                });
              });
            } else {
              self.associations = [];
              console.log('No associations to read.');
            }
          }
        }, function(error){
          console.log('Error reading associations', error);
        }).finally(function(){
          self.hideLoading();
        });
      },

      /**
       * Read the list of the mapping.
       */
      readMapping: function(){
        this.showLoading();
        var self = this;
        this.$http.get(APP_PROPERTIES.getMappingList).then(function(response){
          if(response.status === 200) {
            self.mappingList = response.body.MapCatalogEntryDirectory.entry;
          }
        }, function(error){
          console.log('Error reading mapping', error);
        }).finally(function(){
          self.hideLoading();
        });
      },

      /**
       * Generate a textual representation of the given kind parameter.
       * @param kind The kind from which generate the textual representation.
       * @returns Returns the generated text kind.
       */
      generateTextKind: function(kind){
        var text = "";
        if(kind === '1'){
          text = 'message.labelOntological';
        } else if(kind === '2'){
          text = 'message.labelTaxonomic';
        } else if(kind === '3'){
          text = 'message.labelCrossMapping';
        } else if(kind === '4'){
          text = 'message.labelLink';
        }
        return text;
      },

      /**
       * Approve the given association.
       * @param association The association to approve.
       */
      approve: function(association){
        var self = this;
        self.showLoading();
        var formData = this.buildAssociationBody(association, 'APPROVE');
        this.$http.put(APP_PROPERTIES.associationOperation, formData).then(function(response){
          console.log('Approve ok', response.body);

          /*Remove the approved element*/
          var index = _.findIndex(self.associations, function(associationItem){
            return associationItem.associationID === association.associationID;
          });
          self.associations.splice(index, 1);
        }, function(error){
          console.log('Error approving the association', error);
          noty({text: 'Impossibile approvare l\'associazione ' + association.associationID, type: 'error', timeout:5000});
        }).finally(function(){
          self.hideLoading();
        });
      },

      /**
       * Reject the given association.
       * @param association The association to reject.
       */
      reject: function(association){
        var self = this;
        self.showLoading();
        var formData = this.buildAssociationBody(association, 'REJECT');
        this.$http.put(APP_PROPERTIES.associationOperation, formData).then(function(response){
          console.log('Reject ok', response.body);

          /*Remove the approved element*/
          var index = _.findIndex(self.associations, function(associationItem){
            return associationItem.associationID === association.associationID;
          });
          self.associations.splice(index, 1);
        }, function(error){
          console.log('Error rejecting the association', error);
          noty({text: 'Impossibile rifiutare l\'associazione ' + association.associationID, type: 'error', timeout:5000});
        }).finally(function(){
          self.hideLoading();
        });
      },

      /**
       * Build the association body.
       * @param association The association to manipulate.
       * @param action The action to use.
       * @returns Returns the body to send to approve or reject the association.
       */
      buildAssociationBody: function(association, action){
        return {
        	ChangeSet: {
        		changeSetURI: "CROSS-MAPPING:" + association.associationID,
        		changeSetElementGroup: {
        			changeInstructions: {
        				value: ["ACTION: " + action]
        			}
        		}
        	}
        };
      },

      /**
       * Check the status of the import.
       */
      checkStatus: function(){
        var self = this;
        self.showLoading();
        var url = APP_PROPERTIES.checkStatus;
        url = _.replace(url, '{CODE_SYSTEM}', 'LOINC'); /*LOINC just for sport*/
        console.log('checkStatus url', url);
        this.$http.get(url).then(function(response){
          console.log('Result', response.body);

          /*Set canImport variable*/
          if(response.body.ChangeSet.state === 'FINAL'){
            self.canImport = true;
          } else {
            self.canImport = false;
          }
        }, function(error){
          console.log('Error contacting the service to check the status of the import operation', error);
          self.canImport = false;
        }).finally(function(){
          self.statusChecked = true;
          self.hideLoading();
        });
      },

      /**
       * Load versions for the selected code system.
       */
      loadVersions: function(){
        var self = this;
        self.versionToDelete = '';
        self.showLoading();
        self.getVersionsByCodeSystem(self.subSection).then(function(versions){
          self.handleVersions(versions);
          self.hideLoading();
        });
        self.readMapping();
      },

      /**
       * Load the version based on the code system.
       * @param codeSystem The selected code system.
       * @returns Returns a Promise.
       */
      getVersionsByCodeSystem: function(codeSystem){
        console.log('Load versions');
        var codeSystemToReplace = _.replace(_.toLower(codeSystem), '-', '');
        var url = "";
        
        if(_.indexOf(this.codeSystemsNotStandardLocal, codeSystem)==-1){
        	console.log('LcodeSystem::'+codeSystem+" is local type");   
        	url = _.replace(APP_PROPERTIES.getVersionsCodeSystemLocal, '{CODE_SYSTEM}', codeSystem);  
			
        }else{
        	url = _.replace(APP_PROPERTIES.getVersions, '{CODE_SYSTEM}', codeSystemToReplace);   
			
        }
        return this.retrieveDistinct(url, 'VERSION', false);
      },

      /**
       * Handle the loaded versions.
       * @param versions The list of versions to handle.
       * @param variable The variable in which store the loaded versions.
       */
      handleVersions: function(versions, variable){
		  
        if(variable === 'versions1'){
          this.versions1 = versions;
        } else if(variable === 'versions2'){
          this.versions2 = versions;
        } else if(variable === 'csDeleteVersions'){
          this.csDeleteVersions = versions;
        } else if(variable === 'vsDeleteVersions'){
          this.vsDeleteVersions = versions;
        } else {
          this.versions = versions;
        }
      },

      /**
       * Retrieve information from the distinct only if the values are ok.
       * @param url The url from which load.
       * @param field The field to read.
       * @param allLabel "All" label to preset.
       * @returns Returns the array of the distincts (empty if it can't find it).
       */
      retrieveDistinct: function(url, field, allLabel){
        var array = [];
        if(allLabel !== false){
          array.push({
            label: allLabel,
            value: '-1'
          });
        }
		//console.log("retrieveDistinct::"+url);
        return this.$http.jsonp(url, {
          jsonp: 'json.wrf'
        }).then(function(response){
          var distinctValues = response.body.stats.stats_fields[field].distinctValues;
          /*Normalize the versions*/
          _.each(distinctValues, function(distinctValue){
            array.push({
              label: distinctValue,
              value: distinctValue
            });
          });
          return array;
        }, function(response){
          console.error('Error trying to retrieve the', field, 'field');
          return [];
        });
      },

      /**
       * Ask delete form.
       */
      askDeleteConfirm: function(){
        $('#deleteConfirmModal').modal('toggle');
      },

      /**
       * Delete the current code system.
       */
      deleteCodeSystem: function(){
        var self = this;
        self.callDeleteCodeSystem(self.subSection).then(function(response){
          var body = response.body;
		  console.log("response.body::"+JSON.stringify(body));
          if(body.status === 'ERROR'){
            console.log('Error deleting', body);
            noty({text: self.$t("message.deleteError", self.lang), type: 'error', timeout:5000});
          } else {
            console.log('Delete ok', body);
            noty({text: self.$t("message.deleteOk", self.lang), type: 'success', timeout:5000});
          }
        }).finally(function(){
          self.hideLoading();
        });
        /*So close the modal and reload the versions*/
        $('#deleteConfirmModal').modal('toggle');
        self.loadVersions();
      },

      /**
       * Call delete code system.
       * @param codeSystem The code system to delete.
       * @param version The version to delete.
       * @returns Returns the Promise.
       */
      callDeleteCodeSystem: function(codeSystem, version){
        var self = this;
        this.showLoading();
        var url = _.replace(APP_PROPERTIES.pathDeleteCodeSystem, '{CODE_SYSTEM}', _.toLower(codeSystem));
        if(self.localCodificationValueSet===false){        	
        	url = _.replace(url, '{VERSION}', self.versionToDelete.id);
        }else {
        	url = _.replace(url, '{VERSION}', "vs__" + self.vsVersionToDelete.id);
        }
        return this.$http.delete(url).then(function(response){
          return response;
        }, function(error){
          noty({text: self.$t("message.deleteCodeSystem", self.lang), type: 'error', timeout:5000});
          return error;
        });
      },

      /**
       * Read all local codes.
       */
      readAllLocalCodes: function(){
        console.log('readAllLocalCodes');
        var self = this;
        self.showLoading();
        self.localCodes = [];
        self.getVersionsByCodeSystem('LOINC').then(function(versions){
          var promises = [];
          _.each(versions, function(version){
            promises.push(self.readLocalCodes(version.value));
          });

          Promise.all(promises).then(function(values){
            _.each(values, function(localCodes){
              self.localCodes = _.union(self.localCodes, localCodes);
            });
            console.log('self.localCodes', self.localCodes);
            self.hideLoading();
          });
        });
      },

      /**
       * Read local codes by the given version.
       * @param version The version from which retrieve the local codes.
       * @returns Returns the local codes by the given version.
       */
      readLocalCodes: function(version){
        var url = _.replace(APP_PROPERTIES.getLocalCodes, '{VERSION}', version);
        var url = _.replace(url, '{CODE_SYSTEM}', 'loinc');
        
        return this.retrieveDistinct(url, 'LOCAL_CODE_LIST', false).then(function(localCodeSystems){
          _.each(localCodeSystems, function(localCodeSystem){
            localCodeSystem.version = version;
            localCodeSystem.label = localCodeSystem.label + ' - ' + 'LOINC ' + version;
          });
          return localCodeSystems;
        }, function(response){
          return [];
        }).finally(function(){

        });
      },

      /**
       * Is a valid date?
       * @param s The date to validate.
       * @returns Returns true if the date is valid, false otherwise.
       */
      isValidDate: function(s) {
        var bits = s.split('-');
        var d = new Date(bits[0], bits[1] - 1, bits[2]);
        return d && (d.getMonth() + 1) == bits[1];
      },

      /**
       * Show the loading message.
       */
      showLoading: function(){
        $.blockUI({
          message : '<h1>' + Vue.t('message.labelLoading', this.lang) + '<h1>'
        });
      },

      /**
       * Hide the loading message.
       */
      hideLoading: function(){
        $.unblockUI();
      },

      resetImportLocal: function(byPassField) {
		 console.log("resetImportLocal::"+byPassField);
		  this.errors = {
				'import-code-system-loinc': [],
				'import-code-system-icd9-cm': [],
				'import-code-system-aic': [],
				'import-code-system-atc': [],
				'locale-code-upload-loinc': [],
				'import-of-mapping-resources': [],
				'locale-code-delete-loinc': [],
				'import-code-system-locale': [],
				'import-code-system-standard': [],
				'import-code-system-valueset': [],
			  };
		  
    	  this.standardLocalImport ={
    	    	header: [],
    	    	rowsCount: 0,
    	    	tmpFileNameIt: "",
    	    	tmpFileNameEn: "",
    	    	status: "blank"
	      };

		  this.localCodificationCodeSystemSubType= "nomenclature";
		  this.localCodificationVersion="";
		  this.localCodificationReleaseDate="";
		  this.localCodificationDescription="";
		  this.localCodificationOid="";
		  this.localCodificationOidPrefix="";
		  this.localCodificationCodeSystemType="";
		  this.localCodificationCodeSystemHasOntology="N";
		  this.localCodificationCodeSystemOntologyName="";
		  this.hideTyping=false;
		  this.localTypeMapping={};
	      this.localTypeMappingSubOptionsVisibility={};
	      this.localCodificationsMapping={};
	      this.localCodificationFileName="";
	      this.localCodificationOrganization="";
		  this.fileItStandardLocal="";
		  this.fileEnStandardLocal="";
		  
		  $("#fileItStandardLocal, #fileEnStandardLocal, #fileItLocal, #fileItValueSet, #fileEnValueSet").val("");
		  
		  
		 /*resetta campi nome e dominio*/
		  if(byPassField===undefined || byPassField == false){
			  this.localCodificationName = "";
			  this.localCodificationDomain = "";
		  }
		  

      },
      
      changeMappingType: function(columnName, event) {
    	  console.log("ChangeMappingType", columnName, event.target.value);
    	  this.$set(this.localTypeMapping, columnName, event.target.value);
    	  this.$set(this.localTypeMappingSubOptionsVisibility, columnName, this.localTypeMapping[columnName] === 'it.linksmt.cts2.portlet.search.rest.model.localcodification.HeaderFieldOption' );
    	  if(this.localTypeMapping[columnName] !== 'it.linksmt.cts2.portlet.search.rest.model.localcodification.HeaderFieldOption' ){
    		  this.$set(this.localCodificationsMapping, columnName, "");
    	  }
    	  /*console.log(this.localTypeMapping[columnName] === 'it.linksmt.cts2.portlet.search.rest.model.localcodification.HeaderFieldOption');*/
    	  
    	  
      },
      showMappingOptions: function(columnName) {
      	  console.log(this.localTypeMapping[columnName] === 'it.linksmt.cts2.portlet.search.rest.model.localcodification.HeaderFieldOption');
      	  return this.localTypeMapping[columnName] === 'it.linksmt.cts2.portlet.search.rest.model.localcodification.HeaderFieldOption';
      },
      
      
      /**
       * MANAGING METHODS
       */
      getCodeSystems: function() {
    	  var self = this;
    	  var url = APP_PROPERTIES.pathManageGetCodeSystem;
    	  this.$http.get(url).then(function(response) {
    		  self.codeSystemsRemote = response.data;
    	  }, function(error) {
    		  console.log(error);
    	  })
      },
      
      setSubSection : function(subSection, importMode, domain) {
    	  this.subSection = subSection;
    	  this.importMode = importMode;
		  this.currentTypeObj='';
		 //console.log("subSection::"+subSection);
		 //console.log("importMode::"+importMode);
		 //console.log("domain::"+domain);
		  
		  if(_.indexOf(this.codeSystemsNotStandardLocal, this.subSection)==-1 && this.importMode == 'newVersion'){
    		  this.localCodificationName = subSection;
			  try{
				   if(this.section=='manage-code-system'){
					    this.localCodificationDomain = _.find(this.codeSystemsRemote, {name: subSection}).domain;
				   }
 				   else if(this.section=='import-value-set'){
					   this.localCodificationDomain = _.find(this.valuesetRemote, {name: subSection}).domain;
				   }
				   
			  }catch(e){
				  this.localCodificationDomain = "";
			  }
			 
			  if(domain!==undefined && domain!=null && domain!="" && domain=='salute'){
				 if(!_.startsWith(this.localCodificationOidPrefix,this.prefxDominioSalute)){
					 this.localCodificationOidPrefix=this.prefxDominioSalute;
				 }
			  }
			  else{
				 this.localCodificationOidPrefix = "";
			  }
			  
			  console.log("localCodificationDomain::"+appVue.localCodificationDomain);
    	  }else {
    		  this.localCodificationName = "";
			  this.localCodificationDomain = "";
    	  }
    	  this.resetImportLocal(true);
      },
      
      setSelectedCs: function(cs) {
    	  this.selectedCs = cs;
    	  console.log("selectedCs", cs);
      },
	  
	
      
      loadCsVersions: function(csId,variable) {
    	  var self = this;
    	  self.csDeleteVersions = [];
    	  self.showLoading();
    	  var url = APP_PROPERTIES.pathGetCsVersions;
    	  url = url.replace(":id", csId);
		  console.log("loadCsVersions::"+url);
    	  this.$http.get(url).then(function(response) {
/*    		  console.log(JSON.stringify(response.data.JsonArray.elements));*/
				var versions = [];
    		  try {
    			  response.data.JsonArray.elements.forEach(function(element){
/*    				 console.log("id", element.members.id.value);
    				 console.log("name", element.members.name.value);*/
    				 
    				 /*self.csDeleteVersions.push({
    					 id: element.members.id.value,
    					 name: element.members.name.value
    				 });*/
					 
					 versions.push({
    					 id: element.members.id.value,
    					 name: element.members.name.value
    				 });
					 
		             self.handleVersions(versions, variable);

    			  });
    		  } catch (e) {
				console.error(e);
			}
    	  }, function(error) {
    		  console.log(error);
    	  }).finally(function() {
    		  self.hideLoading();
    	  });
      },
      
      getValueSets: function() {
    	  var self = this;
    	  var url = APP_PROPERTIES.pathManageGetValueSets;
    	  self.showLoading();
    	  self.valuesetRemote = [];
		  console.log("getValueSets::"+url);
    	  this.$http.get(url).then(function(response) {
    		  if(response && response.data && response.data["JsonArray"] && response.data["JsonArray"].elements) {
    			  response.data["JsonArray"].elements.forEach(function(vs) {
    				  
					  try{
						   var typeMapping = {};
						  for (var key in vs.members.typeMapping.members) {
							  var type = vs.members.typeMapping.members[key];
							  typeMapping[key] = type.value;
						  }
						  
						  self.valuesetRemote.push( {
							  name: vs.members.valueSetName.value,
							  currentVersion: vs.members.currentVersion.value,
							  id: vs.members.valueSetId.value,
							  typeMapping: typeMapping,
							  domain: vs.members.domain.value,
						  });
					  }
					  catch(e){}
    				 
    			  });
    		  }
    		  
    	  }, function(error) {
    		  console.log(error);
    	  }).finally(function() {
    		  self.hideLoading();
    	  });
      },
      
      loadVsVersions: function(csId,variable) {
    	  var self = this;
    	  self.vsDeleteVersions = [];
    	  self.showLoading();
    	  var url = APP_PROPERTIES.pathGetVsVersions;
    	  url = url.replace(":id", csId);
    	  this.$http.get(url).then(function(response) {
/*    		  console.log(JSON.stringify(response.data.JsonArray.elements));*/
			  var versions = [];
    		  try {
    			  response.data.JsonArray.elements.forEach(function(element){
/*    				 console.log("id", element.members.id.value);
    				 console.log("name", element.members.name.value);*/
    				 
    				 /*self.vsDeleteVersions.push({
    					 id: element.members.id.value,
    					 name: element.members.name.value
    				 });*/
					 
					 versions.push({
    					 id: element.members.id.value,
    					 name: element.members.name.value
    				 });
					 
		             self.handleVersions(versions, variable);
					 
    			  });
    		  } catch (e) {
				console.error(e);
			}
    	  }, function(error) {
    		  console.log(error);
    	  }).finally(function() {
    		  self.hideLoading();
    	  })
      },
      
      resetVersionsToDelete: function() {
    	  this.vsVersionToDelete = "";
    	  this.versionToDelete = "";
      },
	  
	loadDomines: function() {
    	  var self = this;
    	  self.domains = [];
    	  self.showLoading();
    	  var url = APP_PROPERTIES.getDomains;
    	  this.$http.get(url).then(function(response) {
    		  try {
    			  response.data.JsonArray.elements.forEach(function(element){
    				 self.domains.push({
    					 key: element.members.key.value,
    					 name: element.members.name.value,
						 position: element.members.position.value
    				 });
    			  });
    		  } catch (e) {
				console.error(e);
			}
    	  }, function(error) {
    		  console.log(error);
    	  }).finally(function() {
    		  self.hideLoading();
    	  })
      },
	  
	changeDomine: function() {
    	  var self = this;
    	  //console.log("changeDomine::"+self.localCodificationDomain);
		  if(self.localCodificationDomain=='salute'){
			if(!_.startsWith(self.localCodificationOidPrefix,self.prefxDominioSalute)){
				self.localCodificationOidPrefix=self.prefxDominioSalute;
			}
		  }
		  else{
			  self.localCodificationOidPrefix = "";
		  }
      },
	  
    },

    computed : {
    	isLoinc: function() {
    		return this.subSection === 'LOINC';
    	},
    	//isStandard : function() {
    	//	return this.subSection === 'standard';
    	//},
		//isLocal : function() {
    	//	return this.subSection !== 'LOINC' && this.subSection !== 'ICD9-CM' && this.subSection !== 'AIC' && this.subSection !== 'ATC';
    	//},
		isStandard : function() {
    		return _.indexOf(appVue.codeSystemsNotStandardLocal, this.subSection) && this.currentTypeObj==='STANDARD_NATIONAL';
    	},
		isLocal : function() {
    		return _.indexOf(appVue.codeSystemsNotStandardLocal, this.subSection) && this.currentTypeObj==='LOCAL';
    	},
    	isNewCs: function() {
    		return this.importMode === 'newCs';
    	},
    	isNewVersion: function() {
    		return this.importMode === 'newVersion';
    	},
		localCodificationCodeSystemType: function() {
    		return this.currentTypeObj;
    	},
		
		

    },


    watch : {
    	subSection: function(val, old, e) {
    		/**
    		 * Workaround. 
    		 * Dopo aver ripreso il progetto, aggiungendo un nuovo tab alla lista 
    		 * delle codifiche che possono essere importate, il cambio di tab viene richiamato due volte,
    		 * SOLO per il caso LOCALE: la prima volta con il valore corretto, la seconda con il valore undefined
    		 */
//    		console.log("val::"+val+" old::"+old);
    		if(val != old){
    			if(!val) {
        			this.subSection = old;
        		}
    		}
    	},
    

	    
	    localTypeMapping:  function(newVal, oldVal) {
	    	console.log("localTypeMapping", newVal);
		}
    },

    mounted : function() {
      console.log("Mounted");
      this.checkStatus();
      this.getCodeSystems();
	  this.loadDomines();
    },
  });
});
