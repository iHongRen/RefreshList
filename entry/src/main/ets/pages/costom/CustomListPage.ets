/**
 * @fileName : CustomListPage.ets
 * @author : @cxy
 * @date : 2025/6/29
 * @description : 文件描述
 */

import { RefreshDataSource, RefreshList } from 'refreshlist'
import { ItemModel } from '../../models/ItemModel'
import { CustomListModel } from './CustomListModel'


@Builder
function routerBuilder() {
  CustomListPage()
}

@Component
struct CustomListPage {
  @State title: string = ''
  @State viewModel: CustomListModel = new CustomListModel()

  build() {
    NavDestination() {
      RefreshList({
        dataSource: this.viewModel.dataSource,
        controller: this.viewModel.controller,
        onRefresh: () => this.viewModel.refresh(),
        onLoadMore: () => this.viewModel.loadMore(),
        cumstomLayout: (wrap) => this.cumstomLayout(wrap.dataSource),
        divider: { strokeWidth: 1, color: '#ddd' },
        loadingLayout: () => this.loadingBuilder(),
        emptyLayout: () => this.emptyBuilder()
      })
    }
    .menus(this.menusBuilder)
    .hideTitleBar(false)
    .title(this.title)
    .onReady((ctx) => {
      this.title = ctx.pathInfo.param as string
      this.viewModel.refresh()
    })
  }

  @Builder
  menusBuilder() {
    Text('清空')
      .fontColor('#00f')
      .fontSize(20)
      .height('100%')
      .padding({ left: 20, right: 20 })
      .onClick(() => {
        this.viewModel.dataSource.deleteAll()
      })
  }

  @Builder
  cumstomLayout(dataSource: RefreshDataSource): void {
    LazyForEach(dataSource, (item: ItemModel) => {
      ListItem() {
        this.itemLayout(item)
      }
    }, (item: ItemModel) => item.id)
  }

  // 自定义loading布局
  @Builder
  loadingBuilder(): void {
    Text('正在加载中')
      .fontColor('#f00')
      .fontSize(20)
  }

  // 自定义空页面布局
  @Builder
  emptyBuilder(): void {
    Text('暂无数据')
      .fontColor('#f00')
      .fontSize(20)
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