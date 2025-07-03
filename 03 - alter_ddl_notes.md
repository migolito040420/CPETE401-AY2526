
# Course Notes: Altering Tables in MariaDB (DDL)

This document provides a comprehensive guide to modifying existing table structures using MariaDB's Data Definition Language (DDL). The primary command for these operations is `ALTER TABLE`.

---

## Introduction to `ALTER TABLE`

The `ALTER TABLE` statement is used to add, delete, or modify columns in an existing table. It is also used to add and drop various constraints on an existing table. This is a fundamental skill for database development and maintenance, as application requirements often change over time.

**General Syntax:**
```sql
ALTER TABLE table_name
    [action1, action2, ...];
```
Where `action` can be adding a column, modifying a data type, adding a key, etc.

---

## Common `ALTER TABLE` Operations

Let's use a simplified `products` table as our starting point for the following examples.

**Initial Table:**
```sql
CREATE TABLE products (
    product_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (product_id)
) ENGINE=InnoDB;
```

### 1. Adding a Column (`ADD COLUMN`)

**Scenario:** You initially created the `products` table but forgot to include a column for inventory tracking.

**Syntax:**
```sql
ALTER TABLE table_name
    ADD COLUMN column_name column_definition [FIRST | AFTER existing_column];
```

**Example:** Add a `stock_quantity` column to the `products` table.

```sql
ALTER TABLE products
    ADD COLUMN stock_quantity INT UNSIGNED NOT NULL DEFAULT 0 AFTER price;
```

**Explanation:**
*   We added a new column named `stock_quantity`.
*   Its data type is `INT UNSIGNED` to ensure it only holds positive numbers.
*   `NOT NULL DEFAULT 0` ensures that all existing rows will get a value of `0` for this new column, and new rows must have a value.
*   `AFTER price` places the new column immediately after the `price` column for logical ordering.

### 2. Modifying a Column (`MODIFY COLUMN`)

**Scenario:** You realize that the `product_name` field, currently `VARCHAR(255)`, is too long and you want to reduce its size. You also want to ensure the price is always positive.

**Syntax:**
```sql
ALTER TABLE table_name
    MODIFY COLUMN column_name new_column_definition;
```

**Example:** Change the `product_name` length and add a `CHECK` constraint to `price`.

```sql
ALTER TABLE products
    MODIFY COLUMN product_name VARCHAR(200) NOT NULL,
    ADD CONSTRAINT chk_price CHECK (price > 0);
```

**Explanation:**
*   `MODIFY COLUMN` is used to change the definition of `product_name` to `VARCHAR(200)`.
*   **Caution:** Reducing the size of a `VARCHAR` or changing a data type can result in data loss if existing data exceeds the new capacity.
*   We also added a `CHECK` constraint named `chk_price` to enforce a business rule: the price must be greater than zero.

### 3. Renaming a Column (`CHANGE COLUMN`)

**Scenario:** The team has decided to adopt a more descriptive naming convention. You need to rename `product_id` to `id`.

**Syntax:**
```sql
ALTER TABLE table_name
    CHANGE COLUMN old_column_name new_column_name new_column_definition;
```

**Example:** Rename `product_id` to `id`.

```sql
ALTER TABLE products
    CHANGE COLUMN product_id id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT;
```

**Explanation:**
*   `CHANGE COLUMN` requires you to specify the old name, the new name, and the **full column definition** (data type, constraints, etc.), even if the definition isn't changing.
*   This is a common point of error; forgetting the full definition can inadvertently change the column's data type or nullability.

### 4. Dropping a Column (`DROP COLUMN`)

**Scenario:** You decide to track product categories in a separate, more robust `categories` table and want to remove a temporary `category` text field you added earlier.

**Syntax:**
```sql
ALTER TABLE table_name
    DROP COLUMN column_name;
```

**Example:** First, let's add a temporary column, then drop it.

```sql
-- 1. Add a temporary column
ALTER TABLE products ADD COLUMN temp_category VARCHAR(50);

-- 2. Drop the column
ALTER TABLE products DROP COLUMN temp_category;
```

**Explanation:**
*   `DROP COLUMN` permanently removes the column and all of its data.
*   **This action is irreversible.** Always be certain you no longer need the data before dropping a column.

--- 

## Managing Constraints

### 1. Adding Keys and Foreign Keys

**Scenario:** The `products` table needs a unique `sku` (Stock Keeping Unit) and must be linked to a new `categories` table.

**Supporting Table (`categories`):**
```sql
CREATE TABLE categories (
    category_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (category_id)
) ENGINE=InnoDB;
```

**Example:** Add a `sku`, a `category_id`, and the foreign key relationship.

```sql
ALTER TABLE products
    -- 1. Add a new column for the SKU and make it unique
    ADD COLUMN sku VARCHAR(100) NOT NULL AFTER id,
    ADD UNIQUE KEY uk_sku (sku),

    -- 2. Add the foreign key column
    ADD COLUMN category_id INT UNSIGNED NULL AFTER price,

    -- 3. Add the foreign key constraint
    ADD CONSTRAINT fk_category
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON DELETE SET NULL;
```

**Explanation:**
*   `ADD UNIQUE KEY uk_sku (sku)` ensures that no two products can have the same SKU.
*   We first `ADD COLUMN category_id` to hold the key from the `categories` table.
*   `ADD CONSTRAINT fk_category` creates the foreign key relationship.
*   `ON DELETE SET NULL` specifies that if a category is deleted from the `categories` table, the `category_id` for any products in that category will be set to `NULL`.

### 2. Dropping Constraints

**Scenario:** You need to remove a foreign key constraint to change the column it references.

**Syntax:**
```sql
-- For Foreign Keys
ALTER TABLE table_name DROP FOREIGN KEY constraint_name;

-- For Indexes/Unique Keys
ALTER TABLE table_name DROP INDEX index_name;

-- For Primary Keys (requires a valid replacement)
ALTER TABLE table_name DROP PRIMARY KEY;
```

**Example:** Drop the foreign key and unique key from the `products` table.

```sql
-- 1. Drop the foreign key constraint
ALTER TABLE products DROP FOREIGN KEY fk_category;

-- 2. Drop the unique key on SKU
ALTER TABLE products DROP INDEX uk_sku;
```

**Explanation:**
*   To drop a foreign key, you must know its name (which we defined as `fk_category`).
*   `DROP INDEX` is used to remove `UNIQUE` keys, `FULLTEXT` indexes, and regular indexes.

--- 

## Renaming a Table

**Scenario:** The table `products` needs to be renamed to `items` to better reflect its contents.

**Syntax:**
```sql
ALTER TABLE old_table_name RENAME TO new_table_name;
```

**Example:**
```sql
ALTER TABLE products RENAME TO items;
```

--- 

## Best Practices & Considerations

1.  **Backup First:** Before running any `ALTER TABLE` command on a production database, ensure you have a recent, restorable backup.
2.  **Performance Impact:** `ALTER TABLE` can lock the table, making it unavailable for reads or writes. On very large tables, this can cause significant downtime. For large-scale changes, consider using tools like `pt-online-schema-change` or MariaDB's `ALGORITHM=INPLACE` and `LOCK=NONE` options where possible.
3.  **Transactional Safety:** Wrap schema changes in a transaction (`START TRANSACTION; ... COMMIT;`) if possible, although many DDL statements cause an implicit commit.
4.  **Check for Dependencies:** Before dropping a column or table, check if other parts of your application, views, or stored procedures depend on it.
5.  **Develop on a Staging Server:** Always test your migration scripts on a staging or development server that mirrors the production environment before running them on production data.
