/**
 * @fileName : RefreshController.ets
 * @author : @cxy
 * @date : 2024/9/19
 * @description : 控制器
 */
import { RefreshFooterState } from "./RefreshState"


export class RefreshController {
  // 列表的scroller
  scroller: ListScroller = new ListScroller()
  // 设置是否还有更多加载
  setHasmore: (hasmore: boolean) => void = () => {
  }
  // 结束上拉和下拉刷新
  finishRefresh: () => void = () => {
  }
  // 隐藏更多加载
  hideLoadMore: (hide: boolean) => void = () => {
  }
  // 手动调用下拉刷新
  onRefresh: () => void = () => {
  }
  // 滚动到指定位置
  scrollToIndex: (index: number, smooth?: boolean, align?: ScrollAlign, options?: ScrollToIndexOptions) => void =
    () => {
    }
}