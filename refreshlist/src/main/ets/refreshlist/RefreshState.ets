/**
 * @fileName : RefreshState.ets
 * @author : @cxy
 * @date : 2024/9/19
 * @description : 文件描述
 */

export enum RefreshFooterState {
  Loading = '加载中...',
  NoMore = '亲，没有更多了'
}

export interface RefreshFooterData {
  hide: boolean
  state: RefreshFooterState
}

export interface RefreshHeaderData {
  refreshState: RefreshStatus
  refreshOffset: number
  refreshing: boolean
  text: string
  textColor?: ResourceColor
}

