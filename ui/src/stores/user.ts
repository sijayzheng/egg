import {defineStore} from 'pinia'
import {ref} from 'vue'
import type {RouteRecordRaw} from 'vue-router'
import {asyncRoutes} from '@/router'
import {login, type LoginData, type UserInfo} from '@/api/user'

export const useUserStore = defineStore('user', () => {
  const token = ref<string>('')
  const userInfo = ref<UserInfo>({} as UserInfo)
  const routes = ref<RouteRecordRaw[]>([])

  // 登录
  const loginAction = async (loginData: LoginData) => {
    try {
      const {data} = await login(loginData)
      token.value = data.token
      // 存储token到本地存储
      localStorage.setItem('token', data.token)
      return Promise.resolve(data)
    } catch (error) {
      return Promise.reject(error)
    }
  }

  // 获取用户信息
  const getUserInfo = async () => {
    try {
      const {data} = await getUserInfo()
      userInfo.value = data
      return Promise.resolve(data)
    } catch (error) {
      return Promise.reject(error)
    }
  }

  // 生成动态路由
  const generateRoutes = () => {
    // 根据用户角色过滤路由
    const accessedRoutes = filterAsyncRoutes(asyncRoutes, userInfo.value.roles || [])
    routes.value = accessedRoutes
    return accessedRoutes
  }

  // 过滤异步路由
  const filterAsyncRoutes = (routes: RouteRecordRaw[], roles: string[]) => {
    const res: RouteRecordRaw[] = []

    routes.forEach(route => {
      const tmp = {...route}
      if (hasPermission(roles, tmp)) {
        if (tmp.children) {
          tmp.children = filterAsyncRoutes(tmp.children, roles)
        }
        res.push(tmp)
      }
    })

    return res
  }

  // 检查权限
  const hasPermission = (roles: string[], route: RouteRecordRaw) => {
    if (route.meta && route.meta.roles) {
      return roles.some(role => (route.meta!.roles as string[]).includes(role))
    }
    return true
  }

  // 退出登录
  const logout = () => {
    resetToken()
    // 重置路由
    location.reload()
  }

  // 重置token
  const resetToken = () => {
    token.value = ''
    userInfo.value = {} as UserInfo
    routes.value = []
    localStorage.removeItem('token')
  }

  return {
    token,
    userInfo,
    routes,
    loginAction,
    getUserInfo,
    generateRoutes,
    logout,
    resetToken
  }
})