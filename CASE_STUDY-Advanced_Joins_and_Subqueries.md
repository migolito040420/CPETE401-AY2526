# Case Study: Advanced Joins and Subqueries in E-Commerce

## Introduction

This case study explores a more complex e-commerce database. You will be working with a schema that includes customers, products, categories, suppliers, and orders. The relationships are more intricate than in previous examples, featuring multiple many-to-many relationships.

This case study is designed to challenge your understanding of:
- Complex multi-table `INNER JOIN`s.
- The practical differences between `LEFT JOIN` and `RIGHT JOIN` for finding missing or optional data.
- Combining joins with aggregate functions to produce meaningful business reports.
- Using subqueries (nested queries) to solve problems that joins alone cannot easily handle.

## Database Schema

The database consists of seven tables:
- `Customers`: Stores customer data.
- `Categories`: Lists product categories.
- `Suppliers`: Lists all product suppliers.
- `Products`: Stores product information, including their primary category.
- `ProductSuppliers`: A many-to-many link between products and the suppliers who provide them.
- `Orders`: The main table for customer orders.
- `OrderItems`: The line items for each order, linking `Orders` and `Products`.

### SQL Schema (DDL)

```sql
-- Drop tables in reverse order of dependency to avoid foreign key errors
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS ProductSuppliers;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Suppliers;

-- Table for Customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    registration_date DATE NOT NULL
);

-- Table for Categories
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- Table for Suppliers
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    country VARCHAR(50)
);

-- Table for Products
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE SET NULL
);

-- Many-to-many relationship between Products and Suppliers
CREATE TABLE ProductSuppliers (
    product_id INT,
    supplier_id INT,
    PRIMARY KEY (product_id, supplier_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE CASCADE
);

-- Table for Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

-- Table for OrderItems (linking Orders and Products)
CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price_per_unit DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE SET NULL
);
```

### Sample Data (DML)

```sql
-- Insert data into Categories
INSERT INTO Categories (category_name) VALUES
('Electronics'),
('Books'),
('Home & Kitchen'),
('Toys & Games'); -- A category with no products initially

-- Insert data into Suppliers
INSERT INTO Suppliers (supplier_name, country) VALUES
('TechGlobal', 'USA'),
('BookWorld Inc.', 'Canada'),
('HomeGoods LLC', 'USA'),
('Global Toys', 'China'),
('EuroSupply', 'Germany'); -- A supplier who supplies no products

-- Insert data into Products
INSERT INTO Products (product_name, price, category_id) VALUES
('Laptop Pro 15"', 1200.00, 1),
('Quantum Physics Explained', 25.50, 2),
('Smart Coffee Maker', 89.99, 3),
('The Art of Strategy', 19.99, 2),
('Wireless Mouse', 24.99, 1),
('LED Desk Lamp', 35.00, 3),
('Unsold Product', 99.99, 1); -- A product that is never ordered

-- Insert data into ProductSuppliers
INSERT INTO ProductSuppliers (product_id, supplier_id) VALUES
(1, 1), -- Laptop Pro from TechGlobal
(2, 2), -- Quantum Physics from BookWorld
(3, 1), -- Coffee Maker from TechGlobal
(3, 3), -- Coffee Maker also from HomeGoods
(4, 2), -- Art of Strategy from BookWorld
(5, 1), -- Wireless Mouse from TechGlobal
(6, 3); -- Desk Lamp from HomeGoods

-- Insert data into Customers
INSERT INTO Customers (first_name, last_name, email, registration_date) VALUES
('John', 'Doe', 'john.d@email.com', '2024-01-10'),
('Jane', 'Smith', 'jane.s@email.com', '2024-02-15'),
('Peter', 'Jones', 'peter.j@email.com', '2024-03-20'),
('Mary', 'Williams', 'mary.w@email.com', '2024-04-05'); -- A customer with no orders

-- Insert data into Orders
INSERT INTO Orders (customer_id, order_date, status) VALUES
(1, '2025-01-15', 'Shipped'),
(2, '2025-01-18', 'Shipped'),
(1, '2025-02-01', 'Processing'),
(3, '2025-02-05', 'Shipped');

-- Insert data into OrderItems
INSERT INTO OrderItems (order_id, product_id, quantity, price_per_unit) VALUES
(1, 1, 1, 1200.00), -- John buys a Laptop
(1, 5, 1, 24.99),   -- and a Mouse
(2, 2, 2, 25.50),   -- Jane buys two Physics books
(3, 3, 1, 89.99),   -- John buys a Coffee Maker
(4, 4, 1, 19.99),   -- Peter buys a Strategy book
(4, 2, 1, 25.50);   -- and a Physics book
```

---

## Problem Set

1.  **All Products and Their Categories**: List every product and its category name. Include products that might not have a category assigned.
2.  **Customers and Their Total Spending**: Show each customer's full name and the total amount they have spent across all their orders. List them from highest to lowest spender. Include customers who have never placed an order.
3.  **Suppliers for a Specific Product**: Find all suppliers for the "Smart Coffee Maker". List the supplier names.
4.  **Products Never Ordered**: Identify all products that have never been included in any order. List their names and prices.
5.  **Right Join for Unused Suppliers**: List all suppliers and the names of the products they supply. **Crucially, include suppliers who do not supply any products.**
6.  **Total Revenue by Category**: Calculate the total revenue generated from each product category. List the category name and the total revenue, ordered from most to least profitable.
7.  **Customers Who Bought Electronics**: Get the full names of all customers who have purchased at least one product from the 'Electronics' category.
8.  **Orders Containing Multiple Items**: Find all orders that contain more than one distinct product. List the `order_id` and the count of items.
9.  **Suppliers and Their Product Count**: For each supplier, count how many different products they supply. List the supplier's name and the number of products. Include suppliers who supply zero products.
10. **Most Popular Product**: Find the product that has been sold the most in terms of total quantity. List the product name and the total quantity sold.
11. **Subquery to Find Customers with No Orders**: Using a subquery in the `WHERE` clause, find all customers who have not placed any orders. List their first and last names.
12. **Three-Table Join for Order Details**: For `order_id` 1, list the customer's full name, the product name, the quantity, and the price per unit for each item in the order.
13. **Products Supplied by "TechGlobal"**: List the names of all products supplied by "TechGlobal". Use a join to solve this.
14. **Advanced Subquery: Customers who bought "Quantum Physics Explained"**: Using a subquery, find the first and last names of all customers who have ordered the product named "Quantum Physics Explained".
15. **Complex Report: Revenue per Supplier**: Calculate the total revenue generated from products supplied by each supplier. This is challenging because you need to link suppliers to products, then products to ordered items. List the supplier name and their total generated revenue, ordered from highest to lowest.

---

## Answers

**1. All Products and Their Categories**
```sql
SELECT
    p.product_name,
    c.category_name
FROM Products AS p
LEFT JOIN Categories AS c ON p.category_id = c.category_id;
```

**2. Customers and Their Total Spending**
```sql
SELECT
    c.first_name,
    c.last_name,
    IFNULL(SUM(oi.quantity * oi.price_per_unit), 0) AS total_spent
FROM Customers AS c
LEFT JOIN Orders AS o ON c.customer_id = o.customer_id
LEFT JOIN OrderItems AS oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;
```

**3. Suppliers for a Specific Product**
```sql
SELECT s.supplier_name
FROM Suppliers AS s
INNER JOIN ProductSuppliers AS ps ON s.supplier_id = ps.supplier_id
INNER JOIN Products AS p ON ps.product_id = p.product_id
WHERE p.product_name = 'Smart Coffee Maker';
```

**4. Products Never Ordered**
```sql
SELECT
    p.product_name,
    p.price
FROM Products AS p
LEFT JOIN OrderItems AS oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;
```

**5. Right Join for Unused Suppliers**
```sql
SELECT
    p.product_name,
    s.supplier_name
FROM Products AS p
JOIN ProductSuppliers AS ps ON p.product_id = ps.product_id
RIGHT JOIN Suppliers AS s ON ps.supplier_id = s.supplier_id
ORDER BY s.supplier_name;
```

**6. Total Revenue by Category**
```sql
SELECT
    c.category_name,
    SUM(oi.quantity * oi.price_per_unit) AS total_revenue
FROM Categories AS c
JOIN Products AS p ON c.category_id = p.category_id
JOIN OrderItems AS oi ON p.product_id = oi.product_id
GROUP BY c.category_name
ORDER BY total_revenue DESC;
```

**7. Customers Who Bought Electronics**
```sql
SELECT DISTINCT
    c.first_name,
    c.last_name
FROM Customers AS c
JOIN Orders AS o ON c.customer_id = o.customer_id
JOIN OrderItems AS oi ON o.order_id = oi.order_id
JOIN Products AS p ON oi.product_id = p.product_id
JOIN Categories AS cat ON p.category_id = cat.category_id
WHERE cat.category_name = 'Electronics';
```

**8. Orders Containing Multiple Items**
```sql
SELECT
    order_id,
    COUNT(product_id) AS item_count
FROM OrderItems
GROUP BY order_id
HAVING COUNT(product_id) > 1;
```

**9. Suppliers and Their Product Count**
```sql
SELECT
    s.supplier_name,
    COUNT(ps.product_id) AS product_count
FROM Suppliers AS s
LEFT JOIN ProductSuppliers AS ps ON s.supplier_id = ps.supplier_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY product_count DESC;
```

**10. Most Popular Product**
```sql
SELECT
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM Products AS p
JOIN OrderItems AS oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 1;
```

**11. Subquery to Find Customers with No Orders**
```sql
SELECT first_name, last_name
FROM Customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM Orders);
```

**12. Three-Table Join for Order Details**
```sql
SELECT
    c.first_name,
    c.last_name,
    p.product_name,
    oi.quantity,
    oi.price_per_unit
FROM OrderItems AS oi
JOIN Orders AS o ON oi.order_id = o.order_id
JOIN Customers AS c ON o.customer_id = c.customer_id
JOIN Products AS p ON oi.product_id = p.product_id
WHERE oi.order_id = 1;
```

**13. Products Supplied by "TechGlobal"**
```sql
SELECT p.product_name
FROM Products AS p
JOIN ProductSuppliers AS ps ON p.product_id = ps.product_id
JOIN Suppliers AS s ON ps.supplier_id = s.supplier_id
WHERE s.supplier_name = 'TechGlobal';
```

**14. Advanced Subquery: Customers who bought "Quantum Physics Explained"**
```sql
SELECT c.first_name, c.last_name
FROM Customers AS c
WHERE c.customer_id IN (
    SELECT o.customer_id
    FROM Orders AS o
    JOIN OrderItems AS oi ON o.order_id = oi.order_id
    WHERE oi.product_id = (
        SELECT product_id FROM Products WHERE product_name = 'Quantum Physics Explained'
    )
);
```

**15. Complex Report: Revenue per Supplier**
```sql
SELECT
    s.supplier_name,
    IFNULL(SUM(oi.quantity * oi.price_per_unit), 0) AS total_revenue
FROM Suppliers AS s
LEFT JOIN ProductSuppliers AS ps ON s.supplier_id = ps.supplier_id
LEFT JOIN OrderItems AS oi ON ps.product_id = oi.product_id
GROUP BY s.supplier_name
ORDER BY total_revenue DESC;
```
