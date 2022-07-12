import React from 'react';
import { IncConfirmInputProps, IncComfirnInput } from './confirm-input';
import { IncTextInputProps, IncTextInput } from './input-text';

export enum GENERATOR_TYPE {
  CONFIRM,
  TEXT_INPUT,
  SELECT,
}

type Options = IncConfirmInputProps | IncTextInputProps;

interface GeneratorType {
  type: GENERATOR_TYPE;
  options: Options;
}

/**
 * @param {GeneratorType} props.type 指定交互类型
 * @param {Record<keyof, any>} props.options 对应交互组件参数
 */
export const InteractiveGenerator = (
  props: GeneratorType
): React.ReactElement | null => {
  let interactive: React.ReactElement | null = null;
  switch (props.type) {
    case GENERATOR_TYPE.CONFIRM:
      interactive = (
        <IncComfirnInput {...(props.options as IncConfirmInputProps)} />
      );
      break;
    case GENERATOR_TYPE.TEXT_INPUT:
      interactive = <IncTextInput {...(props.options as IncTextInputProps)} />;
      break;
    default:
      interactive = null;
  }
  return interactive;
};
