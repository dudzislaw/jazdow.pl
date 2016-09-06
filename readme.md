# Static Factory

This is a  static generator for websites.
Gulp as a build tool,
JADE as a template language,
markdown and front-matter as data source.
Uses also:

- stylus with nib, lost and autoprefixer
- coffeescript
- bower
- polymer

### Usage

**go to factory**

```shell
cd .factory
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
https://localhost:3000/
