/**
 * @fileName : RefreshList.ets
 * @author : @cxy
 * @date : 2024/9/19
 * @description : 文件描述
 */

import { RefreshDataSource } from './RefreshDataSource'
import { RefreshHeader } from './RefreshHeader'
import { RefreshFooter } from './RefreshFooter'
import { RefreshController } from './RefreshController'
import { RefreshFooterState } from './RefreshState'
import { RefreshListAttrModifier } from './RefreshListAttrModifier'
import { RefreshListDirvier } from './RefreshListDirvier'
import { RefreshEmptyView } from './RefreshEmptyView'
import { RefreshLoadingView } from './RefreshLoadingView'

interface RefreshItemWrap {
  dataSource: RefreshDataSource
}

@Component
export struct RefreshList {
  //得包含 ListItem/ListItemGroup, 用于支持配置ListItem/ListItemGroup
  //ListItem : 配置ListItem支持侧滑删除等动作
  //ListItemGroup : 通过配合 RefreshGroupDataSource + RefreshGroupModel 实现分组懒加载数据源
  @BuilderParam listItemOrGroupLayout: (item: Object, index: number) => void
  //通常不需要自定义ListItem属性配置，就用itemLayout
  @BuilderParam itemLayout: (item: Object, index: number) => void
  @BuilderParam headerLayout: () => void
  @BuilderParam cumstomLayout: (wrap: RefreshItemWrap) => void
  @BuilderParam loadingLayout: () => void = this.defaultLoadingView
  @BuilderParam emptyLayout: () => void = this.defaultEmptyView
  @Prop showLoading: boolean = true
  @Prop showEmpty: boolean = true
  @State cachedCount: number = 4
  @State safeBottom: number = 30
  @State sticky: StickyStyle = StickyStyle.Header | StickyStyle.Footer;
  @Prop textColor: ResourceColor = '#bbb'
  @Prop space: number = 0
  @Prop barState: BarState = BarState.On
  @Prop pullDownRatio: number = 0.62
  @Prop dirvier: RefreshListDirvier | null = null
  @Prop lanes: number = 1
  @Prop gutter: Dimension = 0
  @Require dataSource: RefreshDataSource = new RefreshDataSource()
  @Require controller: RefreshController = new RefreshController()
  @State listAttrModifier: RefreshListAttrModifier = new RefreshListAttrModifier()
  onRefresh?: () => void
  onLoadMore?: () => void
  keyGenerator?: (item: ESObject, index: number) => string
  scroller: ListScroller = new ListScroller()
  onDidScroll?: OnScrollCallback
  onReachEnd?: () => void
  onScrollIndex?: (start: number, end: number) => void
  ////// 以下，不需要作为属性传值
  @State isEmpty: boolean = false
  @State hideLoadMore: boolean = false
  @State footerState: RefreshFooterState = RefreshFooterState.Loading
  @State refreshWord: string = ''
  @State refreshing: boolean = false;
  @State refreshOffset: number = 0;
  @State refreshState: RefreshStatus = RefreshStatus.Inactive;
  @State listWidth: number = 0
  private canLoadMore: boolean = false;
  private isLoadingMore: boolean = false;

  @Builder
  defaultLoadingView() {
    RefreshLoadingView()
  }

  @Builder
  defaultEmptyView() {
    RefreshEmptyView()
  }

  resetRefreshWord() {
    if (!this.onRefresh) {
      return
    }
    const words = RefreshController.refreshWords
    if (words.length === 0) {
      return
    }
    const index = Math.floor(Math.random() * words.length)
    this.refreshWord = words[index]
  }

  aboutToAppear(): void {
    this.resetRefreshWord()
    this.controller.scroller = this.scroller

    this.controller.setHasmore = (hasmore: boolean) => {
      this.footerState = Boolean(Number(hasmore)) ? RefreshFooterState.Loading : RefreshFooterState.NoMore
    }
    this.controller.onRefresh = () => {
      if (this.onRefresh) {
        this.scroller?.scrollEdge(Edge.Top)
        this.refreshing = true
      }
    }

    this.controller.finishRefresh = () => {
      const total = this.dataSource?.totalItemCount()
      this.refreshing = false
      this.canLoadMore = true
      this.isLoadingMore = false
      this.showLoading = false
      this.isEmpty = total === 0
      this.hideLoadMore = total < 5
    }
    this.controller.hideLoadMore = (hide: boolean) => {
      this.hideLoadMore = hide
    }

    this.controller.scrollToIndex =
      (value: number, smooth?: boolean, align?: ScrollAlign, options?: ScrollToIndexOptions) => {
        this.controller.scroller?.scrollToIndex(value, smooth, align, options)
      }

    this.dataSource.onDataCountChange = (count: number) => {
      this.isEmpty = count === 0
    }
  }

  build() {
    Refresh({
      refreshing: this.refreshing,
      builder: RefreshHeader({
        refreshState: this.refreshState,
        refreshOffset: this.refreshOffset,
        refreshing: this.refreshing,
        text: this.refreshWord,
        textColor: this.textColor
      })
    }) {
      this.listView()
    }
    .onOffsetChange((offset: number) => {
      this.refreshOffset = offset;
    })
    .onStateChange((state: RefreshStatus) => {
      if (!this.onRefresh) {
        this.refreshState = RefreshStatus.Done;
        return
      }
      if (state === RefreshStatus.Done) {
        this.resetRefreshWord()
      }
      this.refreshState = state;
    })
    .onRefreshing(() => {
      const isGuestureTrigger = !this.refreshing
      this.refreshing = true
      if (this.onRefresh) {
        if (isGuestureTrigger) {
          this.onRefresh?.()
        } else {
          setTimeout(() => {
            this.onRefresh?.()
          }, 300)
        }
      } else {
        this.refreshing = false
      }
    })
    .pullDownRatio(this.pullDownRatio)
    .width('100%')
    .height('100%')
  }

  @Builder
  listView() {
    List({ scroller: this.controller.scroller, space: this.space }) {
      if (this.headerLayout) {
        ListItem() {
          this.headerLayout()
        }
      }

      if (this.listItemOrGroupLayout) {
        LazyForEach(this.dataSource, (item: ESObject, index: number) => {
          this.listItemOrGroupLayout(item, index)
        }, this.keyGenerator)
      } else if (this.itemLayout) {
        LazyForEach(this.dataSource, (item: ESObject, index: number) => {
          ListItem() {
            this.itemLayout(item, index)
          }
        }, this.keyGenerator)
      } else if (this.cumstomLayout) {
        this.cumstomLayout({ dataSource: this.dataSource })
      }

      if (this.showLoading) {
        ListItem() {
          this.loadingLayout()
        }
        .width(this.listWidth)
        .height('95%')

      } else if (this.showEmpty && this.isEmpty) {
        ListItem() {
          this.emptyLayout()
        }
        .width(this.listWidth)
        .height('95%')

      } else if (this.onLoadMore && !this.refreshing) {
        ListItem() {
          RefreshFooter({ state: this.footerState, hide: this.hideLoadMore })
        }
        .width(this.listWidth) //确保水平居中显示
      }

    }
    .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
    .scrollBar(this.barState)
    .scrollBarColor('#bbb')
    .contentEndOffset(this.safeBottom)
    .sticky(this.sticky)
    .cachedCount(this.cachedCount)
    .divider(this.dirvier)
    .lanes(this.lanes, this.gutter)
    .attributeModifier(this.listAttrModifier)
    .width('100%')
    .height('100%')
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      this.listWidth = newValue.width as number
    })
    .onReachEnd(() => {
      this.onReachEnd?.()
      if (this.footerState === RefreshFooterState.NoMore) {
        return
      }
      // 加载更多数据逻辑
      if (this.onLoadMore && this.canLoadMore && !this.refreshing) {
        this.canLoadMore = false;
        this.isLoadingMore = true;
        this.footerState = RefreshFooterState.Loading
        this.onLoadMore?.()
      }
    })
    .onScrollIndex((start: number, end: number) => {
      this.onScrollIndex?.(start, end)
      // 当达到列表末尾时，触发新数据加载
    })
    .onScrollFrameBegin((offset: number, state: ScrollState) => {
      if (this.footerState === RefreshFooterState.NoMore) {
        return
      }
      // 只有当向上滑动时触发新数据加载
      if (offset > 5 && !this.isLoadingMore && !this.refreshing) {
        this.canLoadMore = true;
      }
      return { offsetRemain: offset };
    })
    .onDidScroll(this.onDidScroll)
  }
}