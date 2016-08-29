# Shodan Runner
### Description:
Shodan Runner is a bash script designed to expedite shodan search queries using the shodan python cli. The script runs a simple nested loop that reads in files and executes searches based on the contents on the files. It creates a matrix of the test inside files and attempts to search all combinations of words present in files. The output from the search is stored using the search parameters in the file name for ease of analysis later on.
### Purpose:
Shodan is an effective tool for gathering information on Internet facing devices. The shodan-cli does not currently have a built-in option to feed search parameters in order to conduct large scale searches across multiple search parameters in an automated way. 
### Process Flow:
For example, you use the shodan web interface with a given query and get over 1,000 results. Now you need to export it to a file to use the information in conjunction with other tools. Eventually, you use the shodan-cli to repeat this process. Then you run into the need to conduct automate searches in order to maximize time. This is where shodan-runner comes in.
### Requirements:
  - Shodan python cli: If not installed, script will do it for you.
  - Shodan API: After installation, script will ask you to input your shodan API key.
  - Active Internet Connection: Script will reach out to shodan.io, if it does not respond, script will exit.
  - Tested on Debian distro, but should still work on RedHat OS's.
  - Tested on Bash 4.3.11

### Installation:
1. You will see the script run the “easy-install shodan” for you. The script will exit after installation for shodan.
2. Re-run script and if shodan is installed, it will ask you to input your API key. Please mind spaces and tabs when copy/pasting.
3. Script will show how many search credits  you have left on an API key after initialization.
4. Script will show usage instructions once initial checks have validated.

### Usage:
shodan-runner takes 3 parameters:  Ex.
```sh
./shodan-runner.sh “output filename” “file1.txt” “file2.txt”
```

Filenames 1 and 2 can be any file you place in argv. However, these files must contain valid shodan search filters or you will simply lose search credits! 

We call file 1 and file 2 the filter files. These files should be constructed using independent associations  relative to your searches since the output produced should be standardized in naming convention for ease of organization. Search parameters do not have to be evenly balanced between both files. For example, file 1 could be used to search for countries and file 2 could be used to search for ports.

```sh
Example 1: Country vs Ports

File 1			File 2
country:us		port:443
country:ru		port:80
country:cn		port:3389
```
This search would produce 9 output files.

```sh
Example 2: Products vs OS

File 1			File 2
product:apache	os:Linux
product:nginx	"-os:Linux"
product:mysql	os:FreeBSD
```
This search would also produce 9 output files. Use quotes around logic operators. Also, exclusion does not always give you what you want in terms of results.

```sh
Example 3: In-title vs product

File 1			File 2
title:Admin		product:nginx
title:Login		product:IIS
title:remote
```

This would produce 6 output files. 

### Credits:

Shodan : [shodan.io] [John Matherly] @achillean

Shodan book: [https://leanpub.com/shodan]

License
----

MIT

### Future Work

 - Integration into core python-cli?
 - Python re-write
 - Tasking stop/resume operations

    
   [shodan.io]: <https://shodan.io>
   [John Matherly]: <https://twitter.com/achillean>
