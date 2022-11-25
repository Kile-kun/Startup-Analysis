# Startup-Analysis
This Project is meant to highlight, Analyze and Understand the Journey and historical significance of all documented Startups since 1966. 

# _INTRODUCTION_
The Bedrock of any nation’s economic growth is the innovative capacity of its citizens. The ability to create a solution-focused idea out of mere intuition and observations will continue to be a determining factor in ranking economic world powers among countries. 
According to Meo 2022, a startup is a business that is just starting. They are created by one or more owners who desire to provide a good or service for which they feel there is a market. While some startups grow so big and powerful that they disrupt the traditional way of doing things, a case study is Amazon, eBay, Alibaba, et al. which redefined e-commerce. Google and Yahoo disrupt traditional media. Some not-so-lucky ones fizzle away or at best get bought over by the established corporation.

# _PROJECT SUMMARY_
The project entails analyzing Historic startup data detailed and segmented into different tables collated over 40 years. The project analyst was allowed the freedom of tools for the analysis, so the summary Is specified below.

*Title*: Analyzing Historical Details of Startups.

*Dataset*: Due to size of the Datasets involved(over 300MB) all the dataset used was uploaded into a google drive for easy access. They can be found [here](https://drive.google.com/drive/u/1/folders/1gVxvhBmrlEnnLVKDrqZx7_gZeU6wTkQm)

*Analytics Tools*: Microsoft Excel, Microsoft SQL Server Management Studio (MSSMS), and PowerBI.  

# _PROJECT PROCESS_
*Preliminary Data Quality Checks* - Otherwise called data eyeballing, Excel was employed with the sole purpose of giving the first look to have an idea of what we are working on, renaming column titles to establish uniformity, and removing the columns that are not so needed.

*Database Creation* – A startup database was created using MSSMS. The query used was;
DROP DATABASE IF EXISTS startup_db;
CREATE DATABASE startup_db;

*Data Uploads*- Due to the nature and enormous size of the data files the import ‘Flat file’ method was used to upload the CSV formatted files into the database. The data files uploaded are used to create tables in the process, data types are assigned to each column and primary keys are assigned to the deserving column of each table. The data files/tables are explained below.

__Acquisitions Table__- This table is more involved in the details of acquisitions about which company or entity acquired which startup, when and how much was spent to fund the acquisitions. Here, the primary key is the acquisition_id,

__Degrees__- This table highlighted the educations of the founders and top staff of the various startups and considerations it includes their highest level of education and the school they attended, and the primary key is the degree_id,

__Funding Rounds__- This is the table where all the funds raised by startups for each funding series have been raised to run the startups it also involves how much was raised for each series or each round. It also specifies the number of participants of investors in each round for each startup and the pre-valuations and post-valuation state of each startup. funding_round_id is identified as the primary key,

__Funds__- This table contains details of investment companies and ventures capitalist organizations involved in the purchase and investment of startups that are specified across other tables. the details also include the amount they've raised over the years. It has funds_id as its primary key,

__Investments__- this table highlights the details of investment between the investment companies and venture capitalist companies and the startups involved. It also highlighted the funding rounds the investments or the acquisition occurred. The primary key used is the investment_id,

__IPOS__- this is the table of details of startups that went that successfully went public, the number of entities that invested including how much was raised during the public offering, the valuation pre- and post-investments, and others,

__Milestones__- this table detailed the significant events that take place in different startups and the timeline for each event,

__Objects__- This table combines all entities including companies, financial organizations, Startup personnel and products, and all the details about them has the object_id as the primary key,

__Offices__- With office_id as the primary key, This table contains the locations of the headquarters for each startup,

__People__- This table contains the name and birthplace of each startup personnel has people_id as the primary key,

__Relationships__- This table represents the relationship between the people and the roles they occupy for each startup. Relationship_id is the primary key used here,

__Countries__- This data was sourced externally from [dataworld](https://data.world/dr5hn/country-state-city/workspace/file?filename=countries.csv) because the above data lacked adequate information on the region and continents of the locations described in the data provided. Here the country_code was used as the primary key for this table.
