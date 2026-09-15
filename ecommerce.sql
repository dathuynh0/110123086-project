
create database ecommerce
	
use ecommerce

create table categories (
	id VARCHAR(10) primary key not null,
	name VARCHAR(100) not null,
	description TEXT,
	slug VARCHAR(255) not null,
	created_at TIMESTAMP default CURRENT_TIMESTAMP()
)

create table sub_categories (
	id VARCHAR(10) primary key not null,
	parent_id VARCHAR(10) not null,
	name VARCHAR(150) not null,
	slug VARCHAR(255) not null,
	description TEXT,
	created_at TIMESTAMP default CURRENT_TIMESTAMP()
)

create table products (
	id VARCHAR(10) primary key not null,
	sub_category_id VARCHAR(10) not null,
	name VARCHAR(150) not null,
	-- SKU là mã định danh duy nhất của sản phẩm
	sku VARCHAR(100) not null,
	avatar_url TEXT not null,
	description TEXT not null,
	price DECIMAL(15, 2) default 0.00,
	stock_quantity INT default 0,
	created_at TIMESTAMP default CURRENT_TIMESTAMP(), -- lay ngay hien tai 
	constraint fk_product foreign key (sub_category_id) references sub_categories(id),
	
	constraint unique_sku unique (sku),
	
	index index_product_categories_id (sub_category_id)
)

create table customers (
	id VARCHAR(10) primary key not null,
	user_name VARCHAR(255) not null,
	password TEXT not null,
	full_name VARCHAR(100) not null,
	email VARCHAR(255) not null,
	phone VARCHAR(10) not null,
	address VARCHAR(255) not null,
	avatar_url TEXT not null,
	created_at TIMESTAMP default CURRENT_TIMESTAMP(),
	
	-- rang buoc email la duy nhat
	constraint unique_email unique (email) 
)

create table comments (
	id VARCHAR(10) primary key not null,
	customer_id VARCHAR(10) not null ,
	product_id VARCHAR(10) not null,
	content TEXT not null,
	like_number INT default 0,
	dislike_number INT default 0,
	created_at TIMESTAMP default CURRENT_TIMESTAMP(),
	updated_at TIMESTAMP default CURRENT_TIMESTAMP(),
	
	constraint fk_comment_customer_id foreign key (customer_id) references customers(id),
	constraint fk_comment_product_id foreign key (product_id) references products(id),
	
	constraint check_like check (like_number >= 0),
	constraint check_dislike check (dislike_number >= 0)
)


create table orders (
	id VARCHAR(10) primary key,
	customer_id VARCHAR(10) not null,
	total_amount DECIMAL(15, 2) default 0.00,
	order_date TIMESTAMP default CURRENT_TIMESTAMP(),
	status ENUM(
		'Chờ xử lý',
		'Đang giao',
		'Đã giao',
		'Đã hủy'
	) default 'Chờ xử lý',
	constraint fk_orders foreign key (customer_id) references customers(id),
	-- rang buoc gia khong duoc so am
	constraint check_total_amount check (total_amount >= 0)
)

-- bang chi tiet don hang
create table order_items (
	id VARCHAR(10) primary key not null,
	product_id VARCHAR(10) not null,
	order_id VARCHAR(10) not null,
	quantity INT not null,
	unit_price DECIMAL(15, 2) not null, -- gia hien tai
	
	-- rang buoc fk
	constraint fk_order_item_product_id foreign key (product_id) references products(id),
	constraint fk_order_item_order_id foreign key (order_id) references orders(id),
	
	constraint check_quantity check (quantity > 0),
	constraint check_unit_price check (unit_price >= 0),
	
	index index_product_id (product_id),
	index index_order_id (order_id)
)
















