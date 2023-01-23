<#-- Migrated using FreeMarker USCavalry-->

<#-- Converted each entry in the form "<#call something" back into the form "#something" because is an error in conversion-->

<#-- Converted some "${variable}" entry back into the form "$variable" where the variable is not related to FreeMarker -->

<#-- web content structure. -->

<#-- Please use the left panel to quickly add commonly used variables. -->
<#-- Autocomplete is also available and can be invoked by typing "$". -->


<#-- define "d" as dollar char  "$" in javascript: usage ${d} -->

<#assign d = "$">



<!-- CSS  -->

 <link rel="stylesheet" type="text/css" href="/sti-search-portlet/resources/libs/flags/flags.css">
	
 <link rel="stylesheet" type="text/css" href="http://netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.css">
	
 
 <!-- JS LIBS  -->

 <script src="/sti-search-portlet/resources/libs/jquery-3.1.1.min.js">
</script>
 
 <script src="/sti-search-portlet/resources/libs/vue.min.js">
</script>
 
 <script src="https://cdn.jsdelivr.net/vue.resource/1.0.3/vue-resource.min.js">
</script>
 
 <script src="https://cdn.jsdelivr.net/vue.i18n/4.9.0/vue-i18n.min.js">
</script>
 
 <script src="https://cdn.jsdelivr.net/vue.i18n/4.9.0/vue-i18n.min.js">
</script>
 
 <script src="/sti-search-portlet/resources/libs/blockui-2.70/jquery.blockUI.js">
</script>
 
 <script src="/sti-search-portlet/resources/libs/lodash.js">
</script>
 
 <script src="/sti-search-portlet/resources/libs/bootstrap-modal.js">
</script>
 
 <script src="/sti-search-portlet/resources/libs/moment-with-locales.js">
</script>
 
 
<!-- JS APP  -->

 <script src="/sti-search-portlet/resources/js/LangProperties.js">
</script>
 
  <script src="/sti-search-portlet/resources/js/set-environment-svil.js">
</script>
 
 
 
<style>

.modal-hide {
  display: none;
}
.aui .modal{
  width: 900px !important;
  left: 39% !important;
}
.detail-modal .modal-body {
	min-height: 300px !important;
	max-height: 400px !important;
}
.table-condensed td.padding-left-30 {
  padding-left: 30px;
}
.table-condensed td.padding-left-60 {
  padding-left: 60px;
}
.table-condensed td.padding-left-90 {
  padding-left: 90px;
}
.table-condensed td.padding-left-120 {
  padding-left: 120px;
}
.table-condensed td.padding-left-150 {
  padding-left: 150px;
}
</style>

 

<script type="text/javascript">


	/*Properties*/		
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

	
	var STANDARD_PROPERTIES = {
		  jsonFormatHttpParam : "&format=json",
		  pathGetRelations: ENV_PROPERTIES.basePath + "/cts2framework/associations?list=true",
		  getCodeSystemSolrFields: ENV_PROPERTIES.basePath + "/cts2framework/extras/cs/{CS_NAME}/solrextrafields?format=json",
		  getValueSetSolrFields: ENV_PROPERTIES.basePath + "/cts2framework/extras/vs/{VS_NAME}/solrextrafields?format=json",
		  urlDetail: ENV_PROPERTIES.basePath + "/cts2framework/codesystem/__NAME__/version/__VERSION__/entity/__NAME__:__CODE__",
		  pathManageGetCodeSystem: ENV_PROPERTIES.basePath + "/sti-gestione-portlet/api/manage/codeSystems",
		  getCsVersions: ENV_PROPERTIES.basePath + "/cts2framework/extras/cs/:idOrName/versions?format=json",
		  getLanguages: ENV_PROPERTIES.basePath + "/cts2framework/extras/languages/NAME/VERSION_NAME",  
	};
	
	/*************/
	var APP_PROPERTIES = _.merge(ENV_PROPERTIES, STANDARD_PROPERTIES);
	
	Vue.filter('clearUnderscore', function (value) {
	    return value.trim().split("_").join(" ");
	});
	
	/* TODO: verificare dove applicare */
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
	
	/*app*/
	var appVue;
	
	$(document).ready(function(){
		
		
		appVue = new Vue({
			
		    el: '#app',
		    
		    data: {
		    	lang: 'it',
		    	name: '',
		    	version: '',
		    	prevVersion: '',
		    	type: '',
		    	categoriaChangelog: '',
				detailsTab : "tab-details",
				openDetailCurrentVersion: true,
				codeSystemsRemote: [],
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
		            }

		          },
		          
		    	enIsPresent:false,
		    	itIsPresent:false,
		    	
		    },
		    	

		    methods: {
		    	/**
		    	*open dialog detail
		    	*/
		    	openStandardLocalDetailModal: function(newDetailObj, toggleModal, code){
		    		//console.log("openStandardLocalDetailModal::"+code);
		    		var self = this;
		    		
		            this.detailsTab = "tab-details";
		            self.overlayOn("detailModalStandardLocal");
		    		
		    		toggleModal = _.defaultTo(toggleModal, true);
		    		if(toggleModal){
		    			$('#detailModalStandardLocal').modal('toggle');
		    		}
		    		
		    		
		    		var urlDetail="";
		    		if(self.openDetailCurrentVersion){
		    			urlDetail = _.replace(APP_PROPERTIES.urlDetail, /__NAME__/g, self.name).replace("__VERSION__",self.version).replace("__CODE__",code);
		    		}
		    		else{
		    			urlDetail = _.replace(APP_PROPERTIES.urlDetail, /__NAME__/g, self.name).replace("__VERSION__",self.prevVersion).replace("__CODE__",code);
		    		}
		    		
		    		
		    		
		    		if(newDetailObj==null){
		    			newDetailObj={};
		    			newDetailObj.namespace = self.name;
		    			newDetailObj.defLang='it';
		    			newDetailObj.resourceName=code;
		    			newDetailObj.href=urlDetail;
		    		}
		    		
		    		
		    		
		    		
		    		var levelCs = newDetailObj.level;
		    		var namespace = newDetailObj.namespace;
		    		if(levelCs!==undefined && levelCs>
0){
		    			namespace = newDetailObj.name.namespace;
		    		}
		    		
		    		var otherVersionsPromise = self.loadCsVersions(namespace);
		    		var otherVersions = [];
		    		otherVersionsPromise.then(function(values){
		              	otherVersions = values;
		            }).finally(function() {
		                //self.hideLoading();
		            });
		    		
		    		

		    		//console.log("urlDetail::"+urlDetail);
		    		
		    		
		            self.getDetailsAlt(urlDetail).then(function(response){
		              if(response && response.status===200) {
		               
		                var obj = response.body.EntityDescriptionMsg.entityDescription.namedEntity;

		                var it = {};
		                var en = {};
		                var info = {};
						
		               
		                info.codeSystemName = obj.describingCodeSystemVersion.codeSystem.content;
		                info.codeSystemVersion = obj.describingCodeSystemVersion.version.content;
		                //info.otherVersions = obj.alternateEntityID;
		                info.otherVersions = otherVersions;
		                info.namespace = newDetailObj.namespace;
		    			info.additionalInfo=[];
		    			
		    			try{
		    				info.releaseDate = _.find(otherVersions, {name: info.codeSystemVersion}).releaseDate;
		    			}
		    			catch(e){
		    				console.log("ERROR::"+e);
		    			}
		    			
		    			
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
		    			
		    			
		    			try{
			    			 //START Retrieve hierarchical relationships
			    			var level = 0;
			    			var parents = self.retrieveParents(obj, false);
			    			if(parents && parents.length >
 0){
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
		    			}
		    			catch(e){
		    				console.log("ERROR::"+e);
		    			}
		    			 
		    			/**
		    			 * https://vuejs.org/v2/guide/list.html#Caveats

		    			 */
		    			
		    			Vue.set(this.pageComponents.detailObj, "info", info);
		    			Vue.set(this.pageComponents.detailObj, "it", it);
		    			Vue.set(this.pageComponents.detailObj, "en", en);
		    			
		    			
		              }
		            }, function(error) {
		    			//noty({text: 'Impossibile recuperare il dettaglio. Si è verificato un errore', type: 'error', timeout:5000});
		    			console.log(error);
		            }).finally(function() {
		    			self.overlayOff("detailModalStandardLocal");
		    			this.sortAdditionalInfo();
		    			this.loadDetailsRelations(newDetailObj);
		    			this.addLanguageAvaiable(newDetailObj);
		            });

		    		self.pageComponents.detailObj.resourceName = newDetailObj.resourceName;
		    		self.pageComponents.detailObj.defLang = newDetailObj.defLang;
		    	},
		        getDetailsAlt : function(href) {
		            this.pageComponents.detailObj = new SearchDetailObject();
		            var url = href+"?"+APP_PROPERTIES.jsonFormatHttpParam;
		            //console.log(url);
		            return this.${d}http.get(url).then(function(response){
		                return response;
		            });
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
		    		if(self.categoriaChangelog=='CodeSytem'){
		    			urlParams =  APP_PROPERTIES.getCodeSystemSolrFields.replace("{CS_NAME}",info.codeSystemName);
		    		}else if(self.categoriaChangelog=='ValueSet'){
		    			urlParams = APP_PROPERTIES.getValueSetSolrFields.replace("{VS_NAME}",info.codeSystemName);
		    		}
		    		console.log("urlParams::"+urlParams);
		    		
		    		
		    		self.${d}http.get(urlParams).then(function(response) {
		    			var data = response.body;
		    			if(data.JsonArray!==undefined){
		    				var array = data.JsonArray.elements;
			    			
			    			
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
		    			}
		    			
		    		}, function(error) {
		    			noty({text: 'Si è verificato un errore durante la ricerca. Si prega di riprovare', type: 'error', timeout:5000});
		    		}).finally(function() {
		    		  
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
		          self.${d}http.get(url).then(function(response){
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
		                finalMappingRelations[namespace] = [];
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
		        ifArrayReturnsString: function(value){
		        	if(_.isArray(value)){
						value = _.join(value);
					}
					return value;
				},
				
				
				
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

				getPrevVersion: function(){
					var self = this;
					self.openDetailCurrentVersion=false;
					self.openStandardLocalDetailModal(null, false, self.pageComponents.detailObj.resourceName);
				},
				 
				getCurrentVersion: function(){
					var self = this;
					self.openDetailCurrentVersion=true;
					self.openStandardLocalDetailModal(null, false, self.pageComponents.detailObj.resourceName);
				},
				
				
				/**
		    	*return value from object and path
		    	*/
				getValue: function(object, path){
					return _.get(object, path, '');
				},
				
				
		        overlayOn: function(idElem){
					var blockOptions = {
						message : '<h3>
' + Vue.t('message.labelLoading', self.lang) + '<h3>
'
					};
					 	 
					blockOptions.css = {
						"margin-left": '33%',
						"margin-top": '10%'
					};
		    		$("#"+idElem).block(blockOptions);
		        },
		        overlayOff: function(idElem){
		    		$("#"+idElem).unblock({});
		        },
		        getCodeSystems: function() {
		      	  var self = this;
		      	  var url = APP_PROPERTIES.pathManageGetCodeSystem;
		      	  this.${d}http.get(url).then(function(response) {
		      		  self.codeSystemsRemote = response.data;
		      	  }, function(error) {
		      		  console.log(error);
		      	  })
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
		         * Reload the version of codesystem
		  	   * @param csIdOrName codesystem id or name
		         */
		         loadCsVersions: function(csIdOrName) {
		        	  var self = this;
		        	  var localCsVersions = [];
		        	  var url = APP_PROPERTIES.getCsVersions;
		        	  url = url.replace(":idOrName", csIdOrName);
		  		  	//console.log("loadCsVersions URL ::"+url);
		  		
		        	  return this.${d}http.get(url).then(function(response) {
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
		          
		          
		      	addLanguageAvaiable: function(){
		    		var self = this;
		    		var url = APP_PROPERTIES.getLanguages;
		    		self.itIsPresent= false;
		    		self.enIsPresent= false;
		    		url = url.replace("NAME",self.pageComponents.detailObj.info.codeSystemName);
		    		url = url.replace("VERSION_NAME",self.pageComponents.detailObj.info.codeSystemVersion);
		    		//console.log("GET LANGUAGE URL::"+url);

		    		self.${d}http.get(url).then(function(response){
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
		          }
		    },


		    watch : {
		    },

		    mounted : function() {
		    	console.log("mounted");
		    	this.getCodeSystems();
				this.name = $("#name").val();
	    		this.version = $("#version").val();
	    		this.prevVersion = $("#prevVersion").val();
	    		this.type = $("#type").val();
	    		this.categoriaChangelog = $("#categoriaChangelog").val();
	    		
		    }
		});
	});	

	
</script>



 
<div id="app">

	<div class="row-fluid">

		<div class="span12">

			
			<input type="hidden" id="name" value="${code_system.getData()}">

			<input type="hidden" id="version" value="${versione.getData()}">

			<input type="hidden" id="prevVersion" value="${versione_precedente.getData()}">

	 		<input type="hidden" id="type" value="${tipo.getData()}">

	 		<input type="hidden" id="categoriaChangelog" value="${categoria_changelog.getData()}">

		
			<div class="card">

			  <div class="card-body">

				  <h5 class="card-title">

				  	<#if tipo.getData() != "MAPPING">
					  <#if validator.isNotNull(versione_precedente_label) && versione_precedente_label.getData() != "">
							<i class="text-muted">
Nuova versione </i>

						</#if>
						<#if validator.isNull(versione_precedente_label) || versione_precedente_label.getData() == "">
							<i class="text-muted">
Inserimento versione </i>

						</#if>
						${versione_label.getData()}<br>

					</#if>
					<#if tipo.getData() == "MAPPING">
						Inserimento Mapping
					</#if>
				 </h5>

				
				<#if validator.isNotNull(versione_precedente_label) && versione_precedente_label.getData() != "">
					<h6 class="card-subtitle mb-2 text-muted">
Versione Precedente: ${versione_precedente_label.getData()}</h6>

				</#if>
				
				
				<#if validator.isNotNull(data_creazione) && data_creazione.getData() != "">
					<p class="card-text">
Creato il: ${data_creazione.getData()}</p>
				
				</#if>
				
				<#if validator.isNotNull(totale_codici_importati) && totale_codici_importati.getData() != "">
					<p class="card-text">
Codici importati: ${totale_codici_importati.getData()}</p>
		
				</#if>
				
				<#if validator.isNotNull(codici_aggiunti) && codici_aggiunti.getData() != "">
					<p class="card-text">
Nuovi Codici: ${codici_aggiunti.getData()}</p>
		
				</#if>
				
				<#if validator.isNotNull(codici_rimossi) && codici_rimossi.getData() != "">
					<p class="card-text">
Codici Rimossi: ${codici_rimossi.getData()}</p>

				</#if>
				
				<#if validator.isNotNull(lingue_importate) && lingue_importate.getData() != "">
					<p class="card-text">
Lingue importate: ${lingue_importate.getData()}</p>

				</#if>
				
				<#if validator.isNotNull(codici_modificati) && codici_modificati.getData() != "">
					<p class="card-text">

						Codici modificati:
						<#if codici_modificati.getData().indexOf(";") != -1>
<#assign array_codici_modificati = codici_modificati.getData().split(";")>
							
							<#foreach codice in array_codici_modificati>
			    				<a href="#" class="card-link dialog" v-on:click="openStandardLocalDetailModal(null,true,'${codice}')">

									${codice};&nbsp
								</a>

							</#foreach>
						</#if>
						<#if codici_modificati.getData().indexOf(";") == -1>
							<a href="#" class="card-link dialog" v-on:click="openStandardLocalDetailModal(null,true,'${codici_modificati.getData()}')">

								${codici_modificati.getData()};&nbsp
							</a>

						</#if>
						
					</p>

				</#if>
			  </div>

			</div>

		</div>

	</div>

	
	
	
	
	
	
	
	
	
	
	
	<!-- STANDARD/LOCAL -->

	<div class="modal modal-hide detail-modal"  id="detailModalStandardLocal">

		<div class="modal-header">

			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
&times;</button>

			
			<h3>

				{{ pageComponents.detailObj.resourceName }} - {{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.description') }} - {{ pageComponents.detailObj.info.codeSystemVersion | clearVersionForView}}
			</h3>

			    
   			 <div class="row-fluid">

   			 	<div class="span6">
</div>

				<div class="span4 pull-right margin-left-10">

					<div class="row-fluid">

						<button v-if="openDetailCurrentVersion" class="btn btn-primary btn-xs" v-on:click="getPrevVersion()">

							{{ $t("message.labelVersion", lang) }} {{  prevVersion | clearVersionForView}}
						</button>

						<button v-if="!openDetailCurrentVersion" class="btn btn-primary btn-xs" v-on:click="getCurrentVersion()">

							{{ $t("message.labelVersion", lang) }} {{  version | clearVersionForView}}
						</button>

					</div>

				</div>

			</div>

		</div>

		<div class="modal-body">

			<ul class="nav nav-tabs">

				<li v-bind:class="{ active: detailsTab=='tab-details' }" v-on:click="detailsTab='tab-details'">

					<a href="#tab-details">
{{ $t("message.labelDetails", lang) }}</a>

				</li>

				<li v-bind:class="{ active: detailsTab=='tab-additional-info' }" v-on:click="detailsTab='tab-additional-info'">

					<a href="#labelAdditionalInfo">
{{$t("message.labelAdditionalInfo", lang) }}</a>

				</li>

				<li v-if="pageComponents.detailObj.info.isClassification" v-bind:class="{ active: detailsTab=='tab-hierarchical-relationships' }" v-on:click="detailsTab='tab-hierarchical-relationships'">

					<a href="#labelHierarchicalRelationships">
{{$t("message.labelHierarchicalRelationships", lang) }}</a>

				</li>

				<li v-bind:class="{ active: detailsTab=='tab-mapping' }" v-on:click="detailsTab='tab-mapping'">

					<a href="#translations">
{{ $t("message.labelMapping", lang) }}</a>

				</li>

				<li v-bind:class="{ active: detailsTab=='tab-versions' }" v-on:click="detailsTab='tab-versions'">

					<a href="#translations">
{{ $t("message.labelVersions", lang) }}</a>

				</li>

				<li v-bind:class="{ active: detailsTab=='tab-hl7specs' }" v-on:click="detailsTab='tab-hl7specs'">

					<a href="#translations">
{{ $t("message.labelHL7Specs", lang) }}</a>

				</li>

				<li v-bind:class="{ active: detailsTab=='tab-ontology' }" v-on:click="detailsTab='tab-ontology'" >

					<a href="#translations">
{{ $t("message.labelOntology", lang) }}</a>

				</li>

			</ul>


			<div class="tab-content">


				<div class="tab-pane" v-bind:class="{ active: detailsTab=='tab-details' }" id="tab-details">

					<div class="row-fluid">

						<div class="span6">

							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">

								<tr>

									<td class="td-label-detail">

										<strong>
{{ $t("message.localCodeLabel", lang) }}</strong>

									</td>

									<td>
{{ pageComponents.detailObj.resourceName }}</td>

								</tr>

								<tr>

									<td class="td-label-detail">

										<strong>
{{ $t("message.labelDescription", lang) }}</strong>

									</td>

									<td>

										{{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.description') }}
									</td>

								</tr>

								<tr v-if="pageComponents.detailObj.defLang==additionalInfo.lang" v-for="(additionalInfo, key) in pageComponents.detailObj.info.additionalInfo" :key="key">

									<td class="td-label-detail">

										<strong>
{{ additionalInfo.key }}</strong>

									</td>

									<td>
{{ additionalInfo.value }}</td>

								</tr>

							</table>

						</div>

					</div>

				</div>


				<div class="tab-pane" id="tab-additional-info" v-bind:class="{ active: detailsTab=='tab-additional-info' }">

					<div class="row-fluid">

						<div class="span6">

						</div>

					</div>

				</div>

				
				<div class="tab-pane" id="tab-hierarchical-relationships"
					v-bind:class="{ active: detailsTab=='tab-hierarchical-relationships' }"
					v-if="pageComponents.detailObj.info.isClassification">

					<div class="row-fluid">

						<div class="span-12">

							<!-- RELATIONSHIPS -->

							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">

								<thead>

									<th class="span3">
{{ $t("message.labelCode", lang) }}</th>

									<th class="span9">
{{ $t("message.labelDescription", lang) }}</th>

								</thead>

								<tbody>

									<tr v-for="relationship in pageComponents.detailObj.info.relationships">

										<td v-bind:class="{
											'padding-left-30': relationship.level == 1,
											'padding-left-60': relationship.level == 2,
											'padding-left-90': relationship.level == 3,
											'padding-left-120': relationship.level == 4,
											'padding-left-150': relationship.level == 5}">

											<a href="#" v-if="!relationship.current" v-on:click="openStandardLocalDetailModal(null, false, relationship.name)">
{{ relationship.name }}</a>

											<strong v-else>
{{ relationship.name }}</strong>

										</td>

										<td>
{{ relationship['name_' + pageComponents.detailObj.defLang] }}</td>

									</tr>

								</tbody>

							</table>

						</div>

					</div>

				</div>

				
				
				
				<div class="tab-pane" id="tab-hl7specs" v-bind:class="{ active: detailsTab=='tab-hl7specs' }">

					<div class="row-fluid">

						<div class="span6">

							<p>

								<strong>
{{ $t("message.labelHL7Specs", lang) }}</strong>

							</p>

							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">

								<tr>

									<td class="td-label-detail">
<strong>
{{ $t("loinc.localCodeLabel", lang) }}</strong>
</td>

									<td>
{{pageComponents.detailObj.resourceName }}</td>

								</tr>

								<tr>

									<td class="td-label-detail">
<strong>
{{ $t("loinc.labelCodeSystem", lang) }} - {{ $t("message.labelOid", lang) }}</strong>
</td>

									<td>
{{ pageComponents.detailObj.info.csOid }}</td>

								</tr>

								<tr>

									<td class="td-label-detail">
<strong>
{{ $t("loinc.labelCodeSystemName", lang) }}</strong>
</td>

									<td>
{{pageComponents.detailObj.info.codeSystemName }}</td>

								</tr>

								<tr>

									<td class="td-label-detail">
<strong>
{{ $t("loinc.labelCodeSystemVersion", lang) }}</strong>
</td>

									<td>
{{pageComponents.detailObj.info.codeSystemVersion | clearVersionForView}}</td>

								</tr>

								<tr>

									<td class="td-label-detail">
<strong>
{{ $t("loinc.labelDisplayName", lang) }}</strong>
</td>

									<td>
{{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.description') }}</td>

								</tr>

							</table>

						</div>

					</div>

				</div>

				
				

				<div class="tab-pane" id="tab-mapping" v-bind:class="{ active: detailsTab=='tab-mapping' }">

					<div class="row-fluid">

						<div class="span-12">

							<!-- CROSS MAPPING -->

							<div v-if="!isEmptyMappingRelations()">

								<h4>
{{ $t("message.labelMappingToOtherCodingSystems", lang) }}</h4>

							</div>


							<div v-for="(mappings, key) in pageComponents.mappingToOtherCodingSystems">

								<div v-if="mappings.length >
 0">

									<h5>
{{ $t("loinc.labelCodeSystemName", lang) }}: {{ key }}</h5>


									<div v-for="mapping in mappings">

										<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">

											<tr>

												<td class="td-label-detail">
<strong>
 {{
														$t("message.labelCode", lang) }}
												</strong>
</td>

												<td>

													<a href="#" v-on:click="openDetailByCodeSystem(key, mapping, pageComponents.detailObj.info.namespace, 'detailModalStandardLocal')" v-if="mapping.subject.name !== pageComponents.detailObj.resourceName">
{{ mapping.subject.name }}</a>

													<a href="#" v-on:click="openDetailByCodeSystem(key, mapping, pageComponents.detailObj.info.namespace, 'detailModalStandardLocal')" v-else="">
{{ mapping.predicate.name }}</a>

												</td>

											</tr>

											<tr>

												<td class="td-label-detail">
<strong>
 {{
														$t("message.labelDescription", lang) }} </strong>
</td>

												<td>

													<span v-if="mapping.subject.name !== pageComponents.detailObj.resourceName">
{{ mapping['sourceTitle_' + pageComponents.detailObj.defLang] }}</span>

													<span v-else>
{{ mapping['targetTitle_' + pageComponents.detailObj.defLang] }}</span>

												</td>

											</tr>

										</table>

									</div>

								</div>

							</div>

						</div>

					</div>

				</div>


				<!-- VERSIONS -->

				<div class="tab-pane" id="tab-versions"
					v-bind:class="{ active: detailsTab == 'tab-versions' }">

					<div class="row-fluid">

						<div class="span6">

							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">

								<tr>

									<td class="td-label-detail">

										<strong>
{{ $t("message.labelActualVersion", lang) }}</strong>

									</td>

									<td>
{{ pageComponents.detailObj.info.codeSystemVersion | clearVersionForView}}</td>

									<td>
{{ pageComponents.detailObj.info.releaseDate }}</td>

								</tr>

								<tr v-for="(otherVersion, index) in pageComponents.detailObj.info.otherVersions"
									v-if="otherVersion.name !== pageComponents.detailObj.info.codeSystemVersion">

									<td class="td-label-detail">

										<strong v-if="index === 0">
{{ $t("message.labelOtherVersions", lang) }}</strong>

									</td>

									<td>
{{ otherVersion.name | clearVersionForView}}</td>

									<td>
{{ otherVersion.releaseDate }}</td>

								</tr>

							</table>

						</div>

					</div>

				</div>

				
				<div class="tab-pane" id="tab-ontology" v-bind:class="{ active: detailsTab=='tab-ontology' }">

					<div class="row-fluid" v-if=" pageComponents.detailObj.info.hasOntology=='Y'">

						<div class="span2">

							<a v-bind:href="getLodViewHref" class="btn btn-info btn-block" target="_blank">

								{{ $t("message.labelOpenLodView", lang) }}
							</a>

						</div>

						<div class="span2">

							<a v-bind:href="getLodLiveHref" class="btn btn-info btn-block" target="_blank">

								{{ $t("message.labelOpenLodLive", lang) }}
							</a>

						</div>

					</div>


				</div>

			</div>

			<!--End modal body -->


		</div>

		<div class="modal-footer">

<!-- 			<div class="flag flag-it flag-clickable" alt="Italian" v-if="pageComponents.detailObj.defLang=='en'" v-on:click="pageComponents.detailObj.defLang='it'">
</div>
 -->

<!-- 			<div class="flag flag-gb flag-clickable" alt="English" v-if="pageComponents.detailObj.defLang=='it'" v-on:click="pageComponents.detailObj.defLang='en'">
</div>
 -->

			<div class="flag flag-it flag-clickable" alt="Italian" v-if="pageComponents.detailObj.defLang=='en' && (itIsPresent && enIsPresent)" v-on:click="pageComponents.detailObj.defLang='it'">
</div>

			<div class="flag flag-gb flag-clickable" alt="English" v-if="pageComponents.detailObj.defLang=='it' && (itIsPresent && enIsPresent)" v-on:click="pageComponents.detailObj.defLang='en'">
</div>

			
		</div>

	</div>

</div>

