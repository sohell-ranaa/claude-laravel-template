# Business Rules & Logic

**[YOUR PROJECT NAME] - Define your business domain here**

---

## 📝 Instructions

This file should contain your project-specific business rules and domain logic.

Replace the example content below with your actual business rules.

---

## Example: E-Commerce Platform

### Core Business Model

**Product Management:**
- Products have SKUs, prices, inventory levels
- Products can be in multiple categories
- Products can have variants (size, color, etc.)

**Order Processing:**
- Orders go through: pending → confirmed → shipped → delivered
- Payment must be confirmed before shipping
- Orders can be cancelled before shipping

**Inventory Rules:**
- Inventory is decremented on order confirmation
- Out-of-stock products cannot be ordered
- Low stock alerts at threshold

### Critical Business Rules

1. **Payment Before Shipment**
   - No order ships without payment confirmation
   - Exception: COD orders (cash on delivery)

2. **Inventory Management**
   ```php
   if ($product->stock < $orderQuantity) {
       throw new InsufficientStockException();
   }
   ```

3. **Refund Policy**
   - Full refund within 7 days
   - Partial refund for damaged items
   - No refund after 30 days

---

## Your Project

**Replace this section with your business model:**

### Entity 1: [Name]
- Description
- Business rules
- Relationships

### Entity 2: [Name]
- Description
- Business rules
- Relationships

### Critical Rules for Your Domain
1. Rule 1
2. Rule 2
3. Rule 3

---

**See Also:**
- `.claude/skills/business-logic/SKILL.md` - Business logic skill
- `docs/development-patterns.md` - Implementation patterns
