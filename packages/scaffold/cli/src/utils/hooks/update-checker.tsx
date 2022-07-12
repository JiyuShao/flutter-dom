/*
 * @Author: Jiyu Shao
 * @Date: 2022-07-02 14:58:17
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2022-07-04 13:59:23
 */

import React, { useEffect, useState } from 'react';
import { Text } from 'ink';
import path from 'path';
import updateNotifier, { Package } from 'update-notifier';
import logger from '@flutter-dom/logger';
import { Spinner } from '../../components';
import config from '../config';
import { readJsonFile } from '../file-system';

interface INotifierInfo {
  /** Latest version */
  latest: string;
  /** Current version */
  current: string;
  /** Type of current update. Possible values: latest, major, minor, patch, prerelease, build */
  type: string;
  /** Package name */
  name: string;
}

/**
 * 状态
 */
enum STATUS {
  /** 检查中 */
  CHECKING,
  /** 检查失败 */
  ERROR,
  /** 最新版本 */
  LATEST,
  /** 过期版本 */
  OUTDATE,
}

/**
 * 检查更新逻辑
 * @returns {React.ReactElement | null}
 */
export function useCheckUpdate(): React.ReactElement | null {
  const [status, setStatus] = useState(STATUS.CHECKING);
  useEffect(() => {
    const checkUpdate = async () => {
      const updater = new updateNotifier.UpdateNotifier({
        pkg: readJsonFile(
          path.resolve(config.paths.cliProjectRoot, 'package.json')
        ) as Package,
        updateCheckInterval: 0,
        shouldNotifyInNpmScript: true,
      });
      try {
        const updateInfo = (await updater.fetchInfo()) as INotifierInfo;
        if (updateInfo.type === 'latest') {
          setStatus(STATUS.LATEST);
          return;
        }
        updater.config.set('update', updateInfo);
        updater.check();
        updater.notify({
          message: `发现新版本 ${updateInfo.latest} ！\n\n运行 npm i @flutter-dom/cli@${updateInfo.latest} -g 命令来更新`,
        });
        // 不是最新版本，render 会返回 null，process 会自动退出
        setStatus(STATUS.OUTDATE);
      } catch (e: any) {
        logger.error('检查更新出错：%s', e.message);
        setStatus(STATUS.ERROR);
      }
    };
    checkUpdate();
  }, [setStatus]);

  if (status === STATUS.CHECKING) {
    return (
      <Text>
        <Text color="green">
          <Spinner type="dots" />
          检查更新中...
        </Text>
      </Text>
    );
  }
  return null;
}
