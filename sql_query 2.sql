-- SQL IMDB MOVIE Analysis - P1

      select*from actors;
      select*from financials;
      select*from languages;
      select*from movie_actor;
      select*from movies;

-- 1.Write a SQL query to View the Structure of the Table
-- 2. Write a SQL query to Get a Summary of the Dataset
-- 3. Write a SQL query to Count the Number of Movies Released Per Year
-- 4. Write a SQL query to  Top 10 Movies by imdb_rating
-- 5. Write a SQL query to Print all movie titles and release year for all Marvel Studios movies.
-- 6. Write a SQL query to print all movies that have Avenger in their name.
-- 7. Write a SQL query to Select all THOR movies by their release year.
-- 8. Write a SQL query to Print a year and how many movies were released in that year starting with the latest year
-- 9. Write a SQL query to Show all Telugu movie names (assuming you don't know the languageid for Telugu)
-- 10 Write a SQL query to Generate a report of bollywood movies revenue profit unit currency and create a calculated coloumn profit values in millions 
-- 11.Write a SQL query to Generate  actor name , movie title and no of movies per actor
-- 12.Write a SQL query to Generate a report movies with highest and lowest imdb_rating
-- 13. Write a SQL query to Print all actors who acted in any of this movies movie_id(101,110,112)
-- 14.Write a SQL query to Print all  actors whose age >70 and >80
-- 15.Write a SQL query to Print all movies whose rating is greater than any of marvel movies rating
-- 16.Write a SQL query to Generate a report actor_id,actor_name and total number of movies they acted in
-- 17.Write a SQL query to Generate a movies report that produced more than 500% profit and their rating was less than avg rating for all movies
-- 18.Write a SQL query to Generate a movies report that produced more than 600% profit and their rating was more than avg rating for all movies

/*                                     DATA ANALYSIS AND ANSWERING BUSINESS REQUIREMENTS                    */
  
  
   -- 1.Write a SQL query to View the Structure of the Table
   
			DESCRIBE movies;
            
                
   -- 2. Write a SQL query toGet a Summary of the Dataset
   
            SELECT COUNT(*) AS total_movies FROM movies;
            
            
	-- 3. Write a SQL query to Count the Number of Movies Released Per Year 
     
           SELECT release_year, COUNT(*) AS movie_count
		   FROM movies
		   GROUP BY release_year
		   ORDER BY release_year DESC;
           
    -- 4. Write a SQL query to  Top 10 Movies by imdb_rating

           SELECt title, imdb_rating
           FROM movies
           ORDER BY imdb_rating DESC
           LIMIT 10;      
   
   
   -- 5. Write a SQL query to Print all movie titles and release year for all Marvel Studios movies.
   
              select title , release_year from movies 
               where studio="marvel studios";
              
      
	-- 6. Write a SQL query to print all movies that have Avenger in their name.
    
			  select title from movies
			   where title like '%avenger%';
    
    -- 7. Write a SQL query to Select all THOR movies by their release year.
 
               select title , release_year from movies
				where title like "%thor%"
				 order by release_year;  
                 
    -- 8. Write a SQL query to Print a year and how many movies were released in that year starting with the latest year
    
			   select release_year, count(*) as total_movies 
			    from movies
				 group by release_year
                  order by release_year;
               
     -- 9. Write a SQL query to Show all Telugu movie names (assuming you don't know the languageid for Telugu)
        
                select title 
                 from movies m
				  left join languages l
				   on m.language_id = l.language_id
				    where l.name="telugu";
     
-- 10  Write a SQL query to Generate a report of bollywood movies revenue profit unit currency and create a coloumn profit values in millions 


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
            
-- 11 Write a SQL query to Generate  actor name , movie title and no of movies per actor

    
             select a.name , group_concat(m.title separator ' ,' ) as MOvie_title,
               Count(m.title) as total_movies
             from actors a
             JOIN movie_actor ma 
			 On ma.actor_id=a.actor_id
			 JOIN movies  m 
			 On m.movie_id=ma.movie_id 
			 Group by a.actor_id
			 order by total_movies desc ;
             
             
-- 12. Write a SQL query to Generate a report movies with highest and lowest imdb_rating

           select title, imdb_rating from movies
		   where imdb_rating in (
              (select max(imdb_rating) from movies),
			  (select min(imdb_rating) from movies) );
              
              
-- 13. Write a SQL query to Print all actors who acted in any of this movies movie_id(101,110,112)

             select *from actors 
			 where actor_id =ANy (select actor_id from movies 
             where movie_id in(101,110,112));
             
             
-- 14.Write a SQL query to Print all  actors whose age >70 and >80

           select * from 
           (select name, year(curdate())-birth_year as age 
		   from actors) as actor_age
		   where age >70 and age <85;
           
           
-- 15.Write a SQL query to Print all movies whose rating is greater than any of marvel movies rating

           select title from movies
		   where imdb_rating > all
		   (select min(imdb_rating) from movies 
		   where studio="Marvel Studios");
           
           
-- 16.Write a SQL query to Generate a report actor_id,actor_name and total number of movies they acted in

            select*from actors;
		    select*from movies;
			select*from movie_actor;
             
			select actor_id,name,
			(select count(*) from movie_actor
			where actor_id=actors.actor_id) as movie_count
			from actors
			order by movie_count desc;
            
            
-- 17.Write a SQL query to Generate a movies report that produced more than 500% profit and their rating was less than avg rating for all movies

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
     
     
-- 18.   Write a SQL query to Generate a movies report that produced more than 600% profit and their rating was more than avg rating for all movies   

             
        with a as (
		         select movie_id , Round((revenue-budget)*100/budget,1)  as profit_pct
	             from financials
				),
          c as(  
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