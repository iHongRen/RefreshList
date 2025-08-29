/**
 * @fileName : CustomListPage.ets
 * @author : @cxy
 * @date : 2025/6/29
 * @description : 文件描述
 */

import { RefreshDataSource, RefreshFooterData, RefreshFooterState, RefreshHeaderData, RefreshList } from 'refreshlist'
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
  @State refreshHeaderData: RefreshHeaderData = new RefreshHeaderData()
  @State refreshFooterData: RefreshFooterData = new RefreshFooterData()

  build() {
    NavDestination() {
      RefreshList({
        dataSource: this.viewModel.dataSource,
        controller: this.viewModel.controller,
        onRefresh: () => this.viewModel.refresh(),
        onLoadMore: () => this.viewModel.loadMore(),
        refreshHeaderLayout: () => this.refreshHeaderLayout(),
        refreshFooterLayout: () => this.refreshFooterLayout(),
        cumstomLayout: () => this.cumstomLayout(),
        divider: { strokeWidth: 1, color: '#ddd' },
        loadingLayout: () => this.loadingBuilder(),
        emptyLayout: () => this.emptyBuilder(),
        refreshHeaderData: this.refreshHeaderData,
        refreshFooterData: this.refreshFooterData,
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

  // 自定义刷新header动画
  @Builder
  refreshHeaderLayout(): void {
    Column() {
      Image($r("app.media.custom_header")).height(30)
    }
  }

  // 自定义刷新footer动画
  @Builder
  refreshFooterLayout(): void {
    Column() {
      if (this.refreshFooterData.state === RefreshFooterState.Loading) {
        Image($r("app.media.custom_footer")).height(44)
      } else {
        Text('没有更多了').fontColor('#999').fontSize(14)
      }
    }
    .visibility(this.refreshFooterData.isShow ? Visibility.Visible : Visibility.None)
  }

  // 自定义 List 内容
  @Builder
  cumstomLayout(): void {
    LazyForEach(this.viewModel.dataSource, (item: ItemModel) => {
      ListItem() {
        this.itemLayout(item)
      }
    }, (item: ItemModel) => item.id)
  }

  // 自定义loading布局
  @Builder
  loadingBuilder(): void {
    Image($r("app.media.custom_loading")).height(30)
  }

  // 自定义empty布局
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