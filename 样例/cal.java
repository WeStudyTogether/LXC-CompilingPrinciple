import java.io.*;

public class cal {
    public static void main(String ... args) throws Exception {
        parser p = new parser(new scanner(new FileReader(args[0])));
        p.parse();
    }
}