---
name: business-logic
description: Your domain-specific business rules and logic. Customize this for your project's business domain.
---

# Business Logic & Rules

**[YOUR PROJECT NAME] - Define your domain here**

## 📝 Instructions

This skill should contain your project-specific business rules, domain logic, and critical constraints.

**Before using this template:**
1. Replace "[YOUR PROJECT]" with your project name
2. Define your core entities and their rules
3. Document critical business constraints
4. Add code examples for key validations

---

## Example: E-Commerce Platform

### Critical Business Rules

1. **Payment Before Shipment**
   ```php
   // Always verify payment before shipping
   if (!$order->payment_confirmed) {
       throw new PaymentNotConfirmedException();
   }

   // Exception for COD orders
   if ($order->payment_method === 'cod') {
       // Ship without payment confirmation
       $this->shipOrder($order);
   }
   ```

2. **Inventory Management**
   ```php
   // Check stock before confirming order
   if ($product->stock < $orderQuantity) {
       throw new InsufficientStockException();
   }

   // Decrement stock on confirmation
   $product->decrement('stock', $orderQuantity);
   ```

3. **Refund Policy**
   ```php
   // Check refund eligibility
   if ($order->created_at->diffInDays(now()) > 30) {
       throw new RefundPeriodExpiredException();
   }
   ```

### Entity Relationships

**Product:**
- belongs to Category
- has many OrderItems
- has many Reviews

**Order:**
- belongs to User
- has many OrderItems
- has one Payment

**User:**
- has many Orders
- has one Cart
- has many Addresses

---

## Your Project - Replace This Section

### Entity 1: [Name]

**Purpose:** Describe what this entity represents

**Key Fields:**
- `field_1`: Description
- `field_2`: Description
- `field_3`: Description

**Business Rules:**
1. Rule 1 - When X happens, do Y
2. Rule 2 - Never allow Z
3. Rule 3 - Always validate A before B

**Code Example:**
```php
// Example validation or business logic
if ($entity->some_field === 'specific_value') {
    // Do something specific
}
```

### Entity 2: [Name]

**Purpose:** Describe what this entity represents

**Key Fields:**
- `field_1`: Description
- `field_2`: Description

**Business Rules:**
1. Rule 1
2. Rule 2

### Critical Constraints

**List your project's critical constraints:**

1. **Constraint Name**
   - What: Description
   - Why: Business reason
   - How: Implementation approach

   ```php
   // Code example
   if ($condition) {
       // Enforce constraint
   }
   ```

2. **Another Constraint**
   - What: Description
   - Why: Business reason
   - How: Implementation

### Common Operations

**Document common business operations:**

#### Operation 1: [Name]
```php
// Example code for this operation
public function performOperation($entity)
{
    // Step 1: Validate
    $this->validate($entity);

    // Step 2: Process
    $result = $this->process($entity);

    // Step 3: Return
    return $result;
}
```

#### Operation 2: [Name]
```php
// Another common operation
```

---

## Usage in Code

**When to load this skill:**
- Working with core business entities
- Implementing business logic and validations
- Processing payments or financial operations
- Enforcing business constraints
- Making architectural decisions about domain logic

**Example usage:**
```
User asks: "Add order validation logic"
Claude loads: /business-logic skill
Result: Claude knows your specific order rules
```

---

## Related Documentation

- `docs/business-rules.md` - Detailed business rules documentation
- `docs/development-patterns.md` - Implementation patterns
- `.claude/skills/laravel-livewire/SKILL.md` - Technical patterns

---

**Last Updated:** [DATE]
**Project:** [YOUR PROJECT NAME]
**Domain:** [YOUR BUSINESS DOMAIN]
