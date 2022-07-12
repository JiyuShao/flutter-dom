/*
 * 命令暴露
 * @Author: Jiyu Shao
 * @Date: 2021-08-12 11:24:02
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2022-07-12 10:50:45
 */
import React from 'react';
import { render } from 'ink';
import { AnyFlags, Result } from 'meow';
import { COMMAND } from '../constants/command';
import Compile from './compile';
import { reportUnknownCommand } from '../utils/command-helper';
import { useCheckUpdate } from '../utils/hooks/update-checker';
import { COMMAND_HELP_MESSAGE_MAPPING } from '../constants/help-message';

/**
 * 命令处理器 MAPPING
 */
const COMMAND_HANDLER_MAPPING: Record<
  COMMAND,
  (_: Result<AnyFlags>) => JSX.Element
> = {
  [COMMAND.BUILD]: () => <Compile />,
};

interface AppProps {
  cli: Result<AnyFlags>;
}
/**
 * App
 */
function Commands(props: AppProps) {
  const { cli } = props;
  const { input, flags } = cli;

  const command = input[0] as COMMAND;

  // 检查更新逻辑
  const checkUpdateMessage = useCheckUpdate();
  if (checkUpdateMessage) {
    return checkUpdateMessage;
  }

  // 检查命令是否有效
  const commandHandler = COMMAND_HANDLER_MAPPING[command];
  if (typeof commandHandler === 'undefined') {
    reportUnknownCommand(input[0]);
    return null;
  }

  // 输出命令帮助信息
  if (flags.help) {
    console.log(COMMAND_HELP_MESSAGE_MAPPING[command]);
    return null;
  }
  return commandHandler(cli);
}

export default function Main(cli: Result<AnyFlags>) {
  return render(<Commands cli={cli} />);
}
