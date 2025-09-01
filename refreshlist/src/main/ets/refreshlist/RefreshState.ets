/**
 * @fileName : RefreshState.ets
 * @author : @cxy
 * @date : 2024/9/19
 * @description : 刷新状态
 */

@Observed
export class RefreshHeaderData {
  @Track refreshState: RefreshStatus = RefreshStatus.Inactive
  @Track refreshOffset: number = 0 //偏移量
  @Track refreshing: boolean = false //是否正在刷新
}

export enum RefreshFooterState {
  None = 0, //默认
  Loading = 1, //刷新中
  NoMore = 2, //没有更多
}

@Observed
export class RefreshFooterData {
  @Track isShow: boolean = true //是否显示
  @Track state: RefreshFooterState = RefreshFooterState.None
  @Track noneText: string = '上拉加载更多' //默认文本
  @Track loadingText: string = '加载中...' //加载中文本
  @Track noMoreText: string = '亲，没有更多了' //没有更多文本

  footerText(): string {
    if (this.state === RefreshFooterState.Loading) {
      return this.loadingText
    }
    if (this.state === RefreshFooterState.NoMore) {
      return this.noMoreText
    }
    return this.noneText
  }
}



