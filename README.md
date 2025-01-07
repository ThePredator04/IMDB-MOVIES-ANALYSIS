# Imdb Movie Analysis SQL Project

## Project Overview

**Project Title**: Imdb Movie Analysis
**Database**: `movies_db`

This project showcases my SQL expertise through a comprehensive analysis of a movie dataset. It involves conducting exploratory data analysis (EDA) and addressing specific business and analytical questions using SQL queries. By analyzing the dataset, we extracted meaningful insights that can guide and support the initiation of their new project.

## Objectives

1.**Conduct Exploratory Data Analysis (EDA)**: Perform an in-depth exploration of the movie dataset.

2.**Address Business Questions**: Use SQL queries to answer targeted business and analytical questions, providing actionable insights into the movie dataset.
   
3.**Generate Data-Driven Insights**: Analyze the dataset to uncover key metrics and insights that can inform and support the development of a new project.

4.**Showcase SQL Expertise**: Demonstrate advanced SQL skills by designing, querying, and analyzing the dataset effectively to meet the project’s objectives.

##  1.Data Explorations.

  -**1. View the Structure of the Table**:

  -**2. Summary of the Dataset**:

  -**3. Count the Number of Movies Released Per Year**:

  -**4. Top 10 Movies by Imdb Rating**:

  ```sql
           DESCRIBE movies;

           SELECT COUNT(*) AS total_movies FROM movies;
     
            SELECT release_year, COUNT(*) AS movie_count
	        FROM movies
	        GROUP BY release_year
	        ORDER BY release_year DESC;

           SELECt title, imdb_rating
           FROM movies
           ORDER BY imdb_rating DESC
           LIMIT 10;

```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1.**Write a SQL query to Print all movie titles and release year for all Marvel Studios movies.**
```sql
select title , release_year from movies 
 where studio="marvel studios";
```

2. **Write a SQL query to print all movies that have Avenger in their name**:
```sql
select title from movies
where title like '%avenger%';
```

3. **Write a SQL query to print all movies that have Avenger in their name**:
```sql
select title from movies
where title like '%avenger%';
```

4. **Write a SQL query to Select all THOR movies by their release year**:
```sql
        select title , release_year from movies
	where title like "%thor%"
	order by release_year;
```

5. **Write a SQL query to Print a year and how many movies were released in that year starting with the latest year**:
```sql
      select release_year, count(*) as total_movies 
      from movies
      group by release_year
      order by release_year;
```

6. **Write a SQL query to Show all Telugu movie names (assuming you don't know the languageid for Telugu)**:
```sql
                 select title 
                 from movies m
                 left join languages l
                 on m.language_id = l.language_id
                 where l.name="telugu";
;
```

7. **Write a SQL query to Generate a report of bollywood movies revenue profit unit currency and create a coloumn profit values in millions**:
```sql
         select movie_id, title,budget,revenue,currency,unit,
         case 
           when unit="thousands" then round((revenue-budget)/1000,1)
           when unit="billions" then round((revenue-budget)*1000,1)
         else
           round((revenue-budget),1)
           end as profit_in_mlns
         from movies
	 join financials
	 using (movie_id)
	 where industry="bollywood"
	 order by profit_in_mlns;
```

8. **Write a SQL query to Generate  actor name , movie title and no of movies per actor**:
```sql
     select a.name , group_concat(m.title separator ' ,' ) as MOvie_title,
         Count(m.title) as total_movies
     from actors a
     JOIN movie_actor ma
     On ma.actor_id=a.actor_id
     JOIN movies  m
     On m.movie_id=ma.movie_id 
     Group by a.actor_id
     order by total_movies desc ;

```

9. **Write a SQL query to Generate a report movies with highest and lowest imdb_rating**:
```sql
 select title, imdb_rating from movies
 where imdb_rating in (
    (select max(imdb_rating) from movies),
    (select min(imdb_rating) from movies) );
```

11. **Write a SQL query to Print all actors who acted in any of this movies movie_id(101,110,112)**:
```sql
  select *from actors 
   where actor_id =ANy
   (select actor_id from movies 
   where movie_id in(101,110,112));
```

12. **Write a SQL query to Print all movies whose rating is greater than any of marvel movies rating**:
```sql
  select title from movies
  where imdb_rating > all
   (select min(imdb_rating) from movies
   where studio="Marvel Studios");
```

13. **Write a SQL query to Generate a report actor_id,actor_name and total number of movies they acted in**:
```sql
   select actor_id,name,
  (select count(*) from movie_actor
  where actor_id=actors.actor_id) as movie_count
  from actors
  order by movie_count desc;
```

14. **Write a SQL query to Generate a movies report that produced more than 500% profit and their rating was less than avg rating for all movies**:
```sql
  select 
   a.movie_id,a.profit_pct,
   c.title, c.imdb_rating 
  from 
    ( select movie_id , Round((revenue-budget)*100/budget,1)  as profit_pct
     from financials )a
  join ( 
         select *from movies 
         where imdb_rating>=
         ( select avg(imdb_rating) as avg_rating
          from movies) 
          ) c
  on a.movie_id=c.movie_id 
  where profit_pct>=500;
```

15. **Write a SQL query to Generate a movies report that produced more than 600% profit and their rating was more than avg rating for all movies**:
```sql
   with a as (
               select movie_id , Round((revenue-budget)*100/budget,1)  as profit_pct
               from financials
             ),
        c as (  
               select *from movies 
               where imdb_rating>
              ( select avg(imdb_rating) as avg_rating
               from movies)
              )
      select 
          a.movie_id,a.profit_pct,
          c.title, c.imdb_rating 
     from a
     join c
     on a.movie_id=c.movie_id 
     where profit_pct>=600;
```


## Findings


**Revenue and Profit Analysis:** : Movies were analyzed for their revenue, profit, and profitability percentages, identifying high-performing titles with profit values converted into millions. 

**Genre and Franchise Insights:**:Movies were analyzed to uncover insights into their release patterns and evolving popularity trends over the years, offering a comprehensive understanding of their performance.

**IMDb Ratings Insights:**:Movies with the highest and lowest IMDb ratings were identified, along with a comparison to highlight movies that outperformed their peers.



## Conclusion

This project demonstrated my SQL expertise through a detailed analysis of a movie dataset. By conducting exploratory data analysis (EDA) and addressing targeted business and analytical questions with SQL queries, we uncovered valuable insights.
