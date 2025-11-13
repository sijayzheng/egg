import {createApp} from 'vue'
import './style.css'
import App from './App.vue'

import 'highlight.js/styles/stackoverflow-light.css'
import 'highlight.js/lib/common';
import hljsVuePlugin from "@highlightjs/vue-plugin";
import router from './router'
import {createPinia} from 'pinia'

// 样式引入
import 'virtual:uno.css'
import 'animate.css/animate.min.css'
import 'nprogress/nprogress.css'
import '@highlightjs/vue-plugin'
import './styles/index.scss'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'

const app = createApp(App)

// Pinia状态管理
const pinia = createPinia()
app.use(pinia)

// 路由
app.use(router)

// 注册Element Plus
app.use(ElementPlus)

// 注册所有图标
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}


app.use(hljsVuePlugin)
app.mount('#app')


