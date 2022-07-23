import { v4 as uuidv4 } from 'uuid';
import {
  getQuickJS,
  QuickJSContext,
  QuickJSWASMModule,
} from 'quickjs-emscripten';
import { Arena, complexity } from 'quickjs-emscripten-sync';

/** JS 运行环境实例 mapping */
const RUNTIME_INSTANCE_MAPPING: Record<string, Runtime> = {};
class Runtime {
  /** 当前运行环境实例 id */
  private _instanceId?: string;

  /** 当前运行环境实例 */
  private _ctx?: QuickJSContext;

  /** 当前运行环境封装 */
  private _arena?: Arena;

  /** 当前实例初始化缓存 */
  private _initPromise?: Promise<QuickJSWASMModule>;

  constructor() {
    this._init();
  }

  private async _init() {
    try {
      this._initPromise = getQuickJS();
      const QuickJS = await this._initPromise;
      this._instanceId = uuidv4();
      this._ctx = QuickJS.newContext();
      this._arena = new Arena(this._ctx, {
        isMarshalable: (target: any) => {
          // prevent passing globalThis to QuickJS
          if (target === window) return false;
          // complexity is a helper function to detect whether the object is heavy
          if (complexity(target, 30) >= 30) return false;
          return true; // other objects are OK
        },
      });
      RUNTIME_INSTANCE_MAPPING[this._instanceId] = this;
    } catch (error) {
      console.error('Init VM Failed');
      throw error;
    }
  }

  public get waitUntilInited(): Promise<QuickJSWASMModule> | undefined {
    return this._initPromise;
  }

  public getInstanceId(): string {
    return this._instanceId || '';
  }

  public evaluate(code: string): string | Error {
    if (!this._ctx || !this._arena) {
      return new Error('VM is undefined');
    }
    try {
      const result = this._arena.evalCode(code);

      console.debug('Evaluate code succeed', {
        instanceId: this._instanceId,
        code,
        result,
      });

      return JSON.stringify({
        type: typeof result,
        value: result,
      });
    } catch (error) {
      console.debug('Evaluate code failed', {
        instanceId: this._instanceId,
        code,
        error,
      });
      throw new Error(`Evaluate code failed: ${(error as Error).message}`, {
        cause: error as Error,
      });
    }
  }

  public executePendingJobs() {
    if (!this._ctx || !this._arena) {
      return new Error('VM is undefined');
    }
    return this._arena?.executePendingJobs();
  }

  public destory() {
    this._arena?.dispose();
    this._ctx?.dispose();
    this._instanceId && delete RUNTIME_INSTANCE_MAPPING[this._instanceId];
  }
}

export default {
  getAllRuntimeIds: (): string[] => {
    return Object.keys(RUNTIME_INSTANCE_MAPPING);
  },
  createRuntime: async (): Promise<string> => {
    const instance = new Runtime();
    await instance.waitUntilInited;
    return instance.getInstanceId();
  },
  evaluate: (instanceId: string, code: string): string | Error => {
    return RUNTIME_INSTANCE_MAPPING[instanceId]?.evaluate(code);
  },
  executePendingJobs: (instanceId: string): number | Error => {
    return RUNTIME_INSTANCE_MAPPING[instanceId]?.executePendingJobs();
  },
  destoryRuntime: (instanceId: string): void => {
    RUNTIME_INSTANCE_MAPPING[instanceId]?.destory();
  },
};
