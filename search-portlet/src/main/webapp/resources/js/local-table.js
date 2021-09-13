//LOCAL table component
Vue.component('localTable', {
  template: '#local-table-template',
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
  methods: {
	
  },
  computed: {
	  currentLangaugeIsPresent: function(){
		  	var numResult = this.results.length;
		  	var flagCurrentLangPresent = false;
			var elem = this.results[0];
			if(numResult>0 && elem!==undefined && elem.designation['NAME_'+this.lang]===undefined && elem.designation['CS_DESCRIPTION_'+this.lang]===undefined){
				flagCurrentLangPresent = false;
			}
			else{
				flagCurrentLangPresent = true;
			}
			
			//console.log("lang::"+this.lang);
			//console.log("flagCurrentLangPresent::"+flagCurrentLangPresent);
			return flagCurrentLangPresent;
		},
		itaEngIsPresent: function(){
		  	var numResult = this.results.length;
			var elem = this.results[0];
			
			
			if(numResult>0 && elem!==undefined){
				var flagItPresent = false;
				var flagEnPresent = false;
				var flag = false;
				
				if(elem.designation['CS_DESCRIPTION_it']!==undefined){
					flagItPresent=true;
				}
				if(elem.designation['CS_DESCRIPTION_en']!==undefined){
					flagEnPresent=true;
				}
				
				if(flagItPresent==true && flagEnPresent==true){
					flag = true;	
				}
				else{
					flag = false;
				}
				
				
				//console.log("JSON::"+JSON.stringify(elem));
				//console.log("CS_DESCRIPTION_it::"+elem.designation['CS_DESCRIPTION_it']);
				//console.log("CS_DESCRIPTION_en::"+elem.designation['CS_DESCRIPTION_en']);
				//console.log("lang::"+this.lang);
				//console.log("flag in::"+flag);
				
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

