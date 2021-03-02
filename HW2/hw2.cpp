#include <iostream>
using namespace std;

#define MAX_SIZE 100
int CheckSumPossibility(int, int[],int);
int temp[100];
int temp_size=0;

int main(int argc, const char * argv[]) {
    int arraySize;
    int arr[MAX_SIZE];
    int num;
    int returnVal;
    cout << "enter: ";
    cin >> arraySize;
    cin >> num;
    for(int i = 0; i < arraySize; ++i)
        cin >> arr[i];
    returnVal = CheckSumPossibility(num, arr, arraySize);
    if(returnVal == 1){
        for(int i=0;i<temp_size;i++){
            cout << temp[i] << " ";
        }
        cout << "\nPossible!" << endl;
    }
    
    else
        cout << "Not possible!" << endl;
    return 0;
}

int CheckSumPossibility(int num, int arr[], int arraySize){
    if(num == 0)
        return 1;
    if(arraySize == 0)
        return 0;
    if(arr[arraySize-1] > num)
        return CheckSumPossibility(num, arr, arraySize-1);
    if(CheckSumPossibility(num, arr, arraySize-1) == 0)
        if(CheckSumPossibility(num-arr[arraySize-1], arr, arraySize-1)==1){
            temp[temp_size]=arr[arraySize-1];
            temp_size++;
            return 1;
        }
        else return 0;
        else
            return 1;
    
}
