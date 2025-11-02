//
//  TwoSumSorted.swift
//  Source: LeetCode #167
//  Given a sorted array of integers, find two numbers such that they add up to a target.
//  Time Complexity: O(n)
//  Space Complexity: O(1)
//  Pattern: Two Pointer
//  Tags: Array
//

/// Finds two indices in a sorted array whose values add up to the target.
/// - Parameters:
///   - nums: Sorted array of integers.
///   - target: Target sum.
/// - Returns: Indices of the two numbers. Empty array if none found.
/// - Complexity: O(n) time, O(1) space.
/// - Pattern: Two Pointer
func twoSumSorted(_ nums: [Int], _ target: Int) -> [Int] {
    guard !nums.isEmpty else { return [] }
    
    var left = 0
    var right = nums.count - 1
    
    while left < right {
        let sum = nums[left] + nums[right]
        if sum < target {
            left += 1
        } else if sum > target {
            right -= 1
        } else {
            return [left, right]
        }
    }
    
    return []
}

// Example
let nums = [2, 7, 11, 15]
let target = 9
print(twoSumSorted(nums, target)) // Output: [0, 1]
