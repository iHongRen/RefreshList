/**
 * @fileName : RefreshHeader.ets
 * @author : @cxy
 * @date : 2024/9/19
 * @description : 下拉刷新头组件
 */
import { RefreshHeaderData } from './RefreshState'

@Component
export struct RefreshHeader {
  @ObjectLink data: RefreshHeaderData

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      // 可以通过刷新状态控制是否存在Progress组件
      // 当刷新状态处于下拉中或刷新中状态时Progress组件才存在
      if (this.data.refreshState != RefreshStatus.Inactive && this.data.refreshState != RefreshStatus.Done) {
        Progress({ value: this.data.refreshOffset, total: 64, type: ProgressType.Ring })
          .width(20)
          .height(20)
          .style({ status: this.data.refreshing ? ProgressStatus.LOADING : ProgressStatus.PROGRESSING })
          .margin(10)
          .color(new LinearGradient([{ color: "#d8eaff", offset: 0 },
            { color: "#0b72ea", offset: 1 }]))
      }
    }
    .clip(true)
    .height("100%")
    .width("100%")
  }
}
