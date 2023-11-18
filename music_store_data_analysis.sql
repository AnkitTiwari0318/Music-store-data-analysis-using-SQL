Q1: Who is the senior most employee based on job title?
select * from employee order by levels desc limit 1

Q2: which countries have the most invoice?
select count(*) as c, billing_country from invoice group by billing_country order by c desc

Q2: What are top 3 values of total invoice?
select total from invoice order by total desc limit 3

Q3: Write a query which returns the city name with highest total invoice along with the total.
select sum(total) as t, billing_city from invoice group by billing_city order by t desc limit 1

Q3: Write a query which returns details of cutomer who has spent most amount of money.
select customer.customer_id, customer.first_name, customer.last_name, sum(total) as total
from customer join invoice on customer.customer_id = invoice.customer_id 
group by customer.customer_id order by total desc limit 1

Q4: Write a query to return the email, first name, last name and genre of all Rock music listeners. 
	Return your list alphabetically ordered.
select distinct first_name, last_name, email from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
where track_id in(select track_id from track join genre on track.genre_id = genre.genre_id
where genre.name like 'Rock') order by email

Q5: Write a query the artists name and total track count of the top 10 rock bands.
select artist.artist_id, artist.name, count(artist.name) as number_of_songs from artist
join album on artist.artist_id = album.artist_id  
join track on track.album_id = album.album_id 
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock' GROUP BY artist.artist_id, artist.name
ORDER BY number_of_songs DESC
LIMIT 10;

Q6: Return all the track names that have a song length longer than the average song length. 
	Retrun the name and millisecond for each track and it by song length
select name, milliseconds from track where milliseconds>(select avg(milliseconds) from track) 
order by milliseconds desc limit 10
 
Q7: Find out how much amount is spent by each customer on artists. 
	Write a query to return customer name, artist name and total spent.
With Best_selling_artist as( 
	Select artist.artist_id as artist_id, artist.name as artist_name,
	sum(invoice_line.unit_price * invoice_line.quantity) as total_sales
	from invoice_line
	join track on track.track_id = invoice_line.track_id
	join album on album.album_id = track.album_id 
	join artist on artist.artist_id = album.artist_id
	group by 1 order by 3 desc)
select c.customer_id, c.first_name, c.last_name, bsa.artist_name,
sum(il.unit_price*il.quantity) as amount_spent from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join Best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1, 2, 3, 4 order by 5 desc

Q8. Write a query that return the country along with the top selling genre base on amount of purchases.
	For countries where the maximum number of purchases is shared, return all genres.
with popular_genre as(
	select count(invoice_line.quantity) as purchases, customer.country, genre.name, genre.genre_id,
	row_number() over(partition by customer.country order by count(invoice_line.quantity) desc) as RowNo
	from invoice_line
	join invoice on invoice.invoice_id = invoice_line.invoice_id
	join customer on customer.customer_id = invoice.customer_id
	join track on track.track_id = track.track_id
	join genre on genre.genre_id = track.genre_id
	group by 2, 3, 4 order by 2 asc, 1 desc)
select * from popular_genre where RowNo <= 1	

Q9. Write a query that return country along with the top customer and how much they spent.
	For countries where the top amount spent is shared, provide all customer who spent this amount.
with Customer_with_country as(
	select customer.customer_id,first_name,last_name,billing_country,sum(total) as total_spending,
	Row_number() over(partition by billing_country order by sum(total) desc) as RowNo from invoice
	join customer on customer.customer_id = invoice.customer_id
	group by 1, 2, 3, 4 order by 4 asc,5 desc)
select * from customer_with_country where RowNo <=1
		

















