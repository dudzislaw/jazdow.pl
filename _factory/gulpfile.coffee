fs = require('fs')
gulp = require('gulp')
shell = require('gulp-shell')
gulpfn = require('gulp-fn')
plumber = require('gulp-plumber')
uglify = require('gulp-uglify')
gulpFilter = require('gulp-filter')
concat = require('gulp-concat')
sourcemaps = require('gulp-sourcemaps')
jade = require('gulp-jade')
yaml = require('gulp-yaml')
fm = require('front-matter')
data = require('gulp-data')
coffee = require('gulp-coffee')
stylus = require('gulp-stylus')
nib = require('nib')
rupture = require('rupture')
poststylus = require('poststylus')
bower = require('gulp-main-bower-files')
browserSync = require('browser-sync').create()
htmlInjector = require('bs-html-injector')
path = require('path')
notifier = require('node-notifier')
gutil = require('gulp-util')
ghPages = require('gulp-gh-pages')

# Handy paths
paths =
	public: 	'../'
	data: 		'../_data/**/*'
	views: 		'../_views/**/*.jade'
	polymer: 	'../_lib/elements/**/*.jade'
	stylus: 	'../_lib/css/**/*.styl'
	cofee: 		'../_lib/js/**/*.coffee'
	bower: 		'../dist/lib/bower_components/'
	assets: [
		'../_lib/ui/**/*'
		'../_lib/fonts/**/*'
	]
	buildicons: path.join('/Users/franz/Sites/_build-icons/')


# Bower deps - will be merged to lib/js/vendor.min.js by bower-deps task
bower_deps = [
	paths.bower + 'bluebird/js/browser/bluebird.min.js',
	paths.bower + 'jquery/dist/jquery.js',
	paths.bower + 'lodash/dist/lodash.js',
	paths.bower + 'velocity/velocity.js',
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
# JADE – THEME VIEWS
# compile to html with mockup data from markdown files with the same name

gulp.task 'views', ->
	isError = false
	stream = gulp.src('../_views/*.jade')
	.pipe(plumber(
		errorHandler: (error)->
			isError = errorHandler(stream, error.message, error.message, 'jade', 'b_jade-e.png')
	))
	.pipe(data( (file)->
		filepath = '../_data/' + path.basename(file.path, '.jade') + '.md'
		file_content = fs.readFileSync(filepath, 'utf8')
		fmdata = fm(file_content).attributes
		return fmdata
	))
	.pipe(jade(
		pretty: true
	))
	.pipe(gulp.dest('../dist/'))
	.pipe(gulpfn(->
		unless isError then successHandler 'Compiled Jade', 'jade', 'b_jade-s.png'
		return
	))
	return




#--------------------
# JADE – POLYMER ELEMENTS
# compile polymer elements, write to /lib/elements with sourcemaps

gulp.task 'jade-polymer', ->
	isError = false
	stream = gulp.src(paths.polymer)
	.pipe(sourcemaps.init())
	.pipe(plumber(
		errorHandler: (error)->
			isError = errorHandler(stream, error.message, error.message, 'yaml', 'b_jade-e.png')
	))
	.pipe(jade(
		pretty: true
	))
	.pipe(sourcemaps.write('.'))
	.pipe(gulp.dest('../dist/lib/elements/'))
	.pipe(gulpfn(->
		unless isError then successHandler 'Compiled Jade', 'jade', 'b_jade-s.png'
		return
	))
	return




#--------------------
# STYLUS
# compile and minify, write to /lib/css/ with sourcemaps

gulp.task 'stylus', ->
	isError = false
	stream = gulp.src('../_lib/css/*.styl')
	.pipe(sourcemaps.init())
	.pipe(stylus(
		compress: true
		use: [
			nib()
			rupture()
			poststylus([ 'lost','autoprefixer' ])
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
# BOWER
# concat and uglify bower js deps, write to /lib/js/vendor.js

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
# UI AND FONTS
# Just mirror them to dest folder

gulp.task 'assets', ->
	stream = gulp.src(paths.assets, { base: '../_lib/' }).pipe(gulp.dest('../dist/lib/'))



#--------------------
# SERVE
# browserSync server with HTML injection
gulp.task 'serve', ->
	browserSync.use htmlInjector, files: '../dist/**/*.html'
	browserSync.init
		server: baseDir: '../dist'
		files: '../lib/**/*.css'
	return


#--------------------
# RELOAD
# reload browserSync
gulp.task 'reload', ['coffee'], browserSync.reload


#--------------------
# WATCH
gulp.task 'watch', ->
	gulp.watch paths.views, ['views']
	gulp.watch paths.data, ['views']
	gulp.watch paths.polymer, ['jade-polymer']
	gulp.watch paths.assets, ['assets']
	gulp.watch paths.stylus, ['stylus']
	gulp.watch '../_lib/js/**/*.coffee', ['coffee']
	gulp.watch '../lib/js/*.js', ['reload']
	return



gulp.task 'default', [
	'views'
	'jade-polymer'
	'coffee'
	'stylus'
	'assets'
	'watch'
	'serve'
]



#--------------------
# DEPLOY TO GH PAGES

gulp.task 'deploy', ->
	return gulp.src('../dist/**/*').pipe(ghPages())
