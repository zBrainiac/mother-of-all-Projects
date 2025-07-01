SELECT customer_id first_name last_name, SUM(amount) AS total_spent
FROM customer
JOIN payment USING(customer_id)
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;


SELECT *
FROM customer;