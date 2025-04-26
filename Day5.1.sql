-- Tạo cơ sở dữ liệu
CREATE DATABASE OnlineRetailDB;
USE OnlineRetailDB;

-- Bảng khách hàng
CREATE TABLE Customer (
    customerId INT AUTO_INCREMENT PRIMARY KEY,
    customerName VARCHAR(100),
    email VARCHAR(100),
    joinDate DATE
);

-- Bảng sản phẩm
CREATE TABLE Product (
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2),
    stock INT
);

-- Bảng đơn hàng
CREATE TABLE OrderInfo (
    orderId INT AUTO_INCREMENT PRIMARY KEY,
    customerId INT,
    orderDate DATE,
    status VARCHAR(20),
    FOREIGN KEY (customerId) REFERENCES Customer(customerId)
);

-- Bảng chi tiết đơn hàng
CREATE TABLE OrderDetail (
    orderId INT,
    productId INT,
    quantity INT,
    unitPrice DECIMAL(10, 2),
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES OrderInfo(orderId),
    FOREIGN KEY (productId) REFERENCES Product(productId)
);

-- Khách hàng
INSERT INTO Customer (customerName, email, joinDate) VALUES
('Alice Smith', 'alice@example.com', '2022-01-10'),
('Bob Johnson', 'bob@example.com', '2022-03-05'),
('Carol Lee', 'carol@example.com', '2023-06-15');

-- Sản phẩm
INSERT INTO Product (productName, category, price, stock) VALUES
('Laptop A', 'Electronics', 1200.00, 10),
('Smartphone X', 'Electronics', 800.00, 20),
('Office Chair', 'Furniture', 150.00, 15),
('Wireless Mouse', 'Electronics', 25.00, 50),
('Notebook', 'Stationery', 5.00, 200);

-- Đơn hàng
INSERT INTO OrderInfo (customerId, orderDate, status) VALUES
(1, '2023-01-01', 'Completed'),
(2, '2023-01-10', 'Pending'),
(1, '2023-02-01', 'Completed'),
(3, '2023-03-15', 'Cancelled');

-- Chi tiết đơn hàng
INSERT INTO OrderDetail (orderId, productId, quantity, unitPrice) VALUES
(1, 1, 1, 1200.00),
(1, 4, 2, 25.00),
(2, 2, 1, 800.00),
(3, 3, 1, 150.00),
(3, 5, 10, 5.00),
(4, 4, 1, 25.00);


-- 1 Liệt kê tất cả sản phẩm hiện có trong kho.
SELECT * FROM Product;

-- 2 Hiển thị tên và email của tất cả khách hàng.
SELECT customerName, email FROM Customer;

-- 3 Lấy các đơn hàng được đặt trong tháng 1 năm 2023.
SELECT * 
FROM OrderInfo
WHERE MONTH(orderDate) = 1 AND YEAR(orderDate) = 2023;

-- 4 Tìm các sản phẩm có giá trên 500.
SELECT * 
FROM Product
WHERE price > 500;

-- 5 Liệt kê đơn hàng có trạng thái là "Completed".
SELECT * 
FROM OrderInfo
WHERE status = 'Completed';

-- 6 Tìm các khách hàng đăng ký sau ngày 01/06/2022.
SELECT * 
FROM Customer
WHERE joinDate > '2022-06-01';

-- 7 Lấy số lượng sản phẩm trong từng danh mục (category).
SELECT category, COUNT(*) AS number_of_products
FROM Product
GROUP BY category;

-- 8 Tính tổng số sản phẩm có trong kho (stock).
SELECT SUM(stock) AS total_stock
FROM Product;

-- 9 Hiển thị tên sản phẩm và giá.
SELECT productName, price 
FROM Product;

-- 10 Tìm sản phẩm thuộc danh mục "Electronics".
SELECT * 
FROM Product
WHERE category = 'Electronics';

-- 11 Lấy tên khách hàng và tổng số đơn hàng họ đã đặt.
SELECT c.customerName, COUNT(o.orderId) AS total_orders
FROM Customer c
LEFT JOIN OrderInfo o ON c.customerId = o.customerId
GROUP BY c.customerId, c.customerName;

-- 12 Tính tổng tiền của từng đơn hàng (quantity × unitPrice).
SELECT orderId, SUM(quantity * unitPrice) AS total_amount
FROM OrderDetail
GROUP BY orderId;

-- 13 Liệt kê các đơn hàng mà tổng tiền lớn hơn 1000.
SELECT orderId, SUM(quantity * unitPrice) AS total_amount
FROM OrderDetail
GROUP BY orderId
HAVING total_amount > 1000;

-- 14 Tìm những khách hàng chưa từng đặt đơn hàng nào.
SELECT c.*
FROM Customer c
LEFT JOIN OrderInfo o ON c.customerId = o.customerId
WHERE o.orderId IS NULL;


-- 15 Lấy danh sách khách hàng đã hủy đơn hàng (status = 'Cancelled').
SELECT DISTINCT c.*
FROM Customer c
JOIN OrderInfo o ON c.customerId = o.customerId
WHERE o.status = 'Cancelled';

-- 16 Lấy sản phẩm bán chạy nhất (dựa trên tổng quantity trong OrderDetail).
SELECT p.productName, SUM(od.quantity) AS total_quantity
FROM OrderDetail od
JOIN Product p ON od.productId = p.productId
GROUP BY p.productId
ORDER BY total_quantity DESC
LIMIT 1;

-- 17 Hiển thị tất cả sản phẩm chưa từng được bán.
SELECT *
FROM Product p
LEFT JOIN OrderDetail od ON p.productId = od.productId
WHERE od.orderId IS NULL;

-- 18 Lấy các đơn hàng có chứa sản phẩm tên là “Wireless Mouse”.
SELECT o.*
FROM OrderInfo o
JOIN OrderDetail od ON o.orderId = od.orderId
JOIN Product p ON od.productId = p.productId
WHERE p.productName = 'Wireless Mouse';

-- 19 Tính doanh thu theo từng loại danh mục sản phẩm.
SELECT p.category, SUM(od.quantity * od.unitPrice) AS revenue
FROM OrderDetail od
JOIN Product p ON od.productId = p.productId
GROUP BY p.category;

-- 20 Hiển thị chi tiết từng đơn hàng gồm: tên khách hàng, ngày đặt, sản phẩm và số lượng.
SELECT c.customerName, o.orderDate, p.productName, od.quantity
FROM OrderInfo o
JOIN Customer c ON o.customerId = c.customerId
JOIN OrderDetail od ON o.orderId = od.orderId
JOIN Product p ON od.productId = p.productId
ORDER BY o.orderId;

-- 21 Tính doanh thu theo từng khách hàng
SELECT c.customerName, c.customerID, SUM(od.quantity * od.unitPrice) AS totalRevenue
FROM customer c 
JOIN orderinfo o ON c.customerId = o.customerId
JOIN orderdetail od ON o.orderId = od.orderId
WHERE o.status = 'Completed'
GROUP BY c.customerId;

-- 22 Tìm đơn hàng có số lượng sản phẩm nhiều nhất
SELECT orderId, SUM(quantity) AS totalQuantity
FROM orderdetail 
GROUP BY orderId
ORDER BY totalQuantity DESC
LIMIT 1;

-- 23 Liệt kê khách hàng đã mua hàng mỗi tháng trong năm 2023
SELECT c.customerName,MONTH(o.orderDate) AS orderMonth
FROM Customer c
JOIN OrderInfo o ON c.customerId = o.customerId
WHERE YEAR(o.orderDate) = 2023
GROUP BY c.customerId, MONTH(o.orderDate)
ORDER BY orderMonth;

-- 24 Lấy danh sách sản phầm được bán trong ít nhất 2 đơn hàng khác nhau
SELECT p.productName,COUNT(DISTINCT od.orderId) AS num_orders
FROM Product p
JOIN OrderDetail od ON p.productId = od.productId
GROUP BY p.productId
HAVING num_orders >= 2;

-- 25 Tìm đơn hàng giá trị thấp nhất và cao nhất
SELECT od.orderId,SUM(od.quantity * od.unitPrice) AS total_value
FROM orderdetail od
GROUP BY od.orderId
ORDER BY total_value ASC -- ORDER BY total_value DESC
LIMIT 1;

-- 26 Tìm khách chi tiêu nhiều nhất từ trước đến nay
SELECT c.customerName, c.customerID, SUM(od.quantity * od.unitPrice) AS total_spent
FROM customer c 
JOIN orderinfo o ON c.customerId = o.customerId
JOIN orderdetail od ON o.orderId = od.orderId
GROUP BY c.customerId
ORDER BY total_spent DESC
LIMIT 1;

-- 27 Hiển thị danh sách các đơn hàng có ít nhất 2 loại sản phẩm
SELECT o.orderId,COUNT(DISTINCT od.productId) AS num_products
FROM orderinfo o
JOIN orderdetail od ON o.orderId = od.orderId
GROUP BY o.orderId
HAVING num_products >= 2;

-- 28 Tính doanh thu trung bình mỗi tháng trong năm 2023
SELECT 
    MONTH(o.orderDate) AS month,
    AVG(monthly_revenue.total_monthly_revenue) AS avg_monthly_revenue
FROM 
    OrderInfo o
JOIN (
    SELECT 
        od.orderId,
        SUM(od.quantity * od.unitPrice) AS total_monthly_revenue
    FROM 
        OrderDetail od
    JOIN 
        OrderInfo o ON od.orderId = o.orderId
    WHERE 
        o.orderDate BETWEEN '2023-01-01' AND '2023-12-31'
    GROUP BY 
        od.orderId
) AS monthly_revenue ON o.orderId = monthly_revenue.orderId
WHERE 
    o.orderDate BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY 
    month
ORDER BY 
    month;
-- 29 Tạo báo cáo : tên khách hàng , tổng số đơn, tổng tiền đã chi, số lượng sản phẩm đã mua
SELECT c.customerName,COUNT(o.orderId) AS total_orders,SUM(od.quantity * od.unitPrice) AS total_spent,SUM(od.quantity) AS total_quantity
FROM customer c
JOIN orderinfo o ON c.customerId = o.customerId
JOIN orderdetail od ON o.orderId = od.orderId
GROUP BY c.customerId, c.customerName;

-- 30 Tìm khách hàng mua tất cả sản phẩm thuộc danh mục "Electronics"
SELECT c.customerName
FROM customer c
JOIN orderinfo o ON c.customerId = o.customerId
JOIN orderdetail od ON o.orderId = od.orderId
JOIN product p ON od.productId = p.productId
WHERE p.category = 'Electronics'
GROUP BY c.customerName;



