const gulp = require('gulp');
const babel = require('gulp-babel');
const concat = require('gulp-concat');
 
gulp.task('default', function () {
  return gulp.src('app/assets/components/*.jsx')
    .pipe(babel({
        presets: ['es2015', 'react']
      }))
    .pipe(concat('build.js'))
    .pipe(gulp.dest('app/assets/javascripts'));
});
