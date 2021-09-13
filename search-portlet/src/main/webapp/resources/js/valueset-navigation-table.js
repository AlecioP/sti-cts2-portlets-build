//VALUESET navigation table component
Vue.component('valuesetNavigation', {
  template: '#valueset-navigation-template',
  props: {
    model: Array,
    lang: String,
    searchUrl: Function,
    detailCallback: Function,
    side: String,
    showLoading: Function,
    hideLoading: Function,
    tooltipPosition: String,
    activeToggleSelection: String,
  },
  data: function () {
    return {
      flatData: []
    }
  },
  computed: {
    isFolder: function () {
      return this.model.children &&
        this.model.children.length
    },
  },
  methods: {
    /**
     * Generate flat data, without children.
     * @param data The data to transform in flat.
     * @param level The level of the tree.
     * @param parentId The parent id.
     */
    generateFlatData: function (data, level, parentId){
      var self = this;
      _.forEach(data, function(element, key) {
       //console.log('element', element, 'key', key, 'parentId', parentId);
        element.parent = parentId;
        element.level = level;
        self.flatData.push(_.clone(element));
        if(!parentId){
          _.last(self.flatData).shown = true;
        }
        if(element.children && element.children.length) {
          var id = Math.random().toString(36).substring(7);
          _.last(self.flatData).id = id;
          _.last(self.flatData).hasChildren = true;
          self.generateFlatData(_.last(self.flatData).children, level + 1, id);
        }
      });
    },

    /**
     * Returns true if the given element is open, false otherwise.
     * @param element The element to open.
     */
    isShown: function(element){
      return element.shown;
    },

    /**
     * Load sub class of.
     * @param parent The parent from which load the children.
     * @param index The index of the element.
     */
    loadSubclassOf: function(parent, index){
      var url = this.searchUrl(this.side) + "&matchvalue=SUBCLASS_OF=" + parent.resourceName + APP_PROPERTIES.jsonFormatHttpParam;
      var self = this;
      self.showLoading();
      this.$http.get(url).then(function(response){
        var entries = response.body.EntityDirectory.entry;
        //console.log('response', entries);
        parent.children = entries;
        parent.loaded = true;
        parent.open = true;
        var parentId = parent.id;
        var level = parent.level + 1;

        _.forEach(entries, function(entry, key) {
          index++;
          entry.parent = parentId;
          entry.level = level;
          entry.shown = true;
          var designation = jQuery.parseJSON(entry.knownEntityDescription[0].designation);
          entry.id = Math.random().toString(36).substring(7);
          entry.hasChildren = !designation.IS_LEAF;
          entry.loaded = false;
          entry.designation = designation;
          entry.codeSystemVersion = _.replace(entry.knownEntityDescription[0].describingCodeSystemVersion.version.content, '_ita', '');

          //Convert the array in string
          self.convertString(entry, 'DESCRIPTION_en');
          self.convertString(entry, 'DESCRIPTION_it');
          self.convertString(entry, 'NAME_en');
          self.convertString(entry, 'NAME_it');

          //If the name is empty (english and italian), set it to the description
          if(!entry.designation['NAME_en']){
            entry.designation['NAME_en'] = entry.designation['DESCRIPTION_en'];
          }
          if(!entry.designation['NAME_it']){
            entry.designation['NAME_it'] = entry.designation['DESCRIPTION_it'];
          }

          entry.defLang = self.lang;
          self.flatData.splice(index, 0, _.clone(entry));
        });
      }).finally(function(){
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
    }
  },
  mounted : function() {
    console.log("Mounted component!");
    this.generateFlatData(this.model, 0);
  }
});
