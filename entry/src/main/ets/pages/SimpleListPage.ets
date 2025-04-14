/**
 * @fileName : SimpleListPage.ets
 * @author : @cxy
 * @date : 2025/4/14
 * @description : 文件描述
 */
import { RefreshController, RefreshDataSource, RefreshList } from 'refreshlist'


@Builder
function routerBuilder() {
  SimpleListPage()
}

@Component
struct SimpleListPage {
  @State dataSource: RefreshDataSource = new RefreshDataSource()
  @State controller: RefreshController = new RefreshController()
  curpage: number = 1

  onRefresh() {

  }

  onMore() {

  }

  requestData(page: number) {
    setTimeout(()=>{

    }, 3000)

    this.curpage = page
  }

  build() {
    NavDestination() {
      RefreshList({
        dataSource: this.dataSource,
        controller: this.controller,
        itemLayout: (item: Object, index: number)=> this.itemLayout(item as string),
        keyGenerator: (item: string) => item
      })
    }
    .hideTitleBar(false)
    .title('SimpleListPage')
  }

  @Builder
  itemLayout(item: string):void {

  }
}