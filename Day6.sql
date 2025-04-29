-- Xóa database cũ (nếu có) để tránh lỗi
DROP DATABASE IF EXISTS ecommerce_db;

-- Tạo cơ sở dữ liệu mới
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- Bảng người dùng
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Bảng quản trị viên
CREATE TABLE admins (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Bảng vai trò
CREATE TABLE roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

-- Bảng liên kết người dùng và vai trò
CREATE TABLE user_roles (
    user_id INT,
    role_id INT,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- Bảng khách hàng
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    address TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Bảng thương hiệu
CREATE TABLE brands (
    brand_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Bảng nhà cung cấp
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100)
);

-- Bảng sản phẩm
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    brand_id INT,
    supplier_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- Bảng danh mục
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Bảng liên kết sản phẩm và danh mục
CREATE TABLE product_categories (
    product_id INT,
    category_id INT,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Bảng kho
CREATE TABLE warehouses (
    warehouse_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

-- Bảng kho hàng
CREATE TABLE inventory (
    product_id INT PRIMARY KEY,
    warehouse_id INT,
    stock_quantity INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
);

-- Bảng chuyển động kho
CREATE TABLE stock_movements (
    movement_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    warehouse_id INT,
    quantity INT,
    movement_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
);

-- Bảng đơn hàng
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50),
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Bảng chi tiết đơn hàng
CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Bảng thanh toán
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date DATETIME,
    amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Bảng giao dịch
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_id INT,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2),
    FOREIGN KEY (payment_id) REFERENCES payments(payment_id)
);

-- Bảng phương thức vận chuyển
CREATE TABLE shipping_methods (
    shipping_method_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    cost DECIMAL(10,2)
);

-- Bảng vận chuyển
CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    shipped_date DATETIME,
    delivery_date DATETIME,
    shipping_method_id INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_methods(shipping_method_id)
);

-- Bảng đánh giá
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    customer_id INT,
    rating INT,
    comment TEXT,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Bảng câu hỏi
CREATE TABLE questions (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    customer_id INT,
    question_text TEXT,
    question_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Bảng trả lời
CREATE TABLE answers (
    answer_id INT PRIMARY KEY AUTO_INCREMENT,
    question_id INT,
    admin_id INT,
    answer_text TEXT,
    answer_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (question_id) REFERENCES questions(question_id),
    FOREIGN KEY (admin_id) REFERENCES admins(admin_id)
);

-- Bảng khuyến mãi
CREATE TABLE discounts (
    discount_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    description TEXT,
    discount_percent DECIMAL(5,2),
    start_date DATE,
    end_date DATE
);

-- Bảng mã giảm giá
CREATE TABLE coupons (
    coupon_id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_percent DECIMAL(5,2),
    expiration_date DATE
);

-- Bảng liên kết sản phẩm và khuyến mãi
CREATE TABLE product_discounts (
    product_id INT,
    discount_id INT,
    PRIMARY KEY (product_id, discount_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (discount_id) REFERENCES discounts(discount_id)
);

-- Bảng danh sách yêu thích
CREATE TABLE wishlists (
    wishlist_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Bảng mục trong danh sách yêu thích
CREATE TABLE wishlist_items (
    wishlist_id INT,
    product_id INT,
    PRIMARY KEY (wishlist_id, product_id),
    FOREIGN KEY (wishlist_id) REFERENCES wishlists(wishlist_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Bảng phiếu hỗ trợ
CREATE TABLE support_tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    subject VARCHAR(100),
    status VARCHAR(50),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Bảng tin nhắn trong phiếu hỗ trợ
CREATE TABLE ticket_messages (
    message_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT,
    sender_id INT,
    message TEXT,
    sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES support_tickets(ticket_id),
    FOREIGN KEY (sender_id) REFERENCES users(user_id)
);

-- Bảng nhật ký kiểm tra
CREATE TABLE audit_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action VARCHAR(100),
    log_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Bảng nhật ký hoạt động
CREATE TABLE activity_logs (
    activity_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    activity VARCHAR(100),
    activity_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- truy vấn 
-- 1 Liệt kê tất cả sản phẩm hiện có trong kho 
SELECT * FROM users;

-- 2 Tìm tên và email của khách hàng
SELECT CONCAT(customers.first_name, ' ', customers.last_name) AS full_name, users.email
FROM customers
JOIN users ON customers.user_id = users.user_id;

-- 3 Tính tổng số lượng sản phẩm đang có
SELECT COUNT(*) AS total_products FROM products;

-- 4 Đếm số lượng sản phẩm hiện có
SELECT orders.order_id, orders.total_amount
FROM orders;

-- 5 Tìm các đơn hàng đang ở trạng thái pending 
SELECT * FROM orders WHERE status = 'Pending';

-- 6 Tìm tất cả sản phẩm có giá lớn hơn 500
SELECT * FROM products WHERE price > 500;

-- 7 Đếm số khách theo tỉnh thành phố 
SELECT address AS city, COUNT(*) AS customer_count
FROM customers
GROUP BY address;

-- 8 Tìm sản phẩm thuộc danh mục "Electronics"
SELECT p.*
FROM products p
JOIN product_categories pc ON p.product_id = pc.product_id
JOIN categories c ON pc.category_id = c.category_id
WHERE c.name = 'Electronics';

-- 9 Hiển thị thông tin chi tiết các đơn hàng: mã đơn hàng, tên sản phẩm, số lượng
SELECT oi.order_id, p.name , oi.quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;

-- 10 Tìm các kho hàng hiện có
SELECT * FROM warehouses;

-- 11 Liệt kê tất cả sản phẩm có tồn kho < 20 
SELECT p.*, i.stock_quantity
FROM inventory i
JOIN products p ON i.product_id = p.product_id
WHERE i.stock_quantity < 20;

-- 12 Tìm tất cả các phương thức vận chuyển > 1000
SELECT * FROM shipping_methods WHERE cost > 1000;

-- 13 Liệt kê đơn hàng có user_id = 5
SELECT o.*
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.user_id = 5;


-- 14 Lấy 10 sản phâm có giá cao nhất 
SELECT * FROM products
ORDER BY price DESC
LIMIT 10;

-- 15 Tính tổng tiền thanh toán của đơn hàng có ID = 1
SELECT SUM(amount) AS total_paid
FROM payments
WHERE order_id = 1;

-- Medium 
-- 16  Liệt kê tên khách hàng và tổng số đơn đã đặt
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- 17 Tìm các sản phẩm chưa từng xuất hiện trong bất kì đơn hàng nào
SELECT p.name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- 18 Đếm số lượng sản phẩm theo từng danh mục
SELECT c.name AS category_name, COUNT(pc.product_id) AS product__count
FROM categories c
LEFT JOIN product_categories pc ON c.category_id = pc.category_id
GROUP BY c.category_id;

-- 19 Liệt kê sản phẩm có nhà cung cấp ID = 3
SELECT name 
FROM products
WHERE supplier_id = 3;

-- 20 Tìm các đơn hàng có tổng tiền lớn hơn 1000 và đã được giao hàng
SELECT order_id, total_amount, status
FROM orders  
WHERE total_amount > 1000 and status = 'shipped';

-- 21 Liệt kê người dùng và vai trò của họ 
SELECT u.username, r.role_name
FROM users u
JOIN user_roles ur ON u.user_id = ur.user_id
JOIN roles r ON ur.role_id = r.role_id;

-- 22 Đếm số lượng người dùng theo từng vai trò 
SELECT r.role_name, COUNT(ur.user_id) AS user_count
FROM roles r
LEFT JOIN user_roles ur ON r.role_id = ur.role_id
GROUP BY r.role_id;

-- 23 Tìm khách hàng không có bất kì đơn hàng nào
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 24 Tính tổng số tiền khách đã thanh toán
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, SUM(p.amount) AS total_paid
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.customer_id;

-- 25 Liệt kê danh sách khách hàng và tên sản phẩm họ đã mua
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, p.name AS product_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

-- 26 Tìm các sản phẩm thuộc nhiều hơn 1 danh mục
SELECT p.name, COUNT(pc.category_id) AS total_category
FROM products p
JOIN product_categories pc ON p.product_id = pc.product_id
GROUP BY p.product_id
HAVING COUNT(pc.category_id) > 1;

-- 27 Tìm các sản phẩm được lưu trữ ở nhiều kho khác nhau 
SELECT p.name, COUNT(i.warehouse_id) AS total_warehouse
FROM products p
JOIN inventory i ON p.product_id = i.product_id
GROUP BY p.product_id
HAVING COUNT(i.warehouse_id) > 1;

-- 28 Tìm tên sản phẩm và số lượng còn tồn trong mỗi kho 
SELECT p.name AS product_name, w.name AS warehouse_name, i.stock_quantity
FROM inventory i
JOIN products p ON i.product_id = p.product_id
JOIN warehouses w ON i.warehouse_id = w.warehouse_id;

-- 29 Tính tổng giá trị hàng tồn kho tại mỗi kho
SELECT w.name AS warehouse_name, SUM(i.stock_quantity * p.price) AS total_inventory_value
FROM inventory i
JOIN products p ON i.product_id = p.product_id
JOIN warehouses w ON i.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_id;

-- 30 Liệt kê các đơn hàng được giao bằng phương thức "Express"
SELECT o.*
FROM orders o
JOIN shipments s ON o.order_id = s.order_id
JOIN shipping_methods sm ON s.shipping_method_id = sm.shipping_method_id
WHERE sm.name = 'Express';

-- 31 Tìm đơn hàng có nhiều mặt hàng nhất 
SELECT o.order_id, COUNT(oi.product_id) AS item_count
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id
ORDER BY item_count DESC
LIMIT 1;

-- 32 Tính số lượng sản phẩm bán được theo từng thương hiệu
SELECT b.name AS brand_name, SUM(oi.quantity) AS total_sold
FROM brands b
JOIN products p ON b.brand_id = p.brand_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY b.brand_id;

-- 33 Tìm sản phẩm số lượng bán chạy nhất ( tổng số lượng cao nhất )
SELECT p.name AS product_name, SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY total_sold DESC
LIMIT 1;

-- 34 Liệt kê taasts cả các đơn hàng chưa thanh toán đầy đủ( giả sử cóc thể xảy ra) : 
SELECT o.order_id, o.total_amount, COALESCE(SUM(p.amount), 0) AS total_paid
FROM orders o
LEFT JOIN payments p ON o.order_id = p.order_id
GROUP BY o.order_id
HAVING total_paid < o.total_amount;

-- 35 Đếm số đơn hàng và tổng tiền theo trạng thái đơn hàng
SELECT status, COUNT(order_id) AS total_orders, SUM(total_amount) AS total_revenue
FROM orders
GROUP BY status;

-- 36 Top 5 khách hàng có tổng chi tiêu cao nhất 
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- 37 Trung bình số tiền trên mỗi đơn hàng của mỗi khách hàng
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, AVG(o.total_amount) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- 38 Sản phẩm bán được trong cả 3 phương thức vận chuyển 
SELECT p.product_id, p.name
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
JOIN shipments s ON o.order_id = s.order_id
JOIN shipping_methods sm ON s.shipping_method_id = sm.shipping_method_id
GROUP BY p.product_id, p.name
HAVING COUNT(DISTINCT sm.shipping_method_id) = 3;

-- 39 Sản phẩm chưa được nhập kho nào
SELECT p.product_id, p.name
FROM products p
LEFT JOIN inventory i ON p.product_id = i.product_id
WHERE i.product_id IS NULL;

-- 40 Nhà cung cấp có sản phẩm được bán nhiều nhất 
SELECT s.supplier_id, s.name, SUM(oi.quantity) AS total_sold
FROM suppliers s
JOIN products p ON s.supplier_id = p.supplier_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY s.supplier_id
ORDER BY total_sold DESC
LIMIT 1;

-- 41 Khách hàng đặt hàng nhiều lần trong ngày
SELECT o.customer_id, o.order_date, COUNT(*) AS order_count
FROM orders o
GROUP BY o.customer_id, o.order_date
HAVING COUNT(*) > 1;

-- 42 Đơn hàng có tổng tiền bằng tổng tiền các sản phẩm (Kiểm tra tính đúng)
SELECT o.order_id, SUM(oi.quantity * oi.unit_price) AS total_demo, o.total_amount
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.total_amount
HAVING SUM(oi.quantity * oi.unit_price) = o.total_amount;

-- 43 Tên khách hàng và số lượng phương thức thanh toán họ đã dùng
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, COUNT(DISTINCT pm.payment_method) AS payment_methods_used
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments pm ON o.order_id = pm.order_id
GROUP BY c.customer_id;

-- 44 Số lượng sản phẩm theo từng thương hiệu và danh mục
SELECT b.name AS brand, ct.name AS category, COUNT(DISTINCT p.product_id) AS product_count
FROM products p
JOIN brands b ON p.brand_id = b.brand_id
JOIN product_categories pc ON p.product_id = pc.product_id
JOIN categories ct ON pc.category_id = ct.category_id
GROUP BY b.name, ct.name;

-- 45 Kho chứa sản phẩm có tổng giá trị lớn nhất
SELECT w.warehouse_id, w.name, SUM(i.stock_quantity * p.price) AS total_value
FROM inventory i
JOIN products p ON i.product_id = p.product_id
JOIN warehouses w ON i.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_id
ORDER BY total_value DESC
LIMIT 1;

-- 46 Tổng số lượng hàng đã giao cho từng khách trong tháng gần nhất
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, SUM(oi.quantity) AS total_delivered
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered' AND MONTH(o.order_date) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
GROUP BY c.customer_id;

-- 47 Sản phẩm có doanh thu cao nhất 
SELECT p.product_id, p.name, SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name
ORDER BY total_revenue DESC
LIMIT 1;

-- 48 Đơn hàng có ít nhất 2 sản phẩm thuộc thương hiệu khác nhau 
SELECT o.order_id, COUNT(DISTINCT p.brand_id) AS total_brand
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY o.order_id
HAVING COUNT(DISTINCT p.brand_id) >= 2;

-- 49 Khách có đơn hàng dellivered và thành toán bằng PayPAl
SELECT DISTINCT c.customer_id,  CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
WHERE o.status = 'Delivered' AND p.payment_method = 'PayPal';

-- 50 Thống kê tổng tiền theo tháng và trạng thái đơn hàng 
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    status,
    SUM(total_amount) AS total
FROM orders
GROUP BY year, month, status
ORDER BY year, month, status;

