import java.sql.*;

public class DemoProcedures {
    public static void main(String[] args) throws Exception {
        String url = System.getenv("JDBC_URL"); // jdbc:oracle:thin:@//host:1521/xe
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASS");

        try (Connection cn = DriverManager.getConnection(url, user, pass)) {

            try (CallableStatement cs = cn.prepareCall("{ call pkg_mototrack.prc_aluguel_em_json(?) }")) {
                cs.setInt(1, 1);
                cs.execute();
            }

            try (CallableStatement cs = cn.prepareCall("{ ? = call pkg_mototrack.fn_validar_senha_complexidade(?) }")) {
                cs.registerOutParameter(1, Types.VARCHAR);
                cs.setString(2, "Abcdef1!");
                cs.execute();
                System.out.println(cs.getString(1));
            }
        }
    }
}
