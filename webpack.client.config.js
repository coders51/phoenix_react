const path = require('path');
const autoprefixer = require('autoprefixer');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const cssLoaders = ['css-loader?modules&importLoaders=1&localIdentName=[name]__[local]___[hash:base64:5]', {
  loader: 'postcss-loader',
  options: {
    plugins: [
      autoprefixer({
        browsers: [
          'last 3 version',
          'ie >= 10',
        ],
      }),
    ],
  },
},
];

module.exports = {
  entry: [
    'es6-promise',
    'babel-polyfill',
    path.join(__dirname, 'web/static/js/app.js'),
    path.join(__dirname, 'web/static/css/app.scss'),
  ],
  output: {
    path: path.join(__dirname, '/priv/static'),
    filename: 'js/client.js',
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: ['/node_modules/'],
        include: path.join(__dirname, 'web/static/js'),
        use: [{
            loader: 'babel-loader',
            options: { presets: ['es2015', 'react', 'stage-0'] },
          },
        ],
      },
      {
        test: /\.css$/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: [
            ...cssLoaders,
          ],
        }),
      },
      {
        test: /\.(sass|scss)$/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: [
            ...cssLoaders,
            'sass-loader',
          ],
        }),
      },
    ],
  },
  resolve: {
    extensions: ['.webpack-loader.js', '.web-loader.js', '.loader.js', '.js', '.jsx', '.scss', '.css'],
    modules: [
      'node_modules',
      'web/static/js',
    ],
    alias: {
      phoenix: path.join(__dirname, '/deps/phoenix/priv/static/phoenix.js'),
    },
  },
  plugins: [
    new ExtractTextPlugin({
      filename: 'css/app.css',
      disable: false,
      allChunks: true,
    }),
    new CopyWebpackPlugin([{ from: './web/static/assets' }, { from: './web/static/vendor/css', to: 'css/vendor' }, { from: './web/static/vendor/es6-promise.map', to: 'js' }, { from: './web/static/vendor/js', to: 'js/vendor' }]),
  ],
};
