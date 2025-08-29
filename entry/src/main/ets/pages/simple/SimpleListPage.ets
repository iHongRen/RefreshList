/**
 * @fileName : SimpleListPage.ets
 * @author : @cxy
 * @date : 2025/4/14
 * @description : 文件描述
 */
import { RefreshList } from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'
import { SimpleViewModel } from './SimpleViewModel'


@Builder
function routerBuilder() {
  SimpleListPage()
}

@Component
struct SimpleListPage {
  @State title: string = ''
  @State viewModel: SimpleViewModel = new SimpleViewModel()

  build() {
    NavDestination() {
      RefreshList({
        dataSource: this.viewModel.dataSource,
        controller: this.viewModel.controller,
        onRefresh: () => this.viewModel.refresh(),
        onLoadMore: () => this.viewModel.loadMore(),
        itemLayout: (item: Object, index: number) => this.itemLayout(item as ItemModel),
        divider: { strokeWidth: 1, color: '#ddd' },
        keyGenerator: (item: ItemModel) => item.id,
      })
    }
    .hideTitleBar(false)
    .title(this.title)
    .onReady((ctx) => {
      this.title = ctx.pathInfo.param as string
      this.viewModel.refresh()
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
