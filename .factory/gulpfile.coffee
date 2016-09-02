fs = require('fs')
_  = require ('lodash')
gulp = require('gulp')
shell = require('gulp-shell')
gulpfn = require('gulp-fn')
plumber = require('gulp-plumber')
uglify = require('gulp-uglify')
gulpFilter = require('gulp-filter')
concat = require('gulp-concat')
sourcemaps = require('gulp-sourcemaps')
pug = require('gulp-pug')
marked  = require 'marked'
yaml = require('gulp-yaml')
fm = require('front-matter')
data = require('gulp-data')
coffee = require('gulp-coffee')
stylus = require('gulp-stylus')
nib = require('nib')
rupture = require('rupture')
autoprefixer = require('autoprefixer')
lost = require('lost')
poststylus = require('poststylus')
htmlpostcss = require('gulp-html-postcss')
bower = require('gulp-main-bower-files')
browserSync = require('browser-sync').create()
htmlInjector = require('bs-html-injector')
path = require('path')
del = require('del')
notifier = require('node-notifier')
gutil = require('gulp-util')
ghPages = require('gulp-gh-pages')
vulcanize = require('gulp-vulcanize')
bower = require('gulp-bower')



# Handy paths
paths =
	public: 	'../'
	data: 		'../_data/**/*'
	views: 		'../_views/**/*.pug'
	elements: 	'../_elements/**/*.pug'
	stylus: 	'../_lib/css/**/*.styl'
	cofee: 		'../_lib/js/**/*.coffee'
	bower: 		'../dist/lib/bower_components/'
	ui: [
		'../_lib/ui/**/*'
		'../_lib/fonts/**/*'
	]
	assets:		'../_assets/**/*'
	buildicons: path.join('/Users/franz/Sites/_build-icons/')
	ssl:
		crt: path.join('/Users/franz/Sites/_SSL/franz.crt')
		key: path.join('/Users/franz/Sites/_SSL/franz.key')


# Bower deps - will be merged to lib/js/vendor.min.js by bower-deps task
bower_deps = [
	paths.bower + 'axios/dist/axios.min.js'
	paths.bower + 'moment/min/moment-with-locales.min.js'
	paths.bower + 'webcomponentsjs/webcomponents-lite.js'

]


#--------------------
# ERROR / SUCCESS handlers

errorHandler = (stream, log, message, title, icon) ->
	gutil.log log
	gutil.beep()
	notifier.notify
		title: title
		message: message
		icon: paths.buildicons + icon
	stream.end()
	true

successHandler = (message, title, icon) ->
	notifier.notify
		title: title
		message: message
		icon: paths.buildicons + icon
	return




#--------------------
# DATA - MARKDOWN TO JSON
# compile _data/markdown files to json, write to dist/data
gulp.task 'data', ->
	isError = false
	stream = gulp.src(['../_data/**/*.md'])
	.pipe(plumber(
		errorHandler: (error)->
			isError = errorHandler(stream, error.message, error.message, 'pug', 'b_md-e.png')
	))
	.pipe(data( (file)->
		dataObject = fm fs.readFileSync(file.path, 'utf8')
		parsedObject = dataObject.attributes
		parsedObject.content = dataObject.body
		file.contents = new Buffer(JSON.stringify(parsedObject), 'utf8')
		file.path = file.path.replace '.md', '.json'
	))
	.pipe(gulp.dest('../dist/data/'))
	.pipe(gulpfn(->
		unless isError then successHandler 'Compiled Markdown to JSON', 'data', 'b_md-s.png'
		return
	))
	return




#--------------------
# PUG – THEME VIEWS
# compile to html with data from markdown files with the same name

gulp.task 'views', ->
	isError = false
	stream = gulp.src(['../_views/**/*.pug', '!../_views/_*/**/*'])
	.pipe(plumber(
		errorHandler: (error)->
			isError = errorHandler(stream, error.message, error.message, 'pug', 'b_jade-e.png')
	))
	.pipe(data( (file)->
		pugFilePath = path.relative( file.cwd, file.path ) # file path relative to this gulpfile
		mdFilePath = pugFilePath.replace('_views/', '_data/').replace('.pug', '.md')

		file_obj = fm fs.readFileSync(mdFilePath, 'utf8') 			# parse and store data from coresponding .md file
		site_obj = fm fs.readFileSync('../_data/data.md', 'utf8') 	# parse and store sitewide data from data.md file
		content = file_obj.attributes # merge the above
		content.data = site_obj.attributes
		content.content = marked file_obj.body
		return content
	))
	.pipe(pug(
		pretty: true
	))
	.pipe(htmlpostcss(
		[
			autoprefixer( browsers: ['last 1 version'] ),
			lost()
		],
	))
	.pipe(gulp.dest('../dist/'))
	.pipe(gulpfn(->
		unless isError then successHandler 'Compiled views PUG -> HTML', 'pug', 'b_jade-s.png'
		return
	))
	return




#--------------------
# PUG – POLYMER ELEMENTS
# compile polymer elements, write to dist/elements, also passing in site data from data.md

gulp.task 'elements', ->
	isError = false
	stream = gulp.src('../_elements/**/*.pug')
	.pipe(sourcemaps.init())
	.pipe(plumber(
		errorHandler: (error)->
			isError = errorHandler(stream, error.message, error.message, 'yaml', 'b_jade-e.png')
	))
	.pipe(data( (file)->
		site_obj = fm fs.readFileSync('../_data/data.md', 'utf8') 	# parse and store sitewide data from data.md file
		content.data = site_obj.attributes
		content.content = marked site_obj.body
		return content
	))
	.pipe(pug(
		pretty: true
	))
	.pipe(htmlpostcss(
		[
			autoprefixer( browsers: ['last 1 version'] ),
			lost()
		],
	))
	.pipe(sourcemaps.write('.'))
	.pipe(gulp.dest('../dist/elements/'))
	.pipe(gulpfn(->
		unless isError then successHandler 'Compiled Polymer elemets PUG -> HTML', 'pug', 'b_jade-s.png'
		return
	))
	return



#--------------------
# STYLUS
# compile and minify, write to /lib/css/ with sourcemaps

gulp.task 'stylus', ->
	isError = false
	stream = gulp.src(['../_lib/css/*.styl'])
	.pipe(sourcemaps.init())
	.pipe(stylus(
		compress: true
		use: [
			nib()
			rupture()
			poststylus(
				[ 'lost','autoprefixer' ],
				(message)->
					if message.type is not 'warning'
						console.info message.text
						console.info message.node.source.input.file
			)
		]))
	.on('error', (error) ->
		isError = errorHandler(stream, '', error.message, 'stylus', 'b_stylus-e.png')
		return
	)
	.pipe(sourcemaps.write('.'))
	.pipe(gulp.dest('../dist/lib/css'))
	.pipe(gulpfn(->
		unless isError then successHandler 'Compiled Stylus', 'stylus', 'b_stylus-s.png'
		return
	))
	return




#--------------------
# COFFEE
# compile and concat, write to /lib/js/main.min.js with sourcemaps

gulp.task 'coffee', ->
	isError = false
	files = [
		'../_lib/js/functions.coffee',
		'../_lib/js/init.coffee'
	]
	stream = gulp.src(files)
	.pipe(sourcemaps.init())
	.pipe(coffee(
		bare: true
	))
	.on('error', (error) ->
		errorHandler stream, error.stack, error.message, 'compile-coffee', 'b_coffee-e.png'
		return
	)
	.pipe(concat('main.min.js'))
	.pipe(uglify())
	.pipe(sourcemaps.write('.'))
	.pipe(gulp.dest('../dist/lib/js'))
	.pipe(gulpfn(->
		unless isError then successHandler 'Compiled CoffeeScript', 'compile-coffee', 'b_coffee-s.png'
		return
	))
	return




#--------------------
# UI, MISC, AND ASSETS
# Just mirror them to dest folder

gulp.task 'ui', ->
	stream = gulp.src(paths.ui, { base: '../_lib/' }).pipe(gulp.dest('../dist/lib/'))
	return


gulp.task 'misc', ->
	miscFiles = ['../_views/CNAME']
	stream = gulp.src(miscFiles).pipe(gulp.dest('../dist/'))
	return


gulp.task 'assets', ->
	stream = gulp.src(paths.assets, { base: '../_assets/' }).pipe(gulp.dest('../dist/assets/'))
	return




#--------------------
# BOWER
# concat and uglify bower js deps, write to /lib/js/vendor.js
gulp.task 'bower', ->
	return bower()


gulp.task 'bower-deps', ->
	isError = false
	stream = gulp.src(bower_deps)
	.pipe(sourcemaps.init())
	.pipe(concat('vendor.min.js'))
	.pipe(uglify())
	.pipe(sourcemaps.write('.'))
	.pipe(gulp.dest('../dist/lib/js/'))
	return



#--------------------
# EMPTY DIST FOLDER

gulp.task 'clean', ->
	return del ['../dist/**/*'], force: true



#--------------------
# SERVE
# browserSync server with HTML injection
gulp.task 'serve', ->
	browserSync.init(
		server:
			baseDir: '../dist'
		https: true
		files: [
			'../dist/data/**/*'
			'../dist/**/*.html'
			'../dist/lib/**/*.css'
			'../dist/lib/js/**/*'
			'../dist/lib/ui/**/*'
			'../dist/lib/fonts/**/*'
			'../dist/assets/**/*'
		]
		open: false
		reloadOnRestart: true
	)
	return


#--------------------
# WATCH
gulp.task 'watch', ->
	gulp.watch paths.data, ['data']
	gulp.watch paths.elements, ['elements']
	gulp.watch paths.views, ['views']
	gulp.watch paths.ui, ['ui']
	gulp.watch paths.assets, ['assets']
	gulp.watch paths.stylus, ['stylus']
	gulp.watch '../_lib/js/**/*.coffee', ['coffee']
	return



gulp.task 'default', [
	'bower-deps'
	'data'
	'elements'
	'views'
	'coffee'
	'stylus'
	'misc'
	'ui'
	'assets'
	'watch'
	'serve'
]



#--------------------
# DEPLOY TO GH PAGES

gulp.task 'deploy', ->
	return gulp.src('../dist/**/*').pipe(ghPages())
