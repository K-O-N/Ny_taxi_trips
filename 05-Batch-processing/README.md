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
To be able to access SparkUI which resides on Colab’s localhost, we need to make it available from the internet. For that, we will forward it using ngrok. To use Ngrok, you need to register on their website first. After registering, an automatically generated AuthToken is given which can be used later to authenticate with ngrok.
```
%%capture
!pip install pyspark
!pip install findspark
!pip install pyngrok
```
set up the park session ```findspark.init()``` performs the following task
 - locating the spark installation
 - setting the necessary environment variables 
After that we have a SparkSessionobject available, enabling you to configure and submit Spark jobs from your Python code.
```
import findspark

findspark.init()

from pyspark.sql import SparkSession

spark = SparkSession.builder \
        .appName('testColab') \
        .getOrCreate()
```
create the tunnel
```
from pyngrok import ngrok, conf
import getpass

print("Enter your authtoken, which can be copied "
"from https://dashboard.ngrok.com/get-started/your-authtoken")
conf.get_default().auth_token = getpass.getpass()

ui_port = 4040
public_url = ngrok.connect(ui_port).public_url
print(f" * ngrok tunnel \"{public_url}\" -> \"http://127.0.0.1:{ui_port}\"")
```
After you enter your AuthToken copied from the ngrok dashboard you’re all set — SparkUI will be accessible on the provided temporary public URL
