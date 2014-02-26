import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.Scanner;

/**
 * @author tehrengruber
 */
 class Main {
    public static void main(String[] args) throws Exception {
        BufferedReader bi = new BufferedReader(new InputStreamReader(System.in));
        BufferedWriter o = new BufferedWriter(new OutputStreamWriter(new
         FileOutputStream(java.io.FileDescriptor.out), "ASCII"), 512);
        // Read input
        int t = Integer.parseInt(bi.readLine());
        
        // Calculation vars
        int offset;
        int pos;
        String line;
        String out = "";
        
        for (int j=0; j<t; j++) {
            line = bi.readLine();
            pos = 0;
            final int i = Integer.parseInt(line.substring(pos, pos = line.indexOf(" ", pos))); // i
            final int a = Integer.parseInt(line.substring(pos+1, pos = line.indexOf(" ", pos+1))); // A
            final int b = Integer.parseInt(line.substring(pos+1, pos = line.indexOf(" ", pos+1))); // B
            final int c = Integer.parseInt(line.substring(pos+1, pos = line.indexOf(" ", pos+1))); // C
            final int d = Integer.parseInt(line.substring(pos+1)); // D
            
            if(i==0) {
                o.write(String.valueOf(a));
                o.write("\n");
                continue;
            }
            if(i==1) {
                o.write(String.valueOf(b));
                o.write("\n");
                continue;
            }
            long z = b*c + a*d, z2=a, z1=b;
            for(int k=2; k<i; k++){
                z2=z1;
                z1=z;
                z= z1*c + z2*d;
            }
            o.write(String.valueOf(z));
            o.write("\n");
        }
        o.flush();
        
        // Clean up
        in.close();
    }
}