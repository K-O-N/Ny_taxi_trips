# Data Warehouse

- OLAP vs OLTP
- Whar are Data Warehouses
- BigQuery
> - cost
> - partitions and clustering
> - Best Pratices
> - Internals
> - ML in BQ

 ## OLAP Vs OLTP 
| Project | OLTP | OLAP |
|--------|------------|-------------|
| Purpose | store Real time buisness operations/ transactional data | store historical data for analytics |
| Data updates | Short, fast updates initaited by user | Periodical data updates refreshed with data jobs |
| Database Design | Normaised databases for efficiency | denormalised data for analysis |
| Space Requirements | Generally snall if historical data is archived | Large due to historical data |
| Backups and recovery | Regular backups required to ensure buisness continuity and meet governance requirements | Lost data can be reloaded from OLTP database as needed |

## Data Warehouse
OLAP solution used for reporting and data analysis. Consist of raw data, metadata, and summary. Can have many sources, OLTP databases reporting to a staging areas and then the warehouse. 
The warehouse can be tranformed to data marts, etc. Data warehouse provides access to all raw data; summary data, metadata, or data marts. 

## BigQuery
A serverless data warehouse solution. Software as a well as infrastructure including scalability and high-availablity.

## Partitions
Partitioning is a process of creating partitions in your data to improve effeciency and reduce processing cost. 
Craete partitions in BigQuery 
```
```
