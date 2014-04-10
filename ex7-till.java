import java.util.Scanner;

/**
 *
 * @author tehrengruber
 */
class Main {
    public static void main (String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        int t = scanner.nextInt();
        
        for (int i=0; i<t; i++) {
            int n=scanner.nextInt();
            int maxWeight=scanner.nextInt();
            int[] values = new int[n];
            int[] weights = new int[n];
            
            for (int j=0; j<n; j++) {
                values[j] = scanner.nextInt();
            }
            
            for (int j=0; j<n; j++) {
                weights[j] = scanner.nextInt();
            }
            
            knapsack(values, weights, maxWeight);
        }
    }
    
    public static void knapsack (int[] values, int[] weights, int maxWeight) {
        // Create table
        int[][] A = new int[values.length+1][maxWeight+1];
        
        for (int i=1; i<A.length; i++) {
            for (int j=1;j<A[0].length; j++) {
                A[i][j] = A[i-1][j];
                
                if (weights[i-1] <= j 
                        && (A[i-1][j-weights[i-1]] + values[i-1]) >= A[i-1][j]) {
                    A[i][j] = A[i-1][j-weights[i-1]] + values[i-1];
                }
            }
        }
        
        // Fetch solution
        int n=values.length; // n
        int w=maxWeight; // w
        int[] objects = new int[values.length];
        while (n>0) {
            if (weights[n-1] <= w && A[n][w] == A[n-1][w-weights[n-1]] + values[n-1]) {
                objects[n-1]=n;
                w=w-weights[n-1];
            }
            
            n--;
        }
        
        System.out.print(A[values.length][maxWeight]);
        
        quickSort(objects, 0, objects.length-1);
        
        for (int i=0; i<values.length; i++) {
            if (objects[i] != 0)
                System.out.print(" " + objects[i]);
        }
        System.out.println();
        //Main.print(A);
    }
    
    public static void print (int[][] table) {
        for (int i=0; i<table.length; i++) {
            for (int j=0; j<table[i].length; j++) {
                System.out.print(table[i][j] + " ");
            }
            System.out.println();
        }
        System.out.println();
    }

    static void quickSort(int arr[]) {
        Main.quickSort(arr, 0, arr.length-1);
    }
    
    static void quickSort(int arr[], int left, int right) {
        int index = partition(arr, left, right);

        if (left < index - 1) {
            quickSort(arr, left, index - 1);
        }

        if (index < right) {
            quickSort(arr, index, right);
        }
    }

    static int partition(int arr[], int left, int right) {
        int i = left, j = right;
        int tmp;
        int pivot = arr[(left + right) / 2];

        while (i <= j) {
            while (arr[i] < pivot) {
                i++;
            }

            while (arr[j] > pivot) {
                j--;
            }

            if (i <= j) {
                tmp = arr[i];
                arr[i] = arr[j];
                arr[j] = tmp;
                i++;
                j--;
            }
        };

        return i;
    }
}
