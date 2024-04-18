/* ****
1. Get the reviewers’ IDs that are 40 years of age or older.
*/
SELECT UserID, age
FROM VIEWER
WHERE AGE >= 40

/* ****
2. Get the movie title for all movies that are children and comedy. Rename the output attribute
to be “Children Comedy.”
*/
SELECT MOVIETITLE AS "Children Comedy", Children, Comedy
FROM Movie
WHERE children = 1 AND comedy = 1

/* ****
3. Get the reviewer ID, zip, age, gender, and occupation for reviewers in New York City
who are under 40 years old or who are in entertainment. Zip codes for New York City begin
with “10”.
*/
SELECT UserID, Zip, Age, Gender, Occupation
FROM VIEWER
WHERE (zip LIKE '10%' AND age < 40) OR (zip LIKE '10%' AND occupation = 'entertainment')

/* ****
4. Count the number of reviewers in each occupation. List the occupation, the number of
reviews in that occupation, and the category of the occupation. The Category will be done
using a CASE statement. The occupations of Administrator, Educator, and Student will be

assigned a category of “SCHOOL”. All others will be assigned a category of “Non-
SCHOOL”. Give the count column the title "School Positions." Give the Category column the

title “Job Category”. List the Occupations in descending alphabetical order.
*/
SELECT Occupation, COUNT(*) AS "School Positions",
CASE
    WHEN occupation = 'administrator' THEN 'SCHOOL'
    WHEN occupation = 'educator' THEN 'SCHOOL'
    WHEN occupation = 'student' THEN 'SCHOOL'
    ELSE 'Non-SCHOOL'
END AS "Job Category"
FROM Viewer
GROUP BY occupation
ORDER BY occupation DESC

/* ****
5. Create a temporary table using the WITH statement. Call the temporary table MovieTitle20.
In MovieTitle20, create a field that contains the year of release only for titles that are 20
characters long. For titles with 20 characters, the Year is four characters long and begins at
character 16. From the MovieTitle20 table, count the number of movies released in that
year. See explanation of the WITH statement beginning on page 208 of the Murach book.
FUNCTIONS NEEDED: Substring, Len, Count

*/
WITH MovieTitle20 AS(
    SELECT SUBSTRING(MovieTitle, 16, 4) AS ReleaseYear
    FROM MOVIE
    WHERE LEN(MovieTitle) = 20
)
SELECT ReleaseYear, COUNT(*) AS Number_of_Movies_Released
FROM MovieTitle20
GROUP BY ReleaseYear
ORDER BY ReleaseYear

/* ****
6. List the most active reviewers and the number of reviews that they have done. Active
reviewers are reviewers who have reviewed more than 200 movies. Give the count column
an alias. Display the output by descending number of reviews.
*/
SELECT UserID, COUNT(*) AS Number_of_Ratings
FROM Rating
GROUP BY UserID
HAVING COUNT(*) > 200
ORDER BY [Number of Ratings] DESC

/* ****
7. List the youngest age, oldest age, and average age of reviewers for each profession that
have given the Highest rating to an Children Comedy film. Use a left join. Add appropriate
column titles. Sort the occupations in ascending alphabetical order.
*/
SELECT OCCUPATION, MIN(AGE) "Youngest", MAX(AGE) "Oldest", AVG(AGE) "Average"
FROM VIEWER
LEFT JOIN Rating ON VIEWER.USERID = RATING.USERID
LEFT JOIN Movie ON RATING.MovieID = MOVIE.MovieID
WHERE Rating = 5 AND children = 1 AND comedy = 1
GROUP BY OCCUPATION
ORDER BY OCCUPATION ASC

/* ****
8. List the number of reviewers for each profession, not including Administrator, Educator or
Student. Sort the list in descending numerical order by the count column. Give the count
column the title "Occupation Count".
*/
SELECT Occupation, COUNT(*) AS "Occupation Count"
FROM Viewer
WHERE occupation != 'administrator' AND occupation != 'educator' AND occupation != 'student'
GROUP BY occupation
ORDER BY [Occupation Count] DESC
/* ****
9. By occupation, list the Average age, Average Rating, and The number of ratings given to
movies made in 1982. Use the column titles "Average Age", "Average Rating" and "Number
of Ratings" for movies made in 1982. HINT: Use multiple right joins. List the results in
ascending alphabetical order of occupation.
*/
SELECT OCCUPATION, AVG(AGE) "Average Age", AVG(RATING) AS "Average Rating", COUNT(*) AS "Number of Ratings"
FROM VIEWER
RIGHT JOIN Rating ON VIEWER.USERID = RATING.USERID
RIGHT JOIN Movie ON RATING.MovieID = MOVIE.MovieID
WHERE MovieTitle LIKE '%(1982)'
GROUP BY OCCUPATION
ORDER BY OCCUPATION ASC

/* ****
10. List all occupations in zip codes beginning with 10 and have are full length. Full length is
five characters. Show the Average Age which must be above 35.00. Show the results for
average age as a decimal number. Output your results FOR XML with each result on a
single line with the table name on each result line. Only one of the XML parameters, RAW,
AUTO and PATH AUTOmatically puts each value on its own line with the table name on the
left. That's the one you should use. Use your full name as the ROOT. Separate the parts of
your name and field names with underscores (_). Spaces are not a valid character for XML
export. See Murach Chapter 18 for more on XML.
*/
SELECT Occupation, AVG(CAST(AGE AS DECIMAL(4, 2))) AS Average_Age
FROM VIEWER
WHERE zip LIKE '10%' AND len(zip) = 5
GROUP BY occupation
HAVING AVG(CAST(AGE AS DECIMAL(4, 2))) > 35.00
FOR XML AUTO, ROOT('Michelle_Bautista')