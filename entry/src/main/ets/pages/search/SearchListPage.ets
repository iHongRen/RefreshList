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
  @State imageMap: Map<string, boolean> = new Map()

  build() {
    NavDestination() {
      Column() {
        // 搜索头部
        this.searchHeader()

        // 搜索结果列表
        RefreshList({
          dataSource: this.viewModel.dataSource,
          controller: this.viewModel.controller,
          onRefresh: () => this.viewModel.refresh(),
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
      this.viewModel.refresh()
    })
  }

  @Builder
  searchHeader(): void {
    Column() {
      // 搜索框
      Row() {
        TextInput({ placeholder: '搜索内容...', text: this.viewModel.currentKeyword })
          .layoutWeight(1)
          .onChange((value: string) => {
            this.viewModel.currentKeyword = value
            this.viewModel.refresh()
          })
      }
      .width('100%')
      .padding(15)

      // 搜索状态栏
      if (this.viewModel.currentKeyword) {
        Row() {
          Text(`搜索 "${this.viewModel.currentKeyword}"`)
            .fontSize(14)
            .fontColor('#666')
            .layoutWeight(1)

          if (this.viewModel.searchCount > 0) {
            Text(`找到 ${this.viewModel.searchCount} 个结果`)
              .fontSize(12)
              .fontColor('#999')
          }
        }
        .width('100%')
        .padding({ left: 15, right: 15, bottom: 10 })
      }

      // 热门搜索标签
      if (!this.viewModel.currentKeyword) {
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
        ForEach(this.viewModel.hotTags, (tag: string, index: number) => {
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
              this.viewModel.currentKeyword = tag
              this.viewModel.refresh()
            })
        }, (tag: string) => tag)
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
        Image(item.image)
          .alt($r('sys.media.ohos_ic_public_search_filled'))
          .width(50)
          .height(50)
          .borderRadius(8)
          .objectFit(ImageFit.Cover)
          .syncLoad(item.image && this.imageMap.get(item.image))
          .onComplete((event) => {
            if (event && item.image) {
              this.imageMap.set(item.image, true)
            }
          })


        // 搜索结果内容
        Column() {
          // 标题 - 高亮搜索关键词
          Text(item.title)
            .fontSize(16)
            .fontColor('#333')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          // 描述
          if (item.description) {
            Text(item.description)
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
      Image($r('sys.media.ohos_ic_public_search_filled'))
        .width(60)
        .height(60)
        .fillColor('#ddd')

      if (this.viewModel.currentKeyword) {
        Text(`未找到 "${this.viewModel.currentKeyword}" 的相关结果`)
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
        .margin({ top: 10 })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
  }
}