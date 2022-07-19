import path from 'path';
import { Configuration, DefinePlugin } from 'webpack';

export default function getWebpackConfig(
  mode: Configuration['mode']
): Configuration {
  const config: Configuration = {
    mode,
    entry: {
      JsRuntimePolyfill: path.resolve(
        __dirname,
        '../src/js-runtime-polyfill.ts'
      ),
    },
    output: {
      path: path.resolve(__dirname, '../dist'),
      filename: '[name].js',
      library: ['__FLUTTER_DOM_POLYFILL__', '[name]'],
      libraryTarget: 'umd',
      libraryExport: 'default',
    },
    devServer: {
      port: 3000,
    },
    devtool: 'source-map',
    resolve: {
      extensions: ['.js', '.ts'],
      fallback: {
        fs: false,
        process: false,
        path: false,
        perf_hooks: false,
        buffer: false,
        worker_threads: false,
        stream: false,
        crypto: require.resolve('crypto-browserify'),
      },
    },
    module: {
      rules: [
        {
          test: /\.ts$/,
          loader: 'ts-loader',
          include: path.resolve(__dirname, '../src'),
        },
      ],
    },
    plugins: [
      new DefinePlugin({
        'process.env': {},
      }),
    ],
  };
  return config;
}
