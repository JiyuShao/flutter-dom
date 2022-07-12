import * as commentJson from 'comment-json';

interface Parse {
  <T = any>(
    text: string,
    reviver?: ((this: any, key: string, value: any) => any) | null
  ): T;
}

const parse: Parse = str => commentJson.parse(str);

const stringify = (parsed: Record<string, any>): string => {
  const sorted = commentJson.assign({}, parsed, Object.keys(parsed).sort());
  return commentJson.stringify(sorted, null, 2);
};

export { parse, stringify };
