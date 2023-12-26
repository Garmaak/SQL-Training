CREATE TABLE restaurant.tblMenuItems (
	ID INT IDENTITY(101, 1) PRIMARY KEY,
	itemName VARCHAR(50) NOT NULL,
	category VARCHAR(50) NULL,
	price DECIMAL(5,2) NULL,
	menuItemDescription NVARCHAR(255) NULL
);

INSERT INTO restaurant.tblMenuItems VALUES ('Hamburger', 'American', 12.95, 'American style hamburger'),
('Cheeseburger', 'American', 13.95, 'American style cheeseburger'),
('Hot Dog', 'American', 9.00, 'American style hot dog'),
('Veggie Burger', 'American', 10.50, 'American style veggie burger'),
('Mac & Cheese', 'American', 7.00, 'American style mac & cheese'),
('French Fries', 'American', 7.00, 'American style french fries'),
('Orange Chicken', 'Asian', 16.50, 'Asian style orange chicken'),
('Tofu Pad Thai', 'Asian', 14.50, 'Asian style tofu pad thai'),
('Korean Beef Bowl', 'Asian', 17.95, 'Asian style korean beef bowl'),
('Pork Ramen', 'Asian', 17.95, 'Asian style pork ramen'),
('California Roll', 'Asian', 11.95, 'Asian style california roll'),
('Salmon Roll', 'Asian', 14.95, 'Asian style salmon roll'),
('Edamame', 'Asian', 5.00, 'Asian style edamame'),
('Potstickers', 'Asian', 9.00, 'Asian style potstickers'),
('Chicken Tacos', 'Mexican', 11.95, 'Mexican style chicken tacos'),
('Steak Tacos', 'Mexican', 13.95, 'Mexican style steak tacos'),
('Chicken Burrito', 'Mexican', 12.95, 'Mexican style chicken burrito'),
('Steak Burrito', 'Mexican', 14.95, 'Mexican style steak burrito'),
('Chicken Torta', 'Mexican', 11.95, 'Mexican style chicken torta'),
('Steak Torta', 'Mexican', 13.95, 'Mexican style steak torta'),
('Cheese Quesadillas', 'Mexican', 10.50, 'Mexican style cheese quesadillas'),
('Chips & Salsa', 'Mexican', 7.00, 'Mexican style chips & salsa'),
('Chips & Guacamole', 'Mexican', 9.00, 'Mexican style chips & guacamole'),
('Spaghetti', 'Italian', 14.50, 'Italian style spaghetti'),
('Spaghetti & Meatballs', 'Italian', 17.95, 'Italian style spaghetti & meatballs'),
('Fettuccine Alfredo', 'Italian', 14.50, 'Italian style fettuccine alfredo'),
('Meat Lasagna', 'Italian', 17.95, 'Italian style meat lasagna'),
('Cheese Lasagna', 'Italian', 15.50, 'Italian style cheese lasagna'),
('Mushroom Ravioli', 'Italian', 15.50, 'Italian style mushroom ravioli'),
('Shrimp Scampi', 'Italian', 19.95, 'Italian style shrimp scampi'),
('Chicken Parmesan', 'Italian', 17.95, 'Italian style chicken parmesan'),
('Eggplant Parmesan', 'Italian', 16.95, 'Italian style eggplant parmesan');
