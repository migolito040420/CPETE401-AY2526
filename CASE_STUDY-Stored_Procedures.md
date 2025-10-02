****# Case Study: Stored Procedures in MySQL

## Objective
This case study is designed to test your ability to create and use stored procedures in MySQL. You will be working with a simplified database for a small business that sells various products.

## Database Schema
The database consists of three tables: `products`, `orders`, and `order_items`.

### `products` table
| Column | Type | Description |
|---|---|---|
| `product_id` | INT | Primary Key |
| `product_name` | VARCHAR(255) | Name of the product |
| `unit_price` | DECIMAL(10, 2) | Price of one unit of the product |
| `stock_quantity` | INT | Number of units in stock |

### `orders` table
| Column | Type | Description |
|---|---|---|
| `order_id` | INT | Primary Key |
| `order_date` | DATE | Date the order was placed |
| `customer_name` | VARCHAR(255) | Name of the customer |

### `order_items` table
| Column | Type | Description |
|---|---|---|
| `order_item_id` | INT | Primary Key |
| `order_id` | INT | Foreign Key to `orders` table |
| `product_id` | INT | Foreign Key to `products` table |
| `quantity` | INT | Number of units of the product ordered |

## Sample Data
Use the following SQL statements to populate your database with some sample data:

```sql
-- Products
INSERT INTO `products` (`product_id`, `product_name`, `unit_price`, `stock_quantity`) VALUES
(1, 'Laptop', 1200.00, 50),
(2, 'Mouse', 25.00, 150),
(3, 'Keyboard', 75.00, 100),
(4, 'Monitor', 300.00, 75),
(5, 'Webcam', 50.00, 200);

-- Orders
INSERT INTO `orders` (`order_id`, `order_date`, `customer_name`) VALUES
(1, '2025-09-01', 'Alice'),
(2, '2025-09-02', 'Bob'),
(3, '2025-09-03', 'Charlie');

-- Order Items
INSERT INTO `order_items` (`order_item_id`, `order_id`, `product_id`, `quantity`) VALUES
(1, 1, 1, 1),
(2, 1, 2, 2),
(3, 2, 3, 1),
(4, 2, 4, 1),
(5, 3, 5, 3);
```

## Problem Set
Create the following stored procedures in MySQL:

1.  **`get_all_products`**: A stored procedure that returns all products from the `products` table.
2.  **`get_product_by_id`**: A stored procedure that takes a `product_id` as input and returns the corresponding product from the `products` table.
3.  **`get_orders_by_customer`**: A stored procedure that takes a `customer_name` as input and returns all orders placed by that customer.
4.  **`get_order_details`**: A stored procedure that takes an `order_id` as input and returns the order details, including the products and quantities for that order.
5.  **`add_product`**: A stored procedure that takes `product_name`, `unit_price`, and `stock_quantity` as input and adds a new product to the `products` table.
6.  **`update_product_stock`**: A stored procedure that takes a `product_id` and a `new_stock_quantity` as input and updates the stock quantity for that product.
7.  **`update_product_price`**: A stored procedure that takes a `product_id` and a `new_price` as input and updates the price for that product.
8.  **`get_total_order_value`**: A stored procedure that takes an `order_id` as input and returns the total value of that order.
9.  **`get_products_with_low_stock`**: A stored procedure that takes a `stock_threshold` as input and returns all products with a stock quantity below that threshold.
10. **`delete_product`**: A stored procedure that takes a `product_id` as input and deletes the product from the `products` table.

## Submission Instructions
1.  For each problem, create the stored procedure in your MySQL client.
2.  Test each stored procedure to ensure it works correctly.
3.  Take a screenshot of your MySQL client showing the created stored procedure and a successful execution of the stored procedure.
4.  Compile all your screenshots into a single PDF document.
5.  The sequence would be the following:
    1.  Question
    2.  Screenshot of the stored procedure
    3.  Result of the successful execution of the stored procedure. If it does not provide any results like for example deleting a record, query the record to display records deleted is not included.
6.  Submit the PDF document to the "Case Study: Stored Procedures" assignment on Canvas.