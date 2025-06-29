/**
 * @fileName : HeaderListPage.ets
 * @author : @cxy
 * @date : 2025/6/25
 * @description : 文件描述
 */

import { RefreshList } from 'refreshlist'
import { ItemModel } from '../../models/ItemModel'
import { SimpleViewModel } from '../simple/SimpleViewModel'


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
        headerLayout: () => this.headerLayout(),
        onLoadMore: () => this.viewModel.loadMore(),
        itemLayout: (item: Object, index: number) => this.itemLayout(item as ItemModel),
        divider: { strokeWidth: 1, color: '#ddd' },
        keyGenerator: (item: ItemModel) => item.id
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
  headerLayout(): void {
    Text('我是 header')
      .textAlign(TextAlign.Center)
      .fontColor('#fff')
      .fontSize(20)
      .backgroundColor('#00a0ff')
      .width('100%')
      .height(200)
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