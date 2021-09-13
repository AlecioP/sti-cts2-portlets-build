//ICD9-CM table component
Vue.component('icd9CmTable', {
  template: '#icd9-cm-template',
  props: {
    results: Array,
    openDetail: Function,
    changeLanguageProperty: Function,
    lang: String,
  },
  data: function () {
    return {
    }
  },
  computed: {
  },
  methods: {
  },
  mounted : function() {
    //console.log("Mounted icd9CmTable component!");
  }
});
