// @id: two-sum-sorted
// @title: Two Sum Sorted
// @difficulty: Medium
// @tags: Array, Two Pointers
// @time: O(n)
// @space: O(1)
// @source: https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/
//
// ====================================================
// 🧩 Step 1: Problem Statement
// ====================================================
//
// Link: [LeetCode #167 - Two Sum](https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/)
//
// Given an array of integers sorted in ascending order and a`target` value,
// return the indices of any pair of numbers that sum to the `target`.
// If no pair is found, return the empty array
//
// ====================================================
// ⚙️ Step 2: Algorithm Approaches
// ====================================================
//
// 1. Brute Force – Check all possible pairs (O(n²) time, O(1) space)
// 2. Dictionary Map – Standard Two-Sum logic (O(n) time, O(n) space)
// 3. Two Pointers - Inward traversal (O(n) time, O(1) space)
//
// ====================================================
// 💻 Step 3: Code Implementations
// ====================================================

/**
 * Brute Force – Check all possible pairs.
 * Checks every possible pair of numbers to find the target. This is done using two nested loops
 * - Parameters:
 *   - numbers: Input array of integers.
 *   - target: The desired sum value.
 * - Returns: Indexes of the two numbers, or an empty array if none found.
 * - Complexity: O(n²) time, O(1) space.
 */
func twoSumSortedBruteForce(_ numbers: [Int], _ target: Int) -> [Int] {
    guard !numbers.isEmpty else {
        return []
    }
    
    for i in 0..<numbers.count {
        for j in i+1..<numbers.count {
            if numbers[i] + numbers[j] == target {
                return [i, j]
            }
        }
    }
    return []
}

/**
 * Dictionary Map.
 * Build the dictionary while searching for complements.
 * - Parameters:
 *   - numbers: Input array of integers.
 *   - target: The desired sum value.
 * - Returns: Indexes of the two numbers, or an empty array if none found.
 * - Complexity: O(n) time, O(n) space.
 */
func twoSumSortedUsingDictionary(_ numbers: [Int], _ target: Int) -> [Int] {
    guard !numbers.isEmpty else {
        return []
    }
    
    var map: [Int: Int] = [:]
    
    for (index, number) in numbers.enumerated() {
        if let complementIndex = map[number] {
            return [complementIndex, index]
        }
        map[target - number] = index
    }
    return []
}

/**
 * Two Pointers - using inward traversal.
 * If their sum is less than the target, increment left, aiming to increase the sum toward the target value.
 * If their sum is greater than the target, decrement right, aiming to decrease the sum toward the target value.
 * If their sum is equal to the target value, return [left, right]
 * - Parameters:
 *   - numbers: Input array of integers.
 *   - target: The desired sum value.
 * - Returns: Indexes of the two numbers, or an empty array if none found.
 * - Complexity: O(n) time, O(1) space.
 */
func twoSumSorted(_ numbers: [Int], _ target: Int) -> [Int] {
    guard !numbers.isEmpty else {
        return []
    }
    
    var left = 0
    var right = numbers.count - 1
    
    while left < right {
        let sum = numbers[left] + numbers[right]
        if sum == target {
            return [left, right]
        } else if sum < target {
            left += 1
        } else {
            right -= 1
        }
    }
    return []
}

// ====================================================
// 🧪 Step 4: Testing
//====================================================

let tests: [([Int], Int)] = [
    ([2,7,11,15], 9), // [0, 1] Given valid scenarios
    ([], 0), // [] Empty Array
    ([1], 1), // [] Array with just one element
    ([2, 3], 5), // [0, 1] Two-element array that contains a pair that sum to the target
    ([2, 4], 5), // [] Two-element array that doesn't contain a pair sums to the target
    ([2, 2, 3], 5), // [0, 2] or [1 ,2] Array with duplicate values
    ([-1, 2, 3], 2), // [0, 2] Negative number in the target pair
    ([-3, -2, -1], -5) // [0, 1] Both negative in target pair being negative
]

for (nums, target) in tests {
    print("Input: \(nums), Target: \(target)")
    print("→ BruteForce:", twoSumSortedBruteForce(nums, target))
    print("→ Dictionary:", twoSumSortedUsingDictionary(nums, target))
    print("→ TwoPointers:", twoSumSorted(nums, target))
    print("---")
}

// ====================================================
// 📊 Step 5: Analysis
// Two Pointers is optimal for most cases because it uses O(1) space by leveraging the fact that the input array is already sorted.
// ====================================================
//
// Example Output:
//
// Input: [2, 7, 11, 15], Target: 9
// → BruteForce: [0, 1]
// → Dictionary: [0, 1]
// → TwoPointers: [0, 1]
