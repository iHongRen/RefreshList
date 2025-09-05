/**
 * @fileName : RefreshFooter.ets
 * @author : @cxy
 * @date : 2024/9/19
 * @description : 加载更多组件
 */

import { RefreshFooterData, RefreshFooterState } from './RefreshState'

@Component
export struct RefreshFooter {
  @ObjectLink data: RefreshFooterData

  build() {
    Row({ space: 10 }) {
      LoadingProgress()
        .color(this.data.loadingColor)
        .size(this.data.loadingSize)
        .visibility(this.data.state === RefreshFooterState.Loading ? Visibility.Visible : Visibility.None)

      Text(this.data.getText())
        .fontColor(this.data.textColor)
        .font(this.data.font)

    }.width("100%")
    .height(44)
    .justifyContent(FlexAlign.Center)
    .visibility(this.data.isShow ? Visibility.Visible : Visibility.None)
  }
}

