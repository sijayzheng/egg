import type {ComposeOption} from 'echarts/core'
import type {BarSeriesOption, LineSeriesOption} from 'echarts/charts'
import type {DatasetComponentOption, GridComponentOption, TitleComponentOption, TooltipComponentOption} from 'echarts/components'

export interface BaseEntity {
  createDept?: number | string
  createBy?: number | string
  createTime?: string
  updateBy?: number | string
  updateTime?: string
}

export interface PageOrder {
  field: string
  isDesc?: boolean
}

export interface PageQuery {
  current: number | string
  size: number | string
  orders?: PageOrder[]
}

export interface TreeNode<T, K> {
  label: string
  value: K
  children: TreeNode<T, K>[]
  level: number
  isLeaf: boolean
}

export interface SelectOption<T> {
  value: T
  label: string
}

export interface Result<T> {
  success: boolean
  code: number
  message: string
  data: T
  total: number | string
}

export type ECOption = ComposeOption<| BarSeriesOption | LineSeriesOption | TitleComponentOption | TooltipComponentOption | GridComponentOption | DatasetComponentOption>
export type NullType<T> = T | null;


