/**
 * @fileName : AdvancedListPage.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 高级自定义示例 - 综合展示各种高级功能
 */

import {
  RefreshList,
  RefreshHeaderData,
  RefreshFooterData,
  RefreshFooterState,
  RefreshListAttrModifier
} from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'
import { AdvancedViewModel } from './AdvancedViewModel'

@Builder
function routerBuilder() {
  AdvancedListPage()
}


@Component
struct AdvancedListPage {
  @State title: string = ''
  @State viewModel: AdvancedViewModel = new AdvancedViewModel()
  @State refreshHeaderData: RefreshHeaderData = new RefreshHeaderData()
  @State refreshFooterData: RefreshFooterData = new RefreshFooterData()

  aboutToAppear(): void {
    this.viewModel.customAttrModifier.changeTheme(this.viewModel.currentTheme)
  }

  build() {
    NavDestination() {
      Stack() {
        // 主列表
        RefreshList({
          dataSource: this.viewModel.dataSource,
          controller: this.viewModel.controller,
          onRefresh: () => this.viewModel.refresh(),
          onLoadMore: () => this.viewModel.loadMore(),

          // 自定义布局
          headerLayout: () => this.advancedHeaderLayout(),
          itemLayout: (item: Object, index: number) => this.advancedItemLayout(item as ItemModel, index),
          refreshHeaderLayout: () => this.advancedRefreshHeader(),
          refreshFooterLayout: () => this.advancedRefreshFooter(),
          emptyLayout: () => this.advancedEmptyLayout(),
          refreshHeaderData: this.refreshHeaderData,
          refreshFooterData: this.refreshFooterData,

          // 高级配置
          cachedCount: 10,
          itemSpace: 2,
          pullDownRatio: 0.75,
          maintainVisibleContentPosition: true,
          listAttrModifier: this.viewModel.customAttrModifier,

          // 自定义分割线
          divider: {
            strokeWidth: 1,
            color: this.viewModel.currentTheme === 'dark' ? '#333' : '#f0f0f0',
            startMargin: 60,
            endMargin: 0
          },

          // 滚动回调
          onDidScroll: (scrollOffset: number, scrollState: ScrollState) => {
            this.viewModel.showFloatingButton = this.viewModel.controller.scroller.currentOffset()
              .yOffset > 200
          },

          keyGenerator: (item: ItemModel) => item.id
        })

        // 浮动操作按钮
        if (this.viewModel.showFloatingButton) {
          this.floatingActionButtons()
        }

        // 主题切换按钮
        this.themeToggleButton()
      }
      .width('100%')
      .height('100%')
    }
    .title(this.title)
    .menus(this.menusBuilder)
    .onReady((ctx) => {
      this.title = ctx.pathInfo.param as string
      this.viewModel.refresh()
    })
  }

  @Builder
  menusBuilder() {
    Row() {
      Text('刷新')
        .fontSize(14)
        .fontColor('#007AFF')
        .margin({ right: 15 })
        .onClick(() => {
          this.viewModel.controller.onRefresh()
        })

      Text('清空')
        .fontSize(14)
        .fontColor('#ff4444')
        .onClick(() => {
          this.viewModel.dataSource.deleteAll()
        })
    }
    .height('100%')
    .padding({ right: 12 })
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  advancedHeaderLayout(): void {
    Column() {
      // 轮播图区域
      Stack() {
        Image($r('app.media.foreground'))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)

        // 渐变遮罩
        Column()
          .width('100%')
          .height('100%')
          .linearGradient({
            direction: GradientDirection.Bottom,
            colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0.6)', 1]]
          })

        // 标题文字
        Column() {
          Text('RefreshList 高级示例')
            .fontSize(24)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)

          Text('展示各种高级功能和自定义选项')
            .fontSize(14)
            .fontColor('#ffffff80')
            .margin(10)
        }
        .alignItems(HorizontalAlign.Center)
      }
      .alignContent(Alignment.Bottom)

      // 功能卡片区域
      Row({ space: 10 }) {
        ForEach([
          { icon: '🔄', title: '智能刷新', desc: '自动检测' },
          { icon: '⚡', title: '友好接口', desc: '流畅体验' },
          { icon: '🎨', title: '自定义', desc: '灵活配置' }
        ], (item: ESObject) => {
          Column() {
            Text(item.icon)
              .fontSize(24)
            Text(item.title)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 8 })
              .fontColor(this.viewModel.currentTheme === 'dark' ? '#ddd' : '#333')

            Text(item.desc)
              .fontSize(12)
              .fontColor(this.viewModel.currentTheme === 'dark' ? '#eee' : '#666')
              .margin({ top: 4 })

          }
          .layoutWeight(1)
          .padding(15)
          .backgroundColor(this.viewModel.currentTheme === 'dark' ? '#2a2a2a' : Color.White)
          .borderRadius(12)
          .shadow({
            radius: 8,
            color: this.viewModel.currentTheme === 'dark' ? '#00000040' : '#00000010',
            offsetY: 4
          })
        })
      }
      .width('100%')
      .padding(15)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .backgroundColor(this.viewModel.currentTheme === 'dark' ? '#1a1a1a' : '#f8f8f8')
  }

  @Builder
  advancedItemLayout(item: ItemModel, index: number): void {
    ListItem() {
      Row() {
        // 多样化头像
        Stack() {
          if (item.image) {
            Image(item.image)
              .width(50)
              .height(50)
              .borderRadius(25)
              .objectFit(ImageFit.Cover)
          } else {
            Circle({ width: 50, height: 50 })
              .fill(item.avatarColor || '#007AFF')
              .overlay(this.overlyBuilder(item.initial || 'A'), { align: Alignment.Center })
          }

          // 状态指示器
          if (item.isOnline) {
            Circle({ width: 14, height: 14 })
              .fill('#00C851')
              .stroke(Color.White)
              .strokeWidth(2)
          }
        }
        .alignContent(Alignment.BottomEnd)

        // 内容区域
        Column() {
          Row() {
            Text(item.title)
              .fontSize(16)
              .fontColor(this.viewModel.currentTheme === 'dark' ? '#ffffff' : '#333')
              .fontWeight(FontWeight.Medium)
              .layoutWeight(1)

            // 多种标签
            if (item.isHot) {
              Text('HOT')
                .fontSize(10)
                .fontColor(Color.White)
                .backgroundColor('#ff4444')
                .borderRadius(8)
                .padding({
                  left: 6,
                  right: 6,
                  top: 2,
                  bottom: 2
                })
            }

            if (item.isNew) {
              Text('NEW')
                .fontSize(10)
                .fontColor(Color.White)
                .backgroundColor('#00C851')
                .borderRadius(8)
                .padding({
                  left: 6,
                  right: 6,
                  top: 2,
                  bottom: 2
                })
                .margin({ left: 4 })
            }
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)

          if (item.description) {
            Text(item.description)
              .fontSize(14)
              .fontColor(this.viewModel.currentTheme === 'dark' ? '#cccccc' : '#666')
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ top: 4 })
          }

          // 丰富的底部信息
          Row() {
            Text(item.category || '默认')
              .fontSize(12)
              .fontColor('#999')
              .backgroundColor(this.viewModel.currentTheme === 'dark' ? '#333' : '#f0f0f0')
              .borderRadius(4)
              .padding({
                left: 6,
                right: 6,
                top: 2,
                bottom: 2
              })

            if (item.views) {
              Row() {
                Text() {
                  SymbolSpan($r('sys.symbol.eye'))
                    .fontWeight(FontWeight.Normal)
                    .fontSize(12)
                    .fontColor(['#999'])
                }

                Text(`${item.views}`)
                  .fontSize(12)
                  .fontColor('#999')
                  .margin({ left: 2 })
              }
              .margin({ left: 8 })
            }

            if (item.likes) {
              Row() {
                Text() {
                  SymbolSpan($r('sys.symbol.heart_fill'))
                    .fontWeight(FontWeight.Normal)
                    .fontSize(12)
                    .fontColor(['#ff0000'])
                }

                Text(`${item.likes}`)
                  .fontSize(12)
                  .fontColor('#999')
                  .margin({ left: 2 })
              }
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
      }
      .width('100%')
      .padding(15)
      .alignItems(VerticalAlign.Top)
    }
    .backgroundColor(this.viewModel.currentTheme === 'dark' ? '#2a2a2a' : Color.White)
    .onClick(() => {
      console.log(`点击高级项目: ${item.title}`)
    })
    .gesture(
      LongPressGesture({ repeat: false })
        .onAction(() => {
          this.viewModel.showItemOptions(item, index)
        })
    )
  }

  @Builder
  overlyBuilder(text: string) {
    Text(text)
      .fontSize(18)
      .fontColor(Color.White)
      .fontWeight(FontWeight.Bold)
      .width(50)
      .textAlign(TextAlign.Center)
  }

  @Builder
  advancedRefreshHeader(): void {
    Column() {
      Stack() {
        // 背景动画
        Circle({ width: 40, height: 40 })
          .fill('#007AFF20')
          .scale({ x: this.refreshHeaderData.state == RefreshStatus.Refresh ? 1.2 : 1 })
          .animation({
            duration: 1000,
            iterations: this.refreshHeaderData.state == RefreshStatus.Refresh ? -1 : 1,
            playMode: PlayMode.Alternate
          })

        // 刷新图标
        Image($r('app.media.foreground'))
          .width(24)
          .height(24)
          .fillColor('#007AFF')
          .rotate({ angle: this.refreshHeaderData.offset * 6 })
          .animation({
            duration: 1000,
            iterations: this.refreshHeaderData.state == RefreshStatus.Refresh ? -1 : 1
          })
      }

      Text(this.refreshHeaderData.getText())
        .fontSize(14)
        .fontColor(this.viewModel.currentTheme === 'dark' ? '#cccccc' : '#666')
        .margin({ top: 8 })
    }
    .width('100%')
    .height(80)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.viewModel.currentTheme === 'dark' ? '#1a1a1a' : '#f8f8f8')
    .padding(10)
  }

  @Builder
  advancedRefreshFooter(): void {
    if (this.refreshFooterData.isShow) {
      Column() {
        if (this.refreshFooterData.state === RefreshFooterState.Loading) {
          Row() {
            LoadingProgress()
              .width(20)
              .height(20)
              .color('#007AFF')
            Text('加载更多精彩内容...')
              .fontSize(14)
              .fontColor(this.viewModel.currentTheme === 'dark' ? '#cccccc' : '#666')
              .margin({ left: 8 })
          }
        } else if (this.refreshFooterData.state === RefreshFooterState.NoMore) {
          Column() {
            Text('🎉')
              .fontSize(20)
            Text('已加载全部内容')
              .fontSize(14)
              .fontColor('#999')
              .margin({ top: 4 })
          }
        } else {
          Text('请继续拉')
            .fontSize(14)
            .fontColor('#999')
        }
      }
      .width('100%')
      .height(60)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.viewModel.currentTheme === 'dark' ? '#1a1a1a' : '#f8f8f8')
    }
  }

  @Builder
  advancedEmptyLayout(): void {
    Column() {
      Image($r('app.media.foreground'))
        .width(100)
        .height(100)
        .fillColor('#ddd')

      Text('暂无数据')
        .fontSize(18)
        .fontColor(this.viewModel.currentTheme === 'dark' ? '#cccccc' : '#666')
        .margin({ top: 20 })

      Text('下拉刷新试试看')
        .fontSize(14)
        .fontColor('#999')
        .margin({ top: 8 })

      Button('立即刷新')
        .margin({ top: 20 })
        .onClick(() => {
          this.viewModel.controller.onRefresh()
        })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
    .backgroundColor(this.viewModel.currentTheme === 'dark' ? '#1a1a1a' : Color.White)
  }

  @Builder
  floatingActionButtons(): void {
    Column() {
      // 回到顶部按钮
      Button() {
        Image($r('sys.media.ohos_ic_public_arrow_up'))
          .width(24)
          .height(24)
          .fillColor(Color.White)
      }
      .width(50)
      .height(50)
      .borderRadius(25)
      .backgroundColor('#007AFF')
      .onClick(() => {
        this.viewModel.controller.scrollToIndex(0, true)
      })

      // 添加按钮
      Button() {
        Image($r('sys.media.ohos_ic_public_add'))
          .width(24)
          .height(24)
          .fillColor(Color.White)
      }
      .width(50)
      .height(50)
      .borderRadius(25)
      .backgroundColor('#00C851')
      .margin({ top: 10 })
      .onClick(() => {
        this.viewModel.addNewItem()
      })
    }
    .position({ x: '85%', y: '75%' })
    .zIndex(10)
  }

  @Builder
  themeToggleButton(): void {
    Button() {
      Image(this.viewModel.currentTheme === 'dark' ? $r('app.media.foreground') : $r('app.media.startIcon'))
        .width(20)
        .height(20)
        .fillColor(Color.White)
    }
    .width(40)
    .height(40)
    .borderRadius(20)
    .backgroundColor(this.viewModel.currentTheme === 'dark' ? '#ddd' : '#666')
    .position({ x: '85%', y: '10%' })
    .zIndex(10)
    .onClick(() => {
      this.viewModel.toggleTheme()
    })
  }
}