module.exports = {
  // 指定 rootDir 对应的路径，如果与 jest.config.js 文件所在的目录相同，则不用设置
  rootDir: './',
  // 使用 ts-jest 作为预处理器
  // 参考：https://kulshekhar.github.io/ts-jest/docs/getting-started/presets
  preset: 'ts-jest/presets/js-with-ts',
  // 是否报告每个test的执行详情
  verbose: true,
  // 覆盖率结果输出的文件夹
  coverageDirectory: '__tests__/coverage',
  // 模块后缀名
  moduleFileExtensions: ['js', 'json', 'ts'],
  // 初始化配置文件路径
  setupFiles: ['<rootDir>/__tests__/setup/mock.setup.ts'],
  // 测试运行环境，jsdom类浏览器环境
  testEnvironment: 'node',
  // 匹配测试文件
  testMatch: [
    // 识别模块相对地址
    '<rootDir>/packages/**/*.test.{js,ts}',
    // 识别全局测试文件
    '<rootDir>/__tests__/*.{js,ts}',
  ],
  // 忽略测试文件
  testPathIgnorePatterns: ['/node_modules/'],
  // 模块别名，注意要根据项目实际的 tsconfig.json 配置更新
  moduleNameMapper: {
    // 识别全局测试文件
    '^__tests__/(.*)$': '<rootDir>/__tests__/$1',
  },
};
