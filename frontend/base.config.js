const path = require('path');
const webpack = require('webpack');
const AssetsPlugin = require('assets-webpack-plugin');
const ExtractTextPlugin = require("extract-text-webpack-plugin");

module.exports = {
  context: __dirname,
  output: {
    path: path.join(__dirname, '..', 'public', 'assets'),
    filename: 'bundle-[name].js'
  },
  entry: {
    application: ['./app/base-entry'], // workaround for require allowing (fixed in webpack 2)
    main_page: ['./app/pages/main'],
    inner_page: ['./app/pages/inner'],
    product_page: ['./app/pages/product'],
    admin_panel: ['./app/pages/admin_panel'],
    tinymce_content_styles: ['./app/pages/admin_panel/tinymce_content_styles'],
  },
  resolve: {
    extensions: ['', '.js', '.coffee'],
    modulesDirectories: [ 'node_modules' ],
    alias: {
      libs: path.join(__dirname, 'libs'),
      common: path.join(__dirname, 'app', 'common'),
    }
  },
  module: {
    loaders: [
      {
        test: /\.js$/,
        include: [ path.resolve(__dirname + 'frontend/app') ],
        loader: 'babel?presets[]=es2015'
      },
      { test: /\.coffee$/, loader: 'coffee-loader' },
      { test: /\.vue$/, loader: 'vue' },
      { test: require.resolve('jquery'), loader: 'expose?$!expose?jQuery' },
      {
        test: /tinymce_content_styles\.scss/,
        loader: ExtractTextPlugin.extract("style-loader", "css!resolve-url!sass")
      }
    ],
  },
  plugins: [
    new AssetsPlugin({prettyPrint: true}),
    new ExtractTextPlugin("[name].css", {allChunks: true }),
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      '_': 'underscore'
    }),
    new webpack.DefinePlugin({
      __RAILS_ENV__: JSON.stringify(process.env.RAILS_ENV || 'development'),
      __TINYMCE_CONTENT_STYLES__: JSON.stringify(
        (process.env.NODE_ENV != 'production' ? 'http://localhost:3500' : '') + '/assets/tinymce_content_styles.css'
      ),
    })
  ]
};
