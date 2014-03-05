import java.util.Scanner;

/**
 *
 * @author tehrengruber
 */
class Main {
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        
        // Read input
        int t = in.nextInt();
        int[][] input = new int[t][5]; // i, A, B, C, D
        
        for (int j=0; j<t; j++) {
            input[j][0] = in.nextInt(); // i
            input[j][1] = in.nextInt(); // A
            input[j][2] = in.nextInt(); // B
            input[j][3] = in.nextInt(); // C
            input[j][4] = in.nextInt(); // D
        }
        
        // Calculate result
        long[] scope = new long[3];
        int offset;
        
        for (int j=0; j<t; j++) {
            offset = input[j][0];
            scope[0] = input[j][1];
            scope[1] = input[j][2];
            
            for (int i=2; i<=input[j][0]; i++) {
                offset = i%3;
                scope[offset] = input[j][3] * scope[(offset+2)%3]
                        + input[j][4] * scope[(offset+1)%3];
            }
            
            System.out.println(scope[offset]);
        }
        
        // Clean up
        in.close();
    }
}