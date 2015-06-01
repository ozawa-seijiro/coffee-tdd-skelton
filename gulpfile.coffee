gulp   = require 'gulp'
coffee = require 'gulp-coffee'
mocha = require 'gulp-mocha'
browserify = require 'gulp-browserify'


path = {
  scripts: [
    'lib/coffee/**/*.coffee'
  ],
  javascripts: [
    'lib/js/**/.js'
  ]
}

gulp.task 'compile-coffee', () ->
  gulp.src path.scripts
  .pipe coffee()
  .pipe gulp.dest('dest/js')

gulp.task 'test', () ->
  gulp.src path.scripts
    .pipe mocha({reporter:'nyan'})


gulp.task 'watch', () ->
  gulp.watch path.scripts, ['compile-coffee', 'test']


gulp.task 'default', ['watch', 'compile-coffee', 'test'];


gulp.task 'tdd-js', ['compile-js', 'js-test']

gulp.task 'compile-js', () ->
  gulp.watch path.javascripts, ['watch', 'js-test']


gulp.task 'js-test', () ->
  gulp.src path.javascripts
    .pipe mocha({reporter:'nyan'})
