/*
 * 帮助信息相关常量
 * @Author: Jiyu Shao
 * @Date: 2021-08-12 10:27:24
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2022-07-02 17:27:21
 */

import { COMMAND } from './command';

/* 全局帮助信息 */
export const GLOBAL_HELP_MESSAGE = `
使用:
  $ flutter-dom-cli <command> [options] [<arguments> ...]

命令:
  create              创建新项目
  build               构建项目

全局选项:
  -v, --version       输出当前版本
  -h, --help          输出全局帮助信息
`;

/* build 命令帮助信息 */
const BUILD_COMMAND_HELP_MESSAGE = `
使用:
  $ flutter-dom-cli build [options] [<arguments> ...]

选项:
  -h, --help          显示当前命令帮助信息
  --project-type      项目类型，npm、library、cli
`;

/**
 * 命令帮助信息 MAPPING
 */
export const COMMAND_HELP_MESSAGE_MAPPING: Record<COMMAND, string> = {
  [COMMAND.BUILD]: BUILD_COMMAND_HELP_MESSAGE,
};
