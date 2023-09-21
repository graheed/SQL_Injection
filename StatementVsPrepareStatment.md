# Difference between Statement and PreparedStatement

## Statement
A `Statement` is an interface in Java that represents a SQL statement. You can execute static SQL statements and obtain the results produced by the statement using this interface.

### Example
```java
Statement stmt = con.createStatement();
ResultSet rs = stmt.executeQuery("SELECT * FROM employees");
```

## Prepared Statement
A `PreparedStatement` is a subinterface of Statement. It represents a precompiled SQL statement that can be executed multiple times without having to recompile for each execution. This interface is ideal for executing dynamic SQL statements.

### Example
``` Java
PreparedStatement pstmt = con.prepareStatement("SELECT * FROM employees WHERE salary > ?");
pstmt.setDouble(1, 30000);
ResultSet rs = pstmt.executeQuery();
```

1. SQL Injection: Statement is vulnerable to SQL Injection attacks while PreparedStatement is not.
2. Performance: PreparedStatement is faster than Statement because it is compiled only once.
3. Flexibility: PreparedStatement allows you to set parameters dynamically.


## SQL Injection Demonstration using Docker Compose

Place the code block below in a docker-compose.yaml file

``` yaml
version: '3'
services:
  database:
    image: postgres:latest
    environment:
      POSTGRES_USER: ${DB_USERNAME:-myuser} 
      POSTGRES_PASSWORD: ${DB_PASSWORD:-mypassword}
    ports:
      - "${DB_PORT:-5432}:5432"
    volumes:
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
      - database-data:/var/lib/postgresql/data
volumes:
  database-data:
```

The `.env` file is provided in the directory. Feel free to modify the variables as your own.

The Java code needed is below. **Note:** always use the properties file to store your sensitive information, do not leave credentials in plain code as seen below, just for demonstration purposes. Also you may replace the variables for your own login details.

**Make sure to have the proper connector installed in your build manager**

``` java

import java.sql.*;

public class database {
    public static void main(String[] args) {
        String databaseUrl = "jdbc:postgresql://localhost:10001/testdb";
        String user = "rgilzene";
        String password = "#rgilzene#";


        try (Connection conn = DriverManager.getConnection(databaseUrl, user, password)) {
            try (Statement statement = conn.createStatement()) {
                String userName = "admin"; // user input
                String pass = "admin' OR '1'='1"; // user input
                ResultSet rs = statement.executeQuery("SELECT * FROM users WHERE username = '" + userName + "' AND password = '" + pass + "'");
                while (rs.next()) {
                    System.out.print("ID is: " + rs.getInt("id"));
                    System.out.print("| Username is: " + rs.getString("username"));
                    System.out.print("| Passwors is: " + rs.getString("password"));
                    System.out.println();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try (PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM users WHERE username = ? AND password = ?");) {
                String userName = "admin"; // user input
                String pass = "admin' OR '1'='1"; // user input
                pstmt.setString(1, userName);
                pstmt.setString(2, pass);
                ResultSet rs = pstmt.executeQuery();

                while (rs.next()) {
                    System.out.print("ID is: " + rs.getInt("id"));
                    System.out.print("| Username is: " + rs.getString("username"));
                    System.out.print("| Passwors is: " + rs.getString("password"));
                    System.out.println();
                }
            } catch (SQLException e) {
            e.printStackTrace();
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

    }
}

```

## Results
As you can see, the SQL injection attacked worked for the regular statement but not for the prepared statement, hence demonstrating security.



