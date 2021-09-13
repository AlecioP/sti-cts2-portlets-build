module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-template');
  grunt.loadNpmTasks('grunt-convert');
  grunt.loadNpmTasks('grunt-contrib-connect');

  grunt.registerMultiTask('indexhtmlwriter', 'Example task', function() {
  	console.log('indexhtmlwriter');

  	//Read the included portlet styles/scripts
  	var liferayPortletJsonString = grunt.file.read('./dist/liferay-portlet.json');
  	var liferayPortletJson = JSON.parse(liferayPortletJsonString);
  	var styles = liferayPortletJson['liferay-portlet-app']['portlet']['header-portlet-css'];
  	var scripts = liferayPortletJson['liferay-portlet-app']['portlet']['header-portlet-javascript'];
    scripts.forEach(function(item, index){
      scripts[index] = item.replace("set-environment.jsp", "set-environment-svil.js");
    });

  	grunt.config.set('template.process-html-template.options.data.styles', styles);
  	grunt.config.set('template.process-html-template.options.data.scripts', scripts);

  	//Read the content of the app
  	var content = grunt.file.read('./views/view.jsp');
  	grunt.config.set('template.process-html-template.options.data.content', content);
  });

  grunt.initConfig({
  	//Serve the files
  	connect: {
  		server: {
  		  options: {
    			port: 8001,
    			base: 'dist/',
    			hostname: '*',
  		  }
  		}
  	},

  	//Convert liferay-portlet.xml file to json
  	convert: {
  		options: {
  		  explicitArray: false,
  		},
  		xml2json: {
  			files: [
  			  {
  				expand: true,
  				src: ['liferay-portlet.xml'],
  				cwd: 'WEB-INF/',
  				dest: 'dist/',
  				ext: '.json'
  			  }
  			]
  		},
  	},
  	//Copy files
  	copy: {
  	  main: {
  		files: [
  		  {expand: true, src: ['resources/**'], dest: 'dist/'},
  		],
  	  },
  	},

  	//Writer in index.html
  	indexhtmlwriter: {
  		target: {}
  	},

  	//Generate index.html file
  	template: {
  		'process-html-template': {
  			options: {
  				data: {
  					content: 'content',
  					scripts: [],
  					styles: [],
  				}
  			},
  			files: {
  				'dist/index.html': ['index.html.tpl']
  			}
  		}
  	},

  	//Watch changes on files
    watch: {
      files: ['resources/**', 'views/**'],
      options: {
        atBegin: true
      },
  	  tasks: ['copy', 'convert', 'indexhtmlwriter', 'template']
    }
  });

  // On watch events
  grunt.event.on('watch', function(action, filepath) {
    console.log('File changed...', filepath);
  });

  // Default task(s).
  grunt.registerTask('default', ['watch', 'connect']);
  grunt.registerTask('serve', [
	  'connect:server',
	  'watch'
  ]);

};
