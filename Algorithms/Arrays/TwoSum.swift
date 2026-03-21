// @id: two-sum-unsorted
// @title: Two Sum Unsorted
// @difficulty: Easy
// @tags: Array, Dictionary
// @time: O(n)
// @space: O(n)
//
// ====================================================
// 🧩 Step 1: Problem Statement
// ====================================================
//
// Given an array of integers numbers and an integer target
// find the indices of the two numbers such that they add up to a target.
//
// ====================================================
// ⚙️ Step 2: Algorithm Approaches
// ====================================================
//
// 1. Brute Force – Check all pairs (O(n²) time, O(1) space)
// 2. Two-Pass Dictionary – Build map then search (O(n), O(n))
// 3. One-Pass Dictionary – Build + search together (O(n), O(n))
//
// ====================================================
// 💻 Step 3: Code Implementations
// ====================================================

/**
 * Brute Force – Check all pairs
 * Checks every possible pair of numbers to find the target.
 * - Parameters:
 *   - numbers: Input array of integers.
 *   - target: The desired sum value.
 * - Returns: Indices of the two numbers, or an empty array if none found.
 * - Complexity: O(n²) time, O(1) space.
 */
func twoSumBruteForce(_ numbers: [Int], _ target: Int) -> [Int] {
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
 * Two-Pass Dictionary.
 * First Pass: Populate the map with each number and its index
 * Second Pass: Check for each number's complement in the map
 * - Parameters:
 *   - numbers: Input array of integers.
 *   - target: The desired sum value.
 * - Returns: Indices of the two numbers, or an empty array if none found.
 * - Complexity: O(n) time, O(n) space.
 */
func twoSumTwoPass(_ numbers: [Int], _ target: Int) -> [Int] {
    guard !numbers.isEmpty else {
        return []
    }
    
    var map: [Int: Int] = [:]
    
    // First pass: build map
    for (index, number) in numbers.enumerated() {
        map[number] = index
    }
    
    // Second pass: find complement
    for (index, number) in numbers.enumerated() {
        if let complementIndex = map[target - number],
           complementIndex != index { // Exclude the self
            return [index, complementIndex]
        }
    }
    return []
}

/**
 * One-Pass Dictionary.
 * Build the map while searching for complements.
 * - Parameters:
 *   - numbers: Input array of integers.
 *   - target: The desired sum value.
 * - Returns: Indices of the two numbers, or an empty array if none found.
 * - Complexity: O(n) time, O(n) space.
 */
func twoSumOnePass(_ numbers: [Int], _ target: Int) -> [Int] {
    guard !numbers.isEmpty else {
        return []
    }
    
    var map: [Int: Int] = [:] // Stores complement value as key and its index as value
    
    for (index, number) in numbers.enumerated() {
        if let complementIndex = map[number] {
            return [complementIndex, index]
        }
        map[target - number] = index
    }
    
    return []
}

// ====================================================
// 🧪 Step 4: Testing
//====================================================

let tests: [([Int], Int)] = [
    ([3,2,7,11,15], 9), // [1, 2] Given valid scenarios
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
    print("→ BruteForce:", twoSumBruteForce(nums, target))
    print("→ TwoPass:", twoSumTwoPass(nums, target))
    print("→ OnePass:", twoSumOnePass(nums, target))
    print("---")
}

// ====================================================
// 📊 Step 5: Analysis
// One-Pass is optimal for most cases.
// ====================================================
//
// Example Output:
//
// Input: [3,2,7,11,15], Target: 9
// → BruteForce: [1, 2]
// → TwoPass: [1, 2]
// → OnePass: [1, 2]
