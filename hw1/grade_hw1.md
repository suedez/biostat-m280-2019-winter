*Xinrui Zhang*

### Overall Grade: 100/110

### Quality of report: 10/10

-   Is the homework submitted (git tag time) before deadline?

    Yes. `Jan 25, 2019, 7:48 PM PST`.

-   Is the final report in a human readable format html? 

    Yes. `html`.

-   Is the report prepared as a dynamic document (R markdown) for better reproducibility?

    Yes. `Rmd`.

-   Is the report clear (whole sentences, typos, grammar)? Do readers have a clear idea what's going on and how are results produced by just reading the report? 

	  Yes.
    

### Correctness and efficiency of solution: 57/60

-   Q1 (10/10)

-   Q2 (20/20)

-   Q3 (14/15)

	\#3. (-1 pt) Missing explanation of the output.

-  Q4 (13/15)


	\#3. (-2 pts) Table looks crude. Include  
	
    ```
    library(knitr)
    kable(results_table)
    ```
    
    to create a table in the given format.
	    
### Usage of Git: 9/10

-   Are branches (`master` and `develop`) correctly set up? Is the hw submission put into the `master` branch?

    Yes.

-   Are there enough commits? Are commit messages clear? 

    16 commits for hw1. 
      
-   Is the hw1 submission tagged? (-1 pt)

    Tag name should be `hw1`.

-   Are the folders (`hw1`, `hw2`, ...) created correctly? 

    Yes.
  
-   Do not put a lot auxiliary files into version control. 

	 Yes. 

### Reproducibility: 8/10

-   Are the materials (files and instructions) submitted to the `master` branch sufficient for reproducing all the results? Just click the `knit` button will produce the final `html` on teaching server? (-2 pts)

   - Clicking knit button does not produce the final html on teaching server. The path 
   
     ```
     oFile <- paste("/home/suedez/biostat-m280-2019-winter/hw1/n",n,"dist",dist, ".txt", sep="")
     ``` 
      and 
   
     ```
      grep -o $namei /home/suedez/pride_and_prejudice.txt | wc -l
     ```
   
	in `hw1sol.Rmd` are for your own directory on the server. Make sure your collaborators can easily run your code by using relative path, e.g. 
	
	```
	oFile <- paste("./n",n,"dist",dist, ".txt", sep="")
	```  	
	```
	grep -o $namei ./pride_and_prejudice.txt | wc -l
	```
	
	- `eval=FALSE` in the following code chunk

	````
	```{bash, eval=FALSE}
	curl https://www.gutenberg.org/files/1342/1342.txt > pride_and_prejudice.txt
	```
	````
	
	does not download `pride_and_prejudice.txt`. Include all codes necessary for easier reproducibility.


-   If necessary, are there clear instructions, either in report or in a separate file, how to reproduce the results?

    Yes.

### R code style: 16/20

-   [Rule 3.](https://google.github.io/styleguide/Rguide.xml#linelength) The maximum line length is 80 characters. (-2 pts)

	Some violations:

	- `autoSim.R`: line 14
	- `hw1sol.Rmd`: last code chunk 


-   [Rule 4.](https://google.github.io/styleguide/Rguide.xml#indentation) When indenting your code, use two spaces.

-   [Rule 5.](https://google.github.io/styleguide/Rguide.xml#spacing) Place spaces around all binary operators (=, +, -, &lt;-, etc.). 

	

-   [Rule 5.](https://google.github.io/styleguide/Rguide.xml#spacing) Do not place a space before a comma, but always place one after a comma. (-2 pts) 

	Some violations:
	
	- `autoSim.R`: line 14, 15
	- `runSim.R`: line 28, 31, 34
	- `hw1sol.Rmd`: last code chunk 

-   [Rule 5.](https://google.github.io/styleguide/Rguide.xml#spacing) Place a space before left parenthesis, except in a function call.

-   [Rule 5.](https://google.github.io/styleguide/Rguide.xml#spacing) Do not place spaces around code in parentheses or square brackets.
