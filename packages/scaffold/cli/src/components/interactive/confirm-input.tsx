import { Box, Text } from 'ink';
import React, { useState, ReactElement } from 'react';
import { ConfirmInput } from '../index';

export type IncConfirmInputProps = {
  quetion: string;
  props: Record<string, any>;
};

interface IncComfirnInputType {
  (props: IncConfirmInputProps): ReactElement;
}

export const IncComfirnInput: IncComfirnInputType = ({ props, quetion }) => {
  const [value, setValue] = useState('');

  return (
    <Box>
      <Text>{quetion}</Text>
      <ConfirmInput
        placeholder="(y/n)"
        value={value}
        onChange={(value: string) => {
          (!value || /[yn]{1}/i.test(value)) && setValue(value);
        }}
        {...props}
      />
    </Box>
  );
};
