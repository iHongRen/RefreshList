/**
 * @fileName : SimpleListPage.ets
 * @author : @cxy
 * @date : 2025/4/14
 * @description : 文件描述
 */
import { RefreshController, RefreshDataSource, RefreshList } from 'refreshlist'
import { ItemModel } from '../models/ItemModel'


@Builder
function routerBuilder() {
  SimpleListPage()
}

@Component
struct SimpleListPage {
  @State dataSource: RefreshDataSource = new RefreshDataSource()
  @State controller: RefreshController = new RefreshController()
  curpage: number = 1

  refresh(): void {
    this.requestData(1)
  }

  loadMore(): void {
    this.requestData(this.curpage + 1)
  }

  async requestData(page: number): Promise<void> {
    setTimeout(() => {
      const length = page === 1 ? 0 : this.dataSource.totalCount()
      const list: ItemModel[] = []
      for (let i = 0; i < 20; i++) {
        const item = new ItemModel(`${length + i}`, `title${length + i}`)
        list.push(item)
      }

      if (page === 1) {
        this.dataSource.deleteAll()
      }
      this.dataSource.pushDataArray(list)
      this.controller.finishRefresh()

      this.curpage = page
    }, 5000)
  }

  build() {
    NavDestination() {
      RefreshList({
        dataSource: this.dataSource,
        controller: this.controller,
        onRefresh: () => this.refresh(),
        onLoadMore: () => this.loadMore(),
        itemLayout: (item: Object, index: number) => this.itemLayout(item as ItemModel),
        dirvier: { strokeWidth: 1, color: '#ddd' },
        keyGenerator: (item: ItemModel) => item.id
      })
    }
    .hideTitleBar(false)
    .title('SimpleListPage')
    .onReady((ctx) => {
      this.refresh()
    })
  }

  @Builder
  itemLayout(item: ItemModel): void {
    ListItem() {
      Text(item.title)
        .fontColor('#333')
        .fontSize(15)
        .padding(15)
    }
  }
}