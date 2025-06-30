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
import { RefreshFooterData, RefreshFooterState, RefreshHeaderData } from './RefreshState'
import { RefreshListAttrModifier } from './RefreshListAttrModifier'
import { RefreshListDivider } from './RefreshListDirvier'
import { RefreshEmptyView } from './RefreshEmptyView'
import { RefreshLoadingView } from './RefreshLoadingView'

interface RefreshItemWrap {
  dataSource: RefreshDataSource
}

@Component
export struct RefreshList {
  // 需要 ListItem / ListItemGroup 作为组件
  @BuilderParam itemLayout: (item: Object, index: number) => void
  // 自定义布局，自己实现 LazyForEach 部分
  @BuilderParam cumstomLayout: (wrap: RefreshItemWrap) => void
  // 类似于 iOS tableHeaderView
  @BuilderParam headerLayout: () => void
  // loading 布局
  @BuilderParam loadingLayout: () => void = this.defaultLoadingView
  // 空布局
  @BuilderParam emptyLayout: () => void = this.defaultEmptyView
  // 刷新头布局
  @BuilderParam refreshHeaderLayout: (headerData: RefreshHeaderData) => void = this.defaultRefreshHeader
  // 加载更多布局
  @BuilderParam refreshFooterLayout: (footerData: RefreshFooterData) => void = this.defaultRefreshFooter
  // 是否正在loading
  @Prop showLoading: boolean = true
  // 是否展示空布局
  @Prop showEmpty: boolean = true
  // 缓存的列表项数量
  @State cachedCount: number = 4
  // 设置内容区域起始偏移量
  @State contentStartOffset: number = 0
  // 设置内容区末尾偏移量
  @State contentEndOffset: number = 0
  // 吸顶样式
  @State sticky: StickyStyle = StickyStyle.Header | StickyStyle.Footer;
  // item 间距
  @Prop itemSpace: number = 0
  // 滚动条状态
  @Prop barState: BarState = BarState.On
  // 设置下拉跟手系数。
  @Prop pullDownRatio: number = 0.62
  // 分割线样式
  @Prop divider: RefreshListDivider | null = null
  // 设置List组件的布局列数或行数
  @Prop lanes: number = 1
  // 列间距
  @Prop gutter: Dimension = 0
  // 设置显示区域上方插入或删除数据时是否要保持可见内容位置不变。
  @Prop maintainVisibleContentPosition: boolean = false
  // 用于自定义更多 List 属性
  @State listAttrModifier: RefreshListAttrModifier = new RefreshListAttrModifier()
  // 数据源
  @Require dataSource: RefreshDataSource = new RefreshDataSource()
  // 控制器
  @Require controller: RefreshController = new RefreshController()
  ////////////////////////////////////////////////////
  // 刷新时回调
  onRefresh?: () => void
  // 加载更多时回调
  onLoadMore?: () => void
  // 设置item的一key
  keyGenerator?: (item: ESObject, index: number) => string
  scroller: ListScroller = new ListScroller()
  // 滚动时回调
  onDidScroll?: OnScrollCallback
  //滚动到底部回调
  onReachEnd?: () => void
  //滚动到索引回调
  onScrollIndex?: (start: number, end: number) => void
  //////----------- 以下，不需要作为属性传值 ----------///////
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

  @Builder
  defaultRefreshHeader(headerData: RefreshHeaderData) {
    RefreshHeader({
      refreshState: headerData.refreshState,
      refreshOffset: headerData.refreshOffset,
      refreshing: headerData.refreshing,
    })
  }

  @Builder
  defaultRefreshFooter(footerData: RefreshFooterData) {
    RefreshFooter({ state: footerData.state, hide: footerData.hide })
  }

  aboutToAppear(): void {
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
      builder: this.refreshHeaderLayout({
        refreshState: this.refreshState,
        refreshOffset: this.refreshOffset,
        refreshing: this.refreshing,
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
    List({ scroller: this.controller.scroller, space: this.itemSpace }) {
      if (this.headerLayout) {
        ListItem() {
          this.headerLayout()
        }
      }

      if (this.itemLayout) {
        LazyForEach(this.dataSource, (item: ESObject, index: number) => {
          this.itemLayout(item, index)
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
          this.refreshFooterLayout({ state: this.footerState, hide: this.hideLoadMore })
        }
        .width(this.listWidth) //确保水平居中显示
      }
    }
    .maintainVisibleContentPosition(this.maintainVisibleContentPosition)
    .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
    .scrollBar(this.barState)
    .scrollBarColor('#bbb')
    .contentStartOffset(this.contentStartOffset)
    .contentEndOffset(this.contentEndOffset)
    .sticky(this.sticky)
    .cachedCount(this.cachedCount)
    .divider(this.divider)
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