SELECT * FROM bike_db;

-- The "order_date", "required_date" and "shipped_date" in "orders" table are set to TEXT - updated them to DATE type with the below:

ALTER TABLE orders
MODIFY COLUMN order_date DATE,
MODIFY COLUMN required_date DATE,
MODIFY COLUMN shipped_date DATE;

-- The "quantity" column in "order_items" table is previously set to "quantity` binary(1) DEFAULT NULL"
-- Set it to INT data type:

ALTER TABLE order_items
MODIFY COLUMN quantity INT;

-- Under order_items, the quantity shows as BLOB
-- DDL shows: `quantity` binary(1) DEFAULT NULL,
-- this needs to be altered to INT type (see above query)

-- The "order_item" table doesn't include a column for the subtotal which is the list_price multiplied by the quantity (before discount) and the final_total (after a discount, if there is).
-- I added a "subtotal" column right next to the list_price (and before the discount column)

ALTER TABLE order_items
ADD COLUMN subtotal DECIMAL (10,2) AFTER list_price;

-- Populated the subtotal values (list_price x quantity):

UPDATE order_items
SET subtotal = list_price * quantity;

-- I did the same thing to create the "total" column. It is the subtotal less the discount.

ALTER TABLE order_items
ADD COLUMN total DECIMAL (10,2) AFTER discount;

UPDATE order_items
SET total = subtotal - (subtotal * discount);

-- The existing columns "list_price" and "discount" were previously set to DOUBLE. I updated them to DECIMAL.

ALTER TABLE order_items
MODIFY COLUMN list_price DECIMAL (10, 2);

ALTER TABLE order_items
MODIFY COLUMN discount DECIMAL (10, 2);
