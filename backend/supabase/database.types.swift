import Foundation
import Supabase


internal enum PublicSchema {
  internal struct ExpensesSelect: Codable, Hashable, Sendable {
    internal let amount: NumericSelect
    internal let createdAt: String
    internal let description: String?
    internal let groupId: UUID
    internal let id: UUID
    internal let isShared: Bool
    internal let userId: UUID
    internal enum CodingKeys: String, CodingKey {
      case amount = "amount"
      case createdAt = "created_at"
      case description = "description"
      case groupId = "group_id"
      case id = "id"
      case isShared = "is_shared"
      case userId = "user_id"
    }
  }
  internal struct ExpensesInsert: Codable, Hashable, Sendable {
    internal let amount: NumericSelect
    internal let createdAt: String?
    internal let description: String?
    internal let groupId: UUID
    internal let id: UUID?
    internal let isShared: Bool?
    internal let userId: UUID
    internal enum CodingKeys: String, CodingKey {
      case amount = "amount"
      case createdAt = "created_at"
      case description = "description"
      case groupId = "group_id"
      case id = "id"
      case isShared = "is_shared"
      case userId = "user_id"
    }
  }
  internal struct ExpensesUpdate: Codable, Hashable, Sendable {
    internal let amount: NumericSelect?
    internal let createdAt: String?
    internal let description: String?
    internal let groupId: UUID?
    internal let id: UUID?
    internal let isShared: Bool?
    internal let userId: UUID?
    internal enum CodingKeys: String, CodingKey {
      case amount = "amount"
      case createdAt = "created_at"
      case description = "description"
      case groupId = "group_id"
      case id = "id"
      case isShared = "is_shared"
      case userId = "user_id"
    }
  }
  internal struct GroupsSelect: Codable, Hashable, Sendable {
    internal let createdAt: String
    internal let currency: String
    internal let globalBudget: NumericSelect
    internal let id: UUID
    internal let name: String
    internal enum CodingKeys: String, CodingKey {
      case createdAt = "created_at"
      case currency = "currency"
      case globalBudget = "global_budget"
      case id = "id"
      case name = "name"
    }
  }
  internal struct GroupsInsert: Codable, Hashable, Sendable {
    internal let createdAt: String?
    internal let currency: String?
    internal let globalBudget: NumericSelect
    internal let id: UUID?
    internal let name: String
    internal enum CodingKeys: String, CodingKey {
      case createdAt = "created_at"
      case currency = "currency"
      case globalBudget = "global_budget"
      case id = "id"
      case name = "name"
    }
  }
  internal struct GroupsUpdate: Codable, Hashable, Sendable {
    internal let createdAt: String?
    internal let currency: String?
    internal let globalBudget: NumericSelect?
    internal let id: UUID?
    internal let name: String?
    internal enum CodingKeys: String, CodingKey {
      case createdAt = "created_at"
      case currency = "currency"
      case globalBudget = "global_budget"
      case id = "id"
      case name = "name"
    }
  }
  internal struct UserGroupsSelect: Codable, Hashable, Sendable {
    internal let createdAt: String
    internal let discretionaryBudget: NumericSelect
    internal let discretionaryRemaining: NumericSelect
    internal let groupId: UUID
    internal let id: UUID
    internal let userId: UUID
    internal enum CodingKeys: String, CodingKey {
      case createdAt = "created_at"
      case discretionaryBudget = "discretionary_budget"
      case discretionaryRemaining = "discretionary_remaining"
      case groupId = "group_id"
      case id = "id"
      case userId = "user_id"
    }
  }
  internal struct UserGroupsInsert: Codable, Hashable, Sendable {
    internal let createdAt: String?
    internal let discretionaryBudget: NumericSelect
    internal let discretionaryRemaining: NumericSelect
    internal let groupId: UUID
    internal let id: UUID?
    internal let userId: UUID
    internal enum CodingKeys: String, CodingKey {
      case createdAt = "created_at"
      case discretionaryBudget = "discretionary_budget"
      case discretionaryRemaining = "discretionary_remaining"
      case groupId = "group_id"
      case id = "id"
      case userId = "user_id"
    }
  }
  internal struct UserGroupsUpdate: Codable, Hashable, Sendable {
    internal let createdAt: String?
    internal let discretionaryBudget: NumericSelect?
    internal let discretionaryRemaining: NumericSelect?
    internal let groupId: UUID?
    internal let id: UUID?
    internal let userId: UUID?
    internal enum CodingKeys: String, CodingKey {
      case createdAt = "created_at"
      case discretionaryBudget = "discretionary_budget"
      case discretionaryRemaining = "discretionary_remaining"
      case groupId = "group_id"
      case id = "id"
      case userId = "user_id"
    }
  }
  internal struct UsersSelect: Codable, Hashable, Sendable {
    internal let createdAt: String
    internal let email: String
    internal let id: UUID
    internal let name: String?
    internal let passwordHash: String
    internal enum CodingKeys: String, CodingKey {
      case createdAt = "created_at"
      case email = "email"
      case id = "id"
      case name = "name"
      case passwordHash = "password_hash"
    }
  }
  internal struct UsersInsert: Codable, Hashable, Sendable {
    internal let createdAt: String?
    internal let email: String
    internal let id: UUID?
    internal let name: String?
    internal let passwordHash: String
    internal enum CodingKeys: String, CodingKey {
      case createdAt = "created_at"
      case email = "email"
      case id = "id"
      case name = "name"
      case passwordHash = "password_hash"
    }
  }
  internal struct UsersUpdate: Codable, Hashable, Sendable {
    internal let createdAt: String?
    internal let email: String?
    internal let id: UUID?
    internal let name: String?
    internal let passwordHash: String?
    internal enum CodingKeys: String, CodingKey {
      case createdAt = "created_at"
      case email = "email"
      case id = "id"
      case name = "name"
      case passwordHash = "password_hash"
    }
  }
}
