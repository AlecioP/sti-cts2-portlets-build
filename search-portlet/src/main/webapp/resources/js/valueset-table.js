//VALUESET table component
Vue.component('valuesetTable', {
  template: '#valueset-table-template',
  props: {
    results: Array,
    defaultHeaders: Array,
    dynamicHeaders: Array,
    openDetail: Function,
    changeLanguageProperty: Function,
    lang: String,
  },
  data: function () {
    return {
    }
  },
  computed: {
	  currentLangaugeIsPresent: function(){
		  	var numResult = this.results.length;
			var elem = this.results[0];
			if(numResult>0 && elem!==undefined && elem.designation['NAME_'+this.lang]===undefined && elem.designation['VALUESET_DESCRIPTION_'+this.lang]===undefined){
				return false;
			}
			else{
				return true;
			}
		},
		itaEngIsPresent: function(){
		  	var numResult = this.results.length;
			var elem = this.results[0];
			
			
			if(numResult>0 && elem!==undefined){
				var flagItPresent = false;
				var flagEnPresent = false;
				var flag = false;
				
				if(elem.designation['VALUESET_DESCRIPTION_it']!==undefined){
					flagItPresent=true;
				}
				if(elem.designation['VALUESET_DESCRIPTION_en']!==undefined){
					flagEnPresent=true;
				}
				
				if(flagItPresent==true && flagEnPresent==true){
					flag = true;	
				}
				else{
					flag = false;
				}
				
				/*
				console.log("JSON::"+JSON.stringify(elem));
				console.log("VALUESET_DESCRIPTION_it::"+elem.designation['VALUESET_DESCRIPTION_it']);
				console.log("VALUESET_DESCRIPTION_en::"+elem.designation['VALUESET_DESCRIPTION_en']);
				console.log("flag in::"+flag);
				*/
			}
			else{
				flag = false;
			}
			return flag;
		}
  },
  methods: {
  },
  mounted : function() {
    //console.log("Mounted localTable component!");
  }
});

