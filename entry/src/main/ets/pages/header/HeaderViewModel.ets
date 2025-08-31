/**
 * @fileName : HeaderViewModel.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 带头部视图的列表数据管理
 */

import { RefreshController, RefreshDataSource } from "@cxy/refreshlist"
import { ItemModel } from "../../models/ItemModel"

export class HeaderViewModel {
  dataSource: RefreshDataSource = new RefreshDataSource()
  controller: RefreshController = new RefreshController()
  private currentPage: number = 1
  private pageSize: number = 15

  refresh(): void {
    this.requestData(1)
  }

  loadMore(): void {
    this.requestData(this.currentPage + 1)
  }

  getTotalCount(): number {
    return 100 // 模拟总数据量
  }

  getLoadedCount(): number {
    return this.dataSource.totalCount()
  }

  getCurrentPage(): number {
    return this.currentPage
  }

  private async requestData(page: number): Promise<void> {
    // 模拟网络请求延迟
    setTimeout(() => {
      this.currentPage = page
      const data = this.generateData(this.pageSize)
      if (page === 1) {
        this.dataSource.deleteAll()
      }
      this.dataSource.pushDataArray(data)
      // 模拟最多7页数据
      const hasMore = page < 7
      this.controller.setHasmore(hasMore)
      this.controller.finishRefresh()
    }, 1000)
  }

  private generateData(count: number): ItemModel[] {
    const features = [
      '下拉刷新功能', '上拉加载更多', '自定义头部视图', '灵活的布局配置',
      '高性能渲染', '流畅的动画效果', '丰富的自定义选项', '完善的状态管理',
      '响应式设计', '多种列表样式', '数据源管理', '事件回调处理'
    ]

    const descriptions = [
      '支持下拉刷新操作，可自定义刷新动画和提示文本。',
      '智能的上拉加载更多功能，支持自动和手动触发模式。',
      '灵活的头部视图配置，支持复杂的自定义布局设计。',
      '提供多种布局配置选项，适应不同的业务场景需求。',
      '采用高性能的渲染机制，确保大数据量下的流畅体验。',
      '精心设计的动画效果，提升用户交互体验和视觉效果。',
      '丰富的自定义配置选项，满足各种个性化需求。',
      '完善的状态管理机制，确保数据的一致性和可靠性。'
    ]

    const categories = [
      '核心功能', '用户体验', '性能优化', '自定义配置', '数据管理'
    ]

    const colors = [
      '#667eea', '#764ba2', '#f093fb', '#f5576c', '#4facfe',
      '#00f2fe', '#43e97b', '#38f9d7', '#ffecd2', '#fcb69f'
    ]

    const result: ItemModel[] = []
    for (let i = 0; i < count; i++) {
      const globalIndex = (this.currentPage - 1) * this.pageSize + i
      const featureIndex = globalIndex % features.length

      const item = new ItemModel(`header_${globalIndex}`, features[featureIndex])
      item.description = descriptions[globalIndex % descriptions.length]
      item.category = categories[globalIndex % categories.length]
      item.avatarColor = colors[globalIndex % colors.length]
      item.initial = features[featureIndex].charAt(0)
      item.time = this.getRandomTime()

      result.push(item)
    }
    return result
  }

  private getRandomTime(): string {
    const times = [
      '刚刚', '3分钟前', '8分钟前', '15分钟前', '25分钟前',
      '45分钟前', '1小时前', '2小时前', '今天', '昨天'
    ]
    return times[Math.floor(Math.random() * times.length)]
  }
}