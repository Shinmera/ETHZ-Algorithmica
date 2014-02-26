import java.util.Scanner;

class ex2014_02_19{
    private Scanner scan = new Scanner(System.in);
    public static void main(String[] args){new ex2014_02_19();}

    public ex2014_02_19(){
        //System.out.println("Enter the number of tests you would like to perform: ");
        int n = scan.nextInt();

        //System.out.println("Enter your test lines in the form i a b c d: ");
        long[] results = new long[n];
        for(int i=0; i<n; i++){
            try{
                int[] p = readParameters();
                results[i] = Rbounded(p[0], p[1], p[2], p[3], p[4]);
            }catch(IllegalArgumentException ex){
                System.out.println("Error: "+ex.getMessage()+" Please try again: ");
                i--;
            }
        }
        
        //System.out.println("\nResults:");
        for(int i=0; i<n; i++){
            System.out.printf("%d%n", results[i]);
        }
        
        scan.close();
    }

    public long R(int i, int a, int b, int c, int d){
        if(i==0) return a;
        if(i==1) return b;
        long z = b*c + a*d, z2=a, z1=b;
        for(int j=2; j<i; j++){
            z2=z1;
            z1=z;
            z= z1*c + z2*d;
        }
        return z;
    }

    public long Rbounded (int i, int a, int b, int c, int d){
        if(i<0 || i>50) throw new IllegalArgumentException("I must be between 0 and 50 (inclusive).");
        if(a<-1*Math.pow(10,3) || a>Math.pow(10,3) ||
           b<-1*Math.pow(10,3) || b>Math.pow(10,3)) throw new IllegalArgumentException("A and B must be between -10^3 and 10^3 (inclusive).");
        if(c!=-1 && c!=1 ||
           d!=-1 && d!=1) throw new IllegalArgumentException("C and D must be either 1 or -1.");
        return R(i, a, b, c, d);
    }

    public int[] readParameters(){
        int[] parameters = new int[5];
        for(int i=0; i<5; i++){
            parameters[i] = scan.nextInt();
        }
        return parameters;
    }
}
