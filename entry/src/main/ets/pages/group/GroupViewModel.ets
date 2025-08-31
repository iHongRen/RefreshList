/**
 * @fileName : GroupViewModel.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 分组刷新和加载更多数据管理
 */

import { RefreshController, RefreshGroupDataSource } from '@cxy/refreshlist'
import { ItemModel } from "../../models/ItemModel"

interface GroupItem {
  title: string,
  desc: string
}

export class GroupViewModel {
  dataSource: RefreshGroupDataSource = new RefreshGroupDataSource()
  controller: RefreshController = new RefreshController()
  private currentPage: number = 1
  private pageSize: number = 24

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
      // 按类别分组
      this.dataSource.addListToGroup(data, (item: ItemModel) => {
        return item.category || '其他'
      })
      // 模拟最多4页数据
      const hasMore = page < 4
      this.controller.setHasmore(hasMore)
      this.controller.finishRefresh()
    }, 1000)
  }

  private generateData(count: number): ItemModel[] {
    const categories = [
      '开发工具', '设计资源', '学习资料', '项目模板', '插件扩展'
    ]

    const items: GroupItem[] = [
    // 开发工具
      { title: 'HarmonyOS DevEco Studio', desc: '鸿蒙应用开发集成环境，提供完整的开发工具链。' },
      { title: 'ArkTS 语言服务', desc: '智能代码补全、语法检查和重构工具。' },
      { title: '模拟器调试工具', desc: '高性能的设备模拟器，支持多种设备规格。' },
      { title: '性能分析器', desc: '应用性能监控和优化建议工具。' },
      { title: '布局检查器', desc: '可视化界面布局调试和优化工具。' },

      // 设计资源
      { title: 'UX 设计规范', desc: '鸿蒙系统用户体验设计指导原则和规范。' },
      { title: '图标资源库', desc: '丰富的系统图标和自定义图标资源。' },
      { title: '色彩主题方案', desc: '多种预设主题和自定义色彩搭配方案。' },
      { title: '动效设计模板', desc: '常用的动画效果和交互设计模板。' },
      { title: '组件设计系统', desc: '标准化的UI组件库和设计系统。' },

      // 学习资料
      { title: 'ArkTS 入门教程', desc: '从零开始学习ArkTS语言的完整教程。' },
      { title: '组件开发指南', desc: '自定义组件开发的最佳实践和案例。' },
      { title: 'API 参考文档', desc: '完整的系统API文档和使用示例。' },
      { title: '架构设计模式', desc: '应用架构设计的常用模式和实现方法。' },
      { title: '性能优化技巧', desc: '应用性能优化的实用技巧和工具使用。' },

      // 项目模板
      { title: '基础应用模板', desc: '包含常用功能的应用开发起始模板。' },
      { title: '电商应用模板', desc: '完整的电商类应用开发模板和示例。' },
      { title: '社交应用模板', desc: '社交类应用的界面和功能实现模板。' },
      { title: '工具类应用模板', desc: '实用工具类应用的开发模板和组件。' },
      { title: '游戏应用模板', desc: '简单游戏应用的开发框架和示例。' },

      // 插件扩展
      { title: '代码生成插件', desc: '自动生成常用代码模板的开发插件。' },
      { title: '国际化工具', desc: '多语言支持和本地化开发工具。' },
      { title: '测试框架插件', desc: '自动化测试和单元测试框架工具。' },
      { title: '打包部署工具', desc: '应用打包、签名和发布的自动化工具。' },
      { title: '代码质量检查', desc: '代码规范检查和质量评估工具。' }
    ]

    const result: ItemModel[] = []
    for (let i = 0; i < count; i++) {
      const globalIndex = (this.currentPage - 1) * this.pageSize + i
      const categoryIndex = Math.floor(globalIndex / 5) % categories.length
      const itemIndex = globalIndex % items.length

      const item = new ItemModel(`group_${globalIndex}`, items[itemIndex].title)
      item.description = items[itemIndex].desc
      item.category = categories[categoryIndex]
      item.time = this.getRandomTime()
      item.isNew = Math.random() > 0.8 // 20%概率为新项目

      result.push(item)
    }
    return result
  }

  private getRandomTime(): string {
    const times = [
      '刚刚', '5分钟前', '15分钟前', '30分钟前', '1小时前',
      '2小时前', '今天', '昨天', '2天前', '1周前'
    ]
    return times[Math.floor(Math.random() * times.length)]
  }
}