import { v4 as uuidv4 } from 'uuid';
import { getQuickJS, QuickJSVm } from 'esm-quickjs-emscripten';

/** JS 运行环境实例 mapping */
const RUNTIME_INSTANCE_MAPPING: Record<string, Runtime> = {};
class Runtime {
  /** 当前运行环境实例 id */
  private _instanceId?: string;

  /** 当前运行环境实例 */
  private _instance?: QuickJSVm;

  constructor() {
    getQuickJS()
      .then(quickjs => {
        this._instanceId = uuidv4();
        this._instance = quickjs.createVm();
        RUNTIME_INSTANCE_MAPPING[this._instanceId] = this;
      })
      .catch(error => {
        console.error('Init QuickJs Failed');
        throw error;
      });
  }

  public getInstanceId(): string {
    return this._instanceId || '';
  }

  public evaluate(code: string) {
    return this._instance?.evalCode(code);
  }

  public destory() {
    this._instance?.dispose();
    this._instanceId && delete RUNTIME_INSTANCE_MAPPING[this._instanceId];
  }
}

export default {
  getAllRuntimeIds: (): string[] => {
    return Object.keys(RUNTIME_INSTANCE_MAPPING);
  },
  createRuntime: (): string => {
    const instance = new Runtime();
    return instance.getInstanceId();
  },
  evaluate: (instanceId: string, code: string): any => {
    return RUNTIME_INSTANCE_MAPPING[instanceId]?.evaluate(code);
  },
  destoryRuntime: (instanceId: string): void => {
    RUNTIME_INSTANCE_MAPPING[instanceId]?.destory();
  },
};
