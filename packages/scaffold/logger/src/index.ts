import pino, { Logger as OrigionalLogger } from 'pino';

const logger: Logger = pino({
  level: 'debug',
  browser: {
    asObject: true,
    serialize: true,
    write: options => {
      const { level, msg } = options as {
        time: number;
        level: number;
        msg: string;
      };
      const consoleLevel = pino.levels.labels[level];
      // @ts-ignore
      if (console[consoleLevel]) {
        // @ts-ignore
        console[consoleLevel](`[${consoleLevel.toUpperCase()}] ${msg}`);
      } else {
        console.error(options);
      }
    },
  },
  transport: {
    target: 'pino-pretty',
    options: {
      colorize: true,
      ignore: 'pid,hostname',
      translateTime: 'SYS:',
    },
  },
});

export default logger;

export type Logger = OrigionalLogger;
