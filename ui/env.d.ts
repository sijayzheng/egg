/// <reference types="vite/client" />
/// <reference types="unplugin-icons/types/vue" />

declare module '*.vue' {
  import type {DefineComponent} from 'vue'
  const component: DefineComponent<{}, {}, any>
  export default component
}

// 环境变量类型
interface ImportMetaEnv {
  readonly VITE_APP_TITLE: string
  readonly VITE_API_BASE_URL: string
  readonly VITE_UPLOAD_URL: string
  readonly VITE_PROXY_TARGET: string
  readonly VITE_USE_MOCK: boolean
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}

// 全局组件类型
declare module 'vue' {
  interface GlobalComponents {
    Icon: typeof import('~icons/*')['default']
  }
}

// 全局属性类型扩展
declare module '@vue/runtime-core' {
  interface ComponentCustomProperties {

  }
}

// 第三方库类型扩展
declare module 'js-cookie' {
  interface CookiesStatic {
    get(name: string): string | undefined

    get(name: string): any

    set(name: string, value: any, options?: any): void

    remove(name: string, options?: any): void
  }

  const Cookies: CookiesStatic
  export default Cookies
}

declare module 'nprogress' {
  interface NProgress {
    start(): void

    done(): void

    inc(): void

    set(n: number): void

    configure(options: any): void
  }

  const nprogress: NProgress
  export default nprogress
}

declare module 'crypto-js' {
  export interface WordArray {
    toString(encoder?: any): string
  }

  export interface LibStatic {
    WordArray: WordArray
  }

  export const AES: {
    encrypt(message: string, key: string): WordArray
    decrypt(ciphertext: WordArray, key: string): WordArray
  }

  export const enc: {
    Utf8: any
    Base64: any
    Hex: any
  }

  export const mode: {
    ECB: any
    CBC: any
  }

  export const pad: {
    Pkcs7: any
  }
}

// 图片和资源文件类型
declare module '*.svg' {
  const content: string
  export default content
}

declare module '*.png' {
  const content: string
  export default content
}

declare module '*.jpg' {
  const content: string
  export default content
}

declare module '*.jpeg' {
  const content: string
  export default content
}

declare module '*.gif' {
  const content: string
  export default content
}

declare module '*.webp' {
  const content: string
  export default content
}

declare module '*.ico' {
  const content: string
  export default content
}

declare module '*.json' {
  const content: any
  export default content
}

export {}