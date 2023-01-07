import path from 'path';
import { Configuration, DefinePlugin } from 'webpack';
import 'webpack-dev-server';

export default function getWebpackConfig(
  mode: Configuration['mode']
): Configuration {
  const config: Configuration = {
    mode,
    entry: {
      JsRuntimeBridge: path.resolve(
        __dirname,
        '../src/js-runtime-bridge/index.ts'
      ),
      // webpack build is not compatible with quickjs
      // FlutterDomBridge: path.resolve(
      //   __dirname,
      //   '../src/flutter-dom-bridge/index.ts'
      // ),
    },
    output: {
      path: path.resolve(__dirname, '../dist'),
      filename: '[name].js',
      library: ['__FLUTTER_DOM_BRIDGE__', '[name]'],
      // 如果设置的是 umd 的话，在 flutter web 中会走 amd define 导致逻辑出错
      libraryTarget: 'window',
      libraryExport: 'default',
    },
    devServer: {
      port: 3000,
      devMiddleware: {
        writeToDisk: true,
      },
      // useing webpack dev server to serve both webpack & rollup dev dist outputs
      // eg: http://localhost:3000/dist/JsRuntimeBridge.js
      setupMiddlewares(middlewares, devServer) {
        if (!devServer) {
          throw new Error('webpack-dev-server is not defined');
        }
        devServer.app?.get('/dist/*', (req, res) => {
          try {
            res.sendFile(path.join(__dirname, `../${req.path}`));
          } catch (error) {
            console.error('Read dist file failed:', error);
          }
        });
        return middlewares;
      },
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
          options: {
            // 忽略 ts 错误
            transpileOnly: true,
            // 与 tsconfig 配置的不同，只需要编译需要的文件
            onlyCompileBundledFiles: true,
            compilerOptions: {
              // 需要输出，否则会编译失败
              noEmit: false,
              // 输出类型文件
              declaration: false,
              // 指定类型文件输出目录
              outDir: path.resolve(__dirname, '../dist'),
            },
          },
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
