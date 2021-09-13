//AIC navigation table component
Vue.component('aicNavigation', {
  template: '#aic-navigation-template',
  props: {
    results: Array,
    association: Boolean,
    isAssociated: Function,
    toggleAssociation: Function,
    openDetail: Function,
    lang: String,
    side: String,
    tooltipPosition: String,
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
    //console.log("Mounted aicNavigationTable component!");
  }
});
