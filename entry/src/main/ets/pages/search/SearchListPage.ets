/**
 * @fileName : SearchListPage.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 搜索结果列表示例
 */

import { RefreshList } from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'
import { SearchViewModel } from './SearchViewModel'

@Builder
function routerBuilder() {
  SearchListPage()
}

@Component
struct SearchListPage {
  @State title: string = ''
  @State viewModel: SearchViewModel = new SearchViewModel()
  @State searchText: string = ''
  @State isSearching: boolean = false

  build() {
    NavDestination() {
      Column() {
        // 搜索头部
        this.searchHeader()

        // 搜索结果列表
        RefreshList({
          dataSource: this.viewModel.dataSource,
          controller: this.viewModel.controller,
          onRefresh: () => this.viewModel.refresh(this.searchText),
          onLoadMore: () => this.viewModel.loadMore(),
          itemLayout: (item: Object, index: number) => this.searchItemLayout(item as ItemModel),

          // 自定义空状态
          emptyLayout: () => this.searchEmptyLayout(),

          // 自定义加载状态
          loadingLayout: () => this.searchLoadingLayout(),

          keyGenerator: (item: ItemModel) => item.id
        })
          .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
    }
    .title(this.title)
    .onReady((ctx) => {
      this.title = ctx.pathInfo.param as string
    })
  }

  @Builder
  searchHeader(): void {
    Column() {
      // 搜索框
      Row() {
        TextInput({ placeholder: '搜索内容...', text: this.searchText })
          .layoutWeight(1)
          .onChange((value: string) => {
            this.searchText = value
          })
          .onSubmit(() => {
            this.performSearch()
          })

        Button('搜索')
          .margin({ left: 10 })
          .onClick(() => {
            this.performSearch()
          })
      }
      .width('100%')
      .padding(15)

      // 搜索状态栏
      if (this.searchText) {
        Row() {
          Text(`搜索 "${this.searchText}"`)
            .fontSize(14)
            .fontColor('#666')
            .layoutWeight(1)

          if (this.viewModel.dataSource.totalCount() > 0) {
            Text(`找到 ${this.viewModel.dataSource.totalCount()} 个结果`)
              .fontSize(12)
              .fontColor('#999')
          }
        }
        .width('100%')
        .padding({ left: 15, right: 15, bottom: 10 })
      }

      // 热门搜索标签
      if (!this.searchText && this.viewModel.dataSource.totalCount() === 0) {
        this.hotSearchTags()
      }
    }
    .backgroundColor(Color.White)
    .border({ width: { bottom: 1 }, color: '#f0f0f0' })
  }

  @Builder
  hotSearchTags(): void {
    Column() {
      Text('热门搜索')
        .fontSize(14)
        .fontColor('#333')
        .alignSelf(ItemAlign.Start)
        .margin({ bottom: 10 })

      Flex({ wrap: FlexWrap.Wrap, alignItems: ItemAlign.Center }) {
        ForEach(this.viewModel.getHotSearchTags(), (tag: string, index: number) => {
          Text(tag)
            .fontSize(12)
            .fontColor('#666')
            .backgroundColor('#f5f5f5')
            .borderRadius(12)
            .padding({
              left: 12,
              right: 12,
              top: 6,
              bottom: 6
            })
            .margin({ right: 8, bottom: 8 })
            .onClick(() => {
              this.searchText = tag
              this.performSearch()
            })
        })
      }
    }
    .width('100%')
    .padding(15)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  searchItemLayout(item: ItemModel): void {
    ListItem() {
      Row() {
        // 搜索结果图标
        Image(item.image || $r('sys.media.ohos_app_icon'))
          .width(50)
          .height(50)
          .borderRadius(8)
          .objectFit(ImageFit.Cover)

        // 搜索结果内容
        Column() {
          // 标题 - 高亮搜索关键词
          Text(this.highlightSearchText(item.title))
            .fontSize(16)
            .fontColor('#333')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          // 描述
          if (item.description) {
            Text(this.highlightSearchText(item.description))
              .fontSize(14)
              .fontColor('#666')
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ top: 4 })
          }

          // 搜索结果元信息
          Row() {
            Text(item.category || '默认')
              .fontSize(12)
              .fontColor('#999')
              .backgroundColor('#f0f0f0')
              .borderRadius(4)
              .padding({
                left: 6,
                right: 6,
                top: 2,
                bottom: 2
              })

            if (item.views) {
              Text(`${item.views} 浏览`)
                .fontSize(12)
                .fontColor('#999')
                .margin({ left: 8 })
            }

            Blank()

            Text(item.time || '刚刚')
              .fontSize(12)
              .fontColor('#999')
          }
          .width('100%')
          .margin({ top: 8 })
        }
        .layoutWeight(1)
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)

        // 搜索匹配度
        Column() {
          Text(`${item.score || 0}%`)
            .fontSize(12)
            .fontColor('#007AFF')
            .fontWeight(FontWeight.Bold)

          Text('匹配度')
            .fontSize(10)
            .fontColor('#999')
            .margin({ top: 2 })
        }
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .padding(15)
      .alignItems(VerticalAlign.Top)
    }
    .backgroundColor(Color.White)
    .onClick(() => {
      console.log(`查看搜索结果: ${item.title}`)
    })
  }

  @Builder
  searchEmptyLayout(): void {
    Column() {
      Image($r('sys.media.ohos_app_icon'))
        .width(80)
        .height(80)
        .fillColor('#ddd')

      if (this.searchText) {
        Text(`未找到 "${this.searchText}" 的相关结果`)
          .fontSize(16)
          .fontColor('#666')
          .margin({ top: 20 })

        Text('试试其他关键词或检查拼写')
          .fontSize(14)
          .fontColor('#999')
          .margin({ top: 8 })
      } else {
        Text('输入关键词开始搜索')
          .fontSize(16)
          .fontColor('#666')
          .margin({ top: 20 })
      }
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
  }

  @Builder
  searchLoadingLayout(): void {
    Column() {
      LoadingProgress()
        .width(40)
        .height(40)
        .color('#007AFF')

      Text('搜索中...')
        .fontSize(16)
        .fontColor('#666')
        .margin({ top: 20 })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
  }

  private performSearch(): void {
    if (!this.searchText.trim()) {
      return
    }

    this.isSearching = true
    this.viewModel.search(this.searchText.trim())
  }

  private highlightSearchText(text: string): string {
    // 简单的高亮处理，实际项目中可以使用更复杂的高亮逻辑
    if (!this.searchText || !text) {
      return text
    }

    // 这里返回原文本，实际应用中可以返回带高亮标记的富文本
    return text
  }
}