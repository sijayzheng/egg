import {createRouter, createWebHistory, type RouteRecordRaw} from 'vue-router'
import {useUserStore} from '@/stores/user'
import {ElMessage} from 'element-plus'

// 布局组件
const Layout = () => import('@/layout/index.vue')

// 自动导入views目录下的所有vue文件
const modules = import.meta.glob('@/views/**/*.vue')

// 路由配置
export const constantRoutes: RouteRecordRaw[] = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/login.vue'),
    meta: {
      title: '登录',
      hidden: true,
      noAuth: true
    }
  },
  {
    path: '/404',
    name: 'NotFound',
    component: () => import('@/views/error/404.vue'),
    meta: {
      title: '404',
      hidden: true,
      noAuth: true
    }
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/404',
    meta: {
      hidden: true
    }
  }
]

export const asyncRoutes: RouteRecordRaw[] = [
  // {
  //   path: '/',
  //   component: Layout,
  //   redirect: '/dashboard',
  //   meta: {
  //     title: '首页',
  //     icon: 'House',
  //     affix: true
  //   },
  //   children: [
  //     {
  //       path: 'dashboard',
  //       name: 'Dashboard',
  //       component: () => import('@/views/dashboard/index.vue'),
  //       meta: {
  //         title: '仪表板',
  //         icon: 'Odometer',
  //         affix: true,
  //         keepAlive: true
  //       }
  //     }
  //   ]
  // },
  // {
  //   path: '/system',
  //   component: Layout,
  //   meta: {
  //     title: '系统管理',
  //     icon: 'Setting',
  //     roles: ['admin']
  //   },
  //   children: [
  //     {
  //       path: 'user',
  //       name: 'User',
  //       component: () => import('@/views/system/user/index.vue'),
  //       meta: {
  //         title: '用户管理',
  //         icon: 'User',
  //         roles: ['admin'],
  //         keepAlive: true
  //       }
  //     },
  //     {
  //       path: 'role',
  //       name: 'Role',
  //       component: () => import('@/views/system/role/index.vue'),
  //       meta: {
  //         title: '角色管理',
  //         icon: 'UserFilled',
  //         roles: ['admin'],
  //         keepAlive: true
  //       }
  //     },
  //     {
  //       path: 'menu',
  //       name: 'Menu',
  //       component: () => import('@/views/system/menu/index.vue'),
  //       meta: {
  //         title: '菜单管理',
  //         icon: 'Menu',
  //         roles: ['admin'],
  //         keepAlive: true
  //       }
  //     }
  //   ]
  // },
  // {
  //   path: '/example',
  //   component: Layout,
  //   meta: {
  //     title: '功能示例',
  //     icon: 'Grid'
  //   },
  //   children: [
  //     {
  //       path: 'table',
  //       name: 'Table',
  //       component: () => import('@/views/example/table/index.vue'),
  //       meta: {
  //         title: '表格示例',
  //         icon: 'Document'
  //       }
  //     },
  //     {
  //       path: 'form',
  //       name: 'Form',
  //       component: () => import('@/views/example/form/index.vue'),
  //       meta: {
  //         title: '表单示例',
  //         icon: 'Document'
  //       }
  //     },
  //     {
  //       path: 'chart',
  //       name: 'Chart',
  //       component: () => import('@/views/example/chart/index.vue'),
  //       meta: {
  //         title: '图表示例',
  //         icon: 'PieChart'
  //       }
  //     },
  //     {
  //       path: 'editor',
  //       name: 'Editor',
  //       component: () => import('@/views/example/editor/index.vue'),
  //       meta: {
  //         title: '富文本编辑器',
  //         icon: 'Edit'
  //       }
  //     }
  //   ]
  // },
  // {
  //   path: '/profile',
  //   component: Layout,
  //   meta: {
  //     title: '个人中心',
  //     icon: 'User',
  //     hidden: true
  //   },
  //   children: [
  //     {
  //       path: 'index',
  //       name: 'Profile',
  //       component: () => import('@/views/profile/index.vue'),
  //       meta: {
  //         title: '个人资料',
  //         icon: 'User'
  //       }
  //     }
  //   ]
  // }
]

// 创建路由实例
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: constantRoutes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return {top: 0}
    }
  }
})

// 白名单路由（不需要登录即可访问）
const whiteList = ['/login', '/404']

// 路由守卫
router.beforeEach(async (to, from, next) => {
  // 显示页面加载进度条
  if (typeof window !== 'undefined') {
    const nprogress = (await import('nprogress')).default
    nprogress.start()
  }

  const userStore = useUserStore()

  // 判断是否有token
  if (userStore.token) {
    if (to.path === '/login') {
      // 如果已登录，跳转到首页
      next('/')
    } else {
      // 检查用户信息是否已加载
      if (!userStore.userInfo.id) {
        try {
          // 获取用户信息
          await userStore.getUserInfo()

          // 动态添加路由
          await userStore.generateRoutes()
          const accessRoutes = userStore.routes
          accessRoutes.forEach(route => {
            router.addRoute(route)
          })

          // 添加完成后，重定向到目标路由
          next({...to, replace: true})
        } catch (error) {
          // 获取用户信息失败，清除token并跳转到登录页
          await userStore.resetToken()
          ElMessage.error('用户信息获取失败，请重新登录')
          next(`/login?redirect=${to.path}`)
        }
      } else {
        next()
      }
    }
  } else {
    // 没有token
    if (whiteList.includes(to.path)) {
      next()
    } else {
      next(`/login?redirect=${to.path}`)
    }
  }
})

router.afterEach(() => {
  // 关闭进度条
  if (typeof window !== 'undefined') {
    import('nprogress').then(module => {
      module.default.done()
    })
  }
})

// 重置路由
export function resetRouter() {
  const resetWhiteList = ['Login', 'NotFound', 'Redirect']
  router.getRoutes().forEach(route => {
    const {name} = route
    if (name && !resetWhiteList.includes(name as string)) {
      router.hasRoute(name) && router.removeRoute(name)
    }
  })
}

export default router