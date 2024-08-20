-- Create Products Table
CREATE TABLE Products (
    Id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price INT NOT NULL
);

-- Create Cart Table
CREATE TABLE Cart (
    ProductId INT PRIMARY KEY,
    Qty INT NOT NULL,
    FOREIGN KEY (ProductId) REFERENCES Products(Id)
);

-- Create Users Table
CREATE TABLE Users (
    User_ID SERIAL PRIMARY KEY,
    Username VARCHAR(255) NOT NULL
);

-- Create OrderHeader Table
CREATE TABLE OrderHeader (
    OrderID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    Orderdate TIMESTAMP NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(User_ID)
);

-- Create OrderDetails Table
CREATE TABLE OrderDetails (
    OrderHeader INT NOT NULL,
    ProdID INT NOT NULL,
    Qty INT NOT NULL,
    FOREIGN KEY (OrderHeader) REFERENCES OrderHeader(OrderID),
    FOREIGN KEY (ProdID) REFERENCES Products(Id)
);

-- Insert Products into Products Table
INSERT INTO Products (name, price) VALUES
('Coke', 10),
('Chips', 5);

-- Insert Users into Users Table
INSERT INTO Users (Username) VALUES
('Arnold'),
('Sheryl');

-- Insert Coke into the Cart
DO $$
BEGIN
    IF EXISTS (SELECT * FROM Cart WHERE ProductId = 1) THEN
        UPDATE Cart SET Qty = Qty + 1 WHERE ProductId = 1;
    ELSE
        INSERT INTO Cart (ProductId, Qty) VALUES (1, 1);
    END IF;
END $$;

-- Insert Chips into the Cart
DO $$
BEGIN
    IF EXISTS (SELECT * FROM Cart WHERE ProductId = 2) THEN
        UPDATE Cart SET Qty = Qty + 1 WHERE ProductId = 2;
    ELSE
        INSERT INTO Cart (ProductId, Qty) VALUES (2, 1);
    END IF;
END $$;

-- Verify the Cart Contents
SELECT * FROM Cart;

-- Remove Coke from the Cart
DO $$
BEGIN
    IF EXISTS (SELECT * FROM Cart WHERE ProductId = 1 AND Qty > 1) THEN
        UPDATE Cart SET Qty = Qty - 1 WHERE ProductId = 1;
    ELSE
        DELETE FROM Cart WHERE ProductId = 1;
    END IF;
END $$;

-- Verify the Cart Contents
SELECT * FROM Cart;

-- A: Insert into OrderHeader Table
INSERT INTO OrderHeader (UserID, Orderdate) VALUES (1, NOW());

-- B: Insert into OrderDetails Table and Clear the Cart
DO $$
DECLARE
    latest_order_id INT;
BEGIN
    -- Get the last OrderID
    SELECT MAX(OrderID) INTO latest_order_id FROM OrderHeader;

    -- Insert Cart contents into OrderDetails
    INSERT INTO OrderDetails (OrderHeader, ProdID, Qty)
    SELECT latest_order_id, ProductId, Qty FROM Cart;

    -- Clear the Cart
    DELETE FROM Cart;
END $$;

-- Verify the OrderDetails
SELECT * FROM OrderDetails;

-- Print a Single Order
SELECT oh.OrderID, u.Username, oh.Orderdate, p.name, od.Qty 
FROM OrderHeader oh
JOIN Users u ON oh.UserID = u.User_ID
JOIN OrderDetails od ON oh.OrderID = od.OrderHeader
JOIN Products p ON od.ProdID = p.Id
WHERE oh.OrderID = 1;

-- Print All Orders for a Day's Shopping
SELECT oh.OrderID, u.Username, oh.Orderdate, p.name, od.Qty 
FROM OrderHeader oh
JOIN Users u ON oh.UserID = u.User_ID
JOIN OrderDetails od ON oh.OrderID = od.OrderHeader
JOIN Products p ON od.ProdID = p.Id
WHERE oh.Orderdate::date = '2024-04-15'; -- Replace with the desired date

-- Function to Add an Item to the Cart
CREATE OR REPLACE FUNCTION add_to_cart(p_product_id INT) RETURNS VOID AS $$
BEGIN
    IF EXISTS (SELECT * FROM Cart WHERE ProductId = p_product_id) THEN
        UPDATE Cart SET Qty = Qty + 1 WHERE ProductId = p_product_id;
    ELSE
        INSERT INTO Cart (ProductId, Qty) VALUES (p_product_id, 1);
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Function to Remove an Item from the Cart
CREATE OR REPLACE FUNCTION remove_from_cart(p_product_id INT) RETURNS VOID AS $$
BEGIN
    IF EXISTS (SELECT * FROM Cart WHERE ProductId = p_product_id AND Qty > 1) THEN
        UPDATE Cart SET Qty = Qty - 1 WHERE ProductId = p_product_id;
    ELSE
        DELETE FROM Cart WHERE ProductId = p_product_id;
    END IF;
END;
$$ LANGUAGE plpgsql;
