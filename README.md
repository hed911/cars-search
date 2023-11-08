# Solution
Since the main functionality of the system is to implement a scalable search engine that supports a lot of information without affecting its performance, the ElasticSearch solution was chosen as the search engine that stores and is in charge of search optimization.

# Changes made
##RSpec integration for testing
The Rspec Shoulda and SimpleCov gems were added to the Gemfile for performing unit tests, having extra matchers for the associations of the activerecord models and finally SimpleCov for the generation and calculation of the test coverage.

## Redis integration
Added connection to Redis database to be consumed by Sidekiq.

## ActiveJob integration
I decided to implement ActiveJob to execute the SyncToElastic task and be able to synchronize data from the local database and the ElasticSearch service.

## ElasticSearch client use
Using the elasticsearch gem, a decorator class was created to customize the methods of the original class, and a series of classes were also created to generate the corresponding requests and parse the results obtained from the external API.

## last_sync_at field
An extra migration was added to the users table to add a timestamp type field called last_sync_at that will be used to know what the last synchronization date was.

## Rubocop integration
This tool was used for code cleaning and to identify style problems in the source code.

# Why ElasticSearch?
Because Elasticsearch is the most popular and powerful search engine and analytics tool, often chosen as the underlying technology for building search capabilities in various applications and platforms.
Among the largest clients are Facebook, Wikipedia, Uber, Tinder, which give credibility to the robustness of the product.
![Elastic account](https://i.ibb.co/JFzBGmq/Screen-Shot-2023-11-08-at-3-52-48-PM.png "Elastic account")

# How works the sync process?
Since the data in the Recommendations API per user is only updated at most once per record per day, it was decided to schedule record synchronization once every X hours. The synchronization steps are listed below:
- The system takes the total number of users on the platform, divides them into equal parts and schedules a job for each part.
- Sidekiq will use a processor core for each scheduled task and execute the process in parallel.
- For each record within the user table, the application will execute a request to the recommendation service API.
- Then the application will execute a request to the ElasticSearch API to create or update the documents.

# Sync process improvement
This part of the system can be a bottleneck, so digging a little deeper I found that the ElasticSearch API has an endpoint to execute queries in bulk, so synchronization can be improved to just one request that satisfies all records instead of making a request for each record.

# API documentation
Deployed API URL: https://sem-bquilla-referencias-13e559080d65.herokuapp.com/cars/search 

```
{
  "user_id": <user id (required)>
  "query": <car brand name or part of car brand name to filter by (optional)>
  "price_min": <minimum price (optional)>
  "price_max": <maximum price (optional)>
  "page": <page number for pagination (optional, default 1, default page size is 20)>
}
```
## Request examples
Filter cars from user with id = 1 and containing brand name "Volks"
https://sem-bquilla-referencias-13e559080d65.herokuapp.com/cars/search?user_id=1&query=volks

Filter cars from user with id = 1 and with a minimal price of 20000
https://sem-bquilla-referencias-13e559080d65.herokuapp.com/cars/search?user_id=1&price_min=20000

## Test coverage
Test cases were implemented for most of the important classes, achieving a test coverage of 96.23%
![SimpleCov](https://i.ibb.co/347tpqL/Screen-Shot-2023-11-08-at-3-46-53-PM.png "SimpleCov")


