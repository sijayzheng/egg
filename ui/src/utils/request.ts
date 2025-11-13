import axios, {AxiosInstance, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig} from 'axios';
import {ElLoading, ElMessage, ElNotification} from 'element-plus';
import FileSaver from 'file-saver';

// 定义响应数据格式
interface ResponseData<T = any> {
  code: number;
  msg: string;
  data: T;
}

// 定义返回格式
type RequestResult<T = any> = [Error | null, T | null];

// 创建 axios 实例
const request: AxiosInstance = axios.create({
  timeout: 15 * 60 * 1000,
  baseURL: '/api'
});

const tansParams = (params: Record<string, any>): string => {
  let result = '';
  for (const propName of Object.keys(params)) {
    const value = params[propName];
    const part = encodeURIComponent(propName) + '=';
    if (value !== null && value !== '' && typeof value !== 'undefined') {
      if (typeof value === 'object') {
        for (const key of Object.keys(value)) {
          if (value[key] !== null && value[key] !== '' && typeof value[key] !== 'undefined') {
            const paramKey = propName + '[' + key + ']';
            const subPart = encodeURIComponent(paramKey) + '=';
            result += subPart + encodeURIComponent(value[key]) + '&';
          }
        }
      } else {
        result += part + encodeURIComponent(value) + '&';
      }
    }
  }
  return result;
};

// 请求拦截器
request.interceptors.request.use(
    (config: InternalAxiosRequestConfig) => {
      // get请求映射params参数
      if (config.method === 'get' && config.params) {
        let url = config.url + '?' + tansParams(config.params);
        url = url.slice(0, -1);
        config.params = {};
        config.url = url;
      }
      // FormData数据去请求头Content-Type
      if (config.data instanceof FormData) {
        delete config.headers['Content-Type'];
      }
      return config;
    },
    (error: any) => {
      return Promise.reject(error);
    }
);

// 响应拦截器 - 修改为返回 [error, data] 格式
request.interceptors.response.use(
    (res: AxiosResponse) => {
      const data = res.data;
      // 二进制数据则直接返回
      if (res.request.responseType === 'blob' || res.request.responseType === 'arraybuffer') {
        return res;
      }

      // 未设置状态码则默认成功状态
      const code = data.code || 200;
      // 获取错误信息
      const msg = data.msg || '系统错误';

      if (code === 401) {
        const error = new Error('无效的会话，或者会话已过期，请重新登录。');
        return Promise.resolve([error, null]);
      } else if (code === 500) {
        ElMessage({
          message: msg,
          type: 'error'
        });
        const error = new Error(msg);
        return Promise.resolve([error, null]);
      } else if (code !== 200) {
        ElNotification.error({title: msg});
        const error = new Error('系统错误');
        return Promise.resolve([error, null]);
      } else {
        return Promise.resolve([null, data]);
      }
    },
    (error: any) => {
      let {message} = error;
      if (message === 'Network Error') {
        message = '后端接口连接异常';
      } else if (message.includes('timeout')) {
        message = '系统接口请求超时';
      } else if (message.includes('Request failed with status code')) {
        message = '系统接口' + message.substring(message.length - 3) + '异常';
      }

      ElMessage({
        message: message,
        type: 'error',
        duration: 5 * 1000
      });

      return Promise.resolve([error, null]);
    }
);

// 下载队列和状态管理
interface DownloadItem {
  url: string;
  data: any;
  fileName: string;
}

let downloadQueue: DownloadItem[] = [];
let isDownloading = false;

export function downloadFile(url: string, data: any, fileName: string): Promise<RequestResult> {
  return new Promise((resolve) => {
    // 将下载请求加入队列
    downloadQueue.push({
      url,
      data,
      fileName
    });

    // 如果没有正在进行的下载，则开始处理队列
    if (!isDownloading) {
      processDownloadQueue(resolve);
    } else {
      resolve([null, {message: '下载任务已加入队列'}]);
    }
  });
}

function processDownloadQueue(callback?: (result: RequestResult) => void) {
  if (downloadQueue.length === 0) {
    isDownloading = false;
    return;
  }

  isDownloading = true;
  const {url, data, fileName} = downloadQueue.shift()!;

  const downloadLoadingInstance = ElLoading.service({
    text: '正在下载，请稍候...',
    background: 'rgba(0, 0, 0, 0.7)'
  });

  request.post(url, data, {responseType: 'blob'})
         .then(([error, res]: RequestResult) => {
           if (error) {
             if (callback) {
               callback([error, null]);
             }
             return;
           }

           const response = res as AxiosResponse;
           if (response.type !== 'application/json') {
             const blob = new Blob([response.data], {type: 'application/octet-stream'});
             const filename = decodeURIComponent((response.headers as any).filename || fileName);
             FileSaver.saveAs(blob, filename);
             if (callback) {
               callback([null, {success: true, message: '下载成功'}]);
             }
           } else {
             const reader = new FileReader();
             reader.onload = () => {
               try {
                 const rspObj = JSON.parse(reader.result as string);
                 ElMessage.error(rspObj.msg || '系统错误');
                 if (callback) {
                   callback([new Error(rspObj.msg || '系统错误'), null]);
                 }
               } catch (e) {
                 ElMessage.error('解析错误信息失败');
                 if (callback) {
                   callback([new Error('解析错误信息失败'), null]);
                 }
               }
             };
             reader.readAsText(response.data);
           }
         })
         .catch((error: Error) => {
           console.error('下载失败:', error);
           ElMessage.error('下载文件出现错误');
           if (callback) {
             callback([error, null]);
           }
         })
         .finally(() => {
           downloadLoadingInstance.close();
           // 当前下载完成后，处理队列中的下一个任务
           setTimeout(() => processDownloadQueue(callback), 100);
         });
}

// 封装请求方法，返回 [error, data] 格式
export const http = {
  get<T = any>(url: string, config?: AxiosRequestConfig): Promise<RequestResult<T>> {
    return request.get(url, config);
  },

  post<T = any>(url: string, data?: any, config?: AxiosRequestConfig): Promise<RequestResult<T>> {
    return request.post(url, data, config);
  },

  put<T = any>(url: string, data?: any, config?: AxiosRequestConfig): Promise<RequestResult<T>> {
    return request.put(url, data, config);
  },

  delete<T = any>(url: string, config?: AxiosRequestConfig): Promise<RequestResult<T>> {
    return request.delete(url, config);
  },

  patch<T = any>(url: string, data?: any, config?: AxiosRequestConfig): Promise<RequestResult<T>> {
    return request.patch(url, data, config);
  }
};

// 导出 axios 实例（保持原样以兼容旧代码）
export default request;