-- Tạo database
CREATE DATABASE ecommerce;
USE ecommerce;

-- Tạo bảng người dùng
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tạo bảng sản phẩm
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    price DECIMAL(10, 2),
    stock INT,
    category VARCHAR(50)
);

-- Tạo bảng đơn hàng
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Tạo bảng chi tiết đơn hàng
CREATE TABLE order_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


-- Tạo dữ liệu mẫu 


-- Thêm người dùng
INSERT INTO users (name, email) VALUES 
('Nguyen Van A', 'a@gmail.com'),
('Tran Thi B', 'b@gmail.com'),
('Le Van C', 'c@gmail.com');

-- Thêm sản phẩm
INSERT INTO products (name, price, stock, category) VALUES
('Laptop Asus', 15000000, 10, 'Electronics'),
('iPhone 14', 20000000, 5, 'Electronics'),
('Áo thun trắng', 150000, 50, 'Clothing'),
('Giày Nike', 2500000, 20, 'Footwear');

-- Thêm đơn hàng
INSERT INTO orders (user_id, total_amount) VALUES 
(1, 15150000),
(2, 20150000);

-- Thêm chi tiết đơn hàng
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 15000000),
(1, 3, 1, 150000),
(2, 2, 1, 20000000),
(2, 3, 1, 150000);

-- 1.Lấy danh sách tất cả người dùng
SELECT *
FROM users;

-- 2. Lấy danh sách tất cả sản phẩm còn hàng (stock > 0 )
SELECT * 
FROM products   
WHERE stock > 0;

-- 3. Tính tổng đơn hàng của từng người dùng
SELECT u.user_id, u.name, COUNT(o.order_id) as Tong_don_hang
FROM users u 
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY (u.user_id);

-- 4.Tính tổng doanh thu của hệ thống
SELECT SUM(total_amount) as Tong_doanh_thu_he_thong
FROM orders;

-- 5. Tìm sản phẩm có giá cao nhất
SELECT name, price
FROM products
WHERE price = (
SELECT MAX(price)
FROM products
);

-- 6.Liệt kê các đơn hàng và tên người mua tương ứng
SELECT *
FROM orders o 
JOIN users u ON o.user_id = u.user_id
JOIN ;

-- 7.
SELECT p.product_id, p.name, SUM(oi.quantity) AS Tong_sp_da_ban
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id;

-- 8.
SELECT u.user_id, u.name, SUM(o.total_amount) AS Tong_tieu
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id
ORDER BY Tong_tieu DESC
LIMIT 2;

-- 9.
SELECT o.order_id, o.order_date
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.category = 'Clothing';

-- 10.
SELECT u.user_id, u.name
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
WHERE o.order_id IS NULL;
-- Expert

-- 11 
SELECT product_id, SUM(quantity) AS total_sold
FROM order_items
GROUP BY product_id
ORDER BY total_sold DESC
LIMIT 1;

-- 12 
SELECT order_id, SUM(quantity) AS total_quantity
FROM order_items
GROUP BY order_id
ORDER BY total_quantity DESC
LIMIT 1;

-- 13
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amount) AS revenue
FROM orders
GROUP BY month
ORDER BY month;

-- 14
SELECT user_id, COUNT(order_id) / COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) AS avg_orders_per_month
FROM orders
GROUP BY user_id;

-- 15
SELECT o.*
FROM orders o
JOIN (
    SELECT user_id, MAX(order_date) AS latest_order
    FROM orders
    GROUP BY user_id
) latest ON o.user_id = latest.user_id AND o.order_date = latest.latest_order;

-- 16
SELECT *
FROM (
    SELECT *, 
           RANK() OVER (PARTITION BY user_id ORDER BY total_amount DESC) AS rnk
    FROM orders
) ranked
WHERE rnk = 1;

-- 17
SELECT *
FROM products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id FROM order_items
);
-- 18
SELECT o.user_id, COUNT(DISTINCT oi.product_id) AS product_types_bought
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.user_id;
-- 19
SELECT user_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY user_id
HAVING SUM(total_amount) > 30000000;





