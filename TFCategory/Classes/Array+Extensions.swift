//
//  Array+Extensions.swift
//  network
//
//  Created by 姚天成 on 2017/5/25.
//  Copyright © 2017年 姚天成. All rights reserved.
//

import Foundation

extension Array {
    
    ///获取 array 闭区间 lower 为起始 index upper 为往后推几个元素
    ///demo: arr.get(at: ClosedRange(uncheckedBounds: (lower: 1, upper: 2)))
    public func get(at range: ClosedRange<Int>) -> Array {
        var subArray = Array()
        let lowerBound = range.lowerBound > 0 ? range.lowerBound : 0
        let upperBound = range.upperBound > self.count - 1 ? self.count - 1 : range.upperBound
        for index in lowerBound...upperBound {
            subArray.append(self[index])
        }
        return subArray
    }
    
    
    /// 检查数组是否包含至少一个项，且类型与给定元素的类型相同
    /// demo : arr.containsType(of: String())
    public func containsType<T>(of element: T) -> Bool {
        let elementType = type(of: element)
        return first { type(of: $0) == elementType} != nil
    }
    
    
    ///分解的arr与第一元素 / 其余元素 的元组
    ///demo: arr.decompose()
    public func decompose() -> (head: Iterator.Element, tail: SubSequence)? {
        return (count > 0) ? (self[0], self[1..<count]) : nil
    }
    
    
    /// 迭代器
    ///
    /// - Parameter body:  返回 index , 以及 element
    public func forEachEnumerated(_ body: @escaping (_ offset: Int, _ element: Element) -> Void) {
        self.enumerated().forEach(body)
    }
    
    
    /// 获取下标元素
    ///
    /// - Parameter index: 索引
    /// - Returns: 获取到元素( 越界会 为 nil)
    public func get(at index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
    
    
    /// 将元素放入到 arr 第一个位置
    ///
    /// - Parameter newElement: 元素
    public mutating func insertFirst(_ newElement: Element) {
        insert(newElement, at: 0)
    }
    
    
    /// 获取元素里随机一个元素
    ///
    /// - Returns: 获取到元素
    public func random() -> Element? {
        guard count > 0 else { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
    
    
    /// 倒序取数组元素 (0 为 取最后一个元素,以此类推)
    ///
    /// - Parameter index: 索引
    /// - Returns: 元素
    public func reverseIndex(_ index: Int) -> Int? {
        guard index >= 0 && index < count else { return nil }
        return Swift.max(self.count - 1 - index, 0)
    }
    
    
    /// 将数组内元素随机调换位置(洗牌算法)
    public mutating func shuffle() {
        guard self.count > 1 else { return }
        var j: Int
        for i in 0..<(self.count-2) {
            j = Int(arc4random_uniform(UInt32(self.count - i)))
            if i != i+j { swap(&self[i], &self[i+j]) }
        }
    }
    
    /// 返回一个重新随机排序的数组
    ///
    /// - Returns: 数组
    public func shuffled() -> Array {
        var result = self
        result.shuffle()
        return result
    }
    
    
    /// 取出数组内多少个元素(从0开始)
    ///
    /// - Parameter n: 元素个数
    /// - Returns: 数组
    public func takeMax(_ n: Int) -> Array {
        return Array(self[0..<Swift.max(0, Swift.min(n, count))])
    }
    
    
    /// 检查每个元素是否都满足相应条件
    ///
    /// - Parameter body: 相应条件
    /// - Returns: 结果
    public func testAll(_ body: @escaping (Element) -> Bool) -> Bool {
        return self.first { !body($0) } == nil
    }

    
    /// 检查每个元素是否都为给定的 bool 结果
    ///
    /// - Parameter condition: 结果
    /// - Returns: 结果
    public func testAll(is condition: Bool) -> Bool {
        return testAll { ($0 as? Bool) ?? !condition == condition }
    }
}

/// 基于 Equatable 协议
extension Array where Element: Equatable {
    
    /// 检查参数数组是否包含在主数组内
    ///
    /// - Parameter array: 参数数组
    /// - Returns: 结果
    public func contains(_ array: [Element]) -> Bool {
        return array.testAll { self.index(of: $0) ?? -1 >= 0 }
    }
    
    
    /// 检查数组内是否包含某项
    ///
    /// - Parameter elements: 参数
    /// - Returns: 结果
    public func contains(_ elements: Element...) -> Bool {
        return elements.testAll { self.index(of: $0) ?? -1 >= 0 }
    }
    

    /// 返回参数所在位置
    ///
    /// - Parameter element: 参数
    /// - Returns: 数组
    public func indexes(of element: Element) -> [Int] {
        return self.enumerated().flatMap { ($0.element == element) ? $0.offset : nil }
    }
    
    
    /// 返回 obj 的最后一个位置
    ///
    /// - Parameter element:  obj
    /// - Returns: index
    public func lastIndex(of element: Element) -> Int? {
        return indexes(of: element).last
    }
    
    
    /// 移除(第一个)该元素
    ///
    /// - Parameter element: 元素
    public mutating func removeFirst(_ element: Element) {
        guard let index = self.index(of: element) else { return }
        self.remove(at: index)
    }
    
    
    /// 移除数组内包含的所有该元素
    ///
    /// - Parameter elements: 元素
    public mutating func removeAll(_ elements: Element...) {
        for element in elements {
            for index in self.indexes(of: element).reversed() {
                self.remove(at: index)
            }
        }
    }
    
    
    /// 找出当前数组与给定数组不同
    ///
    /// - Parameter values: 数组
    /// - Returns: 不同的数组
    public func difference(_ values: [Element]...) -> [Element] {
        var result = [Element]()
        elements: for element in self {
            for value in values {
                //  if a value is in both self and one of the values arrays
                //  jump to the next iteration of the outer loop
                if value.contains(element) {
                    continue elements
                }
            }
            //  element it's only in self
            result.append(element)
        }
        return result
    }
    
    /// EZSE: Intersection of self and the input arrays.
    public func intersection(_ values: [Element]...) -> Array {
        var result = self
        var intersection = Array()
        
        for (i, value) in values.enumerated() {
            //  the intersection is computed by intersecting a couple per loop:
            //  self n values[0], (self n values[0]) n values[1], ...
            if i > 0 {
                result = intersection
                intersection = Array()
            }
            
            //  find common elements and save them in first set
            //  to intersect in the next loop
            value.forEach { (item: Element) -> Void in
                if result.contains(item) {
                    intersection.append(item)
                }
            }
        }
        return intersection
    }
    
    /// EZSE: Union of self and the input arrays.
    public func union(_ values: [Element]...) -> Array {
        var result = self
        for array in values {
            for value in array {
                if !result.contains(value) {
                    result.append(value)
                }
            }
        }
        return result
    }
    
    /// EZSE: Returns an array consisting of the unique elements in the array
    public func unique() -> Array {
        return reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
    }
}
