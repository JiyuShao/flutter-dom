import { Text } from 'ink';
import React, { useEffect, useState } from 'react';
import { Spinner } from '../../components';

/**
 * 状态
 */
enum STATUS {
  /** 初始化中 */
  INIT,
  /** 结束 */
  FINISH,
}

export default function Dev(): JSX.Element | null {
  const [status, setStatus] = useState(STATUS.INIT);

  useEffect(() => {
    setStatus(STATUS.FINISH);
  }, []);

  if (status === STATUS.INIT) {
    return (
      <Text color="green">
        <Spinner type="dots" />
        <Text color="green">Initing</Text>
      </Text>
    );
  }

  return null;
}
