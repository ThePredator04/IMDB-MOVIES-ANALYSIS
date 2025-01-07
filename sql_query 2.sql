use moviesdb;

select*from actors;

select*from financials;

select*from languages;

select*from movie_actor;

select*from movies;

-- 1. Print all movie titles and release year for all Marvel Studios movies.
 
      select title , release_year from movies 
              where studio="marvel studios";

-- 2. Print all movies that have Avenger in their name.

	   select title from movies
           where title like '%avenger%';
       
-- 3. Print the year when the movie "The Godfather" was released.
       
		select release_year from movies
            where title = "The Godfather";
            
 -- 4.. Print all distinct movie studios in the Bollywood industry.
  
		  select distinct studio from movies
            where industry = "Bollywood";
            
            
-- 1. Print all movies in the order of their release year (latest first)
       
       select * from movies
		  order by release_year;
             
-- 2. All movies released in the year 2022

          select*from movies
		    where release_year= 2022;
            
-- 3. Now all the movies released after 2020
         
            select*from movies
		      where release_year> 2020;

-- 4. All movies after the year 2020 that have more than 8 rating

			select*from movies
		      where release_year>2020 And imdb_rating>8;

-- 5. Select all movies that are by Marvel studios and Hombale Films
      
              select title from movies
		         where studio="marvel studios";
			
-- 6. Select all THOR movies by their release year

             select title , release_year from movies
		         where title like "%thor%"
                   order by release_year;  

                
-- 7. Select all movies that are not from Marvel Studios
         
               select * from movies
		         where title not like "%marvel%"
                   order by release_year;
         
	-- Summary analytics

-- 1. How many movies were released between 2015 and 2022
          
          
          select count(*) as total from movies 
             where release_year between 2015 and 2022;
             
             
-- 2. Print the max and min movie release year
       
       select min(release_year) as min_year,
	      max(release_year) as max_year
            from movies;
           
           
-- 3. Print a year and how many movies were released in that year starting with the latest year   
    
    
         select release_year, count(*) as total_movies 
            from movies
			  group by release_year
                order by release_year;
                
  --  1. Show all the movies with their language names
     
		select title , name 
            from movies m
             INNER JOIN languages l
               on m.language_id = l.language_id;
    
-- 2. Show all Telugu movie names (assuming you don't know the languageid for Telugu)

		 select title 
            from movies m
              left join languages l
                on m.language_id = l.language_id
                where l.name="telugu";
                
-- 3. Show the language and number of movies released in that language  

		 select l.name, count(m.movie_id)
            from languages l  
			  left join movies m using (language_id)
                   group by language_id;
                   
-- 4 Generate a report Title revenue profit unit currency and create a calculated coloumn profit

            select movie_id, title,budget,revenue,currency,unit,(revenue-budget) as profit
	         from movies
               join financials
                 using (movie_id);
                 
 -- 5  Generate a report of bollywood movies revenue profit unit currency and create a calculated coloumn profit values in millions 

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
                                  
   -- 5  Generate  a report  of movie and cast in moving (JOINING MORE TWO TABLES)
   
					select m.title , group_concat(a.name separator " / ") as actors
                     from movies m 
                      JOIN movie_actor ma ON m.movie_id=ma.movie_id
                       JOIN actors a ON ma.actor_id=a.actor_id
                        group by m.movie_id;
                        
    --              
               
   -- 5  Generate  actor name , movie title and no of movies per actor (JOINING MORE TWO TABLES)
   
   
          select a.name , group_concat(m.title separator ' ,' ) as MOvie_title,
           Count(m.title) as total_movies
            from actors a
             JOIN movie_actor ma 
              On ma.actor_id=a.actor_id
                JOIN movies  m 
                  On m.movie_id=ma.movie_id 
                   Group by a.actor_id
                    order by total_movies desc ;
                   

   -- 1.Generate a report movies with highest and lowest imdb_rating
   
         select title, imdb_rating from movies
          where imdb_rating in (
           (select max(imdb_rating) from movies),
             (select min(imdb_rating) from movies) );
             
             
   -- 2.select all actors whose age >70 and >80
      
       select * from 
        (select name, year(curdate())-birth_year as age 
		 from actors) as actor_age
		  where age >70 and age <85;
           
  --  3. select actors who acted in any of this movies movie_id(101,110,112)
  
        select *from actors 
         where actor_id =ANy (select actor_id from movies 
           where movie_id in(101,110,112));
           
  -- 4.   select all movies whose rating is greater than any of marvel movies rating
  
          select title from movies
            where imdb_rating > all
             (select min(imdb_rating) from movies 
               where studio="Marvel Studios");
               
    -- 5.Generate a report actor_id,actor_name and total number of movies they acted in --CORELATED SUBQUERY
    
           select*from actors;
		    select*from movies;
             select*from movie_actor;
             
			select actor_id,name,
		      (select count(*) from movie_actor
                where actor_id=actors.actor_id) as movie_count
                 from actors
                  order by movie_count desc;
                  
        -- 1.  Generate a report with actors whose age between 60 and 80
        
              with actors_age as (select name as actor_name, year(curdate())-birth_year as age 
			   from actors)    
		        select actor_name,age
				 from actors_age
                  where age between 60 and 80;
                  
-- 2. Generate a movies report that produced more than 500% profit and their rating was less than avg rating for all movies  
        
			                 
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
                    
-- REPLICATING THE ABOVE REPORT USING COMMON TABLE EXPRESIONS (CTE)
   
     with a as (
		         select movie_id , Round((revenue-budget)*100/budget,1)  as profit_pct
	             from financials
				),
          c as(  
                 select *from movies 
				  where imdb_rating>=
		         ( select avg(imdb_rating) as avg_rating
		          from movies)
			   )
      select 
          a.movie_id,a.profit_pct,
          c.title, c.imdb_rating 
	 from a
     join c
     on a.movie_id=c.movie_id 
     where profit_pct>=500
      
                
                