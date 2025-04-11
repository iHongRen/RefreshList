/**
 * @fileName : RefreshFooter.ets
 * @author : @cxy
 * @date : 2024/9/19
 * @description : 文件描述
 */

import { RefreshFooterState, RefreshFooterData } from './RefreshState'

@Builder
export function RefreshFooter(data: RefreshFooterData) {
  Row({ space: 10 }) {
    LoadingProgress()
      .color('#bbb')
      .width(30)
      .height(30)
      .visibility(data.state === RefreshFooterState.Loading ? Visibility.Visible : Visibility.None)

    Text(data.state).fontColor('#999').fontSize(13)
  }.width("100%")
  .height(44)
  .justifyContent(FlexAlign.Center)
  .visibility(data.hide ? Visibility.Hidden : Visibility.Visible)
}