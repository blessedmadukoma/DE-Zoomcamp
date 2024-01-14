# Week 1: Includes Issues faced and Resolutions

[My Data Engineering Zoomcamp Github](https://github.com/blessedmadukoma/DE-Zoomcamp)

<u>Introduction:</u>
Week 1 introduces the course, installations, setup and prerequisites needed. The Introduction into the concept of Data Engineering, tools to be used in the Zoomcamp such as Prefect, Airflow, Python, GCP, Terraform, Apache Spark and Docker are shown. 

The following outlines week 1: 

1. Docker introduction and setup
2. Ingesting New York Taxi Data into Postgres
3. Connecting PG admin to Postgres
4. Dockerizing the ingestion script
5. Running Postgres and pgAdmin with Docker-Compose
6. Introduction to GCP and Terraform


### 1. Docker introduction and setup
A. <strong>What is docker:</strong> Docker is a platform and tool for building, shipping, and running distributed applications. It allows developers to package an application with all of its dependencies into a single container, which can be run on any system with the Docker runtime installed. <br/>
B. <strong>Use cases of Docker:</strong> Because docker can be used to package and run applications in a portable and isolated environment. Here are a few use cases: <br/>
  - Processing and Analyzing Data: Docker provides a convenient way for data scientists and engineers to encapsulate their data processing and analysis workflows, be it a Jupyter notebook or a Spark cluster. This facilitates seamless sharing and collaboration within a team, while also ensuring the capability to execute the same workflow across diverse environments.
  
  - Web Applications: Leveraging Docker containers, one can package and deploy web applications, be it a Node.js or a Python-based web server. This streamlines the process of scaling and deploying the application across varied environments with ease.

  - Database Management Systems: 
Containers offer the capability to run Database Management Systems like MySQL or MongoDB, simplifying database management and scaling. It also enables the concurrent operation of multiple versions of the database with ease.

  - Machine Learning: Containers provide a means to package and deploy machine learning models, like TensorFlow or PyTorch models. This facilitates seamless scaling and deployment across diverse environments, including on-premises, cloud, or edge devices.

  - DevOps: Containers can be used for CI/CD (Continuous Integration and Continuous Delivery) pipeline as well, for example, by packaging the application and its dependencies in a container, and then using tools like Jenkins or Travis CI to test, build, and deploy the container to a production environment.
  
### 2. Ingesting New York Taxi Data into Postgres:
    - Creating folder `ny_taxi_postgres_data` in the working directory	
  
  ![Create a new directory](/images/01_ny_taxi_postgres_data.png "ny_taxi_postgres_data directory")
  
  1. Setting up and running Postgres 14-alpine image database on docker:
  - Run the command: <br/>
    ```
    docker run -it \    
      -e POSTGRES_USER="root" \
      -e POSTGRES_PASSWORD="root" \       
      -e POSTGRES_DB="ny_taxi_data_eng" \       
      -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \    
      -p 5432:5432 \   
      --name DE_zoomcamp \
      postgres:14-alpine
    ```
      
    The above command runs a Postgres container named DE_zoomcamp with a db name of ny_taxi_data_eng, a persistent volume linking the created folder/directory “ny_taxi_postgres_data” to the container storage. 
  
  - Install pgcli using pip: `pip install pgcli` 
  - Connect to the database using pgcli by running: `pgcli -h localhost -p 5432 -u root -d ny_taxi_data_eng`
		<br/>
		<br/>
  <strong>My first issue: pgcli said No😂</strong> <br/>
After installing pgcli using both pip and brew, I encountered this error.

![PGCLI error](/images/02_pgcli_1.png "PGCLI error")

<strong>Resolution</strong>: I had to install postgresql locally (I use docker to handle my databases) by running `brew install postgresql` and it was resolved.

￼
![PGCLI resolved](/images/03_pgcli_2.png "PGCLI resolved")

**Note:** Jupiter Notebook is used but I opted for VSCode because of my familiarity with the awesome tool. 

Connecting to my database to check the total records, I have the complete data:

![data](/images/04_db_connection.png "data")
￼

### 3. Connecting PG admin to Postgres: 
  <br/>
  To use the web GUI tool PGAdmin in docker, do the following:
  1. Run the image using the command:
   
  ```
  docker run -it \
  -e PGADMIN_DEFAULT_EMAIL=“youremail@email.com” \
  -e PGADMIN_DEFAULT_PASSWORD=“yourPassword” \
  -p 9090:80 \
  --name my_pgadmin4 \
  dpage/pgadmin4  
  ```
  
  This will automatically pull the image if you do not have it on your local machine.
 
  2. Open localhost:9090, the pgadmin login screen loads.
  3. In order to link to the running Postgres container, docker network is used. Stop the running services (postgres and pgadmin).
  4. Create a docker network: docker network create pg-data-network.
  5. Connect the docker network to the stopped services:
  - DE_zoomcamp: `docker network connect pg-data-network DE_zoomcamp` 
  - my_pgadmin4: `docker network connect pg-data-network my_pgadmin4`

### 4. Dockerizing the ingestion script
  - run the command to execute `ingest_data.py` and upload the data to postgres: <br/>

  ![run python](/images/05_python%20command.png "run python")

  - verify the data in the database: <br/>
 
  ![ingest_data.py](/images/06_verify_data.png "ingest_data.py")
  
  - dockerize the app: <br/>

  ![dockerize the app](/images/07_docker1.png "dockerize the app")

  - verify the app is dockerized: <br/>
￼
  ![verify docker app](/images/08_docker2.png "verify docker app")

￼

### 5. Running Postgres and pgAdmin with Docker-Compose
  - Docker Compose is a tool for defining and running multi-container Docker applications. It allows you to configure and run multiple containers, networks, and volumes in a single YAML file. This makes it easy to manage and configure multiple containers as part of a single application.
  - Below is an image of the docker-compose.yml to run both the postgres and pgAdmin services <br/>
￼
  ![docker-compose](/images/09_docker_compose.png "docker-compose")

### 6. Introduction to GCP and Terraform

What is Terraform?
- Open-source tool by HashiCorp used for provisioning infrastructure resources.
- Supports DevOps practices for change management.
- Managing configuration files in source control to maintain an ideal provisioning state for testing and production environments. 

What is IaC?
- Infrastructure-as-Code
- Build, change and manage your infrastructure in a safe, consistent and repeatable way by defining resource configurations that you can version, reuse and share.

Some advantages:
- Infrastructure lifecycle management
- Version control commits
- Very useful for stack-based deployments and with cloud providers such as AWS, GCP, Azure, k8s.
- State-based approach to track resource changes throughout deployments

Terraform commands:
1. Initialize Terraform: `terraform init` to initialize Terraform and download the required plugins.

2. Plan the infrastructure: `terraform plan` to preview the changes that Terraform will make to your infrastructure.

3. Apply the infrastructure: `terraform apply` to create the infrastructure on your cloud provider i.e. GCP.

4. Destroy the infrastructure: `terraform destroy` to destroy the created infrastructure on your cloud provider.


GCP:
1. Create a new project
2. Create a new service account: a service account is an account for services, instead of using an admin account
3. Download/Setup the Google cloud SDK

Google Cloud Storage (GCS): 
- Data Lake - store the raw data
- BigQuery: Data Warehouse - more structured data
