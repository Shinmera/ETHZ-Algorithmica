import java.util.Scanner;

/**
 *
 * @author tehrengruber
 */
class Main {
    public static class HashTable {
        final Integer[] table;

        final int s;

        final int m;

        int j = 0;
        
        int totalProbing = 0;
        
        boolean debug;

        public HashTable (int m, int s, boolean debug) {
            this.table = new Integer[m];
            this.m = m;
            this.s = s;
            this.debug = debug;
        }

        public HashTable put (int k) {
            int h = k % this.m;
            int pos = h;
            
            if (debug) System.out.println("h(" + k + ") = " + h);

            // Sondieren
            // TODO: this can be an endless loop if the array if full
            while (this.table[pos] != null) {
                this.j++;
                int s = this.s(this.j, k);
                pos = (h - this.s(this.j, k) + this.j * this.m) % this.m;
                
                if (debug)
                    System.out.println("Kollision " + this.j 
                        + ": (" + h + " - " + this.s(this.j, k) 
                        + ") mod " + this.m + " = " + pos
                    );
            }
            this.totalProbing += this.j;
            this.j = 0;

            this.table[pos] = k;
            
            if (debug)
                System.out.println("Pos: " + pos + "\n" + this.toString() + "\n-------------");

            return this;
        }

        /**
         * 
         * @param j number of collisions
         * @param k key
         * @return 
         */
        public int s (int j, int k) throws IllegalArgumentException {
            switch (this.s) {
                case 0: // linear
                    return j;
                case 1: // quadratic
                    return (int) (Math.pow(Math.ceil((double) j/2), 2) * Math.pow(-1, j));
                case 2: // double hashing
                    return j * (1+(k % (this.m-2)));
            }

            throw new IllegalArgumentException();
        }

        public String toString () {
            String s = Integer.toString(this.totalProbing) + " " + (this.table[0] == null ? "0" : this.table[0].toString());

            for (int i=1; i<this.m; i++) {
                s += " " + (this.table[i] == null ? "0" : this.table[i].toString());
            }

            return s;
        }
    }
    
    public static void main (String[] args) {
        Scanner in = new Scanner(System.in);
        
        // Read input
        int t = in.nextInt(); // number of test instances
        HashTable[][] tables = new HashTable[t][3];
        
        for (int i=0; i<t; i++) {   
            // Read input
            int m = in.nextInt();
            int n = in.nextInt();
            
            // Initialize hash tables
            tables[i][0] = new HashTable(m, 0, false);
            tables[i][1] = new HashTable(m, 1, false);
            tables[i][2] = new HashTable(m, 2, false);
            
            // Read input keys
            for (int j=0; j<n; j++) {
                int key = in.nextInt();
                
                for (int k=0; k<3; k++) { // insert key in hashtables
                        tables[i][k].put(key);
                }
            }
        }
        
        // Output results
        for (int i=0; i<t; i++) {
            System.out.println(tables[i][0]);
            System.out.println(tables[i][1]);
            System.out.println(tables[i][2]);
        }
    }
}
