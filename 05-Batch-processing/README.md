# Batch vs Streaming
Data can be processed in different ways:
- Batch processing is when the processing and analysis happens on a set of data that have already been stored over a period of time. That is data is processed in chunks at regular intervals. An example is payroll and billing systems that have to be processed weekly or monthly.
- Streaming data processing happens as the data flows through a system. This results in analysis and reporting of events as it happens. ie processing data on the fly. An example would be fraud detection or intrusion detection.

## Batch Processing
Batch jobs can be processed;
- Weekly
- Daily
- Hourly
- 3 times per hour, etc
 
Technologies used for batch streaming include python, SQL, Spark, Flink
### Advantages of Batch Jobs
- Easy to manage
- Retry is safe as it is not happening in real-time
- Easy to scale
### Disadvantages
- Delay as data is run on intervals

# Spark for Batch Streaming
Spark is a distributed data processing engine. For this project, Spark can be ran in clusters with multiple nodes, each pulling and transforming data.
Spark is multi-language because we can use Java and Scala natively, and there are wrappers for Python, R and other languages. The wrapper for Python is called PySpark.
Spark can deal with both batches and streaming data. The technique for streaming data is seeing a stream of data as a sequence of small
![](spark.jpeg)

## Running Spark on Collab
