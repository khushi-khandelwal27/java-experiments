import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/student_db?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = System.getenv().getOrDefault("JAVA_LAB_DB_USER", "root");
    private static final String PASSWORD = System.getenv().getOrDefault("JAVA_LAB_DB_PASSWORD", "root");

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
