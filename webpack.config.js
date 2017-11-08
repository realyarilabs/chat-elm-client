var path = require('path');
var webpack = require('webpack');
var merge = require('webpack-merge');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var autoprefixer = require('autoprefixer');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var CopyWebpackPlugin = require('copy-webpack-plugin');

const TARGET_ENV = translateEnvVar(process.env.npm_lifecycle_event);
function translateEnvVar(env) {
  switch (env) {
    case "start":
      return 'development';
      break;
    case "build":
      return 'production';
      break;
    case "start:template":
      return 'development-template';
      break;
    case "build:template":
      return 'build-development-template';
      break;
    default:
      return 'development';
  }
}
const isDev = TARGET_ENV == 'development';
const isProd = TARGET_ENV == 'production';
const isDevTemplate = TARGET_ENV == 'development-template';
const isBuildDevTemplate = TARGET_ENV == 'build-development-template';

const entryPath = path.join(__dirname, 'src/static/index.js');
const outputPath = path.join(__dirname, 'dist');

const outputFilename = isProd ? '[name]-[hash].js' : '[name].js'
const outputFilenameTemplate = '[name]-[hash].js';

console.log('WEBPACK GO! Building for ' + TARGET_ENV);

var commonConfig = {
  output: {
    path: outputPath,
    filename: `static/js/${outputFilename}`,
  },
  resolve: {
    extensions: ['.js', '.elm'],
    modules: ['node_modules']
  },
  module: {
    noParse: /\.elm$/,
    rules: [{
      test: /\.(eot|ttf|woff|woff2|svg)$/,
      use: 'file-loader?publicPath=../../&name=static/css/[hash].[ext]'
    }]
  },
  plugins: [
    new webpack.LoaderOptionsPlugin({
      options: {
        postcss: [autoprefixer()]
      }
    }),
    new HtmlWebpackPlugin({
      template: 'src/static/index.html',
      inject: 'body',
      filename: 'index.html'
    })
  ]
}



if (isDev === true) {
  module.exports = merge(commonConfig, {
    entry: [
      'webpack-dev-server/client?http://localhost:8080',
      entryPath
    ],
    devServer: {
      historyApiFallback: true,
      contentBase: './src',
      hot: true
    },
    module: {
      rules: [{
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [{
          loader: 'elm-webpack-loader',
          options: {
            verbose: true,
            warn: true,
            debug: true
          }
        }]
      }, {
        test: /\.sc?ss$/,
        use: ['style-loader', 'css-loader', 'postcss-loader', 'sass-loader']
      }]
    }
  });
}

var commonConfigForTemplateExample = {
  output: {
    path: path.join(__dirname, 'dist'),
    filename: `static/js/${outputFilenameTemplate}`,
  },
  resolve: {
    extensions: ['.js', '.elm'],
    modules: ['node_modules']
  },
  module: {
    noParse: /\.elm$/,
    rules: [{
      test: /\.(eot|ttf|woff|woff2|svg|png|jpg)$/,
      use: 'file-loader?publicPath=../../&name=static/css/[hash].[ext]'
    }]
  },
  plugins: [
    new webpack.LoaderOptionsPlugin({
      options: {
        postcss: [autoprefixer()]
      },
      chunk: ['devServer']
    }),
    new HtmlWebpackPlugin({
      template: 'src/static/example/index-template.html',
      inject: 'body',
      hash: true,
      filename: (isBuildDevTemplate === true ? 'index.html' : 'index-template.html')
    }),
    new HtmlWebpackPlugin({
      template: 'src/static/index.html',
      inject: 'body',
      hash: true,
      filename: (isBuildDevTemplate === true ? 'widget.html' : 'index.html'),
      chunks: ['widget']
    })
  ]
}
if (isProd === true) {
  module.exports = merge(commonConfig, {
    entry: entryPath,
    module: {
      rules: [{
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: 'elm-webpack-loader'
      }, {
        test: /\.sc?ss$/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: ['css-loader', 'postcss-loader', 'sass-loader']
        })
      }]
    },
    plugins: [
      new ExtractTextPlugin({
        filename: 'static/css/[name]-[hash].css',
        allChunks: true,
      }),
      new CopyWebpackPlugin([{
        from: 'src/static/assets/',
        to: 'static/assets/'
      }, {
        from: 'src/static/assets/favicon.ico'
      }]),
      new webpack.optimize.UglifyJsPlugin({
        minimize: true,
        compressor: {
          warnings: false
        }
      })
    ]
  });
}


if (isBuildDevTemplate === true) {
  module.exports = merge(commonConfigForTemplateExample, {
    entry: {
      template: path.join(__dirname, 'src/static/example/index-template.js'),
      widget: path.join(__dirname, 'src/static/index.js'),
    },
    module: {
      rules: [{
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: 'elm-webpack-loader'
      }, {
        test: /\.sc?ss$/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: ['css-loader', 'postcss-loader', 'sass-loader']
        })
      }]
    },
    plugins: [
      new ExtractTextPlugin({
        filename: 'static/css/[name]-[hash].css',
        allChunks: true,
      }),
      new CopyWebpackPlugin([{
        from: 'src/static/assets/',
        to: 'static/assets/'
      }, {
        from: 'src/static/assets/favicon.ico',
        to: 'static/assets/favicon.ico'
      },
      ]),
      new webpack.optimize.UglifyJsPlugin({
        minimize: true,
        compressor: {
          warnings: false
        }
      })
    ]
  });
}

if (isDevTemplate === true) {
  module.exports = merge(commonConfigForTemplateExample, {
    entry: {
      devServer: 'webpack-dev-server/client?http://localhost:8080/',
      template: path.join(__dirname, 'src/static/example/index-template.js'),
      widget: path.join(__dirname, 'src/static/index.js'),
    },
    devServer: {
      historyApiFallback: true,
      contentBase: './src',
      hot: true
    },
    module: {
      rules: [{
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [{
          loader: 'elm-webpack-loader',
          options: {
            verbose: true,
            warn: true,
            debug: true
          }
        }]
      }, {
        test: /\.sc?ss$/,
        use: ['style-loader', 'css-loader', 'postcss-loader', 'sass-loader']
      }]
    }
  });
}
