@Entry
@Component
struct Index {
  pageStack: NavPathStack = new NavPathStack()
  items: string[][] = [
    ['普通刷新和加载更多', 'simple'],
    ['分组刷新和加载更多', 'group'],
    ['HeaderView', 'header'],
    ['自定义使用', 'custom']
  ]

  build() {
    Navigation(this.pageStack) {
      List() {
        ForEach(this.items, (item: string[]) => {
          ListItem() {
            Row() {
              Text(item[0])
                .fontColor('#333')
                .fontSize(18)

              Image($r('sys.media.ohos_ic_public_arrow_right'))
                .width(20)
                .height(20)
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .padding(10)
          .onClick(() => {
            this.pushToName(item)
          })
        })
      }
      .height('100%')
    }
    .titleMode(NavigationTitleMode.Mini)
    .hideBackButton(true)
    .mode(NavigationMode.Stack)
    .title('RefreshList Demo')
  }

  pushToName(item: string[]) {
    this.pageStack.pushPathByName(item[1], item[0])
  }
}