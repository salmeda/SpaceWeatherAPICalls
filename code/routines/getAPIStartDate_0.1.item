package routines;

/*
 * user specification: the function's comment should contain keys as follows: 1. write about the function's comment.but
 * it must be before the "{talendTypes}" key.
 * 
 * 2. {talendTypes} 's value must be talend Type, it is required . its value should be one of: String, char | Character,
 * long | Long, int | Integer, boolean | Boolean, byte | Byte, Date, double | Double, float | Float, Object, short |
 * Short
 * 
 * 3. {Category} define a category for the Function. it is required. its value is user-defined .
 * 
 * 4. {param} 's format is: {param} <type>[(<default value or closed list values>)] <name>[ : <comment>]
 * 
 * <type> 's value should be one of: string, int, list, double, object, boolean, long, char, date. <name>'s value is the
 * Function's parameter name. the {param} is optional. so if you the Function without the parameters. the {param} don't
 * added. you can have many parameters for the Function.
 * 
 * 5. {example} gives a example for the Function. it is optional.
 */
import java.sql.*;
public class getAPIStartDate {

    /**
     * helloExample: not return value, only print "hello" + message.
     * 
     * 
     * {talendTypes} String
     * 
     * {Category} User Defined
     * 
     * {param} string("world") input: The string need to be printed.
     * 
     * {example} helloExemple("world") # hello world !.
     */
  /*  public static void helloExample(String message) {
        if (message == null) {
            message = "World"; //$NON-NLS-1$
        }
        System.out.println("Hello " + message + " !"); //$NON-NLS-1$ //$NON-NLS-2$
    }
    */
	
	public static String getAPIStartD (String apiName) {
	
	String StartDate = null;
	
		try
	    {
	      // create our mysql database connection
	      String mySQLDriver = "com.mysql.cj.jdbc.Driver";
	      String mySQLUrl = "jdbc:mysql://localhost/NASANW";
	      Class.forName(mySQLDriver);
	      Connection conn = DriverManager.getConnection(mySQLUrl, "bdsql", "bdsql99");
	      
	      // our SQL SELECT query. 
	      // if you only need a few columns, specify them by name instead of using "*"
	      String q1 = "select DATE_ADD(ifnull(max(EndDate),'2000-01-01'), INTERVAL 1 DAY) StartDate\n" + 
	      		"from nasaAPIcalls\n" + 
	      		"where apiName= '"+apiName+"'\n" + 
	      		"and Status='Finished'";

	      // create the java statement
	      Statement st = conn.createStatement();
	      
	      // execute the query, and get a java resultset
	      ResultSet rs = st.executeQuery(q1);
	      StartDate = rs.toString();
	      
	      st.close();
	    }
	    catch (Exception e)
	    { 
	      System.err.println(e.getMessage());
	    }
		
		return StartDate;
		
		
	}
	
}