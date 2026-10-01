DROP DATABASE IF EXISTS cafe_aura;
CREATE DATABASE cafe_aura CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cafe_aura;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role ENUM('ADMIN','STAFF','CUSTOMER') NOT NULL,
    active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customer_profiles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    address VARCHAR(200),
    phone VARCHAR(30),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE staff_profiles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    shift VARCHAR(50),
    position VARCHAR(80),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE menus (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(60) NOT NULL,
    price DECIMAL(12,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    is_available TINYINT(1) NOT NULL DEFAULT 1,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NULL,
    staff_id INT NULL,
    customer_name VARCHAR(100) NOT NULL,
    table_number VARCHAR(20) NOT NULL,
    status ENUM('PENDING','PREPARING','READY','SERVED','PAID','CANCELLED') NOT NULL DEFAULT 'PENDING',
    subtotal DECIMAL(12,2) NOT NULL DEFAULT 0,
    tax DECIMAL(12,2) NOT NULL DEFAULT 0,
    total_price DECIMAL(12,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (staff_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_id INT NOT NULL,
    quantity INT NOT NULL,
    price_each DECIMAL(12,2) NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (menu_id) REFERENCES menus(id) ON DELETE RESTRICT
);

CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    staff_id INT NULL,
    amount DECIMAL(12,2) NOT NULL,
    method ENUM('CASH','QRIS','DEBIT','CREDIT') NOT NULL,
    status ENUM('PENDING','PAID','FAILED','REFUNDED') NOT NULL DEFAULT 'PENDING',
    paid_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES users(id) ON DELETE SET NULL
);

INSERT INTO users (name, email, password, role, active) VALUES
('Admin 2F', 'admin@2f.com', 'admin123', 'ADMIN', 1),
('Staff Dapur 2F', 'staff@2f.com', 'staff123', 'STAFF', 1),
('Sam', 'customer@2f.com', 'customer123', 'CUSTOMER', 1),
('Michael Chen', 'michael@2f.com', '12345', 'CUSTOMER', 1),
('Amanda Lee', 'amanda@2f.com', '12345', 'CUSTOMER', 1);

INSERT INTO customer_profiles (user_id, address, phone) VALUES
(3, 'Bandung', '081234567890'),
(4, 'Jakarta', '081298765432'),
(5, 'Bekasi', '081211223344');

INSERT INTO staff_profiles (user_id, shift, position) VALUES
(2, 'Pagi', 'Kitchen Staff');

INSERT INTO menus (name, category, price, stock, is_available, image_url) VALUES
('Iced Oat Latte', 'Coffee', 55000, 60, 1, ''),
('Flat White', 'Coffee', 47500, 55, 1, ''),
('Iced Matcha', 'Tea', 62500, 40, 1, ''),
('Almond Croissant', 'Food', 47500, 35, 1, ''),
('Lavender Oat Latte', 'Coffee', 65000, 30, 1, ''),
('Blueberry Muffin', 'Food', 35000, 45, 1, ''),
('Matcha Tea Latte', 'Tea', 52000, 35, 1, ''),
('2F Roast Beans', 'Coffee', 90000, 20, 1, '');

INSERT INTO orders (customer_id, staff_id, customer_name, table_number, status, subtotal, tax, total_price) VALUES
(3, 2, 'Sam', '12', 'PENDING', 145000, 15950, 160950),
(4, 2, 'Michael Chen', '08', 'PREPARING', 82500, 9075, 91575),
(5, 2, 'Amanda Lee', '21', 'SERVED', 95000, 10450, 105450);

INSERT INTO order_items (order_id, menu_id, quantity, price_each, subtotal) VALUES
(1, 1, 2, 55000, 110000),
(1, 6, 1, 35000, 35000),
(2, 2, 1, 47500, 47500),
(2, 6, 1, 35000, 35000),
(3, 4, 2, 47500, 95000);

INSERT INTO payments (order_id, staff_id, amount, method, status, paid_at) VALUES
(3, 2, 105450, 'QRIS', 'PAID', CURRENT_TIMESTAMP);
