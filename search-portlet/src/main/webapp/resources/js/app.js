

Vue.filter("fallbackstring", function(value , alternative) {
  if (_.trim(value)) {
    return value;
  }else {
    return alternative;
  }
});

Vue.filter("lowercase", function(value) {
    return value.toLowerCase().trim();
});

Vue.filter("capitalize", function(value) {
    return _.startCase(_.toLower(value.trim()));
});

Vue.filter('clearHeader', function (value) {
    return value.trim().replace("DF_S_","").replace("DF_D_","").replace("DF_N_","").replace("DF_M_","").replace("_it","").replace("_en","").split("_").join(" ").split("-").join(" ");
});

Vue.filter('clearUnderscore', function (value) {
    return value.trim().split("_").join(" ");
});

/* TODO: verificare dove applicare */
Vue.filter('clearVersionForView', function (value) {
	value = _.trim(value);
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


Vue.component('date-picker', VueBootstrapDatetimePicker);

var appVue;
  
$(document).ready(function() {
	appVue = new Vue({
		
    el: '#app',
    data: {
      lang: "it",
	  langSearch: "it",

      queryAll: '*',

      //List of modes
      modes: [{
        label: 'Seleziona Modalità',
        value: '-1'
      },{
        label: 'Normale',
        value: 'normal'
      },{
        label: 'Navigazione',
        value: 'navigation'
      },{
        label: 'Cross Mapping',
        value: 'cross-mapping'
      },],
      pageComponents: {
        loincSearchResults : [],

        detailObj : new SearchDetailObject(),
        mappingDetailObj : new MappingDetailObj(),
		domain:"",
		organization:"",

        page : {
          currentPage: 0,
          totalElements : 0,
          totalPages : 0,
          pages : [],
        },

        //CROSS-MAPPING
        leftPage : {
          currentPage: 0,
          totalElements : 0,
          totalPages : 0,
          pages : [],
        },

        rightPage : {
          currentPage: 0,
          totalElements : 0,
          totalPages : 0,
          pages : [],
        },
      },

      //List of all available versions
      versions: [],

      //List of all left versions
      leftVersions: [],

      //List of all right versions
      rightVersions: [],

      //List of all available statuses
      statuses: [],

      //List of all available classes
      classes: [],

      //List of all available systems
      systems: [],

      //List of all available properties
      properties: [],

      //List of all available methods
      methods: [],

      //List of all available scales
      scales: [],

      //List of all available times
      times: [],

      //List of all available chapters
      chapters: [],

      //List of all available anatomical groups
      anatomicalGroups: [],

      //List of all available active principles
      activePrinciples: [],

      //List of all available companies
      companies: [],

      //List of all available relations
      relations: [],

      //Associations
      associations: [],

      //Temporary Associations
      tempAssociations: [],

      //Local code systems
      localCodeSystems: [],

      //Local codes
      localCodes: [],

      //The selected mode
      selectedMode: "navigation",

      //The navigation mode
      navigationMode: 'code-system',
	  subNavigationMode: 'codesystem-group-1',
	  

      //The export mode
      exportMode: 'code-system',
      exportResource: 'ICD9-CM',
	  exportResourceType: 'STANDARD_NATIONAL_STATIC',
      exportLanguage: 'it',
      exportFormat: 'json',
      exportType: '',
      exportLocalCode: '',
      exportMapName: '',
	  subExportMode: 'codesystem-group-1',

      //The export languages
      exportLanguages: [],

      //The export types
      exportTypes: [],

      //The export local codes
      listMappingLocalCodesLoinc: [],

      //The mapping list
      mappingList: [],
	  
      loincSearchForm : {
        selectedNavigationStandard: "ICD9-CM", 
		selectedSearchStandardCodeSystem:  "ICD9-CM",
		selectedSearchStandardValueSet:'TUTTI',
		selectedSearchStandardMapping:'TUTTI',
		
        selectedMappingStandard: 'LOINC',
        selectedLocalCodeSystem : '', 
		

        //NORMAL
        selectedMultiStandardCodeSystem: 'AIC',
		selectedMultiStandardValueSet:'',
		selectedMultiStandardMapping:'',
        version: '-1',
        normalVersion: '-1',
        status: "-1",
        class : "-1",
        system : "-1",
        property: "-1",
        method : "-1",
        time: "-1",
        matchValue : "" ,
        scale: "-1",
        anatomicalGroup: "-1",
        company: "-1",
        chapter: '-1',
        activePrinciple: '-1',

        //CROSS MAPPING
        leftStandard: 'ICD9-CM',
        rightStandard: 'ICD9-CM',
        leftVersion: '-1',
        rightVersion: '-1',
        relation: '',
		
		typeSearch: 'CODESYSTEM', //CODESYSTEM,VALUESET,MAPPING
		dynamicField:{},
		dynamicFieldValue:[],
      },

      paging: _.clone(DEFAULT_PAGING),

      detailObjRequest: {
        status : ""
      },
	  
      detailsTab : "tab-details",
      searchExecuted: false,
      leftSearchExecuted: false,
      rightSearchExecuted: false,
      crossMappingSearch: 'left',
      
      /*List of code systems not local*/
      codeSystemsNotStandardLocal: ['LOINC','ICD9-CM','ATC','AIC'],
      
      codeSystemsRemote: [],
      
      tooltip: {},
      
      /**
       * Nuovo
       */
      selectedCsType: "STANDARD_NATIONAL_STATIC", /*or STANDARD_NATIONAL or STANDARD_NATIONAL or LOCAL or VALUE_SET*/
      localSearchFormVersion : "",
      localSearchFormStandard: "",
      localsCode: [],
      localCsVersions : [],
      valueSets: [],
	  //localSearchFormDomain:{
		//value:"TUTTI"  
	  //},
	  localSearchFormDomain:"TUTTI",

	  domains:[],
	  
	  defaultHeaderTable: [],
	  dynamicHeaderTable: [],

	  enIsPresent:false,
	  itIsPresent:false,
	  resultPresent:false,
	  
	  
 
    },

    methods: {
      resetLoincForm : function() {
        console.log("reset");
        this.pageComponents.loincSearchResults = [];
        this.searchExecuted = false;
        this.loincSearchForm.version = '-1';
        this.loincSearchForm.normalVersion = '-1';
        this.loincSearchForm.status = '-1';
        this.loincSearchForm.class = '-1';
        this.loincSearchForm.system = '-1';
        this.loincSearchForm.property = '-1';
        this.loincSearchForm.method = '-1';
        this.loincSearchForm.time = '-1';
        this.loincSearchForm.matchValue = '';
        this.loincSearchForm.scale = '-1';
        this.loincSearchForm.anatomicalGroup = '-1';
        this.loincSearchForm.company = '-1';
        this.loincSearchForm.chapter = '-1';
        this.loincSearchForm.activePrinciple = '-1';
		this.loincSearchForm.dynamicField = {};
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
      
      
      /**
       * Generate search text.
       * @param matchValue The match value.
       * @param codeSystem The code system.
       * @returns Returns the text to use for the search.
       */
      generateSearchText: function(matchValue, codeSystem){
        var self = this;
		var matchValueValue = _.trim(matchValue);
        if(matchValueValue){
            var searchText = "";

            /**
             * Controllo se il matchValue inserito sia
             * un codice LOINC. In tal caso
             * la ricerca deve essere effettuata in
             * maniera precisa, in modo da restituire
             * un solo risultato.
             */
            if(/^\d+\-\d/.test(matchValueValue) && codeSystem=='LOINC'){
              searchText= '"'+matchValueValue+'"';
            } else {

              var words = _.split(matchValueValue, " ");
              //var separator = "";
			  var separator = "";

              words.forEach(function(word) {
                searchText = searchText+separator;
				//searchText = searchText+"+"+word;
				//searchText = searchText+"+"+self.makeTextSearchLike(word);
                //searchText = searchText+word;
				searchText = searchText+""+self.makeTextSearchLike(word);
                separator = " AND ";
              });
            }
			
			
            //searchText = "\""+searchText+"\"";
            //console.log("searchText::"+searchText);
		
			var selectedVal = self.getSelectedVal().trim();
			
			var csCheck = codeSystem;
			if(self.selectedMode == 'normal'){
				if(selectedVal == 'TUTTI'){
					csCheck = self.getMultiStandardSelectedVal();
				}
			}
			
			
			if(_.indexOf(self.codeSystemsNotStandardLocal, csCheck)==-1){
				/*nuovi codesystem standard/local/valueset*/
				//matchValueParam ="q=" + encodeURIComponent("*"+searchText+"*")+"&fq="+encodeURIComponent("NAME:"+csCheck);
				matchValueParam ="q=" + encodeURIComponent(searchText)+"&fq="+encodeURIComponent("NAME:"+csCheck);
				//matchValueParam ="q=" + searchText+"&fq="+encodeURIComponent("NAME:"+csCheck);
			}
			else{
				 matchValueParam ="q=" + encodeURIComponent(searchText);
			}
			
           
        } else {
          if(codeSystem === 'ICD9-CM'){
            if(self.loincSearchForm.chapter == -1){
              matchValueParam = encodeURIComponent("TYPE:chapter");
            } else {
              matchValueParam = encodeURIComponent(self.queryAll); // + "&sort=ICD9CM_CODE%20ASC";
            }
          } else if(codeSystem === 'ATC'){
            if(self.loincSearchForm.anatomicalGroup == -1){
              matchValueParam = encodeURIComponent("ALL");
            } else {
              matchValueParam = encodeURIComponent(self.queryAll); // + "&sort=CODICE_ATC%20ASC";
            }
          } else if(codeSystem === 'AIC'){
            matchValueParam ="q=" + encodeURIComponent(self.queryAll) + "&sort=CODICE_AIC%20ASC";
          } else if(codeSystem === 'LOINC'){
            matchValueParam ="q=" + encodeURIComponent(self.queryAll) + "&sort=LOINC_NUM%20ASC";
          }else if(_.indexOf(self.codeSystemsNotStandardLocal, codeSystem)==-1){

			/*nuovi codesystem standard/local*/
			//console.log("nuovi codesystem standard/local");
			
			
			/* verifico se sono nella sezione 'normal'*/
			var csCheck ="";
			if(self.selectedMode == 'normal' ){
				/* nel caso di sezione 'normal' e codeSystem = 'TUTTI' i valore del codesystem 
				*da verificare è recuperato dalla pressione di uno dei TAB MultiStandard*/
				if(codeSystem=='TUTTI'){
					csCheck = self.getMultiStandardSelectedVal();
				}
				else{
					csCheck = codeSystem;
				}
			}
			else if(self.selectedMode == 'navigation' || self.selectedMode == 'cross-mapping') {
				/* verifico se sono nella sezione 'navigation o cross-mapping'*/
				csCheck = codeSystem;
			}
			
			
			//verifico se il CS corrente è una classificazione
			var currentElementSelected =  _.find(self.codeSystemsRemote, {name: csCheck});
			if(currentElementSelected!==undefined && currentElementSelected!=null && currentElementSelected.isClassification){

				if(self.selectedMode == 'normal' && codeSystem!='TUTTI' ){
					//in caso di classificazione con codesystem selezionato != TUTTI 
					//	aggiungo i filtri standard per recuperare l'elenco dei CS
					 matchValueParam ="q=" + encodeURIComponent(self.queryAll) + "&fq="+encodeURIComponent("NAME:"+csCheck) + "&sort="+this.getSortField()+"%20ASC";
				 }
				 else{
					 //in tutti gli altri casi di classificazione aggiungo il filtro ALL che permette di costruire l'albero di navigazione sulla classificazione
					//matchValueParam = encodeURIComponent("ALL"); 
					  
					
					//console.log("localSearchFormDomain::"+this.localSearchFormDomain);
					if(this.localSearchFormDomain!==undefined && this.localSearchFormDomain!='TUTTI'){
						/*filtro su dominio mantenendo la visualizzazione di una classificazione (-SUBCLASS_OF:*:" prende solo gli elementi root)*/
						matchValueParam ="q=" + encodeURIComponent(self.queryAll) + "&fq="+encodeURIComponent("DOMAIN:"+this.localSearchFormDomain)+ "&fq="+encodeURIComponent("-SUBCLASS_OF:*") + "&sort="+this.getSortField()+"%20ASC";
					}
					else{
						matchValueParam = encodeURIComponent("ALL"); 
					}
					  
				}

			}else{
				var isLastVersion = "";
				if(self.selectedMode == 'normal' && codeSystem=='TUTTI' ){
					//in caso di ricerca nella sezione normal con elemento selezioanto TUTTI aggiungo il filtro IS_LAST_VERSION:true 
					//perche la versione può essere selezionata solo dopo aver selezionato un CS
					isLastVersion = isLastVersion+"&fq="+encodeURIComponent("IS_LAST_VERSION:true");
				}
				
				//console.log("localSearchFormDomain::"+this.localSearchFormDomain);
				if(this.localSearchFormDomain!==undefined && this.localSearchFormDomain!='TUTTI'){
						/*filtro su dominio mantenendo la visualizzazione di una classificazione (-SUBCLASS_OF:*:" prende solo gli elementi root)*/
					matchValueParam ="q=" + encodeURIComponent(self.queryAll) + "&fq="+encodeURIComponent("NAME:"+csCheck)+ "&fq="+encodeURIComponent("DOMAIN:"+this.localSearchFormDomain)+ "&fq="+encodeURIComponent("-SUBCLASS_OF:*")+ isLastVersion+ "&sort="+this.getSortField()+"%20ASC";
				}
				else{
					matchValueParam ="q=" + encodeURIComponent(self.queryAll) + "&fq="+encodeURIComponent("NAME:"+csCheck)+ isLastVersion+ "&sort="+this.getSortField()+"%20ASC";
				}
			}
			
			
          }else {
        	   matchValueParam ="q=" + encodeURIComponent(self.queryAll) + "&sort="+self.getSortField()+"%20ASC";
          }
        }
        return matchValueParam;
      },
	
	  makeTextSearchLike: function(text){
		  if(text!==undefined && text!=null && text!=""){
			text = "("+text+" OR "+text+"*)";
			//text = "("+"\""+text+"\""+" OR "+"\""+text+"\""+")";
		  }
		  return _.replace(text, /\x2a\x2a/g, "*");
	  },
	  
	  
	  
	  
	  /**
	  *
	  */
      makeSearchUrl: function() {
		var self = this;
        var matchValueParam = "";
		
		var selectedVal = self.getSelectedVal();
		
        //NORMAL
        if(self.selectedMode == 'normal'){
			
         matchValueParam = self.generateSearchText(self.loincSearchForm.matchValue, selectedVal);

          //Loinc
         if(selectedVal == 'LOINC'){
            if(self.lang==='it') {
              matchValueParam = matchValueParam + "&fq="+encodeURIComponent("COMPONENT_it:[* TO *]");
            }

            var status = self.loincSearchForm.status;
            if(status != -1) {
              matchValueParam = matchValueParam + "&fq="+encodeURIComponent("STATUS:\""+status + "\"");
            }

            var classType = self.loincSearchForm.class;
            if(classType != -1) {
              matchValueParam = matchValueParam + "&fq="+encodeURIComponent("CLASS_"+self.lang+":\""+classType + "\"");
            }

            var system = self.loincSearchForm.system;
            if(system != -1) {
              matchValueParam = matchValueParam + "&fq="+encodeURIComponent("SYSTEM_"+self.lang+":\""+system + "\"");
            }

            var property = self.loincSearchForm.property;
            if(property != -1) {
              matchValueParam = matchValueParam + "&fq="+encodeURIComponent("PROPERTY_"+self.lang+":\""+property + "\"");
            }

            var method = self.loincSearchForm.method;
            if(method != -1) {
              matchValueParam = matchValueParam + "&fq="+encodeURIComponent("METHOD_TYP_"+self.lang+":\""+method + "\"");
            }

            var time = self.loincSearchForm.time;
            if(time != -1) {
              matchValueParam = matchValueParam + "&fq="+encodeURIComponent("TIME_ASPECT_"+self.lang+":\""+time + "\"");
            }

            var scale = self.loincSearchForm.scale;
            if(scale != -1) {
              matchValueParam = matchValueParam + "&fq="+encodeURIComponent("SCALE_TYP_"+self.lang+":\""+scale + "\"");
            }
          } else if(selectedVal == 'ICD9-CM'){
            var chapter = self.loincSearchForm.chapter;
            if(chapter != -1) {
              matchValueParam = matchValueParam + "&fq="+encodeURIComponent("CAPITOLO:\"" + chapter + "\"");
            }

            //Add sort parameter
            matchValueParam = matchValueParam + "&sort=" + encodeURIComponent("ICD9CM_ID asc");
          } else if(selectedVal == 'ATC'){
            var anatomicalGroup = self.loincSearchForm.anatomicalGroup;
            if(anatomicalGroup != -1) {
              matchValueParam = matchValueParam + "&fq="+encodeURIComponent("GRUPPO_ANATOMICO:\"" + anatomicalGroup + "\"");
            }
          } else if(selectedVal == 'AIC'){
            var activePrinciple = self.loincSearchForm.activePrinciple;
            if(activePrinciple != -1) {
              matchValueParam = matchValueParam + "&fq="+encodeURIComponent("PRINCIPIO_ATTIVO:\"" + activePrinciple + "\"");
            }

            var company = self.loincSearchForm.company;
            if(company != -1) {
              matchValueParam = matchValueParam + "&fq="+encodeURIComponent("DITTA:\"" + company + "\"");
            }

            var classValue = self.loincSearchForm.class;
            if(classValue != -1) {
              matchValueParam = matchValueParam + "&fq="+encodeURIComponent("CLASSE:\"" + classValue + "\"");
            }
		  } else if(_.indexOf(self.codeSystemsNotStandardLocal, selectedVal)==-1 && selectedVal.trim() != 'TUTTI'){
				var self = self;

				_.each(self.dynamicHeaderTable, function(field){
					try{
						var valueField = self.loincSearchForm.dynamicField[field];
						if(valueField!==undefined && valueField!=null && _.trim(valueField)!="" && _.trim(valueField)!="Tutte" 
							&& _.trim(valueField)!="Tutti" && _.trim(valueField)!="-1"){
							//console.log("dynamicField::"+field+" value::"+valueField);
							
							if(_.startsWith(field,'DF_D_')){
								//console.log("dynamicField data::"+field+" value::"+valueField);
								//var data =_.trim(valueField);
							
								//var tmp = data.split("/");
								//data = tmp[1]+"/"+tmp[0]+"/"+tmp[2];							
								
								//var formatDate = moment(Date.parse(data)).format('YYYY-MM-DD');
								/*In caso di filtro data non prende in considerazione ore minuti e secondi in tutto il range di eventuali orari della giornata cercata*/
								//matchValueParam = matchValueParam + "&fq="+encodeURIComponent(""+field+":["+formatDate+"T00:00:00Z"+" TO "+formatDate+"T23:59:59Z"+"]");
								matchValueParam = matchValueParam + "&fq="+encodeURIComponent(""+field+":["+valueField+" TO "+valueField+"]");
								
							}
							else if(_.startsWith(field,'DF_N_')){
								matchValueParam = matchValueParam + "&fq="+encodeURIComponent(""+field+":" + _.trim(valueField)+"");
							}
							else if(_.startsWith(field,'DF_S_')){
								//matchValueParam = matchValueParam + "&fq="+encodeURIComponent(""+field+":*" + _.trim(valueField)+"*");
								//matchValueParam = matchValueParam + "&fq="+encodeURIComponent(""+field+":" + _.trim(valueField)+"");

								matchValueParam = matchValueParam + "&fq="+encodeURIComponent(""+field+":"+  "\""  + _.trim(valueField)+"\"" +"");							
							}
							
						}
					}
					catch(e){
						console.error(e);
					}
				});
				
				
				if(self.currentCsSelectedIsClassification){
					//console.log("IS CLASSIFICATION");
					/*in caso di classificazione viene aggiunto il filtro sui capitoli se presente (i capitoli sono i primi livelli della gerarchia)*/
					var chapter = self.loincSearchForm.chapter;
					if(chapter!==undefined && chapter!="-1"){
						/*il seguente pezzo di query filtra per tutti i codesystem che hanno l campo SUBCLASS_OF che inizia per chapter+_*/
						matchValueParam = matchValueParam + "&fq=SUBCLASS_OF:"+chapter+"_*";
						/*il seguente pezzo di query aggiunge ai risultati anche il pardre che ha esattamente CS_CODE=chapter*/
						matchValueParam = matchValueParam + encodeURIComponent(" OR CS_CODE:"+chapter);
						//console.log("matchValueParam::"+matchValueParam);
					}
				}
			
			} else if(selectedVal.trim() == 'TUTTI'){
				
				var multiStandardSelectedVal = self.getMultiStandardSelectedVal();
				
				if(_.indexOf(self.codeSystemsNotStandardLocal, multiStandardSelectedVal)!=-1 
					&& selectedVal.trim() == 'TUTTI' ){
					//codeSystem vecchi (LOINC;ATC;AIC;ICD9CM)
					matchValueParam = self.generateSearchText(self.loincSearchForm.matchValue, multiStandardSelectedVal);
					if(multiStandardSelectedVal === 'LOINC' && self.lang === 'it') {
					  matchValueParam = matchValueParam + "&fq="+encodeURIComponent("COMPONENT_it:[* TO *]");
					}

					if(multiStandardSelectedVal === 'ICD9-CM'){
					  matchValueParam = matchValueParam + "&sort=" + encodeURIComponent("ICD9CM_ID asc");
					}
				}
				else {
					//codeSystem nuovi STANDARD/LOCAL
					//console.log("codeSystem STANDARD/LOCAL");
					matchValueParam = self.generateSearchText(self.loincSearchForm.matchValue, selectedVal);
				}
          }
        }

        //Navigation
        else if(self.selectedMode == 'navigation') {
			matchValueParam = self.generateSearchText('', self.loincSearchForm.selectedNavigationStandard);

			//Force italian only content for LOINC
			if(self.loincSearchForm.selectedNavigationStandard === 'LOINC') {
				matchValueParam = matchValueParam + "&fq="+encodeURIComponent("COMPONENT_it:[* TO *]");
			}

			if(self.loincSearchForm.selectedNavigationStandard == 'ICD9-CM'){
				//Add sort parameter
				matchValueParam = matchValueParam + "&sort=" + encodeURIComponent("ICD9CM_ID asc");
			}
		  
			self.pageComponents.domain = "";
			self.pageComponents.organization="";
			var domain = null;
			var organization = null;
			var description = null;
			
			if(self.navigationMode == 'code-system'){
				var currentElementSelected =  _.find(self.codeSystemsRemote, {name: self.loincSearchForm.selectedNavigationStandard});
				if(currentElementSelected!==undefined){
						if(currentElementSelected.domain!==undefined){
						domain = currentElementSelected.domain;
					}
					organization = currentElementSelected.organization;
					description = currentElementSelected.description;
				}
			}else if(self.navigationMode == 'value-set'){
				_.each(self.valueSets, function(obj){
					if(obj.members.valueSetName!==undefined && obj.members.valueSetName.value==self.loincSearchForm.selectedNavigationStandard){
						//console.log("obj.members::"+JSON.stringify(obj.members));
						
						if(obj.members.domain!==undefined && obj.members.domain.value!==undefined){
							domain = obj.members.domain.value;
						}
						if(obj.members.organization!==undefined && obj.members.organization.value!==undefined){
							organization = obj.members.organization.value;
						}
						if(obj.members.description!==undefined && obj.members.description.value!==undefined){
							description = obj.members.description.value;
						}
					}
				});
			}
			
			if(domain || organization || description){
				if(domain!==undefined){
					var dmn =  _.find(self.domains, {value: domain});
					if(dmn!==undefined){
						self.pageComponents.domain = dmn.label;
					}
				}
				self.pageComponents.organization=(organization!==undefined?organization:"");
				self.pageComponents.description=(description!==undefined?description:"");
			}
		  
        }

        //CROSS-MAPPING
        else if(self.selectedMode == 'cross-mapping') {
          var standard = "";
          if(self.crossMappingSearch === 'left'){
            standard = self.loincSearchForm.leftStandard;
            matchValueParam = self.generateSearchText(self.loincSearchForm.selectLeftSearch, standard);
          } else {
            standard = self.loincSearchForm.rightStandard;
            matchValueParam = self.generateSearchText(self.loincSearchForm.selectRightSearch, standard);
          }

          if(standard == 'ICD9-CM'){
            //Add sort parameter
            matchValueParam = matchValueParam + "&sort=" + encodeURIComponent("ICD9CM_ID asc");
          }
        }
		
		
        var url = APP_PROPERTIES.pathSearchEntities + "matchvalue=" + encodeURIComponent(matchValueParam) +  self.paging.asHttpRequestParam();

        url = self.generateParams(url);
		//console.log("url::"+url)
        return url;
      },
      
     	  
	  /**
	  *
	  */
	   getSortField: function() {
		
		var sortField = "";
		if(this.selectedMode == 'normal' || this.selectedMode == 'cross-mapping'){
			if(this.loincSearchForm.typeSearch===undefined || this.loincSearchForm.typeSearch=='CODESYSTEM'){
				sortField = "CS_CODE";
			}else if(this.loincSearchForm.typeSearch=='VALUESET'){
				sortField = "VALUESET_CODE";
			}
		} else if(this.selectedMode == 'navigation'){
			if(this.selectedCsType===undefined || this.selectedCsType=='STANDARD_NATIONAL' || this.selectedCsType=='LOCAL'){
				sortField = "CS_CODE";
			}else if(this.selectedCsType=='VALUE_SET'){
				sortField = "VALUESET_CODE";
			}
		}
		
		return sortField;
	  },
	  
	  /**
	  *
	  */
      getSelectedVal: function() {
		var selectedVal = "";
		if(this.loincSearchForm.typeSearch===undefined || this.loincSearchForm.typeSearch=='CODESYSTEM'){
			selectedVal = this.loincSearchForm.selectedSearchStandardCodeSystem;
		}else if(this.loincSearchForm.typeSearch=='VALUESET'){
			selectedVal = this.loincSearchForm.selectedSearchStandardValueSet;
		}
		return selectedVal;
	  },
	  
	   /**
	  *
	  */
      getMultiStandardSelectedVal: function() {
		var selectedVal = "";
		if(this.loincSearchForm.typeSearch===undefined || this.loincSearchForm.typeSearch=='CODESYSTEM'){
			selectedVal = this.loincSearchForm.selectedMultiStandardCodeSystem;
		}else if(this.loincSearchForm.typeSearch=='VALUESET'){
			selectedVal = this.loincSearchForm.selectedMultiStandardValueSet;
		}
		return selectedVal;
	  },
	  
     

      /**
       * Generate the url with a replaced {STANDARD_PARAM} and {VERSION_PARAM}.
       * @param url The url with the placeholders.
       * @param side The side of the search.
       * @returns Returns the value of the url to use.
       */
      generateParams: function(url, side){
        var standardToReplace = "";
        var versionToReplace = "";
		
        if(side){
          this.crossMappingSearch = side;
        }
        if(this.selectedMode == 'normal'){
			 
			if(this.loincSearchForm.typeSearch===undefined || this.loincSearchForm.typeSearch=='CODESYSTEM'){
				standardToReplace = this.loincSearchForm.selectedSearchStandardCodeSystem;
				versionToReplace = this.loincSearchForm.normalVersion;
				if(this.loincSearchForm.selectedSearchStandardCodeSystem === 'TUTTI'){
					standardToReplace = this.loincSearchForm.selectedMultiStandardCodeSystem;
					versionToReplace = '-1';
				}
			}else if(this.loincSearchForm.typeSearch=='VALUESET'){
				standardToReplace = this.loincSearchForm.selectedSearchStandardValueSet;
				versionToReplace = this.loincSearchForm.normalVersion;
				
				if(this.loincSearchForm.selectedSearchStandardValueSet === 'TUTTI'){
					standardToReplace = this.loincSearchForm.selectedMultiStandardValueSet;
					versionToReplace = '-1';
				}
			}
		  
        } else if(this.selectedMode == 'navigation'){
			
			//console.log("selectedCsType::"+this.selectedCsType);
			//console.log("loincSearchForm.selectedNavigationStandard ::"+this.loincSearchForm.selectedNavigationStandard );
			//console.log("loincSearchForm.version ::"+this.loincSearchForm.version );
			//console.log("localSearchFormVersion ::"+this.localSearchFormVersion );
			
			if(this.selectedCsType == 'STANDARD_NATIONAL_STATIC' || this.selectedCsType == 'VALUE_SET'){
				standardToReplace = this.loincSearchForm.selectedNavigationStandard;
				versionToReplace = this.loincSearchForm.version;
			}
			else if(this.selectedCsType == 'STANDARD_NATIONAL' || this.selectedCsType == 'LOCAL'){
				standardToReplace = this.loincSearchForm.selectedNavigationStandard;
				versionToReplace = this.localSearchFormVersion;
			}
        } else if(this.selectedMode == 'cross-mapping'){
          if(this.crossMappingSearch == 'left'){
            standardToReplace = this.loincSearchForm.leftStandard;
            versionToReplace = this.loincSearchForm.leftVersion;
          } else if(this.crossMappingSearch == 'right'){
            standardToReplace = this.loincSearchForm.rightStandard;
            versionToReplace = this.loincSearchForm.rightVersion;
          }
        }
        if(standardToReplace != '-1'){
          url += '&codesystem=' + standardToReplace;
        }
        if(versionToReplace != '-1'){
          url += '&codesystemversion=' + versionToReplace;
        }
		
		//url += '&codesystemversion=' + 30;
        return url;
      },

      /**
       * On change the code system.
       */
      changeSelectedMode: function() {
        var self = this;
        self.resetResults();
        self.loincSearchForm.matchValue = '';

		self.loincSearchForm.selectedNavigationStandard = 'ICD9-CM';
		self.loincSearchForm.selectedSearchStandardCodeSystem = 'TUTTI';
		
		self.loincSearchForm.selectedSearchStandardValueSet='TUTTI';
		self.loincSearchForm.selectedSearchStandardMapping='TUTTI';
		
        if(self.selectedMode === 'normal'){
			self.reloadFields(self.loincSearchForm.selectedSearchStandardCodeSystem);
        } else if(self.selectedMode === 'navigation'){
		   self.reloadFields(self.loincSearchForm.selectedNavigationStandard);
        }
        
        //If you go outside the language should be italian
        if(self.selectedMode !== 'normal'){
          self.lang = 'it';
        }
       
      },
	  


      /**
       * Change multi standard.
       */
      changeMultiStandard: function(){
        //console.log('ChangeMultiStandard');
        var self = this;
		self.executeSearch(self.lang, 0, 'page', 'loincSearchResults');
		
		setTimeout(function(){ 
			/*TODO:: spostare*/
			self.loincSearchForm.dynamicField={};
			/*Genera l'header dinamico per le tabelle gestite dal template local-table*/
			 self.getDynamicHeaderTable(self.getMultiStandardSelectedVal());
		}, 500);
      },

      /**
       * Returns the search url.
       * @param side The side of the search.
       * @returns Returns the search url.
       */
      getSearchUrl: function(side) {
        var url = APP_PROPERTIES.pathSearchEntities;
        url = this.generateParams(url, side);
        return url;
      },
      
      /**
       * Is the current user Cross Mapping STI.
       */
      isCrossMappingSti: function(){
    	return APP_PROPERTIES.isCrossMappingSti;  
      },

      /**
       * On change the code system.
       */
      changeCodeSystem: function() {
		//console.log("changeCodeSystem::");
        var self = this;
		//self.selectedCsType = "STANDARD_NATIONAL_STATIC";
		/*setta la tipologia di defauit da per i codesystem in base al gruppo di navigazione*/
		if(self.subNavigationMode=="codesystem-group-1"){
			self.selectedCsType = "STANDARD_NATIONAL_STATIC";
		}
		else if(self.subNavigationMode=="codesystem-group-2"){
			self.selectedCsType = "LOCAL";
		}
		      
        //console.log('Resetting code system - '+ self.loincSearchForm.selectedNavigationStandard);
			
        self.resetResults();
        self.loincSearchForm.matchValue = '';

        if(self.loincSearchForm.selectedNavigationStandard !== '-1'){
          self.reloadFields(self.loincSearchForm.selectedNavigationStandard);
        }
      },
  
	changeCodeSystemSearchSelect: function() {
        var self = this;
        self.selectedCsType = "STANDARD_NATIONAL_STATIC";
        //console.log('Resetting code system - '+ self.loincSearchForm.selectedSearchStandardCodeSystem);
		
        self.resetResults();
        self.loincSearchForm.matchValue = '';

        if(self.loincSearchForm.selectedSearchStandardCodeSystem !== '-1' || self.loincSearchForm.selectedSearchStandardCodeSystem !== 'TUTTI'){
          self.reloadFields(self.loincSearchForm.selectedSearchStandardCodeSystem);
        }

		setTimeout(function(){ 
			/*TODO:: spostare*/
			self.loincSearchForm.dynamicField={};
			/*Genera l'header dinamico per le tabelle gestite dal template local-table*/
			 self.getDynamicHeaderTable(self.loincSearchForm.selectedSearchStandardCodeSystem);
		}, 500);
      },
      

      /**
       * Load export properties.
       */
      loadExportProperties: function(){
       //console.log('loadExportProperties::'+this.exportResource);
		var self = this;
		self.loadVersions(); 
		self.loadExportTypes();
		self.getDynamicHeaderTable(this.exportResource);
		setTimeout(function(){ 
			self.loadExportLanguages();
		}, 750);
      },

      /**
       * Load export languages.
       */
      loadExportLanguages: function(){
        //console.log('Load export languages');
		var self = this;
        if(self.exportResource === 'LOINC'){
          self.exportLanguages = [{
            label: 'ITA',
            value: 'it',
          }, {
            label: 'ENG',
            value: 'en',
          }, {
            label: 'mapto',
            value: 'mapto',
          }];
          self.exportLanguage = self.exportLanguages[0].value;
        } else if(self.exportResource === 'ICD9-CM'){
          self.exportLanguages = [{
            label: 'ITA',
            value: 'it',
          }, {
            label: 'ENG',
            value: 'en',
          }];
          self.exportLanguage = self.exportLanguages[0].value;
        } else if(self.exportResource === 'ATC' || self.exportResource === 'AIC'){
          self.exportLanguages = [];
          self.exportLanguage = null;
        }else if(self.exportResourceType == 'LOCAL' || self.exportResourceType == 'STANDARD_NATIONAL' || self.exportResourceType == 'VALUE_SET'){
			var url = APP_PROPERTIES.getLanguages;
			url = url.replace("NAME",self.exportResource);
			url = url.replace("VERSION_NAME",self.loincSearchForm.version);
			//console.log("URL::"+url);
			
			self.$http.get(url).then(function(response){
			  //console.log("response::"+JSON.stringify(response.body.ArrayList));
			  self.exportLanguage = null;
			  self.exportLanguages = [];		
			  
				var langauges = response.body.ArrayList;
				if(langauges!==undefined && langauges!=null && langauges!=""){
					_.each(langauges, function(lang){
						//console.log("lingua::"+lang);
						self.exportLanguages.push({
								label: (lang=='it'?'ITA':'ENG'),
								value: lang,
							});
					});
				}
				self.exportLanguages = _.orderBy(self.exportLanguages, ['label'],['desc']);
			    self.exportLanguage = self.exportLanguages[0].value;
			}).finally(function(){
			  self.hideLoading();
			});	
			 
		}
      },

      /**
       * Load export types.
       */
      loadExportTypes: function(){
        //console.log('Load export types');
        if(this.exportResource === 'AIC'){
          this.exportTypes = [{
            label: 'Classe A',
            value: 'classe_a',
          }, {
            label: 'Classe C',
            value: 'classe_c',
          }, {
            label: 'Classe H',
            value: 'classe_h',
          }, {
            label: 'Farmaci Equivalenti',
            value: 'farmaci_equivalenti',
          }];
          this.exportType = this.exportTypes[0].value;
        } else {
          this.exportTypes = [];
          this.exportType = null;
        }
      },

      /**
       * Export the selected resources.
       */
      exportResources: function(){
        //console.log('Export!');
        var codeSystem = this.exportResource + ':' + this.loincSearchForm.version;
        var parameters = {
          codesystem: codeSystem,
        };

        
		
		if(this.exportResource != 'ATC' && this.exportResource != 'AIC' ){
			//Set the language
			if(this.exportLanguage){
			  parameters.language = this.exportLanguage;
			}
			else{
				noty({text: 'selezionare la lingua', type: 'error', timeout:5000});
				return;
			}
        }
		

        //Set the type
        if(this.exportType && this.exportResource === 'AIC' && this.exportFormat !== 'json'){
          parameters.aictype = this.exportType;
        }

        //Set the format
        if(this.exportFormat === 'json'){
          parameters.format = this.exportFormat;
        }
		
		
		parameters.resourceType = this.exportResourceType;
		
		if(this.exportResourceType=='STANDARD_NATIONAL_STATIC'){
			//console.log("ESPORTA STANDARD_NATIONAL_STATIC::"+JSON.stringify(parameters));
			this.openNewWindow(APP_PROPERTIES.export, parameters); 
		}
		else{
			var URL_EXPORT = this.makeExportSearchUrl(this.exportLanguage,this.exportFormat,this.exportResource);
			URL_EXPORT = URL_EXPORT.replace("&codesystem=&codesystemversion=","&codesystem="+this.exportResource+"&codesystemversion="+this.loincSearchForm.version)
			//console.log("ESPORTA NUOVI ::"+URL_EXPORT);
			window.location.href=URL_EXPORT;
		}
		
      },

      /**
       * Export the selected mapping.
       */
      exportMappingCodificaLocalLoinc: function(){
        //console.log('Export mapping!', this.exportLocalCode);
        var codeSystem = this.exportLocalCode.codeSystem + ':' + this.exportLocalCode.version;
        var parameters = {
          codesystem: codeSystem,
        };

        //Set the language
        if(this.exportLanguage){
          parameters.language = this.exportLanguage;
        }

        //Set the format
        if(this.exportFormat === 'json'){
          parameters.format = this.exportFormat;
        }

        //Set the localMapping
        if(this.exportLocalCode.value){
          parameters.localmapping = this.exportLocalCode.value;
        }
		
		parameters.resourceType = this.exportResourceType;

		//console.log("ESPORTA::"+JSON.stringify(parameters));
        this.openNewWindow(APP_PROPERTIES.export, parameters);
      },

      /**
       * Export the selected generic mapping.
       */
      exportGenericMapping: function(){
		//console.log('Export generic mapping!');
        var URL_EXPORT = this.makeExportSearchUrl(this.exportLanguage,this.exportFormat,this.exportMapName);
		//console.log("ESPORTA NUOVI MAPPING::"+URL_EXPORT);
		window.location.href=URL_EXPORT;
      },
	  
	   /**
       * Execute the export.
       * @param lang The language.
       */
      executeSearchExport: function(lang) {
    	var fileType = this.exportFormat;
        var URL_EXPORT = this.makeExportSearchUrl(lang,fileType,this.loincSearchForm.selectedSearchStandardCodeSystem);
        
        //console.log("URL_EXPORT::"+URL_EXPORT);
        window.location.href=URL_EXPORT;
      },
	  
	  
	   makeExportSearchUrl: function(lang,fileType,selectedCodeSystem) {
		  var self = this;
    	  var fields = [];
		  var mappingName = "";
		  var filterMapping = "";
		  var exportType = 'cs';
		  var mappingType = '';
		  
    	  /*nomi dei campi dell'indice SOLR da esportare nei file csv/json*/
		  /* OLD Codesystem */
    	  if(selectedCodeSystem == 'LOINC'){
    		  fields = ["LOINC_NUM","COMPONENT_"+lang,"PROPERTY_"+lang,"TIME_ASPECT_"+lang,"SYSTEM_"+lang,"SCALE_TYP_"+lang,"METHOD_TYP_"+lang,"CLASS_"+lang,"VERSION","STATUS"];
    	  } else if(selectedCodeSystem == 'ICD9-CM'){
    		  fields = ["ICD9CM_ID","DESCRIPTION_"+lang,"OTHER_DESCRIPTION_"+lang,"VERSION","NOTE_"+lang];
    	  } else if(selectedCodeSystem == 'ATC'){
    		  fields = ["CODICE_ATC","DENOMINAZIONE","GRUPPO_ANATOMICO","VERSION"];
          } else if(selectedCodeSystem == 'AIC'){
        	  fields = ["CODICE_AIC","DENOMINAZIONE","CONFEZIONE","TIPO_FARMACO","PRINCIPIO_ATTIVO","CLASSE","DITTA","VERSION"];
          }else{
			  /* NEW Codesystem/Valueset/Mapping */
			   //var selectedVal = self.getSelectedVal();
			   var selectedVal = selectedCodeSystem;
			  if(_.indexOf(self.codeSystemsNotStandardLocal, selectedVal)==-1){
				  
				var listDynamicFields = [];
				_.each(self.dynamicHeaderTable, function(head){
					if(_.endsWith(head,"_"+lang)){
						listDynamicFields.push(head);
					}
				});
				
				
				
				if(self.selectedMode == 'normal'){//TAB RICERCA
					if(self.loincSearchForm.typeSearch===undefined || self.loincSearchForm.typeSearch=='CODESYSTEM'){
						fields =  _.concat(["CS_CODE","CS_DESCRIPTION"+"_"+lang],listDynamicFields);
					}else if(self.loincSearchForm.typeSearch=='VALUESET'){
						fields =  _.concat(["VALUESET_CODE","VALUESET_DESCRIPTION"+"_"+lang],listDynamicFields);
						exportType = 'vs';
					}else if(self.loincSearchForm.typeSearch=='MAPPING'){
						mappingName = self.loincSearchForm.selectedSearchStandardMapping;
						filterMapping = self.loincSearchForm.matchValue;
						exportType = 'mapping';
					}
				}
				
				if(self.selectedMode == 'export'){//TAB EXPORT
					if(self.exportMode===undefined || self.exportMode=='code-system'){
						fields =  _.concat(["CS_CODE","CS_DESCRIPTION"+"_"+lang],listDynamicFields);
					}else if(self.exportMode=='value-set'){
						fields =  _.concat(["VALUESET_CODE","VALUESET_DESCRIPTION"+"_"+lang],listDynamicFields);
						exportType = 'vs';
					}else if(self.exportMode=='mapping'){
						mappingName = self.exportMapName;
						filterMapping = "";
						exportType = 'mapping';
					}
				}
				
				
			  }
          }
		  
		  
		  if(exportType=='mapping'){
		  /*qui si aggiunge un nuovo parametro: mappingType = [GENERIC,ATC-AIC,LOCAL-LOINC]*/
			var elemMappingLoinc  = _.find(self.listMappingLocalCodesLoinc, {value: mappingName});
			var elemMappingGeneric  = _.find(self.mappingList, {fullname: mappingName});
					
			
			mappingType = 'GENERIC';											
			if(mappingName==MAPPING_ATC_AIC_DEFAULT_VALUE.codeDescription){
				mappingType = MAPPING_TYPE.ATC_AIC;
				var searchText = self.makeSearchTextMapping(mappingName);	
				
				var filterMapping = APP_PROPERTIES.getQuerySolrExportMappingAtcAic;
				filterMapping = _.replace(filterMapping, '{VERSION}', MAPPING_ATC_AIC_DEFAULT_VALUE.version);
				filterMapping = _.replace(filterMapping, '{TEXT}', searchText);
				filterMapping = encodeURIComponent(filterMapping);
			}
			else if(elemMappingLoinc!==undefined){
				mappingType = MAPPING_TYPE.LOCAL_LOINC;
				var searchText = self.makeSearchTextMapping(mappingName);	
				
				var filterMapping = APP_PROPERTIES.getQuerySolrExportMappingLocalLoinc;
				filterMapping = _.replace(filterMapping, '{VERSION}',  elemMappingLoinc.version);
				filterMapping = _.replace(filterMapping, '{LOCAL_CODE}', elemMappingLoinc.value);
				filterMapping = _.replace(filterMapping, '{TEXT}', searchText);
				filterMapping = encodeURIComponent(filterMapping);	
			}
			else if(elemMappingLoinc!==undefined){
				mappingType = MAPPING_TYPE.GENERIC;
			}
		  }
		

    	  var url = self.makeSearchUrl();
     	 
    	  url=url.replace(APP_PROPERTIES.pathSearchEntities,APP_PROPERTIES.exportSearch);
		  url=url+"&exportType="+exportType;
		   
		  /*filtri per esportazione codesystem/valueset*/
    	  url=url+"&language="+lang;
    	  url=url+"&fileType="+fileType;
    	  url=url+"&fields="+fields;
		   
		  /*filtri per esportazione mapping*/
		  url=url+"&mappingName="+mappingName;
		  url=url+"&filterMapping="+filterMapping;
		  url=url+"&mappingType="+mappingType;
		  
    	  return url;
      },
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  

      /**
       * Open the new window for the given url and parameters.
       * @param url The url to call.
       * @param parameters The object containing the parameters to send.
       */
      openNewWindow: function(url, parameters){
        var convertedParameters = jQuery.param(parameters);
        url = url + '?' + convertedParameters;
        window.open(url);
      },

	  
	   exportDisabled: function(){
        return !this.exportResource;
      },
	  
      /**
       * Returns true if the export mapping is disabled, false otherwise.
       */
      exportMappingCodificaLocalLoincDisabled: function(){
        return !this.exportLocalCode.codeSystem;
      },

      /**
       * Returns true if the export of the generic mapping is disabled, false otherwise.
       */
      exportGenericMappingDisabled: function(){
        return !this.exportMapName;
      },
	  
	   /**
       * Execute export by button.
       * @param lang The language.
       * @param page The page.
       */
      executeSearchExportByButton: function(lang) {
    	  this.executeSearchExport(lang);
      },

      
     

      /**
       * Reload all the fields.
       */
      reloadFields: function(selectedCodesystem){
		//console.log("reloadFields :: selectedCodesystem ::"+selectedCodesystem);	
        var self = this;
        var promises = [];
		
		if(selectedCodesystem===undefined || selectedCodesystem===null || selectedCodesystem==""){
			selectedCodesystem = self.getSelectedVal();
			if(selectedCodesystem=='TUTTI'){
				selectedCodesystem=self.loincSearchForm.selectedNavigationStandard;
			}
		}
			
        promises.push(self.getVersionsByCodeSystem(selectedCodesystem));
        promises.push(self.getStatusesByCodeSystem(selectedCodesystem));
        promises.push(self.getClassesByCodeSystem(selectedCodesystem));
        promises.push(self.getSystemsByCodeSystem(selectedCodesystem));
        promises.push(self.getPropertiesByCodeSystem(selectedCodesystem));
        promises.push(self.getMethodsByCodeSystem(selectedCodesystem));
        promises.push(self.getScalesByCodeSystem(selectedCodesystem));
        promises.push(self.getTimesByCodeSystem(selectedCodesystem));
        promises.push(self.getChaptersByCodeSystem(selectedCodesystem));
        promises.push(self.getAnatomicalGroups(selectedCodesystem));
        promises.push(self.getActivePrinciples(selectedCodesystem));
        promises.push(self.getCompanies(selectedCodesystem));

        Promise.all(promises).then(function(values){
          self.handleVersions(values[0], self.selectedMode, self.crossMappingSearch);
          self.handleStatuses(values[1]);
          self.handleClasses(values[2]);
          self.handleSystems(values[3]);
          self.handleProperties(values[4]);
          self.handleMethods(values[5]);
          self.handleScales(values[6]);
          self.handleTimes(values[7]);
          self.handleChapters(values[8]);
          self.handleAnatomicalGroups(values[9]);
          self.handleActivePrinciples(values[10]);
          self.handleCompanies(values[11]);
          if(self.selectedMode === 'navigation'){
            self.executeSearchByButton(self.lang, 0);
          } else {
            self.hideLoading();
          }
        });
      },

      /**
       * Read all local codes.
       */
	   readAllLocalCodes: function(){
        //console.log('readAllLocalCodes');
        var self = this;
        self.showLoading();
        self.listMappingLocalCodesLoinc = [];
        self.getVersionsByCodeSystem('LOINC').then(function(versions){
          //console.log('Quindi qui abbiamo le versioni', versions);
          var promises = [];
          _.each(versions, function(version){
			  if(version.value!="-1"){
				   promises.push(self.readLocalCodes(version.value));
			  }
          });

          Promise.all(promises).then(function(values){
            //console.log('Response from the world', JSON.stringify(values));          
		   _.each(values, function(localCodes){
				//console.log('localCodes', JSON.stringify(localCodes));
				self.listMappingLocalCodesLoinc = _.union(self.listMappingLocalCodesLoinc, localCodes);
            });
           // console.log('self.listMappingLocalCodesLoinc', self.listMappingLocalCodesLoinc);
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
            //localCodeSystem.label = 'LOINC:' + version + ' - ' + localCodeSystem.label;
			 localCodeSystem.label = localCodeSystem.label + ' - LOINC:' + version;
            localCodeSystem.codeSystem = 'LOINC';
          });
          return localCodeSystems;
        }, function(response){
          return [];
        }).finally(function(){

        });
      },

      /**
       * Handle navigation sub section.
       */
      handleNavigationSubsection: function(){
        if(this.navigationMode === 'mapping'){
          this.goToMappingNavigationMode();
          this.loadVersions();
        }
      },

      /**
       * On change the local code system.
       */
      changeLocalCodeSystem: function() {
        //console.log('changeLocalCodeSystem');
        var self = this;
        self.searchExecuted = false;
        self.showLoading();
        self.resetLocalCodes();
        var promises = [];
        var selectedNavigationStandard = self.loincSearchForm.selectedMappingStandard;
        if(selectedNavigationStandard === 'ATC'){
          selectedNavigationStandard = 'AIC';
        }

        if(selectedNavigationStandard !== 'LOINC' || (self.loincSearchForm.selectedLocalCodeSystem && selectedNavigationStandard === 'LOINC')){
          promises.push(self.getLocalCodes(self.loincSearchForm.version, selectedNavigationStandard, self.loincSearchForm.selectedLocalCodeSystem, 0));
          Promise.all(promises).then(function(values){
            if(selectedNavigationStandard === 'LOINC'){
              self.handleLocalCodes(values[0]);
            } else if(selectedNavigationStandard === 'AIC'){
              self.handleAicMapping(values[0]);
            }
            self.searchExecuted = true;
            self.hideLoading();
          });
        } else {
          self.hideLoading();
        }
      },

      /**
       * Load mapping codes for the selected mapping standard.
       * @param fullname The map name.
       */
      loadMappingCodes: function(fullname){
        //console.log('loadMappingCodes::'+fullname);
        var self = this;
        self.showLoading();
        self.searchExecuted = false;
        self.resetLocalCodes();
		
		var url = APP_PROPERTIES.pathGetRelations + '&changesetcontext=' + fullname + APP_PROPERTIES.jsonFormatHttpParam;
		//this.executeSearchMappingCodes(url);
		//console.log(url);
		this.$http.get(url).then(function(response){
			  _.each(response.body.AssociationList.entry, function(entry){
				self.parserMapping(entry);
			  });
			}).finally(function(){
			  self.hideLoading();
			});	

      },

	  
	  
	   /**
       * Search mapping codes for the selected mapping standard.
       * @param fullname The map name.
       */
      searchMappingCodes: function(fullname,page){
        var self = this;
		
		var mappingSelected = fullname;
		if(mappingSelected!==undefined){
			self.showLoading();
			self.searchExecuted = false;
			self.resetLocalCodes();
			self.paging.page = page
			
			//console.log('self.loincSearchForm.matchValue::'+self.loincSearchForm.matchValue);
			if(self.loincSearchForm.matchValue!="TUTTI"){
				//console.log("mappingSelected::"+mappingSelected);	
				
				var elemMappingLoinc  = _.find(self.listMappingLocalCodesLoinc, {value: mappingSelected});
				var elemMappingGeneric  = _.find(self.mappingList, {fullname: mappingSelected});
				var searchText = self.makeSearchTextMapping(mappingSelected);

				if(mappingSelected==MAPPING_ATC_AIC_DEFAULT_VALUE.codeDescription){
					//console.log("mappingSelected::MAPPING ATC – AIC");	
					
					var codeSystem = MAPPING_ATC_AIC_DEFAULT_VALUE.codeSystemReference;
					var version = MAPPING_ATC_AIC_DEFAULT_VALUE.version;
					var codeSystemToReplace = _.toLower(codeSystem);

					var url;
					url = _.replace(APP_PROPERTIES.getAicMappingSearch, '{CODE_SYSTEM}', codeSystemToReplace);
					url = _.replace(url, '{VERSION}', version);
					url = _.replace(url, '{ROWS}', self.paging.pageSize);
					url = _.replace(url, '{START}', page * self.paging.pageSize);
					url = _.replace(url, '{TEXT}', searchText);
					
					console.log("url::"+url);	
					self.$http.jsonp(url, {
						jsonp: 'json.wrf'
					  }).then(function(response){
						var count = response.body.response.numFound;
						var totalPages =  Math.ceil(count / self.paging.pageSize);
						var pageSize = self.paging.pageSize;
						var currentPage =  self.pageComponents.page.currentPage;
						var pageNumbers = [];
						for (var i = 0; i<totalPages; i++){
						  pageNumbers[i] =  i+1 ;
						}
						var pageObj = {
						  currentPage : page,
						  totalElements : count,
						  totalPages: totalPages,
						  pages: pageNumbers
						};

						Vue.set(self.pageComponents, 'page', pageObj);
						
						 _.each(response.body.response.docs, function(entry){
							self.parserMappingAtcAic(entry);
						  });
						self.searchExecuted = true;	
						
					  }).finally(function(){
						self.hideLoading();
					});						
				}
				else if(elemMappingLoinc!==undefined){
					//console.log("mappingSelected::MAPPING LOCALE LOINC");
					var url;
					url = _.replace(APP_PROPERTIES.getLocalCodeListSearch, '{CODE_SYSTEM}', elemMappingLoinc.codeSystem);
					url = _.replace(url, '{VERSION}', elemMappingLoinc.version);
					url = _.replace(url, '{PAGE}', page);
					url = _.replace(url, '{ROWS}', self.paging.pageSize);
					url = _.replace(url, '{TEXT}', searchText);
					url = _.replace(url, '{LOCAL_CODE}', elemMappingLoinc.value);
					
					
					//console.log("url::"+url);
					self.$http.head(url).then(function(resp) {
					   if(resp.headers.map.count!==undefined){
							  var count = resp.headers.map.count[0];
							  var totalPages =  Math.ceil(count / self.paging.pageSize);
							  var pageSize = self.paging.pageSize;
							  var currentPage = self.pageComponents.page.currentPage;
							  var pageNumbers = [];
							  for (var i = 0; i<totalPages; i++){
								pageNumbers[i] =  i+1 ;
							  }
							  var pageObj = {
								currentPage : page,
								totalElements : count,
								totalPages: totalPages,
								pages: pageNumbers
							  }
							  Vue.set(self.pageComponents, 'page', pageObj);
						  }
					}, function(error){
					  noty({text: 'Impossibile recuperare il numero totale di elementi', type: 'error', timeout:5000});
					}).finally(function() {
						//
					}); 

					self.$http.get(url).then(function(response) {
						var results =  response.body.EntityDirectory.entry;
						self.handleLocalCodes(results);							
						self.searchExecuted = true;							
					}, function(response){
						noty({text: 'Impossibile recuperare gli elementi', type: 'error', timeout:5000});
					}).finally(function(){
						self.hideLoading();
					});	
				}
				else if(elemMappingGeneric!==undefined){
						//console.log("mappingSelected::GENERIC MAPPING");
					var url = APP_PROPERTIES.pathSearchRelations
						.replace("MAPPING",mappingSelected)
						.replace("TEXT",searchText)
						+ APP_PROPERTIES.jsonFormatHttpParam + "&page="+self.paging.page+"&maxtoreturn="+self.paging.pageSize;
													
					//console.log("url::"+url);	
					self.$http.get(url).then(function(response){
						var count = response.body.OutputDto.numFound;
						var totalPages =  Math.ceil(count / self.paging.pageSize);
						var pageSize = self.paging.pageSize;
						var currentPage =  self.pageComponents.page.currentPage;
						var pageNumbers = [];
						for (var i = 0; i<totalPages; i++){
						  pageNumbers[i] =  i+1 ;
						}
						var pageObj = {
						  currentPage : page,
						  totalElements : count,
						  totalPages: totalPages,
						  pages: pageNumbers
						};
						
						Vue.set(self.pageComponents, 'page', pageObj);
					
						_.each(response.body.OutputDto.entry, function(entry){
							self.parserMapping(entry);
						});
						self.searchExecuted = true;	
					}).finally(function(){
					  self.hideLoading();
					});	
				}
				else{
					self.hideLoading();
				}
				
			}
		}
		else{
			//self.loadMappingCodes(self.loincSearchForm.selectedSearchStandardMapping);
		}
		 
      },
	  
	  
	  makeSearchTextMapping: function(mappingSelected){
		var self = this;
		var searchText = "";
		var elemMappingLoinc  = _.find(self.listMappingLocalCodesLoinc, {value: mappingSelected});
		var elemMappingGeneric  = _.find(self.mappingList, {fullname: mappingSelected});
		
		if(mappingSelected==MAPPING_ATC_AIC_DEFAULT_VALUE.codeDescription || elemMappingLoinc!==undefined){
			//console.log("preparazione testo per ricerca solr");
			
			var sourceOrTargetEntity = self.loincSearchForm.matchValue;
			
			if(sourceOrTargetEntity.trim()==""){
				sourceOrTargetEntity = "*";
			}
								
			var words = _.split(sourceOrTargetEntity, " ");
			var separator = "";	
			
			words.forEach(function(word) {
				searchText = searchText+separator;
				searchText = searchText+""+self.makeTextSearchLike(word);
				separator = " AND ";
			});
			
			
		}else if(elemMappingGeneric!==undefined){
			//console.log("preparazione testo per ricerca db");
			var searchText = self.loincSearchForm.matchValue;
				
			if(mappingSelected.indexOf(" ")){
				var codeSystemSrcName ="";
				var codeSystemTrgName ="";
			
				var tmp = _.split(mappingSelected," ");
				if(tmp[0] != undefined){
					codeSystemSrcName = tmp[0].trim();
				}
				
				if(tmp[3] != undefined){
					codeSystemTrgName = tmp[3].trim();
				}
				
				if(searchText.toLocaleLowerCase()==codeSystemSrcName.toLocaleLowerCase() 
					|| searchText.toLocaleLowerCase()==codeSystemTrgName.toLocaleLowerCase()){
					searchText = "";
				}
			}
		}
		
		return searchText;
	  },
	  
	  
	  
	   parserMapping: function(entry){
		   var self = this;
			
		   entry.detailObj = {
			  href: entry.subject.href,
			  resourceName: entry.subject.name,
			  defLang: self.lang
			};

			entry.namespace = entry.subject.namespace;
			entry.sourceTitle = {};
			entry.targetTitle = {};

			_.each(entry.associationQualifier, function(associationQualifier){
			  if(associationQualifier.predicate.name === 'sourceTitle_en'){
				entry.sourceTitle.en = associationQualifier.value[0].literal.value;
			  }

			  if(associationQualifier.predicate.name === 'sourceTitle_it'){
				entry.sourceTitle.it = associationQualifier.value[0].literal.value;
			  }

			  if(associationQualifier.predicate.name === 'targetTitle_en'){
				entry.targetTitle.en = associationQualifier.value[0].literal.value;
			  }

			  if(associationQualifier.predicate.name === 'targetTitle_it'){
				entry.targetTitle.it = associationQualifier.value[0].literal.value;
			  }

			  if(associationQualifier.predicate.name === 'releaseDate'){
				entry.releaseDate = associationQualifier.value[0].literal.value;
			  }
			});

			self.localCodes.push(entry);
			self.searchExecuted = true;
	   },
			
			
	  
  
	  /**
       * Search mapping codes for the selected mapping standard.
       * @param URL search.
       */
      executeSearchMappingCodes: function(URL){
        //console.log('executeSearchMappingCodes');
        var self = this;
        	self.$http.get(URL).then(function(response){
			  _.each(response.body.AssociationList.entry, function(entry){
				entry.detailObj = {
				  href: entry.subject.href,
				  resourceName: entry.subject.name,
				  defLang: self.lang
				};

				entry.namespace = entry.subject.namespace;
				entry.sourceTitle = {};
				entry.targetTitle = {};

				_.each(entry.associationQualifier, function(associationQualifier){
				  if(associationQualifier.predicate.name === 'sourceTitle_en'){
					entry.sourceTitle.en = associationQualifier.value[0].literal.value;
				  }

				  if(associationQualifier.predicate.name === 'sourceTitle_it'){
					entry.sourceTitle.it = associationQualifier.value[0].literal.value;
				  }

				  if(associationQualifier.predicate.name === 'targetTitle_en'){
					entry.targetTitle.en = associationQualifier.value[0].literal.value;
				  }

				  if(associationQualifier.predicate.name === 'targetTitle_it'){
					entry.targetTitle.it = associationQualifier.value[0].literal.value;
				  }

				  if(associationQualifier.predicate.name === 'releaseDate'){
					entry.releaseDate = associationQualifier.value[0].literal.value;
				  }
				});

				self.localCodes.push(entry);
				self.searchExecuted = true;
			  });
			}).finally(function(){
			  self.hideLoading();
			});
      },
	  
	  

      /**
       * Load the versions and local code systems of the current selected code system.
       */
      loadVersions: function(){
		//console.log("loadVersions");  
        var self = this;
        self.searchExecuted = false;
        self.showLoading();
        var selectedNavigationStandard = self.loincSearchForm.selectedMappingStandard;
        if(self.selectedMode === 'export'){
          selectedNavigationStandard = self.exportResource;
        } else {
          if(selectedNavigationStandard === 'ATC'){
            selectedNavigationStandard = 'AIC';
          }
        }

        if(_.startsWith(selectedNavigationStandard, 'mapping-')){
          self.loadMappingCodes(selectedNavigationStandard.substring(8));
          return;
        }
		
		
        var promises = [];
        Promise.resolve(self.getVersionsByCodeSystem(selectedNavigationStandard)).then(function(versions){
          self.handleVersions(versions, self.selectedMode, self.crossMappingSearch);
          if(selectedNavigationStandard === 'LOINC'){
            self.getLocalCodeSystems(selectedNavigationStandard, self.loincSearchForm.version).then(function(localCodeSystems){
              self.handleLocalCodeSystems(localCodeSystems);
              self.hideLoading();
              //Trigger change of local code system
              self.changeLocalCodeSystem();
            });
          } else if(selectedNavigationStandard === 'AIC' || selectedNavigationStandard === 'ATC'){
            self.hideLoading();
            self.changeLocalCodeSystem();
          } else{
            self.hideLoading();
          }
        });
      },
	  
	  
	   initilizeLoincMappingNavigation: function(){
		//console.log("initilizeLoincMappingNavigation");
		 var self = this;
        self.loincSearchForm.selectedMappingStandard = 'LOINC';
		self.resultPresent=false;
		self.loincSearchForm.version=null;
		
		Promise.resolve(self.getVersionsByCodeSystem(self.loincSearchForm.selectedMappingStandard)).then(function(versions){
          self.handleVersions(versions, self.selectedMode, self.crossMappingSearch);
         
           _.each(self.versions,function(e){
				
				
				self.getLocalCodeSystems(self.loincSearchForm.selectedMappingStandard, e.value).then(function(localCodeSystems){	
					//console.log("localCodeSystems::"+JSON.stringify(localCodeSystems));
					self.handleLocalCodeSystems(localCodeSystems);
					
					if(localCodeSystems.length>0 && !self.resultPresent){
						
							/*
							console.log("self.loincSearchForm.selectedMappingStandard::"+self.loincSearchForm.selectedMappingStandard);
							console.log("localCodeSystems::"+JSON.stringify(localCodeSystems));
							console.log("self.loincSearchForm.version::"+self.loincSearchForm.version);
							self.changeLocalCodeSystem();
							*/
							
							self.resultPresent = true;
							self.loincSearchForm.version=e.value
							self.changeLoincMappingVersion();

						
						
					}

				});
			});
          
       }).finally(function(){
           self.hideLoading();
        });
      },

      /**
       * Change LOINC mapping version.
       */
      changeLoincMappingVersion: function(){
		//console.log("changeLoincMappingVersion");
        var self = this;
		self.getLocalCodeSystems(self.loincSearchForm.selectedMappingStandard, self.loincSearchForm.version).then(function(localCodeSystems){	
		//console.log("localCodeSystems::"+JSON.stringify(localCodeSystems));
          self.handleLocalCodeSystems(localCodeSystems);
          self.hideLoading();
          //Trigger change of local code system
          self.changeLocalCodeSystem();
        });
      },
	  
	  
	  

      /**
       * Handle the loaded local codes.
       * @param localCodes The local codes.
       */
      handleLocalCodes: function(localCodes){
        var self = this;
		
        var selectedLocalCodeSystem = self.loincSearchForm.selectedLocalCodeSystem;
		
		//console.log("selectedMode::"+self.selectedMode+" typeSearch::"+self.loincSearchForm.typeSearch);
		if(self.selectedMode == 'normal' && self.loincSearchForm.typeSearch=='MAPPING'){
			if(self.loincSearchForm.selectedSearchStandardMapping != 'TUTTI'){
				selectedLocalCodeSystem = self.loincSearchForm.selectedSearchStandardMapping;
			}
			else{
				selectedLocalCodeSystem = self.loincSearchForm.selectedMultiStandardMapping;
			}
		}
		
		self.localCodes = [];
        _.each(localCodes, function(localCode, index){
          var designation = jQuery.parseJSON(localCode.knownEntityDescription[0].designation);
          localCode.localCode = self.findLocalCodeValue(designation, 'LOCAL_CODE', selectedLocalCodeSystem);
          localCode.localDescription = self.findLocalCodeValue(designation, 'LOCAL_DESCRIPTION', selectedLocalCodeSystem);
          localCode.batteryCode = self.findLocalCodeValue(designation, 'BATTERY_CODE', selectedLocalCodeSystem);
          localCode.batteryDescription = self.findLocalCodeValue(designation, 'BATTERY_DESCRIPTION', selectedLocalCodeSystem);
          localCode.units = self.findLocalCodeValue(designation, 'LOCAL_UNITS', selectedLocalCodeSystem);
          localCode.detailObj = {
            href: localCode.href,
            resourceName: localCode.resourceName,
            defLang: self.lang
          };

          //Add to the list
          self.localCodes.push(localCode);
        });
      },

      /**
       * Handle AIC mapping.
       * @param mapping The list of mapping to handle.
       */
      handleAicMapping: function(mapping){
		//console.log("handleAicMapping::"+JSON.stringify(mapping));
        var self = this;
        self.localCodes = mapping;
		
        //Generate the detail object
        _.each(self.localCodes, function(localCode){
          var url = _.replace(APP_PROPERTIES.getAicDetails, /{CODE_SYSTEM}/g, 'ATC');
          url = _.replace(url, '{VERSION}', localCode.VERSIONE_ATC);
          url = _.replace(url, '{CODE}', localCode.CODICE_ATC);
		  //console.log("localCode.VERSIONE_ATC::"+localCode.VERSIONE_ATC);
          localCode.detailObj = {
            href: url,
            resourceName: localCode.CODICE_ATC,
            defLang: self.lang
          };
        });
      },
	  
	  
	  
	   parserMappingAtcAic: function(entry,){
		var self = this;
		var localCode = entry;
		var url = _.replace(APP_PROPERTIES.getAicDetails, /{CODE_SYSTEM}/g, 'ATC');
          url = _.replace(url, '{VERSION}', localCode.VERSIONE_ATC);
          url = _.replace(url, '{CODE}', localCode.CODICE_ATC);
		  //console.log("localCode.VERSIONE_ATC::"+localCode.VERSIONE_ATC);
         
		entry.detailObj = {
		  href: url,
          resourceName: localCode.CODICE_ATC,
          defLang: self.lang
		};
		entry.namespace = 'ATC';
		
		//console.log(JSON.stringify(entry));
		   
		self.localCodes.push(entry);
		self.searchExecuted = true;
	   },
	  

      /**
       * Handle local code systems.
       * @param localCodeSystems The local code systems.
       */
      handleLocalCodeSystems: function(localCodeSystems){
        localCodeSystems.splice(0, 1);
        this.localCodeSystems = localCodeSystems;
        this.loincSearchForm.selectedLocalCodeSystem = ''; //Reset the selected local code system

        //Auto select the first element if any
        if(this.localCodeSystems.length > 0){
          this.loincSearchForm.selectedLocalCodeSystem = this.localCodeSystems[0].value;
        }
      },

      /**
       * Find the local code value by the given parameters. Useful for data parsing.
       * @param designation The designation.
       * @param field The field to retrieve.
       * @param localCodeSystem The local code system.
       * @returns Returns the local code value by the given parameters.
       */
      findLocalCodeValue: function(designation, field, localCodeSystem){
        var valueToReturn;
        _.each(designation[field], function(value, index){
          if(_.includes(value, localCodeSystem + '_#_V#_')){
            valueToReturn = _.replace(value, localCodeSystem + '_#_V#_: ', '');
          }
        });
		
        return valueToReturn;
      },

      /**
       * Handle the loaded versions.
       * @param versions The list of versions to handle.
       * @param selectedMode The selected mode.
       * @param crossMappingSearch The cross mapping search object (self.crossMappingSearch).
       */
	   
      handleVersions: function(versions, selectedMode, crossMappingSearch){
		
        var self = this;
        if(selectedMode == 'cross-mapping'){
          if(crossMappingSearch == 'left'){
            self.leftVersions = versions;
            if(versions.length > 0){
              self.loincSearchForm.leftVersion = versions[0].value;
            }
          } else if(crossMappingSearch == 'right'){
            self.rightVersions = versions;
            if(versions.length > 0){
              self.loincSearchForm.rightVersion = versions[0].value;
            }
          }
        } else {
          //self.versions = versions;
		  self.versions = _.orderBy(versions, ['value'],['asc']);
		  
          if(self.versions.length > 0){
            if(selectedMode === 'normal'){
              self.loincSearchForm.normalVersion = self.versions[1].value;
            } else if(selectedMode === 'navigation' || selectedMode === 'export') {
               self.loincSearchForm.version = self.versions[0].value;
            }
          }
        }
      },
	  


      /**
       * Handle the loaded statuses.
       * @param statuses The list of statuses to handle.
       */
      handleStatuses: function(statuses){
        this.statuses = statuses;
        if(this.statuses.length > 0){
          this.loincSearchForm.status = this.statuses[0].value;
        }
      },

      /**
       * Handle the loaded classes.
       * @param classes The list of classes to handle.
       */
      handleClasses: function(classes){
        this.classes = classes;
        if(this.classes.length > 0){
          this.loincSearchForm.class = this.classes[0].value;
        }
      },

      /**
       * Handle the loaded systems.
       * @param systems The list of systems to handle.
       */
      handleSystems: function(systems){
        this.systems = systems;
        if(this.systems.length > 0){
          this.loincSearchForm.system = this.systems[0].value;
        }
      },

      /**
       * Handle the loaded properties.
       * @param properties The list of properties to handle.
       */
      handleProperties: function(properties){
        this.properties = properties;
        if(this.properties.length > 0){
          this.loincSearchForm.property = this.properties[0].value;
        }
      },

      /**
       * Handle the loaded methods.
       * @param methods The list of methods to handle.
       */
      handleMethods: function(methods){
        this.methods = methods;
        if(this.methods.length > 0){
          this.loincSearchForm.method = this.methods[0].value;
        }
      },

      /**
       * Handle the loaded scales.
       * @param scales The list of scales to handle.
       */
      handleScales: function(scales){
        this.scales = scales;
        if(this.scales.length > 0){
          this.loincSearchForm.scale = this.scales[0].value;
        }
      },

      /**
       * Handle the loaded times.
       * @param times The list of times to handle.
       */
      handleTimes: function(times){
        this.times = times;
        if(this.times.length > 0){
          this.loincSearchForm.time = this.times[0].value;
        }
      },

      /**
       * Handle the loaded chapters.
       * @param chapters The list of chapters to handle.
       */
      handleChapters: function(chapters){
        this.chapters = chapters;
        if(this.chapters.length > 0){
          this.loincSearchForm.chapter = this.chapters[0].value;
        }
      },

      /**
       * Handle the loaded anatomical groups.
       * @param anatomicalGroups The list of anatomical groups to handle.
       */
      handleAnatomicalGroups: function(anatomicalGroups){
        this.anatomicalGroups = anatomicalGroups;
        if(this.anatomicalGroups.length > 0){
          this.loincSearchForm.anatomicalGroup = this.anatomicalGroups[0].value;
        }
      },

      /**
       * Handle the loaded active principles.
       * @param activePrinciples The list of active principles to handle.
       */
      handleActivePrinciples: function(activePrinciples){
        this.activePrinciples = activePrinciples;
        if(this.activePrinciples.length > 0){
          this.loincSearchForm.activePrinciple = this.activePrinciples[0].value;
        }
      },

      /**
       * Handle the loaded companies.
       * @param companies The list of companies to handle.
       */
      handleCompanies: function(companies){
        this.companies = companies;
        if(this.companies.length > 0){
          this.loincSearchForm.company = this.companies[0].value;
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
        return this.$http.jsonp(url, {
          jsonp: 'json.wrf'
        }).then(function(response){
          var distinctValues = response.body.stats.stats_fields[field].distinctValues;
          //Normalize the versions
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
       * Load the version based on the code system.
       * @param codeSystem The selected code system.
       * @returns Returns a Promise.
       */
	   
      getVersionsByCodeSystem: function(codeSystem){
        //console.log('Load versions :: codeSystem ::'+codeSystem);
        this.showLoading();
        if(this.selectedMode === 'navigation' && this.navigationMode === 'mapping' && codeSystem === 'AIC'){
          var codeSystemToReplace = _.replace(_.toLower(codeSystem), '-', '');
          var url = _.replace(APP_PROPERTIES.getAicVersions, '{CODE_SYSTEM}', codeSystemToReplace);
          return this.retrieveDistinct(url, 'VERSIONI_MAPPING', this.$t("message.labelAllFemale", this.lang)).then(function(versions){
            //Remove first element
            versions.splice(0, 1);
            return versions;
          });
        } else {
            var codeSystemToReplace = _.toLower(codeSystem);
			if(codeSystemToReplace!='tutti'){		
				var url = _.replace(APP_PROPERTIES.getVersions, '{CODE_SYSTEM}', codeSystemToReplace);

				return this.$http.get(url).then(function(response) {
				  var data = response.body;
				  var codeSystemVersions = jQuery.parseJSON(data.CodeSystemCatalogEntryMsg.codeSystemCatalogEntry.versions);
				  var versions = [];
				  if(this.selectedMode === 'normal'){
					versions.push({
					  label: this.$t("message.labelAllFemale", this.lang),
					  value: '-1',
					  namespace: ""
					});
				  }
				  _.each(codeSystemVersions, function(version){
					versions.push({
					  label: version,
					  value: version,
					  namespace: codeSystem
					});
				  });
				  return versions;
				}, function(error) {
				  return [];
				});
			}


        }
      },
	  
	  

      /**
       * Get local codes from the given parameters.
       * @param version The version.
       * @param codeSystem The code system.
       * @param localCode The local code.
       * @param page The current page.
       * @returns Returns the promise with the local codes.
       */
      getLocalCodes: function(version, codeSystem, localCode, page){
		//console.log("getLocalCodes::version::"+version+" codeSystem::"+codeSystem+" localCode::"+localCode);
        var self = this;
        var url;
        if(codeSystem === 'LOINC'){
          url = _.replace(APP_PROPERTIES.getLocalCodeList, '{CODE_SYSTEM}', codeSystem);
          url = _.replace(url, '{VERSION}', version);
          url = _.replace(url, '{LOCAL_CODE}', localCode);
		  //console.log("url::"+url);
          return self.$http.get(url).then(function(response) {
            return response.body.EntityDirectory.entry;
          }, function(response){
            //console.log('Error retrieving the response', response);
            return [];
          }).finally(function(){
            return [];
          });
        } else if(codeSystem === 'AIC'){
          var codeSystemToReplace = _.toLower(codeSystem);
          url = _.replace(APP_PROPERTIES.getAicMapping, '{CODE_SYSTEM}', codeSystemToReplace);
          url = _.replace(url, '{VERSION}', self.loincSearchForm.version);
          url = _.replace(url, '{ROWS}', this.paging.pageSize);
          url = _.replace(url, '{START}', page * this.paging.pageSize);
		  //console.log("url::"+url);
          return this.$http.jsonp(url, {
            jsonp: 'json.wrf'
          }).then(function(response){
            var count = response.body.response.numFound;
            var totalPages =  Math.ceil(count / this.paging.pageSize);
            var pageSize = this.paging.pageSize;
            var currentPage =  this.pageComponents.page.currentPage;
            var pageNumbers = [];
            for (var i = 0; i<totalPages; i++){
              pageNumbers[i] =  i+1 ;
            }
            var pageObj = {
              currentPage : page,
              totalElements : count,
              totalPages: totalPages,
              pages: pageNumbers
            };

            //console.log("pageObj, pageVar", pageObj, 'page');
            Vue.set(this.pageComponents, 'page', pageObj);
            return response.body.response.docs;
          }, function(response){
            console.error('Error retrieving the response', response);
            return [];
          });
        } else {
          return [];
        }
      },

      /**
       * Execute local codes search.
       * @param lang The language.
       * @param page The page to request.
       * @param pageVar The page var.
       * @param searchResultsVar The search results var.
       */
      executeLocalCodesSearch: function(lang, page, pageVar, searchResultsVar){
        this.showLoading();
        this.getLocalCodes('', 'AIC', '', page).then(function(localCodes){
          this.handleAicMapping(localCodes);
          this.hideLoading();
        });
      },

      /**
       * Load the status based on the code system.
       * @param codeSystem The selected code system.
       * @returns Returns the Promise.
       */
      getStatusesByCodeSystem: function(codeSystem){
        //console.log('loadStatuses for', codeSystem);
        this.showLoading();
        if(codeSystem === 'LOINC' && this.selectedMode !== 'navigation' && this.selectedMode !== 'export'){
          var codeSystemToReplace = _.replace(_.toLower(codeSystem), '-', '');
          var url = _.replace(APP_PROPERTIES.getStatuses, '{CODE_SYSTEM}', codeSystemToReplace);
          return this.retrieveDistinct(url, 'STATUS', this.$t("message.labelAllMale", this.lang));
        } else {
          return [];
        }
      },

      /**
       * Load the classes based on the code system.
       * @param codeSystem The selected code system.
       * @returns Returns the Promise.
       */
      getClassesByCodeSystem: function(codeSystem){
        //console.log('loadClasses for', codeSystem);
        this.showLoading();
        if(codeSystem === 'LOINC' && this.selectedMode !== 'navigation' && this.selectedMode !== 'export'){
          var codeSystemToReplace = _.replace(_.toLower(codeSystem), '-', '');
          var url = _.replace(APP_PROPERTIES.getClasses, '{CODE_SYSTEM}', codeSystemToReplace);
          url = _.replace(url, '{LANGUAGE}', this.lang);
          return this.retrieveDistinct(url, 'CLASS_' + this.lang, this.$t("message.labelAllFemale", this.lang));
        } else if(codeSystem === 'AIC' && this.selectedMode !== 'navigation' && this.selectedMode !== 'export'){
          var codeSystemToReplace = _.toLower(codeSystem);
          var url = _.replace(APP_PROPERTIES.getAicClasses, '{CODE_SYSTEM}', codeSystemToReplace);
          return this.retrieveDistinct(url, 'CLASSE', this.$t("message.labelAllFemale", this.lang));
        } else {
          return [];
        }
      },

      /**
       * Load the systems based on the code system.
       * @param codeSystem The selected code system.
       * @returns Returns the Promise.
       */
      getSystemsByCodeSystem: function(codeSystem){
        //console.log('loadSystems for', codeSystem);
        this.showLoading();
        if(codeSystem === 'LOINC' && this.selectedMode !== 'navigation' && this.selectedMode !== 'export'){
          var codeSystemToReplace = _.replace(_.toLower(codeSystem), '-', '');
          var url = _.replace(APP_PROPERTIES.getSystems, '{CODE_SYSTEM}', codeSystemToReplace);
          url = _.replace(url, '{LANGUAGE}', this.lang);
          return this.retrieveDistinct(url, 'SYSTEM_' + this.lang, this.$t("message.labelAllFemale", this.lang));
        } else {
          return [];
        }
      },

      /**
       * Load the properties based on the code system.
       * @param codeSystem The selected code system.
       * @returns Returns the Promise.
       */
      getPropertiesByCodeSystem: function(codeSystem){
        //console.log('loadProperties for', codeSystem);
        this.showLoading();
        if(codeSystem === 'LOINC' && this.selectedMode !== 'navigation' && this.selectedMode !== 'export'){
          var codeSystemToReplace = _.replace(_.toLower(codeSystem), '-', '');
          var url = _.replace(APP_PROPERTIES.getProperties, '{CODE_SYSTEM}', codeSystemToReplace);
          url = _.replace(url, '{LANGUAGE}', this.lang);
          return this.retrieveDistinct(url, 'PROPERTY_' + this.lang, this.$t("message.labelAllMale", this.lang));
        } else {
          return [];
        }
      },

      /**
       * Load the methods based on the code system.
       * @param codeSystem The selected code system.
       * @returns Returns the Promise.
       */
      getMethodsByCodeSystem: function(codeSystem){
        //console.log('loadMethods for', codeSystem);
        this.showLoading();
        if(codeSystem === 'LOINC' && this.selectedMode !== 'navigation' && this.selectedMode !== 'export'){
          var codeSystemToReplace = _.replace(_.toLower(codeSystem), '-', '');
          var url = _.replace(APP_PROPERTIES.getMethods, '{CODE_SYSTEM}', codeSystemToReplace);
          url = _.replace(url, '{LANGUAGE}', this.lang);
          return this.retrieveDistinct(url, 'METHOD_TYP_' + this.lang, this.$t("message.labelAllFemale", this.lang));
        } else {
          return [];
        }
      },

      /**
       * Load the scales based on the code system.
       * @param codeSystem The selected code system.
       * @returns Returns the Promise.
       */
      getScalesByCodeSystem: function(codeSystem){
        //console.log('loadScales for', codeSystem);
        this.showLoading();
        if(codeSystem === 'LOINC' && this.selectedMode !== 'navigation' && this.selectedMode !== 'export'){
          var codeSystemToReplace = _.replace(_.toLower(codeSystem), '-', '');
          var url = _.replace(APP_PROPERTIES.getScales, '{CODE_SYSTEM}', codeSystemToReplace);
          url = _.replace(url, '{LANGUAGE}', this.lang);
          return this.retrieveDistinct(url, 'SCALE_TYP_' + this.lang, this.$t("message.labelAllFemale", this.lang));
        } else {
          return [];
        }
      },

      /**
       * Load the times based on the code system.
       * @param codeSystem The selected code system.
       * @returns Returns the Promise.
       */
      getTimesByCodeSystem: function(codeSystem){
        //console.log('loadTimes for', codeSystem);
        this.showLoading();
        if(codeSystem === 'LOINC' && this.selectedMode !== 'navigation' && this.selectedMode !== 'export'){
          var codeSystemToReplace = _.replace(_.toLower(codeSystem), '-', '');
          var url = _.replace(APP_PROPERTIES.getTimes, '{CODE_SYSTEM}', codeSystemToReplace);
          url = _.replace(url, '{LANGUAGE}', this.lang);
          return this.retrieveDistinct(url, 'TIME_ASPECT_' + this.lang, this.$t("message.labelAllMale", this.lang));
        } else {
          return [];
        }
      },

      /**
       * Load the chapters based on the code system.
       * @param codeSystem The selected code system.
       * @returns Returns the Promise.
       */
      getChaptersByCodeSystem: function(codeSystem){
        //console.log('loadChapters for', codeSystem);
        this.showLoading();
        if(codeSystem === 'ICD9-CM'){
          var codeSystemToReplace = _.replace(_.toLower(codeSystem), '-', '');
          var url = _.replace(APP_PROPERTIES.getChapters, '{CODE_SYSTEM}', codeSystemToReplace);
          return [{
            label: this.$t("message.labelAllMale", this.lang),
            value: '-1',
          }, {
            label: 'Malattie infettive e parassitarie_1',
            value: 'Capitolo_1',
          },{
            label: 'Tumori_2',
            value: 'Capitolo_2',
          },{
            label: 'Malattie delle ghiandole endocrine, della nutrizione e del metabolismo, e disturbi immunitari_3',
            value: 'Capitolo_3',
          },{
            label: 'Malattie del sangue e organi emopoietici_4',
            value: 'Capitolo_4',
          },{
            label: 'Disturbi mentali_5',
            value: 'Capitolo_5',
          },{
            label: 'Malattie del sistema nervoso e degli organi di senso_6',
            value: 'Capitolo_6',
          },{
            label: 'Malattie del sistema circolatorio_7',
            value: 'Capitolo_7',
          },{
            label: 'Malattie dell’apparato respiratorio_8',
            value: 'Capitolo_8',
          },{
            label: 'Malattie dell’apparato digerente_9',
            value: 'Capitolo_9',
          },{
            label: 'Malattie dell’apparato genitourinario_10',
            value: 'Capitolo_10',
          },{
            label: 'Complicazioni della gravidanza, del parto e del puerperio_11',
            value: 'Capitolo_11',
          },{
            label: 'Malattie della pelle e del tessuto sottocutaneo_12',
            value: 'Capitolo_12',
          },{
            label: 'Malattie del sistema osteomuscolare e del tessuto connettivo_13',
            value: 'Capitolo_13',
          },{
            label: 'Malformazioni congenite_14',
            value: 'Capitolo_14',
          },{
            label: 'Alcune condizioni morbose di origine perinatale_15',
            value: 'Capitolo_15',
          },{
            label: 'Sintomi, segni, e stati morbosi maldefiniti_16',
            value: 'Capitolo_16',
          },{
            label: 'Traumatismi e avvelenamenti_17',
            value: 'Capitolo_17',
          }];
        } else {
			/*in caso di classificazione recipera i capitoli (primo livello della gerarchia)*/
			if(this.currentCsSelectedIsClassification){
				var array = this.loadFirstNodesClassification(codeSystem);
				return array;
			}
			else{
				return [];
			}
        }
      },


      /**
       * Load anatomical groups.
       * @param codeSystem The selected code system.
       * @returns Returns the Promise.
       */
      getAnatomicalGroups: function(codeSystem){
        if(codeSystem === 'ATC' && this.selectedMode !== 'navigation' && this.selectedMode !== 'export'){
          var codeSystemToReplace = _.replace(_.toLower(codeSystem), '-', '');
          var url = _.replace(APP_PROPERTIES.getAnatomicalGroups, '{CODE_SYSTEM}', codeSystemToReplace);
          return this.retrieveDistinct(url, 'GRUPPO_ANATOMICO', this.$t("message.labelAllMale", this.lang));
        } else {
          return [];
        }
      },

      /**
       * Load active principles.
       * @param codeSystem The selected code system.
       * @returns Returns the Promise.
       */
      getActivePrinciples: function(codeSystem){
        if(codeSystem === 'AIC' && this.selectedMode !== 'navigation' && this.selectedMode !== 'export'){
          var codeSystemToReplace = _.replace(_.toLower(codeSystem), '-', '');
          var url = _.replace(APP_PROPERTIES.getActivePrinciples, '{CODE_SYSTEM}', codeSystemToReplace);
          return this.retrieveDistinct(url, 'PRINCIPIO_ATTIVO', this.$t("message.labelAllMale", this.lang));
        } else {
          return [];
        }
      },

      /**
       * Load companies.
       * @param codeSystem The selected code system.
       * @returns Returns the Promise.
       */
      getCompanies: function(codeSystem){
        if(codeSystem === 'AIC' && this.selectedMode !== 'navigation' && this.selectedMode !== 'export'){
          var codeSystemToReplace = _.replace(_.toLower(codeSystem), '-', '');
          var url = _.replace(APP_PROPERTIES.getCompanies, '{CODE_SYSTEM}', codeSystemToReplace);
          return this.retrieveDistinct(url, 'DITTA', this.$t("message.labelAllFemale", this.lang));
        } else {
          return [];
        }
      },

      /**
       * Load local code systems.
       * @param codeSystem The code systems
       * @param version The current version.
       * @returns Returns the local code systems.
       */
      getLocalCodeSystems: function(codeSystem, version){
        //console.log('Load local code systems');
        var codeSystemToReplace = _.replace(_.toLower(codeSystem), '-', '');
        var url = _.replace(APP_PROPERTIES.getLocalCodes, '{CODE_SYSTEM}', codeSystemToReplace);
        url = _.replace(url, '{VERSION}', version);
        return this.retrieveDistinct(url, 'LOCAL_CODE_LIST').then(function(localCodeSystems){
          return localCodeSystems;
        }, function(response){
          return [];
        }).finally(function(){

        });
      },

      /**
       * Build the status code by the given status.
       * @param status The status from which build the status code.
       * @returns Returns the status code.
       */
      buildStatusCode: function(status){
        return "message.label" + _.upperFirst(_.lowerCase(status));
      },

      /**
       * Reset results.
       */
      resetResults: function() {
    	  //console.log('Reset results');
    	  Vue.set(this.pageComponents, 'loincSearchResults', []);
    	  this.searchExecuted = false;
      },

      /**
       * Reset local codes.
       */
      resetLocalCodes: function(){
        //console.log('Reset local codes');
    	Vue.set(this, 'localCodes', []);
      },

      /**
       * Reset temporary associations.
       * @param side The side of which reset things.
       */
      resetTempAssociations: function(side) {
        //console.log('Reset temp associations');
        if(side){
          side = _.replace(side, 'Page', '');
          _.remove(this.tempAssociations, function(association){
            return association.side === side;
          });
          Vue.set(this, "tempAssociations", this.tempAssociations);
        } else {
          this.tempAssociations = [];
        }
      },

      /**
       * Execute search by button.
       * @param lang The language.
       * @param page The page.
       */
      executeSearchByButton: function(lang, page) {
    	  this.executeSearch(lang, page, 'page', 'loincSearchResults');
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

      /**
       * Execute the search.
       * @param lang The language.
       * @param page The page number.
       * @param pageVar The name of the page variable.
       * @param searchResultsVar The search results variable.
       */
      executeSearch: function(lang, page, pageVar, searchResultsVar) {
        this.resetResults();
        this.resetTempAssociations(pageVar);
        this.paging.page = page;

        this.showLoading();

        this.pageComponents.detailObj = new SearchDetailObject();

        //console.log("Execute search", lang, page, pageVar);

        if(pageVar === 'leftPage'){
          this.leftSearchExecuted = false;
          this.crossMappingSearch = 'left';
        } else if(pageVar === 'rightPage'){
          this.rightSearchExecuted = false;
          this.crossMappingSearch = 'right';
        }

        var URL = this.makeSearchUrl();
		
		if(this.selectedMode == 'normal'){
			if(this.getSelectedVal()!=='TUTTI'){
				this.getDynamicHeaderTable(this.getSelectedVal());
			}
			else{
				this.getDynamicHeaderTable(this.getMultiStandardSelectedVal());
			}
		}
		
		
		
        /**
         * La chiamata per la paginazione
         * viene effettuata sulla stessa url
         * di ricerca, ma è di tipo HEAD.
         */
        this.$http.head(URL).then(function(resp) {
		  if(resp.headers.map.count!==undefined){
			  var count = resp.headers.map.count[0];
			  var totalPages =  Math.ceil(count / this.paging.pageSize);
			  var pageSize = this.paging.pageSize;
			  var currentPage =  this.pageComponents[pageVar].currentPage;
			  var pageNumbers = [];
			  for (var i = 0; i<totalPages; i++){
				pageNumbers[i] =  i+1 ;
			  }
			  var pageObj = {
				currentPage : page,
				totalElements : count,
				totalPages: totalPages,
				pages: pageNumbers
			  }
			  
			  /**
			   * https://vuejs.org/v2/guide/list.html#Caveats
			   */
			  //console.log("pageObj, pageVar", pageObj, pageVar);
			  Vue.set(this.pageComponents, pageVar, pageObj);
		  }
		
          
          
        }, function(error){
          noty({text: 'Impossibile recuperare il numero totale di elementi', type: 'error', timeout:5000});
        }).finally(function() {

        });

        var self = this;

        /**
         * Ricerca
         */
        this.$http.get(URL).then(function(response) {
          //console.log(response.body);
          var data = response.body;
          var elements = [];
          if(data.EntityDirectory && data.EntityDirectory.entry) {
        	
            data.EntityDirectory.entry.forEach(function(entry) {
              var searchResult = {
                href : _.clone(entry.href),
                resourceName: entry.resourceName,
                defLang :  lang,
                namespace: entry.name.namespace
              };
              if (entry.knownEntityDescription && entry.knownEntityDescription[0]) {
                searchResult.designation = jQuery.parseJSON(entry.knownEntityDescription[0].designation);
                searchResult.id = Math.random().toString(36).substring(7);
                searchResult.hasChildren = !searchResult.designation.IS_LEAF;
                searchResult.hasAssociations = searchResult.designation.HAS_ASSOCIATIONS;
                searchResult.codeSystemVersion = _.replace(entry.knownEntityDescription[0].describingCodeSystemVersion.version.content, '_ita', '');
                searchResult.loaded = false;

                //Convert the array in string
                self.convertString(searchResult, 'DESCRIPTION_en');
                self.convertString(searchResult, 'DESCRIPTION_it');
                self.convertString(searchResult, 'NAME_en');
                self.convertString(searchResult, 'NAME_it');

                //If the name is empty (english and italian), set it to the description
                if(!searchResult.designation['NAME_en']){
                  searchResult.designation['NAME_en'] = searchResult.designation['DESCRIPTION_en'];
                }
                if(!searchResult.designation['NAME_it']){
                  searchResult.designation['NAME_it'] = searchResult.designation['DESCRIPTION_it'];
                }
              }
              elements.push(searchResult);
            });
          }

          /**
           * https://vuejs.org/v2/guide/list.html#Caveats
           */
          Vue.set(this.pageComponents, searchResultsVar, elements);
		  
        }, function(error) {
            noty({text: 'Si è verificato un errore durante la ricerca. Si prega di riprovare', type: 'error', timeout:5000});
        }).finally(function() {
          self.searchExecuted = true;
          if(self.crossMappingSearch === 'left'){
            self.leftSearchExecuted = true;
          } else if(self.crossMappingSearch === 'right'){
            self.rightSearchExecuted = true;
          }
          self.hideLoading();
        });
      },
      
      
	  
      

      /**
       * Convert the array in string and set its value given entry and key.
       * @param entry The entry to convert.
       * @param key The key of the entry to convert.
       */
      convertString: function(entry, key){
        if(_.isArray(entry.designation[key])){
          entry.designation[key] = _.join(entry.designation[key]);
        }
      },

      /**
       * If this is array, returns a string.
       * @param value The value.
       * @returns Returns the joined string if the element is an array, otherwise the element itself.
       */
      ifArrayReturnsString: function(value){
        if(_.isArray(value)){
          value = _.join(value);
        }
        return value;
      },

      /**
       * If this is a string, returns an array.
       * @param value The value.
       * @returns Returns the array if the element is a string, otherwise the element itself.
       */
      ifStringReturnsArray: function(value){
        if(!_.isArray(value)){
          value = [value];
        }
        return value;
      },

      /**
       * Remove dollar signs.
       * @param value The value from which remove the dollar signs.
       * @returns Returns the string without the dollar signs.
       */
      removeDollarSigns: function(value){
        return _.replace(value, /\$/g, '');;
      },

      /**
       * Remove dollar signs from an array.
       * @param array The array from which remove the dollar signs.
       * @returns Returns the array without the dollar signs.
       */
      removeDollarSignsFromArray: function(array){
        var self = this;
        _.each(array, function(item, index){
          array[index] = self.removeDollarSigns(item);
        });
        return array;
      },

      /**
       * Change left code system.
       */
      changeLeftCodeSystem: function(){
        this.crossMappingSearch = 'left';
        this.loincSearchForm.selectLeftSearch = '';
        this.pageComponents.leftSearchResults = [];
        this.leftSearchExecuted = false;
        if(this.loincSearchForm.leftStandard !== '-1'){
          var self = this;
          //console.log('Left code system launch search');
          var getVersions = self.getVersionsByCodeSystem(self.loincSearchForm.leftStandard);
          Promise.all([getVersions]).then(function(values){
            self.handleVersions(values[0], self.selectedMode, 'left');
            self.hideLoading();
          });
        }
      },

      /**
       * Change right code system.
       */
      changeRightCodeSystem: function(){
        this.crossMappingSearch = 'right';
        this.loincSearchForm.selectRightSearch = '';
        this.pageComponents.rightSearchResults = [];
        this.rightSearchExecuted = false;
        if(this.loincSearchForm.rightStandard !== '-1'){
          var self = this;
          //console.log('Right code system launch search');
          var getVersions = self.getVersionsByCodeSystem(self.loincSearchForm.rightStandard);
          Promise.all([getVersions]).then(function(values){
            self.handleVersions(values[0], self.selectedMode, 'right');
            self.hideLoading();
          });
        }
      },

      /**
       * Search elements on the left.
       */
      leftSearch: function(lang, page) {
       // console.log('Left search!');
        this.executeSearch(lang, page, 'leftPage', 'leftSearchResults');
      },

      /**
       * Search elements on the right.
       */
      rightSearch: function(lang, page) {
        //console.log('Right search!');
        this.executeSearch(lang, page, 'rightPage', 'rightSearchResults');
      },

      /**
       * Funzione per visualizzare
       * la traduzione
       */
      changeLanguageProperty: function(obj, lang) {
		//console.log("changeLanguageProperty::"+lang+" obg::"+JSON.stringify(obj));
		//this.langSearch = lang; /*Lingua sulla ricerca*/
		obj.defLang = lang;	/*Lingua sulla righa (ATTUALMENTE RIATTIVATA SOLO SU LOINC)*/
		
      },

      getDetailsAlt : function(href) {
        this.pageComponents.detailObj = new SearchDetailObject();
        var url = href+"?"+APP_PROPERTIES.jsonFormatHttpParam;
        //console.log(url);
        return this.$http.get(url).then(function(response){
          return response;
        });
      },

      /**
       * Load the relations of the given detailObj.
       * @param detailObj The detail object.
       */
      loadDetailsRelations: function(detailObj){
        var resourceName = detailObj.resourceName;
        var version = this.pageComponents.detailObj.info.codeSystemVersion;
        var url = APP_PROPERTIES.pathGetRelations + '&codesystemversion=' + version + '&sourceortargetentity=' + resourceName + APP_PROPERTIES.jsonFormatHttpParam;
        var self = this;
		//console.log("loadDetailsRelations::"+url);
        self.$http.get(url).then(function(response){
          if(response.status === 200) {
            body = response.body;
            var mappingRelations = body.AssociationList.entry;
            _.each(mappingRelations, function(mappingRelation){
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
//            var finalMappingRelations = {
//              ATC: [],
//              AIC: [],
//              LOINC: [],
//              'ICD9-CM': [],
//            };
            var finalMappingRelations = {};
            
            _.each(mappingRelations, function(mappingRelation){
              var namespace;
              if(mappingRelation.predicate.name !== resourceName){
                namespace = mappingRelation.predicate.namespace;
                mappingRelation.detailObj = {
                  href: mappingRelation.predicate.href,
                  resourceName: mappingRelation.predicate.name,
                  defLang: self.lang
                };
              } else {
                namespace = mappingRelation.subject.namespace;
                mappingRelation.detailObj = {
                  href: mappingRelation.subject.href,
                  resourceName: mappingRelation.subject.name,
                  defLang: self.lang
                };
              }
			 
			 if(!finalMappingRelations[namespace]){
				 finalMappingRelations[namespace] = [];
			 }
              finalMappingRelations[namespace].push(mappingRelation);
            });

            //console.log('self.pageComponents.mappingToOtherCodingSystems', self.pageComponents.mappingToOtherCodingSystems);
            Vue.set(self.pageComponents, 'mappingToOtherCodingSystems', finalMappingRelations);
          }
        }, function(error) {
          console.log(error);
        });
      },

      /**
       * Returns true if the current mapping relations is empty.
       */
      isEmptyMappingRelations: function(){
        var self = this;
        var isEmpty = true;
        _.each(self.pageComponents.mappingToOtherCodingSystems, function(mappingRelation){
          if(!isEmpty){
            return;
          } else {
            isEmpty = _.isEmpty(mappingRelation);
          }
        });
        return isEmpty;
      },

      /**
       * Open the detail for the given code system.
       * @param key The key.
       * @param mapping The mapping from which open the detail.
       * @param currentModal The current modal.
       * @param modalId The modal id.
       */
      openDetailByCodeSystem: function(key, mapping, currentModal, modalId){
        if(currentModal !== key){
          // Hide the old modal
          $('#' + modalId).modal('hide');
        }
		
		//console.log("key:: "+key);
		//console.log("mapping:: "+JSON.stringify(mapping));
		//console.log("mapping:: "+JSON.stringify(mapping.detailObj));
		//console.log("currentModal:: "+currentModal);
		//console.log("mapping.predicate.namespace:: "+mapping.predicate.namespace);
		//console.log("modalId:: "+modalId);
		//console.log("currentModal !== key:: "+currentModal !== key);
	
       
	   if(key === 'LOINC'){
          this.openLoincDetailModal(mapping.detailObj, currentModal !== 'LOINC');
        } else if(key === 'ICD9-CM'){
          this.openIcd9CmDetailModal(mapping.detailObj, currentModal !== 'ICD9-CM');
        } else if(key === 'ATC'){
          this.openAtcDetailModal(mapping.detailObj, currentModal !== 'ATC');
        } else if(key === 'AIC'){
          this.openAicDetailModal(mapping.detailObj, currentModal !== 'AIC');
        }else{
			if(mapping !== undefined && mapping.detailObj !== undefined){
				mapping.detailObj.namespace = key;
			}
			this.openStandardLocalDetailModal(mapping.detailObj, currentModal !== key, true);
        }
      },
      
      
      /**
       * Open async tooltip
       * */
      asyncTooltip: function(searchResult, side){
 		//console.log("asyncTooltip::"+JSON.stringify(searchResult));
 		var key = searchResult.namespace;
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
       * Load the local mapping by the given definition.
       * @param definition The definition from which retrieve the local mapping.
       * @returns Returns the local mapping.
       */
      loadLocalMapping: function(definition) {
        this.pageComponents.mappingDetailObj = new MappingDetailObj();
        var localCodeList = _.find(definition, {externalIdentifier: 'LOCAL_CODE_LIST'});
        localCodeList = localCodeList.value;
        if(!_.isArray(localCodeList)){
          localCodeList = [];
        }
        var localeCodes = [];

        _.each(localCodeList, function(localCodeItem){
          var localCode = {
            name: _.clone(localCodeItem),
          };
          localeCodes.push(localCode);
        });
        return localeCodes;
      },

      /**
       * Get the value of the given object for the given path.
       * @param object The object from which read the value.
       * @param path The path of the property.
       * @returns Returns the object by the given object/path.
       */
      getValue: function(object, path){
        return _.get(object, path, '');
      },

      /**
       * Toggle the association of the given searchResult.
       * @param searchResult The search result from which toggle the associated property.
       * @param side The association side.
       */
      toggleAssociation: function(searchResult, side){
        if(this.isAssociated(searchResult, side)){
          //console.log('Removing a temp association');
          var index = _.findIndex(this.tempAssociations, {
            resourceName: searchResult.resourceName,
            side: side,
          });
          this.tempAssociations.splice(index, 1);
        } else {
          var index = _.findIndex(this.tempAssociations, {
            side: side
          });
          if(index !== -1){
            this.tempAssociations.splice(index, 1);
          }
          //console.log('Creating a temp association');
          var newElement = _.clone(searchResult);
          newElement.side = side;
          this.tempAssociations.push(newElement);
          //console.log('this.tempAssociations', this.tempAssociations);
        }
      },

      /**
       * Create the association from the temp associations.
       */
      createAssociations: function() {
        //console.log('Adding associations');
        var leftAssociation = _.find(this.tempAssociations, { side: 'left'});
        var rightAssociation = _.find(this.tempAssociations, { side: 'right'});
        var relation = this.loincSearchForm.relation;
        this.associations.push({
          left: _.clone(leftAssociation),
          right: _.clone(rightAssociation),
          relationLabel: _.clone(relation.label),
          relationForwardName: _.clone(relation.forwardName),
          relationReverseName: _.clone(relation.reverseName)
        });
        this.tempAssociations = [];
      },

      /**
       * Just an empty function.
       */
      emptyFunction: function(){

      },

      /**
       * Check if the given element is associated, false otherwise.
       * @param searchResult The element to check.
       * @param side The side of the table.
       * @returns Returns true if the given element is associated, false otherwise.
       */
      isAssociated: function(searchResult, side){
        return _.find(this.tempAssociations, {
          resourceName: searchResult.resourceName,
          side: side
        });
      },

      /**
       * Delete association by the given index.
       * @param index The index of the associations to remove.
       */
      deleteAssociation: function(index) {
        this.associations.splice(index, 1);
      },

      /**
       * Save the associations
       */
      saveAssociations: function(){
        var numberOfElements = this.associations.length;
        var numberOfSent = 0;
        var self = this;
        _.each(this.associations, function(association){
          //console.log('association to save', association);
          var objectToSend = {
          	"entry": {
          		"subject": {
                "href": association.left.href,
          			"namespace": association.left.namespace,
          			"name": association.left.resourceName
          		},
          		"predicate": {
          			"href": association.right.href,
          			"namespace": association.right.namespace,
          			"name": association.right.resourceName
          		},
          		"associationQualifier": [{
          			"predicate": {
          				"uri": "forwardName",
          				"name": "forwardName"
          			},
          			"value": [{
          				"literal": {
          					"value": association.relationForwardName
          				}
          			}]
          		}, {
          			"predicate": {
          				"uri": "reverseName",
          				"name": "reverseName"
          			},
          			"value": [{
          				"literal": {
          					"value": association.relationReverseName
          				}
          			}]
          		}, {
          			"predicate": {
          				"uri": "associationKind",
          				"name": "associationKind"
          			},
          			"value": [{
          				"literal": {
          					"value": "3" // cross-mapping
          				}
          			}]
          		}]
          	}
          };

          //console.log('The object to send is', objectToSend);
          self.$http.post(APP_PROPERTIES.pathSendRelation, objectToSend).then(function(response) {
            //console.log('response', response);
          }, function(error){
            console.error('error sending assocation', error);
            noty({text: 'Errore durante il salvataggio dell\'associazione. Forse l\'associazione che si sta cercando di creare esiste già.', type: 'error', timeout:5000});
          }).finally(function() {
            numberOfSent++;
            if(numberOfSent === numberOfElements){
              self.associations = [];
            }
          });
        });
      },

      /**
       * Load relations.
       */
      loadRelations: function(){
        this.relations = ASSOCIATION_TYPES;
      },

      /**
       * Remove from the given list of versions, the actual version.
       * @param versions The list of versions to filter.
       * @param actualVersion The actualVersion.
       * @returns Returns an array with all the versions expect the actual one.
       */
      removeActualVersions: function(versions, actualVersion){
        return _.filter(versions, function(version) {
          return version.name !== actualVersion;
        });
      },

      /**
       * Open the details LOINC modal of the given object.
       * @param newDetailObj The details object to show.
       * @param toggleModal Should it toggle the modal?
       */
      openLoincDetailModal: function(newDetailObj, toggleModal) {
		//console.log("newDetailObj::"+JSON.stringify(newDetailObj));
        var self = this;
		
		toggleModal = _.defaultTo(toggleModal, true);
		this.detailsTab = "tab-details";
		var blockOptions = {
		  message : '<h1>' + Vue.t('message.labelLoading', this.lang) + '<h1>'
		};
		
		if(toggleModal){
		  blockOptions.css = {
			"margin-left": '33%' ,
			"margin-top": '10%'
		  };
		}

		$("#detailModalLoinc").block(blockOptions);

		if(toggleModal){
		  $('#detailModalLoinc').modal('toggle');
		}
        //this.getDetails(newDetailObj.href);
		
		
		var namespace = 'LOINC';
		var otherVersionsPromise = self.loadCsVersions(namespace);
		var otherVersions = [];
		otherVersionsPromise.then(function(values){
          	otherVersions = values;
        }).finally(function() {
            self.hideLoading();
        });

        this.getDetailsAlt(newDetailObj.href).then(function(response){
          if(response && response.status===200) {
            //TODO Rendere il parsing più dinamico
            var obj = response.body.EntityDescriptionMsg.entityDescription.namedEntity;

            var it = {};
            var en = {};
            var info = {};


            //console.log(obj.describingCodeSystemVersion.version.content);
            info.codeSystemName = obj.describingCodeSystemVersion.codeSystem.content;
            info.codeSystemVersion = obj.describingCodeSystemVersion.version.content;
            //info.otherVersions = self.removeActualVersions(obj.alternateEntityID, info.codeSystemVersion);
			//info.otherVersions = obj.alternateEntityID, info.codeSystemVersion;
			try{
				info.releaseDate = _.find(otherVersions, {name: info.codeSystemVersion}).releaseDate;
			}
			catch(e){}
			info.otherVersions = otherVersions;

            //Retrieve the local code list
            var localeCodes = self.loadLocalMapping(obj.definition);

            obj.definition.forEach(function(d){
              switch (d.externalIdentifier) {
                case 'COMPONENT':
                  if (d.language.content == 'it') {
                    it.component = d.value;
                  } else {
                    en.component = d.value;
                  }
                  break;

                case 'NAME':
                  if (d.language.content == 'it') {
                    it.name = d.value;
                  } else {
                    en.name = d.value;
                  }
                  break;

                case 'STATUS' :
                  //console.log(d.value);
                  info.status = d.value;
                  break;

                case 'PROPERTY':
                  if (d.language.content == 'it') {
                    it.property = d.value;
                  } else {
                    en.property = d.value;
                  }
                  break;

                case 'TIME_ASPECT':
                  if (d.language.content == 'it') {
                    it.time = d.value;
                  } else {
                    en.time = d.value;
                  }
                  break;

                case 'SYSTEM':
                  if (d.language.content == 'it') {
                    it.system = d.value;
                  } else {
                    en.system = d.value;
                  }
                  break;

                case 'SCALE_TYP':
                  if (d.language.content == 'it') {
                    it.scale = d.value;
                  } else {
                    en.scale = d.value;
                  }
                  break;

                case 'METHOD_TYP':
                  if (d.language.content == 'it') {
                    it.method = d.value;
                  } else {
                    en.method = d.value;
                  }
                  break;

                case 'CLASS':
                  if (d.language.content == 'it') {
                    it.class = d.value;
                  } else {
                    en.class = d.value;
                  }
                  break;

                //Gestire i campi non in Italiano?
                case 'LONG_COMMON_NAME':
                  if (d.language.content == 'it') {
                    it.longCommonName = d.value;
                  } else {
                    en.longCommonName = d.value;
                  }
                  break;

                case 'VERSION_LAST_CHANGED':
                  info.versionLastChanged = d.value;
                  break;

                case 'DEFINITION_DESCRIPTION':
                  info.definitionDescription = d.value;
                  break;

                case 'ORDER_OBS':
                  info.orderObs = d.value;
                  break;

                case 'EXAMPLE_UNITS':
                  info.exampleUnits = d.value;
                  break;

                case 'EXAMPLE_UCUM_UNITS':
                  info.exampleUcumUnits = d.value;
                  break;

                case 'EXAMPLE_SI_UCUM_UNITS':
                  info.exampleSiUcumUnits = d.value;
                  break;

                case 'UNITSREQUIRED':
                  info.unitsRequired = d.value;
                  break;

                case 'STATUS_REASON':
                  info.statusReason = d.value;
                  break;

                case 'STATUS_TEXT':
                  info.statusText = d.value;
                  break;

                case 'CHANGE_REASON_PUBLIC':
                  info.changeReasonPublic = d.value;
                  break;

                case 'COMMON_TEST_RANK':
                  info.commonTestRank = d.value;
                  break;

                case 'COMMON_ORDER_RANK':
                  info.commonOrderRank = d.value;
                  break;

                case 'COMMON_SI_TEST_RANK':
                  info.commonSiTestRank = d.value;
                  break;

                case 'ASSOCIATED_OBSERVATIONS':
                  info.associatedObservations = d.value;
                  break;

                //Map to
                case 'MAP_TO':
                  info.mapTo = d.value;

                  //Generate the href to the map_to element
                  info.mapToHref = _.replace(newDetailObj.href, newDetailObj.resourceName, info.mapTo);
                  break;

                case 'MAP_TO_COMMENT':
                  info.mapToComment = d.value;
                  break;

                case 'CS_OID':
                  info.codeSystem = d.value;
                  break;

                //Local mapping
                case 'BATTERY_CODE':
                  var content = d.language.content;
                  var localCode = _.find(localeCodes, {name: _.replace(content, 'LOC_', '')});
                  localCode.batteryCode = d.value;
                  break;

                case 'BATTERY_DESCRIPTION':
                  var content = d.language.content;
                  var localCode = _.find(localeCodes, {name: _.replace(content, 'LOC_', '')});
                  localCode.batteryDescription = d.value;
                  break;

                case 'LOCAL_DESCRIPTION':
                  var content = d.language.content;
                  var localCode = _.find(localeCodes, {name: _.replace(content, 'LOC_', '')});
                  localCode.description = d.value;
                  break;

                case 'LOCAL_UNITS':
                  var content = d.language.content;
                  var localCode = _.find(localeCodes, {name: _.replace(content, 'LOC_', '')});
                  localCode.units = d.value;
                  break;

                case 'LOCAL_CODE':
                  var content = d.language.content;
                  var localCode = _.find(localeCodes, {name: _.replace(content, 'LOC_', '')});
                  localCode.code = d.value;
                  break;
                default:
                  break;
              }

            });

            info.localMappingList = localeCodes;

            if(info.mapTo){
              info.mapToDetails = {
                href: info.mapToHref,
                resourceName: info.mapTo,
                defLang: newDetailObj.defLang
              };
            }

            /**
             * https://vuejs.org/v2/guide/list.html#Caveats
             */
            Vue.set(this.pageComponents.detailObj, "info", info);
            Vue.set(this.pageComponents.detailObj, "it", it);
            Vue.set(this.pageComponents.detailObj, "en", en);
			
          }
        }, function(error) {
          noty({text: 'Impossibile recuperare il dettaglio. Si è verificato un errore', type: 'error', timeout:5000});
          console.log(error);
        }).finally(function() {
          $("#detailModalLoinc").unblock({});
		  this.addNavigationVersionInfo(newDetailObj);
          this.loadDetailsRelations(newDetailObj);
		  this.addLanguageAvaiable(newDetailObj);
        });

        self.pageComponents.detailObj.resourceName = newDetailObj.resourceName;
		self.pageComponents.detailObj.defLang = newDetailObj.defLang;
      },

      /**
       * Open ICD9-CM detail.
       * @param newDetailObj The details object to show.
       * @param toggleModal Should it toggle the modal?
       */
      openIcd9CmDetailModal: function(newDetailObj, toggleModal) {
		  //console.log("newDetailObj::"+JSON.stringify(newDetailObj));
		var self = this;
		self.detailsTab = "tab-details";
		toggleModal = _.defaultTo(toggleModal, true);
		var blockOptions = {
		  message : '<h1>' + Vue.t('message.labelLoading', self.lang) + '<h1>'
		};

		if(toggleModal){
		  blockOptions.css = {
			"margin-left": '33%' ,
			"margin-top": '10%'
		  };
		}

		$("#detailModalIcd9Cm").block(blockOptions);

		if(toggleModal){
		  $('#detailModalIcd9Cm').modal('toggle');
		}
		
		
		var namespace = "ICD9-CM";
		var otherVersionsPromise = self.loadCsVersions(namespace);
		var otherVersions = [];
		otherVersionsPromise.then(function(values){
          	otherVersions = values;
        }).finally(function() {
            self.hideLoading();
        });

       
        this.getDetailsAlt(newDetailObj.href).then(function(response){
          if(response && response.status===200) {
            //TODO Rendere il parsing più dinamico
            var obj = response.body.EntityDescriptionMsg.entityDescription.namedEntity;

            var it = {};
            var en = {};
            var info = {};

            //console.log(obj.describingCodeSystemVersion.version.content);
            info.codeSystemName = obj.describingCodeSystemVersion.codeSystem.content;
            info.codeSystemVersion = obj.describingCodeSystemVersion.version.content;
            //info.otherVersions = obj.alternateEntityID;
			try{
				info.releaseDate = _.find(otherVersions, {name: info.codeSystemVersion}).releaseDate;
			}
			catch(e){}
			info.otherVersions = otherVersions;

            obj.definition.forEach(function(d){
              switch (d.externalIdentifier) {
                case 'NAME':
                  if (d.language.content == 'it') {
                    it.name = self.ifArrayReturnsString(d.value);
                  } else {
                    en.name = self.ifArrayReturnsString(d.value);
                  }
                  break;
                case 'DESCRIPTION':
                  if (d.language.content == 'it') {
                    it.description = self.ifArrayReturnsString(d.value);
                  } else {
                    en.description = self.ifArrayReturnsString(d.value);
                  }
                  break;
                case 'OTHER_DESCRIPTION':
                  if (d.language.content == 'it') {
                    it.otherDescription = self.removeDollarSignsFromArray(self.ifStringReturnsArray(d.value));
                  } else {
                    en.otherDescription = self.removeDollarSignsFromArray(self.ifStringReturnsArray(d.value));
                  }
                  break;
                case 'NOTE':
                  if (d.language.content == 'it') {
                    it.note = self.ifStringReturnsArray(d.value);
                  } else {
                    en.note = self.ifStringReturnsArray(d.value);
                  }
                  break;
                case 'INCLUDE':
                  if (d.language.content == 'it') {
                    it.include = self.removeDollarSignsFromArray(self.ifStringReturnsArray(d.value));
                  } else {
                    en.include = self.removeDollarSignsFromArray(self.ifStringReturnsArray(d.value));
                  }
                  break;
                case 'ESCLUDE':
                  if (d.language.content == 'it') {
                    it.esclude = self.removeDollarSignsFromArray(self.ifStringReturnsArray(d.value));
                  } else {
                    en.esclude = self.removeDollarSignsFromArray(self.ifStringReturnsArray(d.value));
                  }
                  break;
                case 'CODIFY_FIRST':
                  if (d.language.content == 'it') {
                    it.codifyFirst = self.ifArrayReturnsString(d.value);
                  } else {
                    en.codifyFirst = self.ifArrayReturnsString(d.value);
                  }
                  break;
                case 'USE_ADD_CODE':
                  if (d.language.content == 'it') {
                    it.useAddCode = self.ifArrayReturnsString(d.value);
                  } else {
                    en.useAddCode = self.ifArrayReturnsString(d.value);
                  }
                  break;
                case 'TYPE':
                  info.type = d.value;
                  break;
                case 'SUBCLASS_OF':
                  info.subClassOf = d.subClassOf;
                  break;
                case 'CS_OID':
                  info.codeSystem = d.value;
                  break;
                default:
                  break;
              }
            });

            //Retrieve hierarchical relationships
            var parents = self.retrieveParents(obj, true);
            var level = 0;
            if(parents && parents.length > 0){
              parents.shift(); //Remove the first element
            }

            if(parents && parents.length > 0){
              level = _.last(parents).level + 1;
            } else {
              parents = [];
            }

            //Merge data from children, current object and children
            var currentObject = {
              current: true, //This is the current object
              name: newDetailObj.resourceName,
              name_it: it.description || it.name,
              name_en: en.description || en.name,
              level: level
            };
            info.relationships = _.concat(parents, [currentObject], self.retrieveChildren(obj, level + 1));

            /**
             * https://vuejs.org/v2/guide/list.html#Caveats
             */
            Vue.set(this.pageComponents.detailObj, "info", info);
            Vue.set(this.pageComponents.detailObj, "it", it);
            Vue.set(this.pageComponents.detailObj, "en", en);
			
          }
        }, function(error) {
          noty({text: 'Impossibile recuperare il dettaglio. Si è verificato un errore', type: 'error', timeout:5000});
          console.log(error);
        }).finally(function() {
          $("#detailModalIcd9Cm").unblock({});
		  this.addNavigationVersionInfo(newDetailObj);
          this.loadDetailsRelations(newDetailObj);
		  this.addLanguageAvaiable(newDetailObj);
        });

        self.pageComponents.detailObj.resourceName = newDetailObj.resourceName;
		self.pageComponents.detailObj.defLang = newDetailObj.defLang;
      },

      /**
       * Open ATC detail of the  given object.
       * @param newDetailObj The object of which open the details.
       * @param toggleModal Should it toggle the modal?
       */
      openAtcDetailModal: function(newDetailObj, toggleModal) {
		  //console.log("newDetailObj::"+JSON.stringify(newDetailObj));
		 var self = this;
        this.detailsTab = "tab-details";
        
    	 toggleModal = _.defaultTo(toggleModal, true);
         var blockOptions = {
           message : '<h1>' + Vue.t('message.labelLoading', this.lang) + '<h1>'
         };

         if(toggleModal){
           blockOptions.css = {
             "margin-left": '33%' ,
             "margin-top": '10%'
           };
         }

         $("#detailModalAtc").block(blockOptions);

         if(toggleModal){
           $('#detailModalAtc').modal('toggle');
         }
		 
       
	   var namespace = 'ATC';
	   var otherVersionsPromise = self.loadCsVersions(namespace);
		var otherVersions = [];
		otherVersionsPromise.then(function(values){
          	otherVersions = values;
        }).finally(function() {
            self.hideLoading();
        });

       
        this.getDetailsAlt(newDetailObj.href).then(function(response){
          if(response && response.status===200) {
            //TODO Rendere il parsing più dinamico
            var obj = response.body.EntityDescriptionMsg.entityDescription.namedEntity;

            var it = {};
            var en = {};
            var info = {};

            info.codeSystemName = obj.describingCodeSystemVersion.codeSystem.content;
            info.codeSystemVersion = obj.describingCodeSystemVersion.version.content;
            //info.otherVersions = obj.alternateEntityID;
			try{
				info.releaseDate = _.find(otherVersions, {name: info.codeSystemVersion}).releaseDate;
			}
			catch(e){}
			info.otherVersions=otherVersions;

            var level = 0;

            if(info.parents && info.parents.length > 0){
              info.level = _.last(info.parents).level + 1;
            }

            obj.definition.forEach(function(d){
              switch (d.externalIdentifier) {
                case 'NAME':
                  info.name = d.value;
                  break;
                case 'GRUPPO_ANATOMICO':
                  info.gruppoAnatomico = d.value;
                  break;
                case 'TYPE':
                  info.type = d.value;
                  break;
                case 'SUBCLASS_OF':
                  info.subClassOf = d.subClassOf;
                  break;
                case 'CS_OID':
                  info.codeSystem = d.value;
                  break;
                default:
                  break;
              }
            });

            //Retrieve hierarchical relationships
            var parents = self.retrieveParents(obj, false);
            var level = 0;

            if(parents && parents.length > 0){
              level = _.last(parents).level + 1;
            } else {
              parents = [];
            }

            //Merge data from children, current object and children
            var currentObject = {
              current: true, //This is the current object
              name: newDetailObj.resourceName,
              name_it: info.name,
              name_en: info.name,
              level: level
            };
            info.relationships = _.concat(parents, [currentObject], self.retrieveChildren(obj, level + 1));

            /**
             * https://vuejs.org/v2/guide/list.html#Caveats
             */
            Vue.set(this.pageComponents.detailObj, "info", info);
            Vue.set(this.pageComponents.detailObj, "it", it);
            Vue.set(this.pageComponents.detailObj, "en", en);

          }
        }, function(error) {
          noty({text: 'Impossibile recuperare il dettaglio. Si è verificato un errore', type: 'error', timeout:5000});
          console.log(error);
        }).finally(function() {
          $("#detailModalAtc").unblock({});
		  this.addNavigationVersionInfo(newDetailObj);
          this.loadDetailsRelations(newDetailObj);
		  this.addLanguageAvaiable(newDetailObj);
        });

        self.pageComponents.detailObj.resourceName = newDetailObj.resourceName;
		self.pageComponents.detailObj.defLang = newDetailObj.defLang;
      },

      /**
       * Open AIC detail of the  given object.
       * @param newDetailObj The object of which open the details
       * @param toggleModal Should it toggle the modal?
       */
      openAicDetailModal: function(newDetailObj, toggleModal) {
		  //console.log("newDetailObj::"+JSON.stringify(newDetailObj));
        this.detailsTab = "tab-details";
		 var self = this;
		 
		toggleModal = _.defaultTo(toggleModal, true);
		var blockOptions = {
		  message : '<h1>' + Vue.t('message.labelLoading', self.lang) + '<h1>'
		};

		if(toggleModal){
		  blockOptions.css = {
			"margin-left": '33%' ,
			"margin-top": '10%'
		  };
		}

		$("#detailModalAic").block(blockOptions);

		if(toggleModal){
		  $('#detailModalAic').modal('toggle');
		}
		
		
		var namespace = 'AIC';
		var otherVersionsPromise = self.loadCsVersions(namespace);
		var otherVersions = [];
		otherVersionsPromise.then(function(values){
          	otherVersions = values;
        }).finally(function() {
            self.hideLoading();
        });
		
       
        this.getDetailsAlt(newDetailObj.href).then(function(response){
          if(response && response.status===200) {
            //TODO Rendere il parsing più dinamico
            var obj = response.body.EntityDescriptionMsg.entityDescription.namedEntity;

            var it = {};
            var en = {};
            var info = {};

            info.codeSystemName = obj.describingCodeSystemVersion.codeSystem.content;
            info.codeSystemVersion = obj.describingCodeSystemVersion.version.content;
            //info.otherVersions = obj.alternateEntityID;
			try{
				info.releaseDate = _.find(otherVersions, {name: info.codeSystemVersion}).releaseDate;
			}
			catch(e){}
			info.otherVersions=otherVersions;
            info.parents = self.retrieveParents(obj, false);

            obj.definition.forEach(function(d){
              switch (d.externalIdentifier) {
                case 'NAME':
                  info.name = d.value;
                  break;
                case 'CONFEZIONE':
                  info.confezione = d.value;
                  break;
                case 'CLASSE':
                  info.classe = d.value;
                  break;
                case 'DITTA':
                  info.ditta = d.value;
                  break;
                case 'CODICE_GRUPPO_EQ':
                  info.codiceGruppoEq = d.value;
                  break;
                case 'DESCR_GRUPPO_EQ':
                  info.descrGruppoEq = d.value;
                  break;
                case 'METRI_CUBI_OSSIGENO':
                  info.metriCubiOssigeno = d.value;
                  break;
                case 'PRINCIPIO_ATTIVO':
                  info.principioAttivo = d.value;
                  break;
                case 'PREZZO_AL_PUBBLICO':
                  info.prezzoAlPubblico = d.value + '€';
                  break;
                case 'PREZZO_EX_FACTORY':
                  info.prezzoExFactory = d.value + '€';
                  break;
                case 'PREZZO_MASSIMO_CESSIONE':
                  info.prezzoMassimoCessione = d.value + '€';
                  break;
                case 'IN_LISTA_TRASPARENZA_AIFA':
                  var value = d.value;
                  if(value == 'false'){
                    info.inListaTrasparenzaAifa = 'message.labelNo';
                  } else {
                    info.inListaTrasparenzaAifa = 'message.labelYes';
                  }
                  break;
                case 'IN_LISTA_REGIONE':
                  var value = d.value;
                  if(value == 'false'){
                    info.inListaRegione = 'message.labelNo';
                  } else {
                    info.inListaRegione = 'message.labelYes';
                  }
                  break;
                case 'UNITA_POSOLOGICA':
                  info.unitaPosologica = d.value;
                  break;
                case 'PREZZO_UNITA_POSOLOGICA':
                  info.prezzoUnitaPosologica = d.value + '€';
                  break;
                case 'CODICE_ATC':
                  info.codiceAtc = d.value;
                  break;
                case 'CS_OID':
                  info.codeSystem = d.value;
                  break;
                default:
                  break;
              }
            });

            /**
             * https://vuejs.org/v2/guide/list.html#Caveats
             */
            Vue.set(this.pageComponents.detailObj, "info", info);
            Vue.set(this.pageComponents.detailObj, "it", it);
            Vue.set(this.pageComponents.detailObj, "en", en);

          }
        }, function(error) {
          noty({text: 'Impossibile recuperare il dettaglio. Si è verificato un errore', type: 'error', timeout:5000});
          console.log(error);
        }).finally(function() {
          $("#detailModalAic").unblock({});
		  this.addNavigationVersionInfo(newDetailObj);
          this.loadDetailsRelations(newDetailObj);
		  this.addLanguageAvaiable(newDetailObj);
        });

		self.pageComponents.detailObj.resourceName = newDetailObj.resourceName;
		self.pageComponents.detailObj.defLang = newDetailObj.defLang;
      },

      
      
      
      
      /**
       * Open LOCAL detail of the  given object.
       * @param newDetailObj The object of which open the details
       * @param toggleModal Should it toggle the modal?
       */
      openStandardLocalDetailModal: function(newDetailObj, toggleModal, fromOtherModal) {
    	//console.log("newDetailObj::"+JSON.stringify(newDetailObj));
		var self = this;
        this.detailsTab = "tab-details";
		
		
		toggleModal = _.defaultTo(toggleModal, true);
		var blockOptions = {
		  message : '<h1>' + Vue.t('message.labelLoading', self.lang) + '<h1>'
		};

		if(toggleModal){
		  blockOptions.css = {
			"margin-left": '33%' ,
			"margin-top": '10%'
		  };
		}
		
		$("#detailModalStandardLocal").block(blockOptions);
				
		if(toggleModal){
			$('#detailModalStandardLocal').modal('toggle');
		}
		
		//console.log("newDetailObj.namespace::"+newDetailObj.namespace);
		
		var levelCs = newDetailObj.level;
		var namespace = newDetailObj.namespace;
		if(levelCs!==undefined && levelCs>0){
			namespace = newDetailObj.name.namespace;
		}
		
		var otherVersionsPromise = self.loadCsVersions(namespace);
		var otherVersions = [];
		otherVersionsPromise.then(function(values){
          	otherVersions = values;
        }).finally(function() {
            self.hideLoading();
        });

        
		//console.log("newDetailObj.href::"+newDetailObj.href);
        self.getDetailsAlt(newDetailObj.href).then(function(response){
          if(response && response.status===200) {
            //TODO Rendere il parsing più dinamico
            var obj = response.body.EntityDescriptionMsg.entityDescription.namedEntity;

            var it = {};
            var en = {};
            var info = {};

            info.codeSystemName = obj.describingCodeSystemVersion.codeSystem.content;
            info.codeSystemVersion = obj.describingCodeSystemVersion.version.content;
		    info.namespace = newDetailObj.namespace;
			//info.otherVersions = obj.alternateEntityID;
			info.otherVersions = otherVersions;
			try{
				info.releaseDate = _.find(otherVersions, {name: info.codeSystemVersion}).releaseDate;
			}
			catch(e){
				console.log("ERROR::"+e);
			}
			info.additionalInfo=[];
			
			
			var currentElementSelected =  _.find(self.codeSystemsRemote, {name: info.codeSystemName});
			if(currentElementSelected!==undefined){
				info.isClassification = currentElementSelected.isClassification;
				info.hasOntology = currentElementSelected.hasOntology!="" ? currentElementSelected.hasOntology : "N";
				info.ontologyName = currentElementSelected.ontologyName;
				info.type = currentElementSelected.type;
			}
			else{
				info.isClassification = false;
				info.hasOntology = 'N';
			}
			
			//console.log("info.codeSystemVersion::"+info.codeSystemVersion);
           //console.log("obj::"+JSON.stringify(obj));
            obj.definition.forEach(function(d){
				//console.log("d.language.content::"+d.language.content);
				switch (d.externalIdentifier) {
					case 'NAME':
						//info.description = d.value;
						if (d.language.content == 'it') {
							it.description = self.ifArrayReturnsString(d.value);
						} else if (d.language.content == 'en') {
							en.description = self.ifArrayReturnsString(d.value);
						}
					break;
                  
                   
					case 'CS_OID':
						info.csOid = d.value;
						break;
                    
					default:
						
						if(d.externalIdentifier!="IS_LEAF" &&  d.externalIdentifier!="MAPPING"  
								&&  d.externalIdentifier!="LOCAL_CODE_LIST" && d.value!==null && d.value!=""){
							//info.additionalInfo.push({key:d.externalIdentifier,value:d.value});
							
							if(d.language!==undefined && d.language.content!==undefined){
								if (d.language.content == 'it' || d.language.content == 'en') {
									info.additionalInfo.push({key:d.externalIdentifier, value:d.value, lang:d.language.content});
								} 
							}
						}
					break;
				}
            });
			
			//console.log(JSON.stringify(info.additionalInfo));
			
			 //START Retrieve hierarchical relationships
			var level = 0;
			var parents = self.retrieveParents(obj, false);
			if(parents && parents.length > 0){
			  level = _.last(parents).level + 1;
			} else {
			  parents = [];
			}

			//Merge data from children, current object and children
			var currentObject = {
			  current: true, //This is the current object
			  name: newDetailObj.resourceName,
			  name_it: it.description || it.name,
			  name_en: en.description || en.name,
			  level: level
			};
			 
			info.relationships = _.concat(parents, [currentObject], self.retrieveChildren(obj, level + 1));
			 //END Retrieve hierarchical relationships

			 
			/**
			 * https://vuejs.org/v2/guide/list.html#Caveats
			 */
			
			Vue.set(this.pageComponents.detailObj, "info", info);
			Vue.set(this.pageComponents.detailObj, "it", it);
			Vue.set(this.pageComponents.detailObj, "en", en);
			
			
          }
        }, function(error) {
			noty({text: 'Impossibile recuperare il dettaglio. Si è verificato un errore', type: 'error', timeout:5000});
			console.log(error);
        }).finally(function() {
			$("#detailModalStandardLocal").unblock({});
			this.sortAdditionalInfo();
			this.loadDetailsRelations(newDetailObj);
			this.addNavigationVersionInfo(newDetailObj);
			this.addLanguageAvaiable(newDetailObj);
        });

		self.pageComponents.detailObj.resourceName = newDetailObj.resourceName;
		self.pageComponents.detailObj.defLang = newDetailObj.defLang;
      },
	  
	  
	addLanguageAvaiable: function(){
		var self = this;
		var url = APP_PROPERTIES.getLanguages;
		self.itIsPresent= false;
		self.enIsPresent= false;
		url = url.replace("NAME",self.pageComponents.detailObj.info.codeSystemName);
		url = url.replace("VERSION_NAME",self.pageComponents.detailObj.info.codeSystemVersion);
		//console.log("GET LANGUAGE URL::"+url);

		self.$http.get(url).then(function(response){
			//console.log("response::"+JSON.stringify(response.body.ArrayList));
			var langauges = response.body.ArrayList;
			var info = self.pageComponents.detailObj.info;
			//self.pageComponents.detailObj.info.avaiableLanguage=langauges;
			info.avaiableLanguage=langauges;
			 
			if(_.indexOf(info.avaiableLanguage, 'it')!=-1){
				self.itIsPresent= true;
			}
			if(_.indexOf(info.avaiableLanguage, 'en')!=-1){
				self.enIsPresent= true;
			}
			Vue.set(self.pageComponents.detailObj, "info", info);
		}).finally(function(){
			self.hideLoading();
		});	
		
	},
	  
	  
	  addNavigationVersionInfo: function(newDetailObj){
		var self = this;
		self.pageComponents.detailObj.href = newDetailObj.href;
		self.pageComponents.detailObj.namespace = newDetailObj.namespace;
		self.pageComponents.detailObj.releaseDate = newDetailObj.releaseDate;
		
		var lengthOtherVersions = self.pageComponents.detailObj.info.otherVersions.length;
		var indexCurrentVersion = _.findIndex(self.pageComponents.detailObj.info.otherVersions, function(version) { return version.name == self.pageComponents.detailObj.info.codeSystemVersion });
		
		/* se la versione corrente non è la prima setto prevVersion*/
		if(indexCurrentVersion>0){
			var prevVersion = self.pageComponents.detailObj.info.otherVersions[indexCurrentVersion-1].name
			self.pageComponents.detailObj.prevVersionName = prevVersion;
			self.pageComponents.detailObj.hrefPrev = newDetailObj.href.replace(self.pageComponents.detailObj.info.codeSystemVersion,prevVersion);
		}
		
		/* se la versione corrente non è l'ultima setto nextVersion*/
		if(indexCurrentVersion<(lengthOtherVersions-1)){
			var nextVersion = self.pageComponents.detailObj.info.otherVersions[indexCurrentVersion+1].name
			self.pageComponents.detailObj.nextVersionName = nextVersion;
			self.pageComponents.detailObj.hrefNext = newDetailObj.href.replace(self.pageComponents.detailObj.info.codeSystemVersion,nextVersion);
		}
		/*
		console.log("indexCurrentVersion::"+indexCurrentVersion)
		console.log("self.pageComponents.detailObj.hrefPrev::"+self.pageComponents.detailObj.hrefPrev);
		console.log("self.pageComponents.detailObj.href::"+self.pageComponents.detailObj.href);
		console.log("self.pageComponents.detailObj.hrefNext::"+self.pageComponents.detailObj.hrefNext);
		*/
	  },
	  
	  
	  /**
	  * sortAdditionalInfo
	  */
	  sortAdditionalInfo: function() {
		var self = this;
		  
		var orderSolrFields = [];
		var info = self.pageComponents.detailObj.info;
		//console.log("additionalInfo::"+JSON.stringify(info.additionalInfo));
					
		//recupero i mtadata_parameter del CS/VS per recuperare la posizione
		var urlParams = "";
		if(self.navigationMode=='code-system' || self.navigationMode=='mapping'){
			urlParams =  APP_PROPERTIES.getCodeSystemSolrFields.replace("{CS_NAME}",info.codeSystemName);
		}else if(self.navigationMode=='value-set'){
			urlParams = APP_PROPERTIES.getValueSetSolrFields.replace("{VS_NAME}",info.codeSystemName);
		}
		//console.log("sortAdditionalInfo::urlParams::"+urlParams);
		
		
		self.$http.get(urlParams).then(function(response) {
			var data = response.body;
			var array = data.JsonArray.elements;
			//var array = data.ArrayList;
			
			_.each(array, function(element){
				//console.log("element::"+JSON.stringify(element));
				var field = "";
				var position=0;
				if(element.members.name!==undefined){
					field = element.members.name.value.trim()
					if(!_.startsWith(field,'DF_M_')){
						field = field.replace("DF_S_","").replace("DF_D_","").replace("DF_N_","").replace("_it","").replace("_en","");
					}
				}
				
				if(element.members.position!==undefined){
					position = element.members.position.value;
				}
				
				var elemento = _.find(info.additionalInfo, {key: field});
				if(elemento!==undefined){
					//console.log("field::"+field+" position::"+position+" obj::"+elemento.key);
					orderSolrFields.push({key:elemento.key,value:elemento.value,lang:elemento.lang,position:position});
				}
			});

			
			//per la lingua italiana: se manca la lingua italiana ricopia tutti i dati presenti nell'array orderSolrFields
			//settando per ogni elemento copiato la lingua 'it'
			//in questo modo sia in italiano che in inglese vedremo gli stessi dati e non i campi vuoti
			if(!_.find(orderSolrFields, {lang: 'it'})) {
				//console.log("it not present");
				_.each(orderSolrFields, function(obj){
					orderSolrFields.push({key:obj.key,value:obj.value,lang:'it',lang:'it',position:obj.position});
				});
			}
			
			//per la lingua inglese: se manca la lingua inglese ricopia tutti i dati presenti nell'array orderSolrFields 
			//settando per ogni elemento copiato la lingua 'en'
			//in questo modo sia in italiano che in inglese vedremo gli stessi dati e non i campi vuoti
			if(!_.find(orderSolrFields, {lang: 'en'})) {
				//console.log("en not present");
				_.each(orderSolrFields, function(obj){
					orderSolrFields.push({key:obj.key,value:obj.value,lang:'en',position:obj.position});
				});
			}
			
			orderSolrFields = _.sortBy(orderSolrFields, 'position');
			info.additionalInfo = orderSolrFields;
			//Vue.set(self.pageComponents.detailObj.info.additionalInfo, "additionalInfo", orderSolrFields);
			//console.log("info.additionalInfo::"+JSON.stringify(info.additionalInfo));
			//console.log("orderSolrFields::"+JSON.stringify(orderSolrFields));
		}, function(error) {
			noty({text: 'Si è verificato un errore durante la ricerca. Si prega di riprovare', type: 'error', timeout:5000});
		}).finally(function() {
		  
		});
	},
      
      
      /**
       * Retrieve the parents by the given obj.
       * @param obj The object from which retrieve the parents.
       * @param isIcd9 True if the object from ICD9-CM.
       * @returns Returns the list of parents.
       */
      retrieveParents: function(obj, isIcd9){
        var self = this;
        var parents = _.reverse(obj.parent);
        _.each(parents, function(parent, index){
          var designation = jQuery.parseJSON(parent.designation);
          parent.name_it = designation.NAME_it;
          parent.name_en = designation.NAME_en;
          parent.detailObj = {
            href: parent.href,
            resourceName: parent.name,
            defLang: self.lang,
			namespace: obj.entityID.namespace
          };
          parent.level = index;
          if(isIcd9){
            //Remove 1 because we usually remove the first element (ICD9-CM)
            parent.level--;
          }
        });
        return parents;
      },

      /**
       * Retrieve the children by the given obj.
       * @param obj The object from which retrieve the children.
       * @param level The start level for hierarchical relationships.
       * @returns Returns the list of children.
       */
      retrieveChildren: function(obj, level){
        var self = this;
        var children = jQuery.parseJSON(obj.children);
        _.each(children, function(child){
          var designation = jQuery.parseJSON(child._knownEntityDescriptionList["0"]._designation);
          child.name = child._resourceName;
          child.name_it = designation.NAME_it;
          child.name_en = designation.NAME_en;
          child.detailObj = {
            href: child._href,
            resourceName: child.name,
            defLang: self.lang,
			namespace: obj.entityID.namespace 
          };
          child.level = level;
        });
        return children;
      },

      /**
       * Go to mapping.
       */
      goToMappingNavigationMode: function(subNavigationMode){
        var self = this;

        //self.mappingList = [];
		self.navigationMode = 'mapping'; 
		self.subNavigationMode = (subNavigationMode!==undefined?subNavigationMode:'mapping-group-1');
		/*fix: set default value per selectedCsType*/
		self.selectedCsType = "STANDARD_NATIONAL_STATIC";
		
		if(self.subNavigationMode=='mapping-group-1'){
			self.loincSearchForm.selectedMappingStandard = 'LOINC';
		}
		else{
			self.loincSearchForm.selectedMappingStandard = 'ATC';
			/*if(self.mappingList.length>0){
				self.loincSearchForm.selectedMappingStandard = "mapping-"+self.mappingList[0].fullname;
			}
			else{
				self.loincSearchForm.selectedMappingStandard = "";
			}*/
		}
      },

      /**
       * Load the mapping list.
       */
      loadMappingList: function(){
        var self = this;
        self.showLoading();
        self.mappingList = [];
        self.$http.get(APP_PROPERTIES.getMappingList).then(function(response) {
          //self.mappingList = data.MapCatalogEntryDirectory.entry;
		  self.mappingList = response.body.OutputDto.entry;
		  
		  //self.mappingList.push({fullname: 'ATC – AIC'});
		  //self.mappingList.push({fullname: 'LOINC'});
          //console.log('lista mapping::', self.mappingList);
        }).finally(function(){
          self.hideLoading();
        });
      },

      /**
       * The page variable.
       */
      filteredPages: function (pageVar) {
        var from = 0;
        if(this.pageComponents[pageVar].currentPage < 3){
          from = 0;
        }else {
          from =  this.pageComponents[pageVar].currentPage - 3;
        }
        var partial = _.slice(this.pageComponents[pageVar].pages, from, from+10);
        return partial;
      },
      hasNextHidePages : function(pageVar) {
        var from = this.pageComponents[pageVar].currentPage < 3 ? 0 : this.pageComponents[pageVar].currentPage - 3;
        var partial = _.slice(this.pageComponents[pageVar].pages, from, from+10)
        return partial.length+from != this.pageComponents[pageVar].pages.length;
      },
      hasPreviousHidePages : function(pageVar) {
        //if(this.pageComponents.page.totalPages > 10 ){
          var temp = this.pageComponents[pageVar].currentPage - 3 ;
          return temp > 0 ;
        //}else {
          //return false;
        //}
      },

      /**
       * Get the code system for the lod url.
       * @param codeSystem The code system.
       * @returns Returns the code system for LOD.
       */
      getLodCodeSystem: function(codeSystem){
        var code = '';
        if(codeSystem === 'LOINC'){
          code = 'LNC';
        } else if(codeSystem === 'ICD9-CM'){
          code = "ICD9CM";
        } else if(codeSystem === 'ATC'){
          code = "UATC";
        } else if(this.pageComponents.detailObj.info.type!==undefined 
				&& this.pageComponents.detailObj.info.hasOntology == 'Y'
				&& this.pageComponents.detailObj.info.ontologyName!==undefined 
				&& this.pageComponents.detailObj.info.ontologyName!="" 
				&& (this.pageComponents.detailObj.info.type == 'LOCAL'
					|| this.pageComponents.detailObj.info.type == 'STANDARD_NATIONAL'
					|| this.pageComponents.detailObj.info.type == 'VALUE_SET')	){
			 code = this.pageComponents.detailObj.info.ontologyName;
		}
        return code;
      },

      /**
       * Get the resource name for the lod url.
       * @param resourceName The resource name.
       * @param codeSystem The code system.
       * @returns Returns the resource name for LOD.
       */
      getLodResourceName: function(resourceName, codeSystem){
        var name = resourceName;
        if(codeSystem === 'ICD9CM'){
          if(_.includes(resourceName, '-')){
            name = resourceName + '.99';
          } else {
            name = resourceName;
          }
        }
        return name;
      },
      
      /**
       * Nuova parte
       */
	   
	   /**
       * Get the list of codesystem object
       */
      loadLocals: function() {
    	  var url = APP_PROPERTIES.getLocalsList
    	  var self = this;
    	  self.$http.get(url).then(function(response) {
	          var data = response.body;
	          self.localsCode = data.JsonArray.elements;
	          //console.log(self.localsCode);
	      });
      }, 
      
	  
	   /**
       * Bind select codeSystem 
	   * @param code The codesystem object.
       */
      changeCodeSystemLocal: function(code) {
		 // console.log("changeCodeSystemLocal::")
    	  var self = this;
    	  self.localSearchFormStandard = code.members.codeSystemName.value; 
    	  self.selectedCsType = code.members.type.value;
    	  self.loincSearchForm.selectedNavigationStandard = code.members.codeSystemName.value; 
    	 
    	  
		  this.$set(this.loincSearchForm, "selectedNavigationStandard", code.members.codeSystemName.value);
          //console.log('Resetting code system local', code.members.codeSystemName.value);
          //console.log('this.loincSearchForm.selectedNavigationStandard', this.loincSearchForm.selectedNavigationStandard);
          self.resetResults();
          self.loincSearchForm.matchValue = '';

          if(self.loincSearchForm.selectedNavigationStandard !== '-1'){
            //console.log('Load things');
            var currentVersion = code.members.currentVersion.value;
            self.reloadLocalFields(code.members.codeSystemId.value, currentVersion);
          }
        },
		
	   /**
       * Bind change valueset
	   * @param code The valueset object.
       */
		changeValueSet: function(code) {
    	  var self = this;
		  if(code.members.valueSetName!==undefined){
			  self.localSearchFormStandard = code.members.valueSetName.value; 
			  self.selectedCsType = "VALUE_SET";
			  self.loincSearchForm.selectedNavigationStandard = code.members.valueSetName.value; 
			  
			  this.$set(this.loincSearchForm, "selectedNavigationStandard", code.members.valueSetName.value);
			  //console.log('Resetting valueset local', code.members.valueSetName.value);
			  //console.log('this.loincSearchForm.selectedNavigationStandard', this.loincSearchForm.selectedNavigationStandard);
			  self.resetResults();
			  self.loincSearchForm.matchValue = '';

			  if(self.loincSearchForm.selectedNavigationStandard !== '-1'){
				//console.log('Load things');
				var currentVersion = code.members.currentVersion.value;
				//self.reloadLocalFields(code.members.valueSetId.value, currentVersion);
				self.reloadFields(self.loincSearchForm.selectedNavigationStandard);
			  }
		  }

        },
        
       /**
       * Reload the field of search 
	   * @param id codesystem id
	   * @param currentVersion of codesystem
       */
        reloadLocalFields: function(id, currentVersion) {
        	var self = this;
            var promises = [];
            promises.push(self.loadCsVersions(id));
            
            Promise.all(promises).then(function(values){
//            	self.handleVersions(values[0], self.selectedMode, self.crossMappingSearch);
            	self.localCsVersions = values[0];
            	self.localSearchFormVersion = currentVersion;
            	self.executeSearchByButton(self.lang, 0);
            	
            }).finally(function() {
            	/*self.hideLoading();*/
            });
        },
        
		/**
       * Reload the version of codesystem
	   * @param csIdOrName codesystem id or name
       */
        loadCsVersions: function(csIdOrName) {
      	  var self = this;
      	  var localCsVersions = [];
      	  self.showLoading();
      	  var url = APP_PROPERTIES.getCsVersions;
      	  url = url.replace(":idOrName", csIdOrName);
		  //console.log("loadCsVersions URL ::"+url);
		
      	  return this.$http.get(url).then(function(response) {
      		 try {
   			  response.data.JsonArray.elements.forEach(function(element){
				/*console.log("id", element.members.id.value);
   				 console.log("name", element.members.name.value);*/
   				 
   				 localCsVersions.push({
   					 id: element.members.id.value,
   					 name: element.members.name.value,
					 namespace: element.members.namespace.value,
					 releaseDate: element.members.releaseDate.value
   				 });
   			  });
   		  } catch (e) {
				console.error(e);
			}
      		  return localCsVersions;
      	  }, function(error) {
      		  console.log(error);
      	  });
        },
        
		 /**
       * Get the list of valueset object
       */
        loadValueSets: function() {
      	  var url = APP_PROPERTIES.getValueSetsList
      	  var self = this;
		  //console.log("loadValueSets::"+url);
      	  self.$http.get(url).then(function(response) {
  	         var data = response.body;
			
  	          self.valueSets = data.JsonArray.elements;
  	           //console.log(JSON.stringify(self.valueSets));
  	      });
        },
		
		 /**
       * Bind select valueset in search tab
	   * @param code The valueset object.
       */
		changeValueSetSearchSelect: function() {
			var self = this;
			self.reloadFields(self.loincSearchForm.selectedSearchStandardValueSet);
			
			self.resetResults();
			self.loincSearchForm.matchValue = '';
			
			setTimeout(function(){ 
				self.loincSearchForm.dynamicField={};
				//Genera l'header dinamico per le tabelle gestite dal template local-table
				 self.getDynamicHeaderTable(self.loincSearchForm.selectedSearchStandardValueSet);
			}, 500);
			self.hideLoading();
		},
		
		
		/**
		* Reset defaul codessystem value navigation tab
		*/
		selectFirstCodeSystemAsNavigationStandard: function(subNavigationMode) {
			var self = this;
			self.navigationMode = 'code-system'; 
			
			if(subNavigationMode===undefined){
				self.localSearchFormDomain='TUTTI';
			}else{
				self.subNavigationMode = (subNavigationMode!==undefined?subNavigationMode:'codesystem-group-1');
			
				//console.log("self.subNavigationMode::"+self.subNavigationMode);
				if(self.subNavigationMode=='codesystem-group-1'){
					self.loincSearchForm.selectedNavigationStandard='ICD9-CM'; 
					
					self.changeCodeSystem(); 
					self.loadLocals();
				}
				else{
					
					var code = null;
					_.each(self.localsCode, function(element){
						if(element.members.codeSystemName!==undefined  && element.members.type!==undefined && element.members.type.value=="LOCAL" && code==null){
							//console.log(JSON.stringify(element.members.codeSystemName.value),JSON.stringify(element.members.type.value));
							code = element;
						}
					});
					//console.log("codeSystem:"+JSON.stringify(code));
					
					self.changeCodeSystemLocal(code); 
				}
			}
		},
		
				 /**
		* Reset defaul valueset value navigation tab
		*/
		selectFirstValueSetAsNavigationStandard: function() {
			var self = this; 
			self.navigationMode = 'value-set'; 
			if(self.valueSets!==undefined && self.valueSets.length>0){
				var vs = self.valueSets[0];
				self.loincSearchForm.selectedNavigationStandard=vs.members.valueSetName.value;
				self.changeValueSet(vs);
			}
			else{
				self.loincSearchForm.selectedNavigationStandard=''
			}
		},
		
		
		/**
		* Reset defaul codessystem value export tab
		*/
		selectFirstCodeSystemAsExport: function(subExportMode) {
			var self = this;
			self.exportMode = 'code-system'; 
			self.subExportMode = (subExportMode!==undefined?subExportMode:'codesystem-group-1');
		
			//console.log("self.subNavigationMode::"+self.subNavigationMode);
			if(self.subExportMode=='codesystem-group-1'){
				self.exportResource = 'ICD9-CM';
				self.exportResourceType='STANDARD_NATIONAL_STATIC'; 
				self.loadExportProperties(); 
			}
			else{
				var code = null;
				_.each(self.localsCode, function(element){
					if(element.members.codeSystemName!==undefined  && element.members.type!==undefined && element.members.type.value=="LOCAL" && code==null){
						code = element;
					}
				});
				//console.log("codeSystem:"+JSON.stringify(code));
				self.exportResource=code.members.codeSystemName.value; 
				self.exportResourceType=code.members.type.value; 
				self.loadExportProperties(); 
			}
			
		},
		
		
		 /**
		* Reset defaul valueset value export tab
		*/
		selectFirstValueSetAsExport: function() {
			var self = this; 
			self.exportMode = 'value-set'; 
			if(self.valueSets.length>0){
				var vs = self.valueSets[0];
				//self.loincSearchForm.selectedNavigationStandard=vs.members.valueSetName.value;
				self.exportResource=vs.members.valueSetName.value 
				self.exportResourceType=vs.members.type.value; 
				self.loadExportProperties(); 				
			}
			else{
				self.loincSearchForm.selectedNavigationStandard=''
			}
		},
		
		
		/**
       * Go to mapping export
       */
      goToMappingExportMode: function(subExportMode){
        var self = this;

        //self.mappingList = [];
		self.exportMode = 'mapping'; 
		self.subExportMode = (subExportMode!==undefined?subExportMode:'mapping-group-1');
		
		if(self.subExportMode=='mapping-group-1'){
			self.loincSearchForm.selectedMappingStandard = 'LOINC';
		}
		else{
			self.loincSearchForm.selectedMappingStandard = 'ATC';
		}
      },
		

		
		
		 /**
		   * Bind select valueset in search tab
		   * @param code The valueset object.
		   */
		changeMappingSearchSelect: function() {
			var self = this;
			//console.log(self.loincSearchForm.selectedSearchStandardMapping);
			 self.searchMappingCodes(self.loincSearchForm.selectedSearchStandardMapping,0);
			 self.loincSearchForm.matchValue = ''
		},
		
		executeMappingSearchByButton: function(lang,page) {
			var self = this;
			var fullname = self.loincSearchForm.selectedSearchStandardMapping;
			if(fullname=='TUTTI'){
				fullname = self.loincSearchForm.selectedMultiStandardMapping;
			}
			self.searchMappingCodes(fullname,page);
		},
		
		executeMappingSearchNavigatorByButton: function(lang,page) {
			var self = this;
			var fullname = self.loincSearchForm.selectedMappingStandard;
			fullname=fullname.replace("mapping-","");
			self.searchMappingCodes(fullname,page);
		},
		
	
		
		 /**
		   * Change Type Search in search tab 
		   * @codeSystemName type search [CODESYSTEM,VALUESET,MANAGING]
		   */
		changeTypeSearch: function(codeSystemName){
			var self = this;
			
			self.resetResults();
			self.loincSearchForm.matchValue = '';
			
			self.loincSearchForm.selectedSearchStandardCodeSystem = 'TUTTI';
			self.loincSearchForm.selectedSearchStandardValueSet = 'TUTTI';
			self.loincSearchForm.selectedSearchStandardMapping = 'TUTTI';
			
			if(self.loincSearchForm.typeSearch=='CODESYSTEM'){
				self.loadLocals();
				if(self.codeSystemsRemote[0]!==undefined){
					self.loincSearchForm.selectedMultiStandardCodeSystem = self.codeSystemsRemote[0].name;
				}
			}else if(self.loincSearchForm.typeSearch=='VALUESET'){
				self.loadValueSets();
				if(self.valueSets[0]!==undefined){
					self.loincSearchForm.selectedMultiStandardValueSet = self.valueSets[0].members.valueSetName.value;
				}
			}else if(self.loincSearchForm.typeSearch=='MAPPING'){
				
				self.loadMappingList();
				self.readAllLocalCodes();
				self.loincSearchForm.selectedMultiStandardMapping = MAPPING_ATC_AIC_DEFAULT_VALUE.codeDescription;
				/*
				setTimeout(function(){ 
					if(self.mappingList[0]!==undefined){
						self.loincSearchForm.selectedMultiStandardMapping = self.mappingList[0].fullname; 
					}
				}, 500);
				*/
			}
		},
		

		/**
		   * Get the headers of table by codeSystem name 
		   * @codeSystemName code system name
		   */
		getDynamicHeaderTable: function(codeSystemName){
			//console.log("getDynamicHeaderTable::"+codeSystemName);
			var self = this;
			defaultHeaderTable = [];
			dynamicHeaderTable = [];
			
			
			if(codeSystemName!==undefined && _.indexOf(self.codeSystemsNotStandardLocal, codeSystemName)==-1){
				
				var urlParams = "";
				if(self.selectedMode=='normal'){ //TAB RICERCA
					if(self.getSelectedVal()=='TUTTI' && _.indexOf(self.codeSystemsNotStandardLocal, self.getMultiStandardSelectedVal())!=-1 ){
						//console.log("::non eseguito::");
						return;
					}
				}
				if(self.selectedMode=='export'){ //TAB EXPORT
					//
				}
				
				//recupero i mtadata_parameter del CS/VS per recuperare la posizione
				
				if(self.loincSearchForm.typeSearch===undefined || self.loincSearchForm.typeSearch=='CODESYSTEM'){
					urlParams =  APP_PROPERTIES.getCodeSystemSolrFields.replace("{CS_NAME}",codeSystemName);
				}else if(self.loincSearchForm.typeSearch=='VALUESET'){
					urlParams = APP_PROPERTIES.getValueSetSolrFields.replace("{VS_NAME}",codeSystemName);
				}
				//console.log("urlParams::"+urlParams);
				
				var orderSolrFields = [];
				self.$http.get(urlParams).then(function(response) {
					var data = response.body;
					var array = data.JsonArray.elements;
					var dbFieldsIt = [];
					var dbFieldsEn = [];
					_.each(array, function(element){
						//console.log("element::"+JSON.stringify(element));
						var field = "";
						var lang = "";
						var position=0;
						if(element.members.name!==undefined){
							field = element.members.name.value;
						}
						if(element.members.lang!==undefined){
							lang = element.members.lang.value.toLowerCase();
						}
						if(element.members.position!==undefined){
							position = element.members.position.value;
						}
						
						if(!_.startsWith(field,'DF_M_')){
							if(lang=='it'){
								dbFieldsIt.push({"field":field,"position":position});
							}
							if(lang=='en'){
								dbFieldsEn.push({"field":field,"position":position});
							}
						}
						
						
						
					});


					
					orderSolrFields = dbFieldsIt.concat(dbFieldsEn);
					orderSolrFields = _.sortBy(orderSolrFields,"position");
					
					//console.log("dbFieldsIt::"+JSON.stringify(dbFieldsIt));
					//console.log("dbFieldsEn::"+JSON.stringify(dbFieldsEn));
					//console.log("orderSolrFields::"+JSON.stringify(orderSolrFields));
					

					_.each(orderSolrFields, function(elem,key){
						//console.log("field::"+elem.field+" position::"+elem.position);
						dynamicHeaderTable.push(elem.field);
					});
					
					
					/*default field*/
					defaultHeaderTable.push("message.labelCode");
					defaultHeaderTable.push("message.labelDescription");
					
					/**
					* https://vuejs.org/v2/guide/list.html#Caveats
					*/
					Vue.set(self, 'defaultHeaderTable', defaultHeaderTable);
					Vue.set(self, 'dynamicHeaderTable', dynamicHeaderTable);
					
				}, function(error) {
					noty({text: 'Si è verificato un errore durante la ricerca. Si prega di riprovare', type: 'error', timeout:5000});
				}).finally(function() {
				  
				});
			}
		},
		
		/**
		   * Get the First Nodes of the classification 
		   * @codeSystemName code system name
		   */
		loadFirstNodesClassification: function(codeSystem){
			var self = this;
			var url = _.replace(APP_PROPERTIES.getFirstNodesClassification, '{CODE_SYSTEM}', codeSystem);
			var url = _.replace(url, '{LANG}', self.lang);
			
			//console.log("urlChapter::"+url);
			return self.$http.jsonp(url, {
				jsonp: 'json.wrf'
			}).then(function(response){
			  var nodes = response.body.response.docs;
			  //Normalize the chapter
			  var array = [];
			  
			  array.push({
				  label: self.$t("message.labelAllMale", self.lang),
				  value: '-1',
				});
				
			_.each(nodes, function(node){
				var value = node.CS_CODE;
				var label = "";
				if(node["CS_DESCRIPTION_"+self.lang]!==undefined){
					label = node["CS_DESCRIPTION_"+self.lang];
				}
				else{
					label = value;
				}
				
				array.push({
					value: value,
					label: label,
				});
			  });
				//console.log("array::"+JSON.stringify(array));
			  return array;
			}, function(response){
			  console.error('Error trying to retrieve the', field, 'field');
			  return [];
			}).finally(function(){
				self.hideLoading();
			});
		},
		
		/**
	   * Get list of domain 
	   */
		loadDomains: function() {
    	  var self = this;
    	  self.domains = [];
    	  self.showLoading();
    	  var url = APP_PROPERTIES.getDomains;
    	  this.$http.get(url).then(function(response) {
    		  try {
    			  response.data.JsonArray.elements.forEach(function(element){
    				 /*self.domains.push({
    					 key: element.members.key.value,
    					 name: element.members.name.value,
						 position: element.members.position.value
    				 });*/
					  self.domains.push({
    					 value: element.members.key.value,
    					 label: element.members.name.value,
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
	  
	  /**
	   * Filter on self.localsCode 
	   */
	  codeSystemDomainFilter: function() {
		//console.log("codeSystemDomainFilter");
		var self = this;
		var domain = '';
		
		if(self.localSearchFormDomain!==undefined && self.localSearchFormDomain!='TUTTI'){
			domain = self.localSearchFormDomain;
		}
		else{
			domain = 'TUTTI';
		}
				
		//console.log("domain::"+domain);

		if(domain!==undefined && domain!='TUTTI'){
			/*filtro su codesystem*/
			var listCsTmp=[];
			var url = APP_PROPERTIES.getLocalsList
			  var self = this;
			  self.$http.get(url).then(function(response) {
				  var data = response.body;
				  _.each(data.JsonArray.elements, function(element){
					  //console.log(element.members.domain.value);
						if(element.members.domain!==undefined && element.members.domain.value==domain){
							listCsTmp.push(element);
						}
					});
				  
			  });
			self.localsCode = listCsTmp;
			//console.log(self.localsCode);
			
			/*filtro su valuset*/
			var listVsTmp=[];
			var url = APP_PROPERTIES.getValueSetsList
			  var self = this;
			  self.$http.get(url).then(function(response) {
				  var data = response.body;
				  _.each(data.JsonArray.elements, function(element){
					  //console.log(element.members.domain.value);
						if(element.members.domain!==undefined && element.members.domain.value==domain){
							listVsTmp.push(element);
						}
					});
				  
			  });
			self.valueSets = listVsTmp;
			//console.log(self.valueSets);
			
			/*filtro su mapping*/
			
			/*svuoto i risultati in pagina*/
			self.versions=[];
			self.localCsVersions=[];
			self.pageComponents.loincSearchResults=[];
			self.loincSearchForm.selectedNavigationStandard='';
		}
		else{
			self.loadLocals();
			self.loadValueSets();
		}
			
	  },
	  
	  prevVersion: function(detailObj,key){
		detailObj.href = detailObj.hrefPrev;
		if(key === 'LOINC'){
          this.openLoincDetailModal(detailObj, false);
        } else if(key === 'ICD9-CM'){
          this.openIcd9CmDetailModal(detailObj, false);
        } else if(key === 'ATC'){
          this.openAtcDetailModal(detailObj, false);
        } else if(key === 'AIC'){
          this.openAicDetailModal(detailObj, false);
        }else{
         this.openStandardLocalDetailModal(detailObj, false, true);
        }
	  },
	  
	  nextVersion: function(detailObj,key){
		detailObj.href = detailObj.hrefNext;
		if(key === 'LOINC'){
          this.openLoincDetailModal(detailObj, false);
        } else if(key === 'ICD9-CM'){
          this.openIcd9CmDetailModal(detailObj, false);
        } else if(key === 'ATC'){
          this.openAtcDetailModal(detailObj, false);
        } else if(key === 'AIC'){
          this.openAicDetailModal(detailObj, false);
        }else{
          this.openStandardLocalDetailModal(detailObj, false, true);
        }
	  },
	  
	  
	  
	  
	  /*query su db*/
	  getListOfValuesForField: function(fields){
		var self = this;  
		
			
		_.each(fields, function(fieldName, idx) {
			setTimeout(function () {
				var name = "";
				var url = APP_PROPERTIES.getValuesForFieldDB;
				
				var currentVersion = "";
				if(self.loincSearchForm.typeSearch=="CODESYSTEM"){
					name = self.loincSearchForm.selectedSearchStandardCodeSystem;
					currentVersion = _.find(self.codeSystemsRemote, {name: name}).currentVersion;
				}else if(self.loincSearchForm.typeSearch=="VALUESET"){
					name = self.loincSearchForm.selectedSearchStandardValueSet;
					 _.each(appVue.valueSets, function(obj){
						if(obj.members.valueSetName.value == name){
							if(currentVersion==""){
								currentVersion = obj.members.currentVersion.value;
							}
						}				
					})
					
				}
				
				
				
				var fieldNameQueryValue = fieldName.trim().replace("DF_S_","").replace("DF_D_","").replace("DF_N_","").replace("DF_M_","").replace("_it","").replace("_en","");
				url = url.replace("{CODE_SYSTEM}",name).replace("{VERSION_NAME}",currentVersion).replace("{FIELD_NAME}",fieldNameQueryValue).replace("{LANG}",self.langSearch);
				  
				var elem = _.find(self.loincSearchForm.dynamicFieldValue, {fieldName: fieldName});
				//console.log("elem :: "+JSON.stringify(elem));
				if(elem==undefined){
					//console.log("url :: "+url);
					
					 self.$http.get(url).then(function(response) {
						  //console.log(JSON.stringify(response));
							var list = response.body.ArrayList;
							
							list = [self.$t("message.labelAllFemale", self.lang)].concat(list)
							
							
							self.loincSearchForm.dynamicFieldValue.push({
								'fieldName':fieldName,
								listValue:list
							});
							Vue.set(self.loincSearchForm, 'dynamicFieldValue', self.loincSearchForm.dynamicFieldValue);
					  }, function(error) {
						  console.log(error);
					  })
					

				  }
				else{
					//console.log("già presente::");
				}
			}, 200 + idx);
		});
	  }
 
    },

    computed : {
      getLodViewHref: function() {
        var iri = APP_PROPERTIES.virtuoso + "/ontology/{{codeSystem}}/{{resourceName}}&sparql=" + APP_PROPERTIES.virtuoso + "/sparql&prefix=" + APP_PROPERTIES.virtuoso + "/";
    	var href = "http://lodview.it/lodview/?IRI=" + iri;
        var codeSystem = this.getLodCodeSystem(this.pageComponents.detailObj.info.codeSystemName);
        var resourceName = this.getLodResourceName(this.pageComponents.detailObj.resourceName, codeSystem);
    	href = _.replace(href, "{{resourceName}}", resourceName);
        href = _.replace(href, "{{codeSystem}}", codeSystem);
    	return href;
      },
      getLodLiveHref: function() {
        var parameter = APP_PROPERTIES.virtuoso + "/ontology/{{codeSystem}}/{{resourceName}}";
    	var href = "http://lodlive.it/?" + parameter;
        var codeSystem = this.getLodCodeSystem(this.pageComponents.detailObj.info.codeSystemName);
        var resourceName = this.getLodResourceName(this.pageComponents.detailObj.resourceName, codeSystem);
    	href = _.replace(href, "{{resourceName}}", resourceName);
        href = _.replace(href, "{{codeSystem}}", codeSystem);
    	return href;
      },
      disableExportOnSearch: function() {
          return !(this.searchExecuted && this.pageComponents.loincSearchResults.length > 0);
      },
	  disableExportOnSearchMapping: function(){
		  return !(this.searchExecuted && this.localCodes.length > 0);
	  },
	  currentCsSelectedIsClassification: function(){
			try{
				var isClassification = _.find(this.codeSystemsRemote, {name: this.loincSearchForm.selectedSearchStandardCodeSystem}).isClassification;
				if(isClassification!==undefined){
					return isClassification;
				}
				else{
					return false;
				}
			}
			catch(e){
				//console.log("currentCsSelectedIsClassification::"+e);
				return false;
			}
	},
	getLabelFromSubNavigationMode: function(){
		if(this.navigationMode === 'value-set'){
			//return this.$t("message.labelValueSet", this.lang);
			return "";
        }else if(this.subNavigationMode === 'codesystem-group-1'){
			return this.$t("message.labelCodeSystem", this.lang) +" "+ this.$t("message.labelCodeSystemStandardNational", this.lang);
        } else if(this.subNavigationMode === 'codesystem-group-2'){
			return this.$t("message.labelCodeSystem", this.lang) +" "+ this.$t("message.labelCodeSystemLocals", this.lang);
        } else if(this.subNavigationMode === 'mapping-group-1'){
			//return this.$t("message.labelMappingG1", this.lang);
			return "";
        }else if(this.subNavigationMode === 'mapping-group-2'){
			return this.$t("message.labelMappingG2", this.lang);
        }
	  },
	  
	 
	 getLabelFromExportMode: function(){
		if(this.exportMode === 'value-set'){
			//return this.$t("message.labelValueSet", this.lang);
			return "";
        }
		else if(this.exportMode === 'mapping'){
			if(this.exportResource === 'LOCAL-LOINC'){
				//return this.$t("message.labelMappingG1", this.lang);
				return "";
			}
			if(this.exportResource === 'genericMapping'){
				//return this.$t("message.labelMappingG2", this.lang);
				return "";
			}
        } else if(this.subExportMode === 'codesystem-group-1'){
			return this.$t("message.labelCodeSystem", this.lang) +" "+this.$t("message.labelCodeSystemStandardNational", this.lang);
        } else if(this.subExportMode === 'codesystem-group-2'){
			return this.$t("message.labelCodeSystem", this.lang) +" "+ this.$t("message.labelCodeSystemLocals", this.lang);
        }
	},

    },
	



    watch : {
      /**
       * On language change.
       */
      lang: function(){
        this.reloadFields();
      }
    },

    mounted : function() {
		console.log("Mounted");
		this.loadRelations();
		this.changeSelectedMode();
		this.getCodeSystems();				
		this.loadLocals();
		this.loadDomains();
		
		
		this.loadValueSets();
		this.loadMappingList();
	}
  });
});
