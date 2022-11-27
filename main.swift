func get_all_shortest_transformation_sequences(start_word: String, target_word: String, words: [String]) -> [[String]] {
    var result: [[String]] = []
    var found = false
    var level = 0
    let words = Set(words)
    var slate: [String] = []
    var parent: [String: Set<String>] = [:]
    var visited: Set<String> = []
    var levels: [String: Int] = [:]
    
    func getNeighbors(_ parent: String) -> [String] {
        var neighbors: [String] = []
        if words.count < 26 {
            for neighbor in words where parent.isOneDiff(of: neighbor) {
                neighbors.append(neighbor)
            }
        } else {
            let parent = parent.map { $0 }
            for i in parent.indices {
                var neighbor = parent
                for letter in "abcdefghijklmnopqrstuvwxyz" {
                    neighbor[i] = letter
                    let neighborString = String(neighbor)
                    if words.contains(neighborString) {
                        neighbors.append(neighborString)
                    }
                }
            }
        }
        return neighbors
    }
    
    func bfs(_ root: String) {
        var queue: [String] = []
        queue.append(root)
        
        while queue.count > 0, !found {
            let qc = queue.count
            level += 1
            for _ in 0..<qc {
                let word = queue.removeFirst()
                for neighbor in getNeighbors(word) {
                    if neighbor == target_word {
                        found = true
                    }
            
                    if !visited.contains(neighbor) {
                        visited.insert(neighbor)
                        levels[neighbor] = level
                        queue.append(neighbor)
                        parent[neighbor, default: []].insert(word)
                    } else if 
                        !parent[word, default: []].contains(neighbor),
                        levels[neighbor]! > levels[word]!
                    {
                        parent[neighbor, default: []].insert(word)
                    }
                }
            }
        }
    }
    
    func dfs(_ root: String, _ slate: inout [String]) {
        guard slate.count <= level + 1 else { return }
        
        guard let neighbors = parent[root], root != start_word else {
            result.append(slate.reversed())
            return
        }
        
        if root == target_word {
            slate.append(target_word)
        }
        
        for neighbor in neighbors {
            slate.append(neighbor)
            dfs(neighbor, &slate)
            slate.removeLast()
        }
    }
    
    bfs(start_word)
    
    guard found else { return [] }
    
    dfs(target_word, &slate)
    
    return result
}

extension String {
    func isOneDiff(of string: String) -> Bool {
        let s1 = self.map { $0 }, s2 = string.map { $0 }
        var count = 0
        for i in s1.indices where s1[i] != s2[i] {
            count += 1
        }
        return count == 1
    }
}