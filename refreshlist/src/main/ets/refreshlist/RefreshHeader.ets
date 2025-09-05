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
      Column({ space: 10 }) {
        if (this.data.state !== RefreshStatus.Inactive && this.data.state !== RefreshStatus.Done) {
          Progress({ value: this.data.offset, total: 64, type: ProgressType.Ring })
            .size(this.data.loadingSize)
            .color(this.data.loadingColor)
            .style({
              status: this.data.state === RefreshStatus.Refresh ? ProgressStatus.LOADING : ProgressStatus.PROGRESSING
            })
        }

        Text(this.data.getText())
          .fontColor(this.data.textColor)
          .font(this.data.font)
      }
      .padding({ top: 10 })
      .height(64)
    }
    .clip(true)
    .height("100%")
    .width("100%")
  }
}
