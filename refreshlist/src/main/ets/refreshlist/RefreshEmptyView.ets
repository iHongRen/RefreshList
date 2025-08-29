/**
 * @fileName : RefreshEmptyView.ets
 * @author : @cxy
 * @date : 2025/4/11
 * @description : 空页面
 */

@Component
export struct RefreshEmptyView {
  @Prop icon: ResourceStr = $r('sys.media.save_button_picture')
  @Prop title: string = '暂无数据'
  @Prop desc: string = ''
  @Prop retryTitle: string = '重新加载'
  @Prop offsetY: number = 0 //可用来调整位置, 0居中
  @Prop iconSize: Size = { width: 100, height: 100 }
  onRetry?: () => void

  build() {
    Column({ space: 8 }) {
      Column({ space: 10 }) {
        Image(this.icon).size(this.iconSize).objectFit(ImageFit.Contain)
        Text(this.title).fontColor('#999').fontSize(14)
        Text(this.desc).fontColor('#aaa').fontSize(12)
        if (this.onRetry) {
          Button() {
            Text(this.retryTitle).fontColor('#fff').fontSize(12)
          }
          .backgroundColor('#0663f6')
          .padding({
            left: 12,
            right: 12,
            top: 8,
            bottom: 8
          })
          .onClick(() => {
            this.onRetry?.()
          })
        }
      }
      .offset({ y: this.offsetY })
    }
    .padding({ left: 20, right: 20 })
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}