# Static Factory

This is a  static generator for websites. Forked from theme-factory. It uses Gulp to build scripts and styles, it uses JADE as a template language, to which you pass markdown and front-matter data.
Uses also:

- stylus with nib, lost and autoprefixer
- coffeescript
- bower
- polymer (if needed)

### Usage

**go to factory**

```shell
cd _factory
```

**install npm modules**

```shell
npm install
```

**install bower components**

```shell
bower install
```

**build vendor.min.js file with all bower dependencies**

```shell
gulp bower-deps
```

**run gulp**

```shell
gulp
```

**Done!**

go to:
http://localhost:3000/html
