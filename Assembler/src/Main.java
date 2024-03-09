import java.util.Scanner;

public class Main {
    static int[] numbersArray;
    public static void main(String[] args) {
        numbersArray = sort(createIntArray(scanNumbers()));
        printArray(numbersArray);
        System.out.println("\nAverage: " + average(numbersArray));
        System.out.println("Mediana: " + mediana(numbersArray));
    }

    public static String scanNumbers() {
        Scanner scan = new Scanner(System.in);

        System.out.println("Введіть числа");

        String numbers = scan.nextLine();
        return numbers;
    }

    public static int[] createIntArray(String numbers) {
        String[] numbersArrayString = numbers.split(" ");

        int[] numbersArray = new int[numbersArrayString.length];
        for (int i = 0; i < numbersArrayString.length; i++) {
            numbersArray[i] = Integer.valueOf(numbersArrayString[i]);
        }

        return numbersArray;
    }

    public static int[] sort(int[] numbersArray) {
        int arrayLength = numbersArray.length;

        if (arrayLength < 2) {
            return numbersArray;
        }

        int midIndex = arrayLength / 2;
        int[] leftHalf = new int[midIndex];
        int[] rightHalf = new int[arrayLength - midIndex];

        for (int i = 0; i < midIndex; i++) {
            leftHalf[i] = numbersArray[i];
        }

        for (int i = midIndex; i < numbersArray.length; i++) {
            rightHalf[i - midIndex] = numbersArray[i];
        }

        sort(leftHalf);
        sort(rightHalf);

        return merge(numbersArray, leftHalf, rightHalf);
    }

    public static int[] merge(int[] numbersArray, int[] leftHalf, int[] rightHalf) {
        int leftSize = leftHalf.length;
        int rightSize = rightHalf.length;

        int i = 0;
        int j = 0;
        int k = 0;

        while(i < leftSize && j < rightSize) {
            if (leftHalf[i] <= rightHalf[j]) {
                numbersArray[k] = leftHalf[i];
                i++;
            } else {
                numbersArray[k] = rightHalf[j];
                j++;
            }
            k++;
        }

        while (i < leftSize) {
            numbersArray[k] = leftHalf[i];
            i++;
            k++;
        }

        while (j < rightSize) {
            numbersArray[k] = rightHalf[j];
            j++;
            k++;
        }

        return numbersArray;
    }

    public static void printArray(int[] array) {
        for (int i = 0; i < array.length; i++) {
            System.out.print(array[i] + " ");
        }
    }

    public static double average(int[] array) {
        int sum = 0;
        for (int i = 0; i < array.length; i++) {
            sum += array[i];
        }
        double res = (double)  sum / array.length;
        return res;
    }

    public static double mediana(int[] array) {
        double mediana;
        if (array.length % 2 == 0) {
            mediana = (double) (array[array.length / 2] + array[array.length / 2 - 1]) / 2;
        } else {
            mediana = array[array.length / 2];
        }
        return mediana;
    }
}