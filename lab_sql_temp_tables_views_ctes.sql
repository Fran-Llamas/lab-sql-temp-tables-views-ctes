USE sakila;

SELECT * FROM rental;

SELECT * FROM customer;

CREATE VIEW rental_info AS
SELECT c.customer_id, c.first_name, c.last_name, c.email, COUNT(r.customer_id) AS rental_count
FROM customer AS c
LEFT JOIN rental AS r
ON c.customer_id = r.customer_id
GROUP BY customer_id;


# total amount paid by each customer (total_paid), rental summary view join with the payment table and calculate the total amount paid by each customer

CREATE TEMPORARY TABLE total_paid
SELECT ri.*, SUM(p.amount) AS total_paid
FROM rental_info AS ri
LEFT JOIN payment AS p
ON ri.customer_id = p.customer_id
GROUP BY ri.customer_id;

SELECT * FROM total_paid;

CREATE TEMPORARY TABLE total_paid_2
SELECT ri.customer_id, SUM(p.amount) AS total_paid
FROM rental_info AS ri
LEFT JOIN payment AS p
ON ri.customer_id = p.customer_id
GROUP BY ri.customer_id;

SELECT * FROM total_paid_2;

# Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid. 
# Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.


SELECT total_paid.*, total_paid.total_paid / total_paid.rental_count AS avg_payment_per_rental
FROM total_paid