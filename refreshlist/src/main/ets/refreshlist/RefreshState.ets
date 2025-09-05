/**
 * @fileName : RefreshState.ets
 * @author : @cxy
 * @date : 2024/9/19
 * @description : 刷新状态
 */
import { RefreshGlobalConfig } from "./RefreshGlobalConfig"

@Observed
export class RefreshHeaderData {
  @Track state: RefreshStatus = RefreshStatus.Inactive //刷新状态
  @Track offset: number = 0 //偏移量
  @Track dragText: ResourceStr = RefreshGlobalConfig.headerDragText //默认文本
  @Track overDragText: ResourceStr = RefreshGlobalConfig.headerOverDragText //加载中文本
  @Track refreshText: ResourceStr = RefreshGlobalConfig.headerRefreshText //没有更多文本
  @Track doneText: ResourceStr = RefreshGlobalConfig.headerDoneText //没有更多文本
  @Track textColor: ResourceColor = RefreshGlobalConfig.headerTextColor //文本颜色
  @Track font: Font = RefreshGlobalConfig.headerTextFont //文本字体
  @Track loadingColor: ResourceColor | LinearGradient = RefreshGlobalConfig.headerLoadingColor // loading 颜色
  @Track loadingSize: SizeOptions = RefreshGlobalConfig.headerLoadingSize //loading size

  getText(): ResourceStr {
    if (this.state === RefreshStatus.Drag) {
      return this.dragText
    }
    if (this.state === RefreshStatus.OverDrag) {
      return this.overDragText
    }
    if (this.state === RefreshStatus.Refresh) {
      return this.refreshText
    }
    if (this.state === RefreshStatus.Done) {
      return this.doneText
    }
    return this.dragText
  }
}

export enum RefreshFooterState {
  None = 0, //默认
  Loading = 1, //刷新中
  NoMore = 2, //没有更多
}

@Observed
export class RefreshFooterData {
  @Track isShow: boolean = true //是否显示
  @Track state: RefreshFooterState = RefreshFooterState.None //状态
  @Track noneText: ResourceStr = RefreshGlobalConfig.footerNoneText //默认文本
  @Track loadingText: ResourceStr = RefreshGlobalConfig.footerLoadingText //加载中文本
  @Track noMoreText: ResourceStr = RefreshGlobalConfig.footerNoMoreText //没有更多文本
  @Track textColor: ResourceColor = RefreshGlobalConfig.footerTextColor //文本颜色
  @Track font: Font = RefreshGlobalConfig.footerTextFont //文本字体
  @Track loadingColor: ResourceColor = RefreshGlobalConfig.footerLoadingColor // loading 颜色
  @Track loadingSize: SizeOptions = RefreshGlobalConfig.footerLoadingSize //loading size

  getText(): ResourceStr {
    if (this.state === RefreshFooterState.Loading) {
      return this.loadingText
    }
    if (this.state === RefreshFooterState.NoMore) {
      return this.noMoreText
    }
    return this.noneText
  }
}



