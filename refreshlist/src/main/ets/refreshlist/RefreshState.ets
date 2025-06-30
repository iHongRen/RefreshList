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
  hide: boolean //是否需要隐藏 footer
  state: RefreshFooterState
}

export interface RefreshHeaderData {
  refreshState: RefreshStatus
  refreshOffset: number //偏移量
  refreshing: boolean //是否正在刷新
}

