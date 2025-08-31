/**
 * @fileName : AdvancedViewModel.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 高级示例数据管理
 */

import { RefreshDataSource, RefreshController } from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'

export class AdvancedViewModel {
  dataSource: RefreshDataSource = new RefreshDataSource()
  controller: RefreshController = new RefreshController()
  private currentPage: number = 1
  private pageSize: number = 15

  refresh(): void {
    this.requestPage(1)
  }

  loadMore(): void {
    this.requestPage(this.currentPage + 1)
  }

  requestPage(page: number) {
    // 模拟网络请求延迟
    setTimeout(() => {
      this.currentPage = page
      const data = this.generateData(this.pageSize)
      if (page === 1) {
        this.dataSource.deleteAll()
      }
      this.dataSource.pushDataArray(data)

      // 模拟最多5页数据
      const hasMore = page < 5
      this.controller.setHasmore(hasMore)
      this.controller.finishRefresh()
    }, 800)
  }

  private generateData(count: number): ItemModel[] {
    const categories = [
      '科技前沿', '设计灵感', '开发技巧', '产品思考', '用户体验',
      '行业动态', '创新理念', '技术分享', '项目实战', '团队协作'
    ]

    const titles = [
      'HarmonyOS NEXT 生态建设新进展', '移动端UI设计的未来趋势',
      'ArkTS开发最佳实践分享', '用户体验设计的核心原则',
      '高性能移动应用架构设计', '跨平台开发技术对比',
      '人工智能在移动开发中的应用', '响应式设计实现方案',
      '移动应用安全防护策略', '敏捷开发团队管理经验',
      '数据可视化技术探索', '云原生应用开发实践',
      '微服务架构设计模式', '前端性能优化技巧',
      '移动端测试自动化方案', '开源项目贡献指南'
    ]

    const descriptions = [
      '深入探讨HarmonyOS NEXT生态系统的最新发展，分析其对开发者和用户的影响。',
      '分析当前移动端UI设计的发展趋势，预测未来设计方向和技术革新。',
      '分享ArkTS开发中的实用技巧和最佳实践，帮助开发者提升开发效率。',
      '从用户角度出发，探讨如何设计出真正符合用户需求的产品体验。',
      '介绍高性能移动应用的架构设计原则，包括性能优化和扩展性考虑。'
    ]

    const colors = [
      '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7',
      '#DDA0DD', '#98D8C8', '#F7DC6F', '#BB8FCE', '#85C1E9'
    ]

    const result: ItemModel[] = []
    for (let index = 0; index < count; index++) {
      const globalIndex = (this.currentPage - 1) * this.pageSize + index
      const categoryIndex = globalIndex % categories.length
      const isHot = Math.random() > 0.7 // 30%概率为热门
      const isNew = globalIndex < 5 && this.currentPage === 1 // 第一页前5个为新内容

      const item = new ItemModel(`advanced_${globalIndex}`, titles[globalIndex % titles.length])
      item.description = descriptions[globalIndex % descriptions.length]
      item.category = categories[categoryIndex]
      item.avatarColor = colors[categoryIndex]
      item.initial = categories[categoryIndex].charAt(0)

      // 状态属性
      item.isHot = isHot
      item.isNew = isNew
      item.isOnline = Math.random() > 0.4 // 60%在线

      // 数值属性
      item.views = Math.floor(Math.random() * 50000) + 1000
      item.likes = Math.floor(Math.random() * 5000) + 100
      item.comments = Math.floor(Math.random() * 500) + 10
      item.score = Math.floor(Math.random() * 100) + 1

      // 时间属性
      item.time = this.getRandomTime()

      // 媒体属性
      item.image = Math.random() > 0.5 ? `https://picsum.photos/100/100?random=${globalIndex}` : undefined

      result.push(item)
    }
    return result
  }

  private getRandomTime(): string {
    const times = [
      '刚刚', '2分钟前', '5分钟前', '15分钟前', '30分钟前',
      '1小时前', '3小时前', '今天 14:30', '昨天 20:15', '2天前',
      '1周前', '2周前', '1个月前'
    ]
    return times[Math.floor(Math.random() * times.length)]
  }
}