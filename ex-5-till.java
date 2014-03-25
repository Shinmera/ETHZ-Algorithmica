class Main {
    static class Heap {
        int[] array;
        int size = 0;

        public Heap (int n) {
            this.array = new int[n];
        }

        public Heap insert (int key) {       
            this.array[this.size] = key;
            int lastPos = this.size;
            int pos = (lastPos+1)/2-1;

            if (pos<0)
                pos=0;

            while (this.array[pos]>key) {
                this.array[lastPos] = this.array[pos];
                this.array[pos] = key;

                lastPos = pos;
                pos = (pos+1)/2-1; // move to the parent

                if (pos<0)
                pos=0;
            }

            this.size++;

            return this;
        }

        public int extractMin () {
            int min = this.array[0];

            // Replace root with last child
            this.array[0] = this.array[this.size-1];
            this.array[this.size-1] = 0;
            this.size--;

            // Select first left child
            int lastPos = 0;
            int pos = 1;

            while (pos < this.size) { // while array[lastPos] has a left child
                if (pos+1 < this.size) { // if array[lastPos] has a right child
                    pos = this.array[pos] < this.array[pos+1] // select the smaller child
                            ? pos : pos+1;
                }

                if (this.array[pos]<this.array[lastPos]) {
                    int tmp = this.array[pos];
                    this.array[pos] = this.array[lastPos];
                    this.array[lastPos] = tmp;

                    lastPos = pos;
                    pos = (pos+1)*2-1;
                } else {
                    break;
                }
            }

            return min;
        }

        public int queryLast () {
            return this.array[this.size-1];
        }

        public String toString () {
            String result = "|";

            for (int i=0; i < this.array.length; i++) {
                result += this.array[i] + "|";
            }

            return result;
        }
    }
    
    public static void test () {
        Heap heap = new Heap(6);
        heap.insert(4);
        heap.insert(5);
        heap.insert(2);
        heap.insert(3);
        heap.insert(-1);
        heap.insert(7);
        System.out.println(heap);
        System.out.println(heap.extractMin());
        System.out.println(heap);
        System.out.println(heap.extractMin());
        System.out.println(heap);
    }
    
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        int t = scanner.nextInt();
        Heap[] heaps = new Heap[t];
        
        for (int i=0; i<t; i++) {
            int n = scanner.nextInt();
            heaps[i] = new Heap(n);
            
            for (int j=0; j<n; j++) {
                heaps[i].insert(scanner.nextInt());
                //System.out.println(heaps[i]);
                System.out.print(heaps[i].queryLast() + " ");
            }
            System.out.println();
            //System.out.println(heaps[i]);
            
            for (int j=0; j<n; j++) {
                System.out.print(heaps[i].extractMin() + " ");
            }
            
            System.out.println();
        }
    }
}
