/*
 * @Author: chubiao Ni
 * @Date: 2022-02-17 14:25:40
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2022-07-04 09:48:27
 */

import fs from 'fs';
import logger from '@flutter-dom/logger';
import { parse } from './json';

/**
 * 读取 JSON 文件
 * @returns {Record<string, any>}
 */
export function readJsonFile(filePath: string): Record<string, any> {
  let jsonConfig = {};
  try {
    const jsonConfigString = fs.readFileSync(filePath, 'utf8');
    jsonConfig = parse(jsonConfigString);
  } catch (error) {
    logger.debug(`找不到文件: ${filePath}`);
  }
  return jsonConfig;
}
