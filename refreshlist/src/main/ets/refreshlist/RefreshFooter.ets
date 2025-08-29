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
        .color('#bbb')
        .width(30)
        .height(30)
        .visibility(this.data.state === RefreshFooterState.Loading ? Visibility.Visible : Visibility.None)

      Text(this.data.footerText()).fontColor('#999').fontSize(13)
    }.width("100%")
    .height(44)
    .justifyContent(FlexAlign.Center)
    .visibility(this.data.isShow ? Visibility.Visible : Visibility.None)
  }
}

