package serie1;
import java.util.Scanner;

public class Serie1 {

    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        int t = in.nextInt();
        for (int j = 1; j <= t; ++j) {
            int i = in.nextInt();
            long A = in.nextInt();
            long B = in.nextInt();
            long C = in.nextInt();
            long D = in.nextInt();
            
            long R; long R1; long R2;
            if (i == 0) {R = A;}
            else {
                if (i == 1) {R = B;}
                else {
                    R = A; R1 = B; R2 = A;
                    for (int k = 2; k <= i; ++k) {
                        R = C * R1 + D * R2;
                        R2 = R1;
                        R1 = R;
                        }
                    }
            System.out.println(R); 
            }     
        }  
    }
}

