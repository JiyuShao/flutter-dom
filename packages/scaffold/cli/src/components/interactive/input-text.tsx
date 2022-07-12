import { Box, Text } from 'ink';
import React, { useState, ReactElement } from 'react';
import { TextInput } from '../index';

export type IncTextInputProps = {
  title: string;
  props: Record<string, any>;
};

interface IncTextInputType {
  (props: IncTextInputProps): ReactElement;
}

export const IncTextInput: IncTextInputType = ({ title, props }) => {
  const [value, setValue] = useState('');

  return (
    <Box>
      <Box marginRight={1}>
        <Text>{title}</Text>
      </Box>

      <TextInput value={value} onChange={setValue} {...props} />
    </Box>
  );
};
