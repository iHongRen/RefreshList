/**
 * @fileName : GroupListPage.ets
 * @author : @cxy
 * @date : 2025/4/16
 * @description : 文件描述
 */


@Builder
function routerBuilder() {
  GroupListPage()
}

@Component
struct GroupListPage {
  @State title: string = ''

  build() {
    NavDestination() {

      Column() {

      }
    }
    .onReady((ctx) => {
      this.title = ctx.pathInfo.param as string
      
    })
  }
}