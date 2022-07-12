/*
 * Command 工具函数
 * @Author: Jiyu Shao
 * @Date: 2021-08-12 11:12:48
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2022-07-04 09:48:16
 */

import logger from '@flutter-dom/logger';
import { COMMAND } from '../constants/command';

const VALID_COMMANDS = Object.entries(COMMAND).map(cmd => cmd[1]);

/**
 * 是否为有效command
 *
 * @export
 * @param {COMMAND} command command
 */
export function isValidCommand(command: COMMAND): boolean {
  return VALID_COMMANDS.includes(command);
}

/**
 * 提示command不支持
 *
 * @export
 * @param {COMMAND} command command
 */
export function reportUnknownCommand(command: string): void {
  logger.error('Unknown command: %s', command);
}

/**
 * 提示argument不支持
 *
 * @export
 * @param {string} arg arguments
 */
export function reportUnknownArgument(arg: string): void {
  logger.error('Unknown argument: %s', arg);
}
