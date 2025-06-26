/**
 * @fileName : RefreshHeader.ets
 * @author : @cxy
 * @date : 2024/9/19
 * @description : 文件描述
 */
import { RefreshHeaderData } from './RefreshState'

@Builder
export function RefreshHeader(refreshData: RefreshHeaderData) {
  Stack({ alignContent: Alignment.Bottom }) {
    // 可以通过刷新状态控制是否存在Progress组件
    // 当刷新状态处于下拉中或刷新中状态时Progress组件才存在
    if (refreshData.refreshState != RefreshStatus.Inactive && refreshData.refreshState != RefreshStatus.Done) {
      Progress({ value: refreshData.refreshOffset, total: 64, type: ProgressType.Ring })
        .width(20)
        .height(20)
        .style({ status: refreshData.refreshing ? ProgressStatus.LOADING : ProgressStatus.PROGRESSING })
        .margin(10)
        .color(new LinearGradient([{ color: "#d8eaff", offset: 0 },
          { color: "#0b72ea", offset: 1 }]))
    }
  }
  .clip(true)
  .height("100%")
  .width("100%")
}
