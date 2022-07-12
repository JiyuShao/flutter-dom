#!/usr/bin/env node

/*
 * cli 主程序入口
 * @Author: Jiyu Shao
 * @Date: 2021-08-12 10:25:07
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2022-07-04 13:55:29
 */

import meow from 'meow';
import Commands from './commands';
import { GLOBAL_HELP_MESSAGE } from './constants/help-message';

// 执行初始化命令行逻辑
const init = async () => {
  // 配置CLI参数和标志解析规则
  const cli = meow({
    help: GLOBAL_HELP_MESSAGE,
    autoHelp: false,
    autoVersion: false,
    allowUnknownFlags: false,
    flags: {
      // 全局配置
      version: { type: 'boolean', alias: 'v' },
      help: { type: 'boolean', alias: 'h' },
    },
  });
  // 获取用户传的参数, 并进行处理
  const { input } = cli;
  const { flags } = cli;

  if (flags.version) {
    cli.showVersion();
  }

  if (input.length === 0) {
    cli.showHelp();
  }

  Commands(cli);
};

init();
