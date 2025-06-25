/**
 * @fileName : GroupListPage.ets
 * @author : @cxy
 * @date : 2025/4/16
 * @description : 文件描述
 */
import { RefreshGroupModel, RefreshList } from 'refreshlist'
import { ItemModel } from '../../models/ItemModel'
import { GroupViewModel } from './GroupViewModel'


@Builder
function routerBuilder() {
  GroupListPage()
}

@Component
struct GroupListPage {
  @State title: string = ''
  @State viewModel: GroupViewModel = new GroupViewModel()

  build() {
    NavDestination() {
      RefreshList({
        dataSource: this.viewModel.dataSource,
        controller: this.viewModel.controller,
        onRefresh: () => this.viewModel.refresh(),
        onLoadMore: () => this.viewModel.loadMore(),
        itemLayout: (group: Object, index: number) => this.groupLayout(group as RefreshGroupModel),
        dirvier: { strokeWidth: 1, color: '#ddd' },
        keyGenerator: (group: RefreshGroupModel) => group.title
      })
    }
    .title(this.title)
    .onReady((ctx) => {
      this.title = ctx.pathInfo.param as string
      this.viewModel.refresh()
    })
  }

  @Builder
  groupLayout(group: RefreshGroupModel): void {
    ListItemGroup({ header: this.sectionHeader(group) }) {
      LazyForEach(group.dataSource, (item: ItemModel, index: number) => {
        ListItem() {
          Text(item.title)
            .fontColor('#333')
            .fontSize(15)
            .padding(15)
        }
      }, (item: ItemModel) => item.title)
    }
  }

  @Builder
  sectionHeader(group: RefreshGroupModel) {
    Text(group.title)
      .fontColor('#fff')
      .fontSize(15)
      .fontWeight(FontWeight.Medium)
      .padding(15)
      .width('100%')
      .backgroundColor('#666')
  }
}