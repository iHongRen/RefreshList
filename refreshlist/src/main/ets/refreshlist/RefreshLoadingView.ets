/**
 * @fileName : RefreshLoadingView.ets
 * @author : @cxy
 * @date : 2025/4/11
 * @description : 文件描述
 */

@Component
export struct RefreshLoadingView {
  @Prop loading: boolean = true
  @Prop title: string = '数据加载中...'

  build() {
    if (this.loading) {
      Column({space: 5}) {
        LoadingProgress().color('#bbb').width(30).height(30)
        Text(this.title).fontColor('#999').fontSize(14)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
  }
}