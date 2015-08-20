var gulp          = require('gulp'),
    browserSync   = require('browser-sync').create(),
    sass          = require('gulp-sass'),
    coffee        = require('gulp-coffee'),
    minifyCss     = require('gulp-minify-css'),
    autoprefixer  = require('gulp-autoprefixer'),
    uncss         = require('gulp-uncss'),
    uglify        = require('gulp-uglify'),
    sftp          = require('gulp-sftp'),
    clean         = require('gulp-clean'),
    include       = require("gulp-include"),
    rename        = require("gulp-rename"),
    spritesmith   = require('gulp.spritesmith'),
    svgSprite     = require("gulp-svg-sprites");

// Static Server + watching scss/html files
gulp.task('serve', ['sass'], function() {
  browserSync.init({ server: "./" });
  gulp.watch("assets/sass/*.scss", ['sass']);
  gulp.watch("assets/javascripts/*.js", ['scripts']);
  gulp.watch("assets/javascripts/*.coffee", ['coffee']);
  gulp.watch("assets/images/sprite-img/*.png", ['sprite-img']);
  gulp.watch("assets/images/sprite-svg/*.svg", ['sprite-svg']);
  gulp.watch("*.html").on('change', browserSync.reload);
});

// Compile sass into CSS & auto-inject into browsers
gulp.task('sass', function () {
  gulp.src('assets/sass/*.scss')
  .pipe(sass().on('error', sass.logError))
  .pipe(autoprefixer({
    browsers: ['last 2 versions', 'ie 9'],
    cascade: false
  }))
  .pipe(gulp.dest('assets/stylesheets/css'))
  //.pipe(minifyCss())
  .pipe(browserSync.stream());
});

gulp.task('sprite-img', function generateSpritesheets () {
  // Use all normal and `-2x` (retina) images as `src`
  //   e.g. `github.png`, `github-2x.png`
  var spriteData = gulp.src('assets/images/sprite-img/*.png')
    .pipe(spritesmith({
      // Filter out `-2x` (retina) images to separate spritesheet
      //   e.g. `github-2x.png`, `twitter-2x.png`
      retinaSrcFilter: 'assets/images/sprite-img/*-2x.png',
      // Generate a normal and a `-2x` (retina) spritesheet
      imgName: 'spritesheet.png',
      retinaImgName: 'spritesheet-2x.png',
      // Optional path to use in CSS referring to image location
      imgPath: '../../images/spritesheet.png',
      retinaImgPath: '../../images/spritesheet-2x.png',
      // Generate SCSS variables/mixins for both spritesheets
      cssName: 'sprites.scss'
    }));
  // Deliver spritesheets to `dist/` folder as they are completed
  spriteData.img.pipe(gulp.dest('assets/images'));
  // Deliver CSS to `./` to be imported by `index.scss`
  spriteData.css.pipe(gulp.dest('assets/sass/'));
});

gulp.task('sprite-svg', function () {
  return gulp.src('assets/images/sprite-svg/*.svg')
    .pipe(svgSprite({
      preview: false,
      cssFile: false,
      svg: {
        sprite: "sprite-svg.svg",
      }
    }))
    .pipe(gulp.dest("assets/images"));
});

gulp.task("scripts", function() {
  gulp.src("assets/javascripts/main.js")
    .pipe(include())
      .on('error', console.log)
    .pipe(rename("scripts.js"))
    .pipe(gulp.dest("assets/javascripts/"))
    .pipe(browserSync.stream());
});

gulp.task('coffee', function() {
  gulp.src('assets/javascripts/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('assets/javascripts/script.js'))
});

gulp.task('compress', ['scripts'], function() {
  return gulp.src('assets/javascripts/scripts.js')
    .pipe(uglify())
    .pipe(rename("scripts-min.js"))
    .pipe(gulp.dest('assets/javascripts/'));
});

gulp.task('uncss', function() {
  return gulp.src('assets/stylesheets/css/style.css')
    .pipe(uncss({
        html: ['*.html']
    }))
    .pipe(gulp.dest('assets/stylesheets/css'));
});

gulp.task('clean', function () {
  return gulp.src('dist', {read: false})
    .pipe(clean());
});

gulp.task('sftp', ['clean'], function () {
  return gulp.src('src/*')
    .pipe(sftp({
      host: 'website.com',
      user: 'johndoe',
      pass: '1234'
    }));
});


gulp.task('dev', ['serve']);