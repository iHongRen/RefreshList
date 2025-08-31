/**
 * @fileName : CustomListModel.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 自定义使用示例数据管理
 */

import {
  RefreshController, RefreshDataSource
} from '@cxy/refreshlist'
import { ItemModel } from "../../models/ItemModel"

export class CustomListModel {
  dataSource: RefreshDataSource = new RefreshDataSource()
  controller: RefreshController = new RefreshController()
  private currentPage: number = 1
  private pageSize: number = 18

  refresh(): void {
    this.requestData(1)
  }

  loadMore(): void {
    this.requestData(this.currentPage + 1)
  }

  private async requestData(page: number): Promise<void> {
    setTimeout(() => {
      this.currentPage = page
      const data = this.generateData(this.pageSize)
      if (page === 1) {
        this.dataSource.deleteAll()
      }
      this.dataSource.pushDataArray(data)

      // 模拟最多3页数据
      const hasMore = page < 3
      this.controller.setHasmore(hasMore)
      this.controller.finishRefresh()

      // 隐藏加载更多组件
      this.controller.hideLoadMore(!hasMore)

    }, 1200)
  }

  private generateData(count: number): ItemModel[] {
    const customFeatures = [
      '自定义刷新动画', '个性化加载效果', '定制化列表布局', '自定义空状态页面',
      '个性化加载状态', '自定义分隔线样式', '定制化交互效果', '个性化主题配置',
      '自定义手势操作', '定制化动画过渡', '个性化状态指示器', '自定义错误处理',
      '定制化数据展示', '个性化用户反馈', '自定义性能优化', '定制化响应式设计'
    ]

    const descriptions = [
      '展示如何创建独特的下拉刷新动画效果，提升用户体验。',
      '演示个性化的数据加载动画，让等待过程更加有趣。',
      '展示完全自定义的列表项布局，满足特殊设计需求。',
      '演示如何设计吸引人的空状态页面，引导用户操作。',
      '展示个性化的加载状态提示，提供更好的用户反馈。',
      '演示自定义分隔线和间距，创造独特的视觉效果。',
      '展示定制化的用户交互效果，提升操作体验。',
      '演示如何实现个性化的主题配置和样式定制。'
    ]

    const categories = [
      '界面定制', '交互设计', '动画效果', '用户体验', '性能优化'
    ]

    const colors = [
      '#667eea', '#764ba2', '#f093fb', '#f5576c', '#4facfe',
      '#00f2fe', '#43e97b', '#38f9d7', '#ffecd2', '#fcb69f'
    ]

    const result: ItemModel[] = []
    for (let i = 0; i < count; i++) {
      const globalIndex = (this.currentPage - 1) * this.pageSize + i
      const featureIndex = globalIndex % customFeatures.length

      const item = new ItemModel(`custom_${globalIndex}`, customFeatures[featureIndex])
      item.description = descriptions[globalIndex % descriptions.length]
      item.category = categories[globalIndex % categories.length]
      item.avatarColor = colors[globalIndex % colors.length]
      item.time = this.getRandomTime()

      result.push(item)
    }
    return result
  }

  private getRandomTime(): string {
    const times = [
      '刚刚', '1分钟前', '3分钟前', '8分钟前', '15分钟前',
      '30分钟前', '1小时前', '2小时前', '今天', '昨天'
    ]
    return times[Math.floor(Math.random() * times.length)]
  }
}