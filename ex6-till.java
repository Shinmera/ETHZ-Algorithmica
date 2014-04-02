import java.util.Scanner;

/**
 *
 * @author tehrengruber
 */
class Main {
    public static void main (String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        int t = scanner.nextInt();
        scanner.next();
        
        for (int i=0; i<t; i++) {
            longestSequence(scanner.nextLine(), scanner.nextLine());
        }
    }
    
    public static void longestSequence (String s2, String s1) {
        int[][] table = new int[s2.length()+1][s1.length()+1];

        // Fill tablo
        for (int i=1; i<table.length; i++) {
            for (int j=1; j<table[i].length; j++) {
                if (s2.charAt(i-1) == s1.charAt(j-1)) {
                    table[i][j] = table[i-1][j-1]+1;
                } else {
                    table[i][j] = table[i-1][j] > table[i][j-1] 
                            ? table[i-1][j] : table[i][j-1];
                }
            }
        }
        
        //Main.print(table, s1, s2);
        
        // Backtrace
        int i = s2.length(),
            j = s1.length();
        
        String longestSequence = "";
        
        while (i > 0 && j > 0) {
            if (s1.charAt(j-1) == s2.charAt(i-1)) {
                longestSequence = s1.charAt(j-1) + longestSequence;
                i--;
                j--;
            } else if (table[i-1][j] == table[i][j]) {
                i--;
            } else if (table[i][j-1] == table[i][j]) {
                j--;
            }
        }
        
        System.out.println(table[s2.length()][s1.length()] + " " + longestSequence);
    }
    
    public static void print (int[][] table, String s1, String s2) {
        System.out.print("    ");
        for (int i=0; i<s1.length(); i++) {
            System.out.print(s1.charAt(i) + " ");
        }
        
        System.out.println();
        for (int i=0; i<table.length; i++) {
            if (i>0)
                System.out.print(s2.charAt(i-1) + " ");
            else
                System.out.print("  ");
            
            for (int j=0; j<table[i].length; j++) {
                System.out.print(table[i][j] + " ");
            }
            System.out.println();
        }
        System.out.println();
    }
}