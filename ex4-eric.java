package serie4;
import java.util.Scanner;
        
public class Serie4 {
    
    public static void swap (int[] b, int x, int y) {
        int tmp;
        tmp = b[x];
        b[x] = b[y];
        b[y] = tmp;
    }
    
    public static void main(String[] args) {
        
        //input
        Scanner in= new Scanner(System.in);
        int t = in.nextInt();
        for (int j = 1; j <= t; ++j) {
            int n = in.nextInt();
            int[] a = new int [n+1];
            for (int i = 1; i <= n; ++i) {
                a[i] = in.nextInt(); 
            }
            
            int franken = 0;
            
            //insertion sort
            for (int i = 1; i <= n; ++i) {
                for (int k = i-1; k >= 1 && a[k] > a[k+1]; k--) {
                    swap(a, k, k+1);
                }
            } 
            
            while ((a[n] != 0) && (a[n-1] != 0) && (a[n-2] != 0)) {
                //calculating
                for (int i = 0; i < 3; ++i) {
                    if (a[n-i] != 0) {a[n-i] -= 1;} else break;
                    if (i == 2) {franken += 1;}
                }

                //insert numbers at the right place
                for (int i = n-3; i <= n; ++i) {
                    for (int k = i-1; k >= 1 && a[k] > a[k+1]; k--) {
                        swap(a, k, k+1);
                    }
                }
            }
            System.out.println(franken);
        }
    }
}
