import request from '@/utils/request'

export interface LoginData {
  username: string
  password: string
}

export interface UserInfo {
  id: number
  username: string
  nickname: string
  avatar: string
  email: string
  phone: string
  roles: string[]
  permissions: string[]
}

export interface LoginResponse {
  token: string
  userInfo: UserInfo
}

// 登录
export const login = (data: LoginData) => {
  return request.post<LoginResponse>('/api/auth/login', data)
}

// 获取用户信息
export const getUserInfo = () => {
  return request.get<UserInfo>('/api/auth/userInfo')
}

// 退出登录
export const logout = () => {
  return request.post('/api/auth/logout')
}