//localDynamicFilter component

Vue.filter("parseValueFilter", function(value,fieldName) {
	if(_.startsWith(fieldName,'DF_D_') && value!='Tutte'){
		return moment(value).locale('it').format('DD/MM/YYYY');
	}
	else{
		 return value;		
	}
});

Vue.component('localFilter', {
	template : '#local-filter-template',
	props : {
		dynamicFields : Array,
		elementForm : Object,
		lang : String,
		getValues : Function,
		dynamicFieldValue: Array
	},
	data : function() {
		return {
			dynamicFieldValueList:[],
			dynamicFieldValue:[]
		}
	},
	computed : {
		getFields : function() {
			var self = this;
			var fields =[];
			
			
			_.each(self.dynamicFields, function(field) {
				if (fields.indexOf(field) == -1 &&  _.endsWith(field, self.lang)) {
					fields.push(field);
				}
			});
			
			var removeElements = ['DOMAIN','ORGANIZATION'];
			_.remove(fields, function (field) {
				return _.indexOf(removeElements, field) !== -1;
			});
			
			self.getValues(fields);
			
			self.dynamicFields = fields;
			return self.dynamicFields;
		},
		
	},
	methods : {
		getValuesFromField : function(fieldName){
			var values = [];
			var elem = _.find(this.dynamicFieldValue, {fieldName: fieldName});
			if(elem!==undefined){
				values = elem.listValue;
				//console.log("fieldName::"+fieldName);
				//console.log("values::"+JSON.stringify(values));
			}
			return values;
		},

	},
	mounted : function() {
		//console.log("Mounted localFilter component!");
	}
});
